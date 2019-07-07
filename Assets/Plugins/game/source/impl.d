module impl;

import std.conv; 
import std.string;

import core.sys.windows.windows;
import core.sys.windows.dll;

import mono;
import unity;

version(app_target) {}
else
 mixin SimpleDllMain;

enum gamePlaneY = 5f;

__gshared GameData gameData;

struct GameData
{
    // how much time till next asteroid
    float spawnTimeRate = 10f;
    float lastSpawn = 0;

    float playerRateOfFire = 0.6f;
    float lastShot = 0;

    // camera view bounds
    int boundsObjId;

    int playerScore;
    float timeSurvived = 0;
}


extern(C)
export void PluginInit(void* owner)
{
    auto mrt = GetModuleHandle("mono-2.0-bdwgc.dll");
    Loader.Load(mrt);
    onPluginLoaded(owner);
}

void onPluginLoaded(void* obj)
{
    try 
    {
        mono_add_internal_call("NativeTriggerColliderHelper::OnTriggerEnter_Native", &NativeTriggerColliderHelper_OnTriggerEnter);
        mono_add_internal_call("NativeTriggerColliderHelper::OnTriggerExit_Native", &NativeTriggerColliderHelper_OnTriggerExit);
        StartLevel();
    }
    catch (Exception e)
    {
        import std.file;
        Debug.Log(format("%s\n%s:%s", e.msg, e.file, e.line));
    }
}


extern(C)
export void PluginShutdown()
{
    
}


extern(C)
export void PluginTick(float dt)
{
    import core.memory;

    // one of the issues with memory management, it would be awesome to have this function attached as component instead
    GameObject player = GameObject.FindGameObjectWithTag("Player");

    // time scale zero means game is paused, so we don't want to take any input in that frame
    if (player && player._obj && player.active && Time.timeScale) 
    {
        auto inputH = Input.GetAxis("Horizontal");
        auto inputV = Input.GetAxis("Vertical");
        {
            import std.math;
            enum maxVelocity = 12f;
            enum accelerationTime = 1.5f;
            enum acceleration = maxVelocity / accelerationTime; 

            Rigidbody playerRb = player.transform.GetComponent!Rigidbody();
            auto mass = playerRb.mass;
            auto velocityDir = playerRb.velocity.normalized;
            auto velocity = playerRb.velocity.magnitude;

            auto desiredDir = Vector3(inputH,0,inputV);
            if (desiredDir.sqrMagnitude > 0.01)
                player.transform.rotation = Quaternion.RotateTowards(player.transform.rotation, Quaternion.LookRotation(desiredDir), 120f * Time.deltaTime);
            // that way when no input provided the ship should decelerate
            if (inputH == 0)
                desiredDir.x -= velocityDir.x;
            if (inputV == 0)
                desiredDir.z -= velocityDir.z;
            desiredDir = desiredDir.normalized;

            float factor = 1f - Mathf.Clamp01(velocity/maxVelocity);
            float finalX = desiredDir.x * (mass * acceleration) * factor;
            float finalZ = desiredDir.z * (mass * acceleration) * factor;
            
            playerRb.AddForce(Vector3(finalX, 0, finalZ));
        }

        if (Input.GetButton("Fire1"))
        {
            auto res = Resources.Load("PlayerShot");

            if (res._obj && Time.timeSinceLevelLoad > gameData.lastShot + gameData.playerRateOfFire)
            {
                // casting at this moment is not supported, so we just making new instance passing object handle
                // of course in this simple case we could cast using cast operator, but it doesn't really know if object is castable to that type
                GameObject pew = new MonoImplement!GameObject(GameObject.Instantiate(res, player.transform.position, player.transform.rotation)._obj);
                //pew.AddComponent(cast(Type)getSystemType!TestComponent); // another way to add component (with reflection)
                pew.AddComponent!NativeTriggerColliderHelper();
                Rigidbody rb = pew.transform.GetComponent!Rigidbody();
                auto projectileVelocity = player.transform.forward;
                projectileVelocity.x *= 20f;
                projectileVelocity.z *= 20f;
                rb.velocity = projectileVelocity;
                GameObject.Destroy(pew, 5f); // sets projectile lifetime
                gameData.lastShot = Time.timeSinceLevelLoad;
            }
        }

        if (Time.timeSinceLevelLoad > gameData.lastSpawn + gameData.spawnTimeRate)
            SpawnAsteroids();

        UIController.instance.UpdateTime(Time.timeSinceLevelLoad);
    }

    if (Input.GetButton("Cancel"))
    {
        UIController.instance.ShowQuitDialog();
    }

    //GC.collect();
    //Debug.Log(GC.stats.usedSize);
}

extern(C) void Helper_SceneLoaded()
{
    StartLevel();
}

void StartLevel()
{
    gameData = GameData.init;

    GameObject bounds = new MonoImplement!GameObject("ViewBounds");

    BoxCollider boxCollider = bounds.AddComponent!BoxCollider();
    boxCollider.center = Vector3(0, gamePlaneY, 0);
    boxCollider.size = Vector3(2 * Camera.main.orthographicSize * Camera.main.aspect, 10, 2 * Camera.main.orthographicSize);
    boxCollider.isTrigger = true;

    bounds.AddComponent!NativeTriggerColliderHelper();
    gameData.boundsObjId = bounds.GetInstanceID();
}

void SpawnAsteroids()
{
    gameData.lastSpawn = Time.timeSinceLevelLoad;
    auto dir2d = Random.insideUnitCircle;
    auto target2d = Random.insideUnitCircle;
    auto direction = Vector3(dir2d.x, 0, dir2d.y).normalized;
    auto spawnAt = Vector3(2.5 * direction.x * Camera.main.orthographicSize * Camera.main.aspect, gamePlaneY, 2.5 * direction.z * Camera.main.orthographicSize);
    auto target = Vector3(target2d.x * 12f, 0, target2d.y * 12f);
    target.y = gamePlaneY;
    scope GameObject asteroid = new MonoImplement!GameObject(
        GameObject.Instantiate(
            Resources.Load("Asteroid"), 
            spawnAt,
            Quaternion.LookRotation(Vector3(target.x - spawnAt.x, 0, target.z - spawnAt.z))
        )._obj
    );
    Rigidbody rb = asteroid.transform.GetComponent!Rigidbody();
    auto fwd = asteroid.transform.forward;
    auto vel = Random.Range(4f,9f);
    rb.velocity = Vector3(fwd.x * vel, 0, fwd.z * vel);
    gameData.spawnTimeRate -= gameData.spawnTimeRate * 0.04;
    gameData.spawnTimeRate = Mathf.Clamp(gameData.spawnTimeRate, 0.3f, 10f);
}


@assembly(unityDefaultAssembly)
abstract class NativeTriggerColliderHelper : MonoBehaviour
{
    mixin(monoObjectImpl);
}

@assembly(unityDefaultAssembly)
abstract class UIController : MonoBehaviour
{
    mixin(monoObjectImpl);

    @property static UIController instance();

    void ShowQuitDialog();
    void SetScore(int score);
    void UpdateTime(float seconds);
    void OnGameOver(int score, float time);
}

extern(C)
void NativeTriggerColliderHelper_OnTriggerEnter(void* this_, void* other)
{
    scope NativeTriggerColliderHelper self = new MonoImplement!NativeTriggerColliderHelper(cast(MonoObject*)this_);
    scope Collider thisCol = self.transform.GetComponent!Collider();
    scope Collider otherCol = new MonoImplement!Collider(cast(MonoObject*)other);

    if (!(thisCol && otherCol))
        return;

    // here we simply compare tags, assuming that only objects with tag 'Enemy' can be hit
    if (otherCol.tag == "Enemy")
    {
        if (self.tag == "Player")
        {
            GameObject.Destroy(otherCol.gameObject);
            self.gameObject.SetActive(false);
            gameData.timeSurvived = Time.timeSinceLevelLoad;
            UIController.instance.OnGameOver(gameData.playerScore, gameData.timeSurvived);
            // play death effect
            GameObject.Instantiate(Resources.Load("PS_PlayerDeath"), self.transform.position, self.transform.rotation);
        }
        else if (self.gameObject.GetInstanceID() != gameData.boundsObjId)
        {
            GameObject.Destroy(otherCol.gameObject);
            GameObject.Destroy(self.gameObject);
            gameData.playerScore += cast(int) (5 + 10 * otherCol.transform.localScale.magnitude); // 5 base points + 10x scale
            UIController.instance.SetScore(gameData.playerScore);
        }
    }

    if((thisCol.gameObject.GetInstanceID() != gameData.boundsObjId && otherCol.gameObject.GetInstanceID() != gameData.boundsObjId) && (thisCol.isTrigger && otherCol.isTrigger))
    {
        Physics.IgnoreCollision(thisCol, otherCol);
    }
}

extern(C)
void NativeTriggerColliderHelper_OnTriggerExit(void* this_, void* other)
{
    scope self = new MonoImplement!NativeTriggerColliderHelper(cast(MonoObject*)this_);
    scope Collider otherCol = new MonoImplement!Collider(cast(MonoObject*)other);

    if (self.gameObject.GetInstanceID() == gameData.boundsObjId)
    {
        if (otherCol.tag != "Player")
            GameObject.Destroy(otherCol.gameObject);
        else
        {
            // pop player from other side
            import std.math : abs;

            Transform player = otherCol.transform;
            auto pos = player.position;

            if (abs(pos.x) > Camera.main.orthographicSize * Camera.main.aspect)
                pos.x = -pos.x;
            if (abs(pos.z) > Camera.main.orthographicSize)
                pos.z = -pos.z;
            
            player.position = pos;

            // clear trail, ugly, but otherwise it will draw a line across the screen
            try 
            {
                auto trail = otherCol.transform.GetComponentInChildren!TrailRenderer();
                if (trail && trail._obj)
                    trail.Clear();
            }
            catch (MonoException e)
            {
                Debug.Log(cast(Object)e._exc);
            }
        }
    }
}


version(app_target)
void main()
{
    import unity;
    Debug.Log("test");
}