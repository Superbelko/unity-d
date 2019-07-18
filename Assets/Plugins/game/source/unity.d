module unity;

import mono;

alias Field = MonoMember;


enum unityDefaultAssembly = "Assembly-CSharp";


@assembly("netstandard")
@namespace("System")
{
    abstract class Type 
    {
        mixin(monoObjectImpl);

        @property .Assembly Assembly();
    }
}

@assembly("netstandard")
@namespace("System.Reflection")
{
    abstract class Assembly 
    {
        mixin(monoObjectImpl);

        @property string FullName();
    }
}

@namespace("System.Collections")
{
    interface IEnumerable
    {
        IEnumerator GetEnumerator();
    }

    interface IEnumerator
    {
        Object Current();

        bool MoveNext();
        void Reset();
    }

    class List(T) {

    }
}

@namespace("UnityEngine")
{
    enum HideFlags 
    {
        None = 0,
        HideInHierarchy = 1,
        HideInInspector = 2,
        DontSaveInEditor = 4,
        NotEditable = 8,
        DontSaveInBuild = 16,
        DontUnloadUnusedAsset = 32,
        DontSave = 52,
        HideAndDontSave = 61
    }

    enum Space
    {
        World = 0,
        Self = 1
    }

    enum SendMessageOptions
    {
        RequireReceiver = 0,
        DontRequireReceiver = 1
    }

    enum PhysicMaterialCombine
    {
        Average = 0,
        Multiply = 1,
        Minimum = 2,
        Maximum = 3
    }

    enum RigidbodyConstraints
    {
        None = 0,
        FreezePositionX = 2,
        FreezePositionY = 4,
        FreezePositionZ = 8,
        FreezePosition = 14,
        FreezeRotationX = 16,
        FreezeRotationY = 32,
        FreezeRotationZ = 64,
        FreezeRotation = 112,
        FreezeAll = 126
    }

    enum CollisionDetectionMode
    {
        Discrete = 0,
        Continuous = 1,
        ContinuousDynamic = 2,
        ContinuousSpeculative = 3
    }

    enum RigidbodyInterpolation
    {
        None = 0,
        Interpolate = 1,
        Extrapolate = 2
    }

    enum QueryTriggerInteraction
    {
        UseGlobal = 0,
        Ignore = 1,
        Collide = 2
    }

    enum ForceMode
    {
        Force = 0,
        Impulse = 1,
        VelocityChange = 2,
        Acceleration = 5
    }

    enum CameraType
    {
        Game = 1,
        SceneView = 2,
        Preview = 4,
        VR = 8,
        Reflection = 16
    }

    enum DepthTextureMode
    {
        None = 0,
        Depth = 1,
        DepthNormals = 2,
        MotionVectors = 4
    }

    enum CameraClearFlags
    {
        Skybox = 1,
        Color = 2,
        SolidColor = 2,
        Depth = 3,
        Nothing = 4
    }

    enum TransparencySortMode
    {
        Default = 0,
        Perspective = 1,
        Orthographic = 2,
        CustomAxis = 3
    }

    enum OpaqueSortMode
    {
        Default = 0,
        FrontToBack = 1,
        NoDistanceSort = 2
    }

    enum RenderingPath
    {
        UsePlayerSettings = -1,
        VertexLit = 0,
        Forward = 1,
        DeferredLighting = 2,
        DeferredShading = 3
    }

    enum StereoTargetEyeMask
    {
        None = 0,
        Left = 1,
        Right = 2,
        Both = 3
    }


    @symname("Object")
    abstract class Object_
    {
        mixin(monoObjectImpl);

        @property string name();
        @property void name(string);
        @property HideFlags hideFlags();
        @property void hideFlags(HideFlags);
        static void Destroy(Object_ obj);
        static void Destroy(Object_ obj, float t);
        static void DontDestroyOnLoad(Object_ target);
        static Object_ FindObjectOfType(Type type);
        static T FindObjectOfType(T)() { mixin(monoGenericMethod!T); }
        //static T[] FindObjectsOfType(T)();
        //static Object[] FindObjectsOfType(Type type);
        static Object_ Instantiate(Object_ original, Vector3 position, Quaternion rotation, Transform parent);
        static Object_ Instantiate(Object_ original);
        static Object_ Instantiate(Object_ original, Vector3 position, Quaternion rotation);
        //static T Instantiate(T)(T original, Transform parent, bool worldPositionStays);
        //static T Instantiate(T)(T original, Transform parent);
        //static T Instantiate(T)(T original, Vector3 position, Quaternion rotation, Transform parent);
        //static T Instantiate(T)(T original, Vector3 position, Quaternion rotation);
        //static T Instantiate(T)(T original);
        static Object_ Instantiate(Object_ original, Transform parent, bool instantiateInWorldSpace);
        static Object_ Instantiate(Object_ original, Transform parent);
        bool Equals(Object other);
        int GetHashCode();
        int GetInstanceID();
        string ToString();

        //public static bool operator ==(Object x, Object y);
        //public static bool operator !=(Object x, Object y);

        //static bool opCast(T : bool)(Object exists);
    }

    abstract class Component : Object_
    {
        mixin(monoObjectImpl);

        @property GameObject gameObject();
        @property string tag();
        @property void tag(string);
        @property Component rigidbody();
        @property Component rigidbody2D();
        @property Component camera();
        @property Component light();
        @property Component animation();
        @property Transform transform();
        @property Component constantForce();
        @property Component audio();
        @property Component guiText();
        @property Component networkView();
        @property Component guiElement();
        @property Component guiTexture();
        @property Component collider();
        @property Component collider2D();
        @property Component renderer();
        @property Component hingeJoint();
        @property Component particleSystem();

        void BroadcastMessage(string methodName);
        void BroadcastMessage(string methodName, Object parameter);
        void BroadcastMessage(string methodName, Object parameter, SendMessageOptions options);
        void BroadcastMessage(string methodName, SendMessageOptions options);
        bool CompareTag(string tag);
        Component GetComponent(Type type);
        T GetComponent(T)() { mixin(monoGenericMethod!T); }
        Component GetComponent(string type);
        T GetComponentInChildren(T)() { mixin(monoGenericMethod!T); }
        /*
        T GetComponentInChildren(T)(bool includeInactive);
        Component GetComponentInChildren(Type t, bool includeInactive);
        Component GetComponentInChildren(Type t);
        Component GetComponentInParent(Type t);
        T GetComponentInParent(T)();
        T[] GetComponents(T)();
        void GetComponents(T)(List!(T) results);
        void GetComponents(Type type, List!(Component) results);
        Component[] GetComponents(Type type);
        void GetComponentsInChildren(T)(List!(T) results);
        void GetComponentsInChildren(T)(bool includeInactive, List!(T) result);
        Component[] GetComponentsInChildren(Type t);
        Component[] GetComponentsInChildren(Type t, bool includeInactive);
        T[] GetComponentsInChildren(T)();
        T[] GetComponentsInChildren(T)(bool includeInactive);
        T[] GetComponentsInParent(T)();
        Component[] GetComponentsInParent(Type t);
        void GetComponentsInParent(T)(bool includeInactive, List!(T) results);
        T[] GetComponentsInParent(T)(bool includeInactive);
        Component[] GetComponentsInParent(Type t, bool includeInactive);
        */
        void SendMessage(string methodName, SendMessageOptions options);
        void SendMessage(string methodName, Object value, SendMessageOptions options);
        void SendMessage(string methodName);
        void SendMessage(string methodName, Object value);
        void SendMessageUpwards(string methodName, SendMessageOptions options);
        void SendMessageUpwards(string methodName, Object value);
        void SendMessageUpwards(string methodName, Object value, SendMessageOptions options);
        void SendMessageUpwards(string methodName);
    }


    abstract class Transform : Component, IEnumerable
    {
        mixin(monoObjectImpl);

        //this() {}

        @property Vector3 localPosition();
        @property void localPosition(Vector3);
        @property Vector3 eulerAngles();
        @property void eulerAngles(Vector3);
        @property Vector3 localEulerAngles();
        @property void localEulerAngles(Vector3);
        @property Vector3 right();
        @property void right(Vector3);
        @property Vector3 up();
        @property void up(Vector3);
        @property Vector3 forward();
        @property void forward(Vector3);
        @property Quaternion rotation();
        @property void rotation(Quaternion);
        @property Vector3 position();
        @property void position(Vector3);
        @property Quaternion localRotation();
        @property void localRotation(Quaternion);
        @property Transform parent();
        @property void parent(Transform);
        @property Matrix4x4 worldToLocalMatrix();
        @property Matrix4x4 localToWorldMatrix();
        @property Transform root();
        @property int childCount();
        @property Vector3 lossyScale();
        @property bool hasChanged();
        @property void hasChanged(bool);
        @property Vector3 localScale();
        @property void localScale(Vector3);
        @property int hierarchyCapacity();
        @property void hierarchyCapacity(int);
        @property int hierarchyCount();

        void DetachChildren();
        Transform Find(string n);
        Transform FindChild(string n);
        Transform GetChild(int index);
        int GetChildCount();
        abstract IEnumerator GetEnumerator();
        int GetSiblingIndex();
        Vector3 InverseTransformDirection(Vector3 direction);
        Vector3 InverseTransformDirection(float x, float y, float z);
        Vector3 InverseTransformPoint(float x, float y, float z);
        Vector3 InverseTransformPoint(Vector3 position);
        Vector3 InverseTransformVector(Vector3 vector);
        Vector3 InverseTransformVector(float x, float y, float z);
        bool IsChildOf(Transform parent);
        void LookAt(Transform target, Vector3 worldUp);
        void LookAt(Vector3 worldPosition, Vector3 worldUp);
        void LookAt(Vector3 worldPosition);
        void LookAt(Transform target);
        void Rotate(float xAngle, float yAngle, float zAngle);
        void Rotate(Vector3 eulers, Space relativeTo);
        void Rotate(Vector3 eulers);
        void Rotate(float xAngle, float yAngle, float zAngle, Space relativeTo);
        void Rotate(Vector3 axis, float angle, Space relativeTo);
        void Rotate(Vector3 axis, float angle);
        void RotateAround(Vector3 point, Vector3 axis, float angle);
        void RotateAround(Vector3 axis, float angle);
        void RotateAroundLocal(Vector3 axis, float angle);
        void SetAsFirstSibling();
        void SetAsLastSibling();
        void SetParent(Transform p);
        void SetParent(Transform parent, bool worldPositionStays);
        void SetPositionAndRotation(Vector3 position, Quaternion rotation);
        void SetSiblingIndex(int index);
        Vector3 TransformDirection(float x, float y, float z);
        Vector3 TransformDirection(Vector3 direction);
        Vector3 TransformPoint(float x, float y, float z);
        Vector3 TransformPoint(Vector3 position);
        Vector3 TransformVector(float x, float y, float z);
        Vector3 TransformVector(Vector3 vector);
        void Translate(float x, float y, float z);
        void Translate(float x, float y, float z, Space relativeTo);
        void Translate(Vector3 translation);
        void Translate(Vector3 translation, Space relativeTo);
        void Translate(float x, float y, float z, Transform relativeTo);
        void Translate(Vector3 translation, Transform relativeTo);
    }


    abstract class GameObject : Object_
    {
        mixin(monoObjectImpl);

        this() { super(_obj); }
        this(string name) { super(_obj); }
        this(string name, Type components...) { super(_obj); }
        this(MonoObject* obj) { super(obj); }

        @property int layer();
        @property bool active();
        @property bool activeSelf();
        @property bool activeInHierarchy();
        @property bool isStatic();
        @property void isStatic(bool);
        @property string tag();
        @property void tag(string);
        @property Scene scene();
        @property GameObject gameObject();
        @property Component rigidbody();
        @property Component rigidbody2D();
        @property Component camera();
        @property Component light();
        @property Component animation();
        @property Component constantForce();
        @property Component renderer();
        @property Component audio();
        @property Component guiText();
        @property Component networkView();
        @property Component guiElement();
        @property Component guiTexture();
        @property Component collider();
        @property Component collider2D();
        @property Transform transform();
        @property Component hingeJoint();
        @property Component particleSystem();

        static GameObject Find(string name);
        static GameObject[] FindGameObjectsWithTag(string tag);
        static GameObject FindGameObjectWithTag(string tag);
        static GameObject FindWithTag(string tag);
        Object_ AddComponent(Type type);
        T AddComponent(T : Component)() { mixin(monoGenericMethod!T); }
        void SetActive(bool value);
    }


    abstract class Debug
    {
        mixin MonoObjectImpl;

        static void Log(Object msg);
        
        static void Log(T)(T t) {
            Log(cast(Object) boxify(t));
        }

        pragma(mangle, Log.mangleof)
        static void Log_Impl(Object msg) {
            auto dom = MonoDomainHandle.get();
            auto ass = dom.openAssembly("UnityEngine");
            MonoClassHandle cls = ass.image.classFromName("UnityEngine", "Debug");
            auto m = cls.getMethod!(Debug.Log)();
            m.call(cast(void*)msg);
        }
    }

    struct Rect
    {
        mixin(monoObjectImpl);

        // internals
        float m_XMin;
        float m_YMin;
        float m_Width;
        float m_Height;

        @property static Rect zero();
        @property float x();
        @property void x(float val);
        @property float y();
        @property void y(float val);
        @property Vector2 position();
        @property void position(Vector2 val);
        @property Vector2 center();
        @property void center(Vector2 val);
        @property Vector2 min();
        @property void min(Vector2 val);
        @property Vector2 max();
        @property void max(Vector2 val);
        @property float width();
        @property void width(float val);
        @property float height();
        @property void height(float val);
        @property Vector2 size();
        @property void size(Vector2 val);
        @property float xMin();
        @property void xMin(float val);
        @property float yMin();
        @property void yMin(float val);
        @property float xMax();
        @property void xMax(float val);
        @property float yMax();
        @property void yMax(float val);
        @property float left();
        @property float right();
        @property float top();
        @property float bottom();

        static Rect MinMaxRect(float xmin, float ymin, float xmax, float ymax);
        static Vector2 NormalizedToPoint(Rect rectangle, Vector2 normalizedRectCoordinates);
        static Vector2 PointToNormalized(Rect rectangle, Vector2 point);
        bool Contains(Vector3 point, bool allowInverse);
        bool Contains(Vector3 point);
        bool Contains(Vector2 point);
        bool Equals(Rect other);
        /*override*/ bool Equals(Object other);
        /*override*/ int GetHashCode();
        bool Overlaps(Rect other, bool allowInverse);
        bool Overlaps(Rect other);
        void Set(float x, float y, float width, float height);
        /*override*/ string ToString();
        string ToString(string format);
    }

    struct Color
    {
        mixin(monoObjectImpl);

        float r;
        float g;
        float b;
        float a;
    }

    struct Vector2
    {
        mixin(monoObjectImpl);

        float x, y;
    }

    struct Vector3
    {
        mixin(monoObjectImpl);

        float x, y, z;

        @property static Vector3 zero();
        @property static Vector3 one();
        @property static Vector3 forward();
        @property static Vector3 back();
        @property static Vector3 right();
        @property static Vector3 down();
        @property static Vector3 left();
        @property static Vector3 positiveInfinity();
        @property static Vector3 up();
        @property static Vector3 negativeInfinity();
        @property static Vector3 fwd();
        @property float sqrMagnitude();
        @property Vector3 normalized();
        @property float magnitude();

        Vector3 opBinary(string op:"+")(Vector3 b) { return MonoOperator!(opBinary!op)(this, b); }
        Vector3 opBinary(string op:"-")(Vector3 b) { return MonoOperator!(opBinary!op)(this, b); }
        Vector3 opUnary(string op:"-")() { return MonoOperator!(opUnary!op)(this); } 
        Vector3 opBinary(string op:"*")(float d) { return MonoOperator!(opBinary!op)(this, d); }
        Vector3 opBinaryRight(string op:"*")(float d) { return MonoOperator!(Vector3.opBinaryRight!op)(d, this); }
        Vector3 opBinary(string op:"/")(float d) { return MonoOperator!(opBinary!op)(this, d); }
        float opIndex(int i) { return MonoOperator!(opIndex)(this, i); }
        void opIndexAssign(float val, int index) { MonoOperator!(opIndexAssign)(&this, index, val); }
    }

    struct Vector4
    {
        mixin(monoObjectImpl);

        float x, y, z, w;
    }


    struct Matrix4x4
    {
        mixin(monoObjectImpl);

        float[16] m; // these actually are 16 floats named 'm00' to 'm33'
    }


    struct Quaternion
    {
        mixin(monoObjectImpl);

        float x, y, z, w;

        static Quaternion LookRotation(Vector3 forward);
        static Quaternion RotateTowards(Quaternion from, Quaternion to, float maxDegreesDelta);
    }


    struct Mathf
    {
        mixin(monoObjectImpl);

        static int CeilToInt(float f);
        static int Clamp(int value, int min, int max);
        static float Clamp(float value, float min, float max);
        static float Clamp01(float value);
        static float Lerp(float a, float b, float t);
        static float Max(float[] values...);
        static float Max(float a, float b);
    }


    struct Bounds
    {
        mixin(monoObjectImpl);

        // internals
        private Vector3 m_Center;
        private Vector3 m_Extents;

        //this(Vector3 center, Vector3 size) { m_Center = center; m_Extents = size * 0.5f; }

        @property Vector3 extents();
        @property void extents(Vector3 val);
        @property Vector3 size();
        @property void size(Vector3 val);
        @property Vector3 center();
        @property void center(Vector3 val);
        @property Vector3 min();
        @property void min(Vector3 val);
        @property Vector3 max();
        @property void max(Vector3 val);

        Vector3 ClosestPoint(Vector3 point);
        bool Contains(Vector3 point);
        void Encapsulate(Vector3 point);
        void Encapsulate(Bounds bounds);
        /*override*/ bool Equals(Object other);
        bool Equals(Bounds other);
        void Expand(float amount);
        void Expand(Vector3 amount);
        /*override*/ int GetHashCode();
        bool IntersectRay(Ray ray);
        bool IntersectRay(Ray ray, out float distance);
        bool Intersects(Bounds bounds);
        void SetMinMax(Vector3 min, Vector3 max);
        float SqrDistance(Vector3 point);
        string ToString(string format);
        /*override*/ string ToString();
    }


    struct Ray
    {
        mixin(monoObjectImpl);

        // internals
        Vector3 m_Origin;
        Vector3 m_Direction;

        //this(Vector3 origin, Vector3 direction);

        @property Vector3 origin();
        @property void origin(Vector3 val);
        @property Vector3 direction();
        @property void direction(Vector3 val);

        Vector3 GetPoint(float distance);
        string ToString();
        string ToString(string format);
    }

    struct RaycastHit
    {
        mixin(monoObjectImpl);

        // internals
        Vector3 m_Point;
        Vector3 m_Normal;
        uint m_FaceID;
        float m_Distance;
        Vector2 m_UV;
        int m_Collider;

        @property Collider collider();
        @property Vector3 point();
        @property void point(Vector3 val);
        @property Vector3 normal();
        @property void normal(Vector3 val);
        @property Vector3 barycentricCoordinate();
        @property void barycentricCoordinate(Vector3 val);
        @property float distance();
        @property void distance(float val);
        @property int triangleIndex();
        @property Vector2 textureCoord();
        @property Vector2 textureCoord2();
        @property Vector2 textureCoord1();
        @property Transform transform();
        @property Rigidbody rigidbody();
        @property Vector2 lightmapCoord();
    }

    abstract class PhysicMaterial : Object_
    {
        mixin(monoObjectImpl);

        this(string name);
        this(MonoObject* obj) { super(obj); }

        @property float bounciness();
        @property void bounciness(float val);
        @property float dynamicFriction();
        @property void dynamicFriction(float val);
        @property float staticFriction();
        @property void staticFriction(float val);
        @property PhysicMaterialCombine frictionCombine();
        @property void frictionCombine(PhysicMaterialCombine val);
        @property PhysicMaterialCombine bounceCombine();
        @property void bounceCombine(PhysicMaterialCombine val);
        @property float bouncyness();
        @property void bouncyness(float val);
        @property Vector3 frictionDirection2();
        @property void frictionDirection2(Vector3 val);
        @property float dynamicFriction2();
        @property void dynamicFriction2(float val);
        @property float staticFriction2();
        @property void staticFriction2(float val);
        @property Vector3 frictionDirection();
        @property void frictionDirection(Vector3 val);
    }

    struct PhysicsScene
    {
        mixin(monoObjectImpl);

        // internals
        int m_Handle;

        int BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, RaycastHit[] results);
        bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, out RaycastHit hitInfo);
        bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, out RaycastHit hitInfo, Quaternion orientation, float maxDistance = float.infinity, int layerMask = -5, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        int BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, RaycastHit[] results, Quaternion orientation, float maxDistance = float.infinity, int layerMask = -5, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        bool CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction, out RaycastHit hitInfo, float maxDistance = float.infinity, int layerMask = -5, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        int CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction, RaycastHit[] results, float maxDistance = float.infinity, int layerMask = -5, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        /*override*/ bool Equals(Object other);
        bool Equals(PhysicsScene other);
        /*override*/ int GetHashCode();
        bool IsEmpty();
        bool IsValid();
        int OverlapBox(Vector3 center, Vector3 halfExtents, Collider[] results);
        int OverlapBox(Vector3 center, Vector3 halfExtents, Collider[] results, Quaternion orientation, int layerMask = -5,  QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        int OverlapCapsule(Vector3 point0, Vector3 point1, float radius, Collider[] results, int layerMask = -1, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        int OverlapSphere(Vector3 position, float radius, Collider[] results, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        int Raycast(Vector3 origin, Vector3 direction, RaycastHit[] raycastHits, float maxDistance = float.infinity, int layerMask = -5, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        bool Raycast(Vector3 origin, Vector3 direction, out RaycastHit hitInfo, float maxDistance = float.infinity, int layerMask = -5, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        bool Raycast(Vector3 origin, Vector3 direction, float maxDistance = float.infinity, int layerMask = -5, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        void Simulate(float step);
        int SphereCast(Vector3 origin, float radius, Vector3 direction, RaycastHit[] results, float maxDistance = float.infinity, int layerMask = -5, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        bool SphereCast(Vector3 origin, float radius, Vector3 direction, out RaycastHit hitInfo, float maxDistance = float.infinity, int layerMask = -5, QueryTriggerInteraction queryTriggerInteraction = QueryTriggerInteraction.UseGlobal);
        /*override*/ string ToString();
    }


    abstract class Physics
    {
        mixin(monoObjectImpl);

        enum float k_MaxFloatMinusEpsilon = 340282326356119260000000000000000000000f;

        enum int IgnoreRaycastLayer = 1 << 2;
        enum int DefaultRaycastLayers = ~IgnoreRaycastLayer;
        enum int AllLayers = ~0;

        @property static float minPenetrationForPenalty();
        @property static void minPenetrationForPenalty(float val);
        @property static Vector3 gravity();
        @property static void gravity(Vector3 val);
        @property static float defaultContactOffset();
        @property static void defaultContactOffset(float val);
        @property static float sleepThreshold();
        @property static void sleepThreshold(float val);
        @property static bool queriesHitTriggers();
        @property static void queriesHitTriggers(bool val);
        @property static bool queriesHitBackfaces();
        @property static void queriesHitBackfaces(bool val);
        @property static float bounceThreshold();
        @property static void bounceThreshold(float val);
        @property static int defaultSolverIterations();
        @property static void defaultSolverIterations(int val);
        @property static int defaultSolverVelocityIterations();
        @property static void defaultSolverVelocityIterations(int val);
        @property static float bounceTreshold();
        @property static void bounceTreshold(float val);
        @property static float sleepVelocity();
        @property static void sleepVelocity(float val);
        @property static float sleepAngularVelocity();
        @property static void sleepAngularVelocity(float val);
        @property static float maxAngularVelocity();
        @property static void maxAngularVelocity(float val);
        @property static int solverIterationCount();
        @property static void solverIterationCount(int val);
        @property static int solverVelocityIterationCount();
        @property static void solverVelocityIterationCount(int val);
        @property static float penetrationPenaltyForce();
        @property static void penetrationPenaltyForce(float val);
        @property static float defaultMaxAngularSpeed();
        @property static void defaultMaxAngularSpeed(float val);
        @property static PhysicsScene defaultPhysicsScene();
        @property static bool autoSimulation();
        @property static void autoSimulation(bool val);
        @property static bool autoSyncTransforms();
        @property static void autoSyncTransforms(bool val);
        @property static bool reuseCollisionCallbacks();
        @property static void reuseCollisionCallbacks(bool val);
        @property static float interCollisionDistance();
        @property static void interCollisionDistance(float val);
        @property static float interCollisionStiffness();
        @property static void interCollisionStiffness(float val);
        @property static bool interCollisionSettingsToggle();
        @property static void interCollisionSettingsToggle(bool val);
        @property static Vector3 clothGravity();
        @property static void clothGravity(Vector3 val);

        static void IgnoreCollision(Collider collider1, Collider collider2, bool ignore);
        static void IgnoreCollision(Collider collider1, Collider collider2);
        static void IgnoreLayerCollision(int layer1, int layer2, bool ignore);
        static void IgnoreLayerCollision(int layer1, int layer2);
        static bool GetIgnoreLayerCollision(int layer1, int layer2);
        static bool GetIgnoreCollision(Collider collider1, Collider collider2);
        static bool Raycast(Vector3 origin, Vector3 direction, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool Raycast(Vector3 origin, Vector3 direction, float maxDistance, int layerMask);
        static bool Raycast(Vector3 origin, Vector3 direction, float maxDistance);
        static bool Raycast(Vector3 origin, Vector3 direction);
        static bool Raycast(Vector3 origin, Vector3 direction, out RaycastHit hitInfo, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool Raycast(Vector3 origin, Vector3 direction, out RaycastHit hitInfo, float maxDistance, int layerMask);
        static bool Raycast(Vector3 origin, Vector3 direction, out RaycastHit hitInfo, float maxDistance);
        static bool Raycast(Vector3 origin, Vector3 direction, out RaycastHit hitInfo);
        static bool Raycast(Ray ray, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool Raycast(Ray ray, float maxDistance, int layerMask);
        static bool Raycast(Ray ray, float maxDistance);
        static bool Raycast(Ray ray);
        static bool Raycast(Ray ray, out RaycastHit hitInfo, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool Raycast(Ray ray, out RaycastHit hitInfo, float maxDistance, int layerMask);
        static bool Raycast(Ray ray, out RaycastHit hitInfo, float maxDistance);
        static bool Raycast(Ray ray, out RaycastHit hitInfo);
        static bool Linecast(Vector3 start, Vector3 end, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool Linecast(Vector3 start, Vector3 end, int layerMask);
        static bool Linecast(Vector3 start, Vector3 end);
        static bool Linecast(Vector3 start, Vector3 end, out RaycastHit hitInfo, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool Linecast(Vector3 start, Vector3 end, out RaycastHit hitInfo, int layerMask);
        static bool Linecast(Vector3 start, Vector3 end, out RaycastHit hitInfo);
        static bool CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction, float maxDistance, int layerMask);
        static bool CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction, float maxDistance);
        static bool CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction);
        static bool CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction, out RaycastHit hitInfo, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction, out RaycastHit hitInfo, float maxDistance, int layerMask);
        static bool CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction, out RaycastHit hitInfo, float maxDistance);
        static bool CapsuleCast(Vector3 point1, Vector3 point2, float radius, Vector3 direction, out RaycastHit hitInfo);
        static bool SphereCast(Vector3 origin, float radius, Vector3 direction, out RaycastHit hitInfo, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool SphereCast(Vector3 origin, float radius, Vector3 direction, out RaycastHit hitInfo, float maxDistance, int layerMask);
        static bool SphereCast(Vector3 origin, float radius, Vector3 direction, out RaycastHit hitInfo, float maxDistance);
        static bool SphereCast(Vector3 origin, float radius, Vector3 direction, out RaycastHit hitInfo);
        static bool SphereCast(Ray ray, float radius, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool SphereCast(Ray ray, float radius, float maxDistance, int layerMask);
        static bool SphereCast(Ray ray, float radius, float maxDistance);
        static bool SphereCast(Ray ray, float radius);
        static bool SphereCast(Ray ray, float radius, out RaycastHit hitInfo, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool SphereCast(Ray ray, float radius, out RaycastHit hitInfo, float maxDistance, int layerMask);
        static bool SphereCast(Ray ray, float radius, out RaycastHit hitInfo, float maxDistance);
        static bool SphereCast(Ray ray, float radius, out RaycastHit hitInfo);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, Quaternion orientation, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, Quaternion orientation, float maxDistance, int layerMask);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, Quaternion orientation, float maxDistance);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, Quaternion orientation);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, out RaycastHit hitInfo, Quaternion orientation, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, out RaycastHit hitInfo, Quaternion orientation, float maxDistance, int layerMask);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, out RaycastHit hitInfo, Quaternion orientation, float maxDistance);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, out RaycastHit hitInfo, Quaternion orientation);
        static bool BoxCast(Vector3 center, Vector3 halfExtents, Vector3 direction, out RaycastHit hitInfo);
        static RaycastHit[] RaycastAll(Vector3 origin, Vector3 direction, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static RaycastHit[] RaycastAll(Vector3 origin, Vector3 direction, float maxDistance, int layerMask);
        static RaycastHit[] RaycastAll(Vector3 origin, Vector3 direction, float maxDistance);
        static RaycastHit[] RaycastAll(Vector3 origin, Vector3 direction);
        static RaycastHit[] RaycastAll(Ray ray, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static RaycastHit[] RaycastAll(Ray ray, float maxDistance, int layerMask);
        static RaycastHit[] RaycastAll(Ray ray, float maxDistance);
        static RaycastHit[] RaycastAll(Ray ray);
        static int RaycastNonAlloc(Ray ray, RaycastHit[] results, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static int RaycastNonAlloc(Ray ray, RaycastHit[] results, float maxDistance, int layerMask);
        static int RaycastNonAlloc(Ray ray, RaycastHit[] results, float maxDistance);
        static int RaycastNonAlloc(Ray ray, RaycastHit[] results);
        static int RaycastNonAlloc(Vector3 origin, Vector3 direction, RaycastHit[] results, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static int RaycastNonAlloc(Vector3 origin, Vector3 direction, RaycastHit[] results, float maxDistance, int layerMask);
        static int RaycastNonAlloc(Vector3 origin, Vector3 direction, RaycastHit[] results, float maxDistance);
        static int RaycastNonAlloc(Vector3 origin, Vector3 direction, RaycastHit[] results);
        static RaycastHit[] CapsuleCastAll(Vector3 point1, Vector3 point2, float radius, Vector3 direction, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static RaycastHit[] CapsuleCastAll(Vector3 point1, Vector3 point2, float radius, Vector3 direction, float maxDistance, int layerMask);
        static RaycastHit[] CapsuleCastAll(Vector3 point1, Vector3 point2, float radius, Vector3 direction, float maxDistance);
        static RaycastHit[] CapsuleCastAll(Vector3 point1, Vector3 point2, float radius, Vector3 direction);
        static RaycastHit[] SphereCastAll(Vector3 origin, float radius, Vector3 direction, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static RaycastHit[] SphereCastAll(Vector3 origin, float radius, Vector3 direction, float maxDistance, int layerMask);
        static RaycastHit[] SphereCastAll(Vector3 origin, float radius, Vector3 direction, float maxDistance);
        static RaycastHit[] SphereCastAll(Vector3 origin, float radius, Vector3 direction);
        static RaycastHit[] SphereCastAll(Ray ray, float radius, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static RaycastHit[] SphereCastAll(Ray ray, float radius, float maxDistance, int layerMask);
        static RaycastHit[] SphereCastAll(Ray ray, float radius, float maxDistance);
        static RaycastHit[] SphereCastAll(Ray ray, float radius);
        static Collider[] OverlapCapsule(Vector3 point0, Vector3 point1, float radius, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static Collider[] OverlapCapsule(Vector3 point0, Vector3 point1, float radius, int layerMask);
        static Collider[] OverlapCapsule(Vector3 point0, Vector3 point1, float radius);
        static Collider[] OverlapSphere(Vector3 position, float radius, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static Collider[] OverlapSphere(Vector3 position, float radius, int layerMask);
        static Collider[] OverlapSphere(Vector3 position, float radius);
        static void Simulate(float step);
        static void SyncTransforms();
        static bool ComputePenetration(Collider colliderA, Vector3 positionA, Quaternion rotationA, Collider colliderB, Vector3 positionB, Quaternion rotationB, out Vector3 direction, out float distance);
        static Vector3 ClosestPoint(Vector3 point, Collider collider, Vector3 position, Quaternion rotation);
        static int OverlapSphereNonAlloc(Vector3 position, float radius, Collider[] results, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static int OverlapSphereNonAlloc(Vector3 position, float radius, Collider[] results, int layerMask);
        static int OverlapSphereNonAlloc(Vector3 position, float radius, Collider[] results);
        static bool CheckSphere(Vector3 position, float radius, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool CheckSphere(Vector3 position, float radius, int layerMask);
        static bool CheckSphere(Vector3 position, float radius);
        static int CapsuleCastNonAlloc(Vector3 point1, Vector3 point2, float radius, Vector3 direction, RaycastHit[] results, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static int CapsuleCastNonAlloc(Vector3 point1, Vector3 point2, float radius, Vector3 direction, RaycastHit[] results, float maxDistance, int layerMask);
        static int CapsuleCastNonAlloc(Vector3 point1, Vector3 point2, float radius, Vector3 direction, RaycastHit[] results, float maxDistance);
        static int CapsuleCastNonAlloc(Vector3 point1, Vector3 point2, float radius, Vector3 direction, RaycastHit[] results);
        static int SphereCastNonAlloc(Vector3 origin, float radius, Vector3 direction, RaycastHit[] results, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static int SphereCastNonAlloc(Vector3 origin, float radius, Vector3 direction, RaycastHit[] results, float maxDistance, int layerMask);
        static int SphereCastNonAlloc(Vector3 origin, float radius, Vector3 direction, RaycastHit[] results, float maxDistance);
        static int SphereCastNonAlloc(Vector3 origin, float radius, Vector3 direction, RaycastHit[] results);
        static int SphereCastNonAlloc(Ray ray, float radius, RaycastHit[] results, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static int SphereCastNonAlloc(Ray ray, float radius, RaycastHit[] results, float maxDistance, int layerMask);
        static int SphereCastNonAlloc(Ray ray, float radius, RaycastHit[] results, float maxDistance);
        static int SphereCastNonAlloc(Ray ray, float radius, RaycastHit[] results);
        static bool CheckCapsule(Vector3 start, Vector3 end, float radius, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static bool CheckCapsule(Vector3 start, Vector3 end, float radius, int layerMask);
        static bool CheckCapsule(Vector3 start, Vector3 end, float radius);
        static bool CheckBox(Vector3 center, Vector3 halfExtents, Quaternion orientation, int layermask, QueryTriggerInteraction queryTriggerInteraction);
        static bool CheckBox(Vector3 center, Vector3 halfExtents, Quaternion orientation, int layerMask);
        static bool CheckBox(Vector3 center, Vector3 halfExtents, Quaternion orientation);
        static bool CheckBox(Vector3 center, Vector3 halfExtents);
        static Collider[] OverlapBox(Vector3 center, Vector3 halfExtents, Quaternion orientation, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static Collider[] OverlapBox(Vector3 center, Vector3 halfExtents, Quaternion orientation, int layerMask);
        static Collider[] OverlapBox(Vector3 center, Vector3 halfExtents, Quaternion orientation);
        static Collider[] OverlapBox(Vector3 center, Vector3 halfExtents);
        static int OverlapBoxNonAlloc(Vector3 center, Vector3 halfExtents, Collider[] results, Quaternion orientation, int mask, QueryTriggerInteraction queryTriggerInteraction);
        static int OverlapBoxNonAlloc(Vector3 center, Vector3 halfExtents, Collider[] results, Quaternion orientation, int mask);
        static int OverlapBoxNonAlloc(Vector3 center, Vector3 halfExtents, Collider[] results, Quaternion orientation);
        static int OverlapBoxNonAlloc(Vector3 center, Vector3 halfExtents, Collider[] results);
        static int BoxCastNonAlloc(Vector3 center, Vector3 halfExtents, Vector3 direction, RaycastHit[] results, Quaternion orientation, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static int BoxCastNonAlloc(Vector3 center, Vector3 halfExtents, Vector3 direction, RaycastHit[] results, Quaternion orientation);
        static int BoxCastNonAlloc(Vector3 center, Vector3 halfExtents, Vector3 direction, RaycastHit[] results, Quaternion orientation, float maxDistance);
        static int BoxCastNonAlloc(Vector3 center, Vector3 halfExtents, Vector3 direction, RaycastHit[] results, Quaternion orientation, float maxDistance, int layerMask);
        static int BoxCastNonAlloc(Vector3 center, Vector3 halfExtents, Vector3 direction, RaycastHit[] results);
        static RaycastHit[] BoxCastAll(Vector3 center, Vector3 halfExtents, Vector3 direction, Quaternion orientation, float maxDistance, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static RaycastHit[] BoxCastAll(Vector3 center, Vector3 halfExtents, Vector3 direction, Quaternion orientation, float maxDistance, int layerMask);
        static RaycastHit[] BoxCastAll(Vector3 center, Vector3 halfExtents, Vector3 direction, Quaternion orientation, float maxDistance);
        static RaycastHit[] BoxCastAll(Vector3 center, Vector3 halfExtents, Vector3 direction, Quaternion orientation);
        static RaycastHit[] BoxCastAll(Vector3 center, Vector3 halfExtents, Vector3 direction);
        static int OverlapCapsuleNonAlloc(Vector3 point0, Vector3 point1, float radius, Collider[] results, int layerMask, QueryTriggerInteraction queryTriggerInteraction);
        static int OverlapCapsuleNonAlloc(Vector3 point0, Vector3 point1, float radius, Collider[] results, int layerMask);
        static int OverlapCapsuleNonAlloc(Vector3 point0, Vector3 point1, float radius, Collider[] results);
        static void RebuildBroadphaseRegions(Bounds worldBounds, int subdivisions);
    }


    struct Scene
    {
        @property int handle();
    }


    abstract class YieldInstruction {}


    abstract class Coroutine : YieldInstruction {
        mixin(monoObjectImpl);
    }


    abstract class Time 
    {
        mixin(monoObjectImpl);

        @property static float realtimeSinceStartup();
        @property static int renderedFrameCount();
        @property static int frameCount();
        @property static float timeScale();
        @property static void timeScale(float val);
        @property static float maximumParticleDeltaTime();
        @property static void maximumParticleDeltaTime(float val);
        @property static float smoothDeltaTime();
        @property static float maximumDeltaTime();
        @property static void maximumDeltaTime(float val);
        @property static int captureFramerate();
        @property static void captureFramerate(float val);
        @property static float fixedDeltaTime();
        @property static void fixedDeltaTime(float val);
        @property static float unscaledDeltaTime();
        @property static float fixedUnscaledTime();
        @property static float unscaledTime();
        @property static float fixedTime();
        @property static float deltaTime();
        @property static float timeSinceLevelLoad();
        @property static float time();
        @property static float fixedUnscaledDeltaTime();
        @property static bool inFixedTimeStep();
    }


    abstract class Input
    {
        mixin(monoObjectImpl);

        static float GetAxis(string axisName);
        static float GetAxisRaw(string axisName);
        static bool GetButton(string buttonName);
        static bool GetButtonDown(string buttonName);
        static bool GetButtonUp(string buttonName);
        //static string[] GetJoystickNames();
        static bool GetKey(string name);
        static bool GetKey(KeyCode key);
        static bool GetKeyDown(string name);
        static bool GetKeyDown(KeyCode key);
        static bool GetKeyUp(KeyCode key);
        static bool GetKeyUp(string name);
        static bool GetMouseButton(int button);
        static bool GetMouseButtonDown(int button);
        static bool GetMouseButtonUp(int button);
    }


    abstract class Behaviour : Component
    {
        mixin(monoObjectImpl);

        @property bool enabled();
        @property void enabled(bool);

        @property bool isActiveAndEnabled();
    }


    abstract class MonoBehaviour : Behaviour
    {
        mixin(monoObjectImpl);

        //this() {}

        @property bool useGUILayout();
        @property void useGUILayout(bool);
        @property bool runInEditMode();
        @property void runInEditMode(bool);

        static void print(Object message);
        void CancelInvoke(string methodName);
        void CancelInvoke();
        void Invoke(string methodName, float time);
        void InvokeRepeating(string methodName, float time, float repeatRate);
        bool IsInvoking(string methodName);
        bool IsInvoking();
        Coroutine StartCoroutine(string methodName);
        Coroutine StartCoroutine(IEnumerator routine);
        Coroutine StartCoroutine(string methodName, Object value);
        Coroutine StartCoroutine_Auto(IEnumerator routine);
        void StopAllCoroutines();
        void StopCoroutine(IEnumerator routine);
        void StopCoroutine(Coroutine routine);
        void StopCoroutine(string methodName);
    }


    abstract class Light : Component
    {
        mixin(monoObjectImpl);
    }

    abstract class Collider : Component
    {
        mixin(monoObjectImpl);

        @property bool enabled();
        @property void enabled(bool val);
        @property Rigidbody attachedRigidbody();
        @property bool isTrigger();
        @property void isTrigger(bool val);
        @property float contactOffset();
        @property void contactOffset(float val);
        @property Bounds bounds();
        @property PhysicMaterial sharedMaterial();
        @property void sharedMaterial(PhysicMaterial val);
        @property PhysicMaterial material();
        @property void material(PhysicMaterial val);

        Vector3 ClosestPoint(Vector3 position);
        Vector3 ClosestPointOnBounds(Vector3 position);
        bool Raycast(Ray ray, out RaycastHit hitInfo, float maxDistance);
    }

    abstract class BoxCollider : Collider
    {
        mixin(monoObjectImpl);

        @property Vector3 center();
        @property void center(Vector3 val);
        @property Vector3 size();
        @property void size(Vector3 val);
        @property Vector3 extents();
        @property void extents(Vector3 val);
    }


    abstract class Rigidbody : Component
    {
        mixin(monoObjectImpl);

        @property Vector3 angularVelocity();
        @property void angularVelocity(Vector3 val);
        @property float drag();
        @property void drag(float val);
        @property float angularDrag();
        @property void angularDrag(float val);
        @property float mass();
        @property void mass(float val);
        @property bool useGravity();
        @property void useGravity(bool val);
        @property float maxDepenetrationVelocity();
        @property void maxDepenetrationVelocity(float val);
        @property bool isKinematic();
        @property void isKinematic(bool val);
        @property bool freezeRotation();
        @property void freezeRotation(bool val);
        @property RigidbodyConstraints constraints();
        @property void constraints(RigidbodyConstraints val);
        @property CollisionDetectionMode collisionDetectionMode();
        @property void collisionDetectionMode(CollisionDetectionMode val);
        @property Vector3 centerOfMass();
        @property void centerOfMass(Vector3 val);
        @property Vector3 worldCenterOfMass();
        @property Quaternion inertiaTensorRotation();
        @property void inertiaTensorRotation(Quaternion val);
        @property Vector3 inertiaTensor();
        @property void inertiaTensor(Vector3 val);
        @property bool detectCollisions();
        @property void detectCollisions(bool val);
        @property Vector3 position();
        @property void position(Vector3 val);
        @property Quaternion rotation();
        @property void rotation(Quaternion val);
        @property RigidbodyInterpolation interpolation();
        @property void interpolation(RigidbodyInterpolation val);
        @property int solverIterations();
        @property void solverIterations(int val);
        @property float sleepThreshold();
        @property void sleepThreshold(float val);
        @property float maxAngularVelocity();
        @property void maxAngularVelocity(float val);
        @property int solverVelocityIterations();
        @property void solverVelocityIterations(int val);
        @property float sleepVelocity();
        @property void sleepVelocity(float val);
        @property float sleepAngularVelocity();
        @property void sleepAngularVelocity(float val);
        @property bool useConeFriction();
        @property void useConeFriction(bool val);
        @property Vector3 velocity();
        @property void velocity(Vector3 val);
        @property int solverIterationCount();
        @property void solverIterationCount(int val);
        @property int solverVelocityIterationCount();
        @property void solverVelocityIterationCount(int val);

        void AddExplosionForce(float explosionForce, Vector3 explosionPosition, float explosionRadius, float upwardsModifier, ForceMode mode);
        void AddExplosionForce(float explosionForce, Vector3 explosionPosition, float explosionRadius, float upwardsModifier);
        void AddExplosionForce(float explosionForce, Vector3 explosionPosition, float explosionRadius);
        void AddForce(Vector3 force, ForceMode mode);
        void AddForce(Vector3 force);
        void AddForce(float x, float y, float z, ForceMode mode);
        void AddForce(float x, float y, float z);
        void AddForceAtPosition(Vector3 force, Vector3 position);
        void AddForceAtPosition(Vector3 force, Vector3 position, ForceMode mode);
        void AddRelativeForce(Vector3 force, ForceMode mode);
        void AddRelativeForce(Vector3 force);
        void AddRelativeForce(float x, float y, float z);
        void AddRelativeForce(float x, float y, float z, ForceMode mode);
        void AddRelativeTorque(Vector3 torque, ForceMode mode);
        void AddRelativeTorque(Vector3 torque);
        void AddRelativeTorque(float x, float y, float z, ForceMode mode);
        void AddRelativeTorque(float x, float y, float z);
        void AddTorque(Vector3 torque, ForceMode mode);
        void AddTorque(float x, float y, float z, ForceMode mode);
        void AddTorque(Vector3 torque);
        void AddTorque(float x, float y, float z);
        Vector3 ClosestPointOnBounds(Vector3 position);
        Vector3 GetPointVelocity(Vector3 worldPoint);
        Vector3 GetRelativePointVelocity(Vector3 relativePoint);
        bool IsSleeping();
        void MovePosition(Vector3 position);
        void MoveRotation(Quaternion rot);
        void ResetCenterOfMass();
        void ResetInertiaTensor();
        void SetDensity(float density);
        void SetMaxAngularVelocity(float a);
        void Sleep();
        bool SweepTest(Vector3 direction, out RaycastHit hitInfo, float maxDistance, QueryTriggerInteraction queryTriggerInteraction);
        bool SweepTest(Vector3 direction, out RaycastHit hitInfo, float maxDistance);
        bool SweepTest(Vector3 direction, out RaycastHit hitInfo);
        RaycastHit[] SweepTestAll(Vector3 direction, float maxDistance, QueryTriggerInteraction queryTriggerInteraction);
        RaycastHit[] SweepTestAll(Vector3 direction, float maxDistance);
        RaycastHit[] SweepTestAll(Vector3 direction);
        void WakeUp();

    }


    abstract class Camera : Behaviour
    {
        mixin(monoObjectImpl);

        @property float nearClipPlane();
        @property void nearClipPlane(float val);
        @property float farClipPlane();
        @property void farClipPlane(float val);
        @property float fieldOfView();
        @property void fieldOfView(float val);
        @property RenderingPath renderingPath();
        @property void renderingPath(RenderingPath val);
        @property RenderingPath actualRenderingPath();
        @property bool allowHDR();
        @property void allowHDR(bool val);
        @property bool allowMSAA();
        @property void allowMSAA(bool val);
        @property bool allowDynamicResolution();
        @property void allowDynamicResolution(bool val);
        @property bool forceIntoRenderTexture();
        @property void forceIntoRenderTexture(bool val);
        @property float orthographicSize();
        @property void orthographicSize(float val);
        @property bool orthographic();
        @property void orthographic(bool val);
        @property OpaqueSortMode opaqueSortMode();
        @property void opaqueSortMode(OpaqueSortMode val);
        @property TransparencySortMode transparencySortMode();
        @property void transparencySortMode(TransparencySortMode val);
        @property Vector3 transparencySortAxis();
        @property void transparencySortAxis(Vector3 val);
        @property float depth();
        @property void depth(float val);
        @property float aspect();
        @property void aspect(float val);
        @property Vector3 velocity();
        @property int cullingMask();
        @property void cullingMask(int val);
        @property int eventMask();
        @property void eventMask(int val);
        @property bool layerCullSpherical();
        @property void layerCullSpherical(bool val);
        @property CameraType cameraType();
        @property void cameraType(CameraType val);
        @property ulong overrideSceneCullingMask();
        @property void overrideSceneCullingMask(ulong val);
        @property float[] layerCullDistances();
        @property void layerCullDistances(float[] val);
        @property static int PreviewCullingLayer();
        @property bool useOcclusionCulling();
        @property void useOcclusionCulling(bool val);
        @property Matrix4x4 cullingMatrix();
        @property void cullingMatrix(Matrix4x4 val);
        @property Color backgroundColor();
        @property void backgroundColor(Color val);
        @property CameraClearFlags clearFlags();
        @property void clearFlags(CameraClearFlags val);
        @property DepthTextureMode depthTextureMode();
        @property void depthTextureMode(DepthTextureMode val);
        @property bool clearStencilAfterLightingPass();
        @property void clearStencilAfterLightingPass(bool val);
        //@property ProjectionMatrixMode projectionMatrixMode();
        @property bool usePhysicalProperties();
        @property void usePhysicalProperties(bool val);
        @property Vector2 sensorSize();
        @property void sensorSize(Vector2 val);
        @property Vector2 lensShift();
        @property void lensShift(Vector2 val);
        @property float focalLength();
        @property void focalLength(float val);
        @property GateFitMode gateFit();
        @property void gateFit(GateFitMode val);
        @property Rect rect();
        @property void rect(Rect val);
        @property Rect pixelRect();
        @property void pixelRect(Rect val);
        @property int pixelWidth();
        @property int pixelHeight();
        @property int scaledPixelWidth();
        @property int scaledPixelHeight();
        @property RenderTexture targetTexture();
        @property void targetTexture(RenderTexture val);
        @property RenderTexture activeTexture();
        @property int targetDisplay();
        @property void targetDisplay(int val);
        @property Matrix4x4 cameraToWorldMatrix();
        @property Matrix4x4 worldToCameraMatrix();
        @property void worldToCameraMatrix(Matrix4x4 val);
        @property Matrix4x4 projectionMatrix();
        @property void projectionMatrix(Matrix4x4 val);
        @property Matrix4x4 nonJitteredProjectionMatrix();
        @property void nonJitteredProjectionMatrix(Matrix4x4 val);
        @property bool useJitteredProjectionMatrixForTransparentRendering();
        @property void useJitteredProjectionMatrixForTransparentRendering(bool val);
        @property Matrix4x4 previousViewProjectionMatrix();
        @property static Camera main();
        @property static Camera current();
        @property Scene scene();
        @property void scene(Scene val);
        @property bool stereoEnabled();
        @property float stereoSeparation();
        @property void stereoSeparation(float val);
        @property float stereoConvergence();
        @property void stereoConvergence(float val);
        @property bool areVRStereoViewMatricesWithinSingleCullTolerance();
        @property StereoTargetEyeMask stereoTargetEye();
        @property void stereoTargetEye(StereoTargetEyeMask val);
        @property MonoOrStereoscopicEye stereoActiveEye();
        @property static int allCamerasCount();
        @property static Camera[] allCameras();
        @property int commandBufferCount();
        @property bool isOrthoGraphic();
        @property void isOrthoGraphic(bool val);
        @property static Camera mainCamera();
        @property float near();
        @property void near(float val);
        @property float far();
        @property void far(float val);
        @property float fov();
        @property void fov(float val);
        @property bool hdr();
        @property void hdr(bool val);
        @property bool stereoMirrorMode();
        @property void stereoMirrorMode(bool val);
        
        enum StereoscopicEye
        {
            Left = 0,
            Right = 1
        }

        enum MonoOrStereoscopicEye
        {
            Left = 0,
            Right = 1,
            Mono = 2
        }

        enum GateFitMode
        {
            None = 0,
            Vertical = 1,
            Horizontal = 2,
            Fill = 3,
            Overscan = 4
        }

        enum FieldOfViewAxis
        {
            Vertical = 0,
            Horizontal = 1
        }
    }

    abstract class Random
    {
        mixin(monoObjectImpl);

        @property static Quaternion rotation();
        @property static Vector3 onUnitSphere();
        @property static Vector2 insideUnitCircle();
        @property static Vector3 insideUnitSphere();
        @property static float value();
        //@property static State state { get; set; }
        @property static int seed();
        @property static void seed(int val);
        @property static Quaternion rotationUniform();

        static int Range(int min, int max);
        static float Range(float min, float max);
    }

    abstract class Resources
    {
        mixin(monoObjectImpl);

        static Object_ Load(string path);
        static T Load(T)(string path) { mixin(monoGenericMethod); }

    }

    abstract class Texture : Object_
    {
        mixin(monoObjectImpl);
    }

    abstract class RenderTexture : Texture
    {
        mixin(monoObjectImpl);
    }

    abstract class Renderer : Component
    {
        mixin(monoObjectImpl);
    }

    abstract class TrailRenderer : Renderer
    {
        mixin(monoObjectImpl);

        @property float time();
        @property void time(float val);

        void Clear();
    }
}


@assembly(unityDefaultAssembly)
//@namespace("")
abstract class NativeLoader : MonoBehaviour
{
    mixin(monoObjectImpl);

    mixin MonoMember!(int, "testInt");
    mixin MonoMember!(string, "testStr");
    mixin MonoMember!(GameObject, "testGo");

    static mixin MonoMember!(string, "pluginExtension");

    //private int testInt = 42;
    //private string testStr = "test";
    //private Vector3 testVec = new Vector3(1f,2f,3f);
    //private GameObject testGo;
}


@namespace("UnityEngine")
enum KeyCode
{
    None = 0,
    Backspace = 8,
    Tab = 9,
    Clear = 12,
    Return = 13,
    Pause = 19,
    Escape = 27,
    Space = 32,
    Exclaim = 33,
    DoubleQuote = 34,
    Hash = 35,
    Dollar = 36,
    Percent = 37,
    Ampersand = 38,
    Quote = 39,
    LeftParen = 40,
    RightParen = 41,
    Asterisk = 42,
    Plus = 43,
    Comma = 44,
    Minus = 45,
    Period = 46,
    Slash = 47,
    Alpha0 = 48,
    Alpha1 = 49,
    Alpha2 = 50,
    Alpha3 = 51,
    Alpha4 = 52,
    Alpha5 = 53,
    Alpha6 = 54,
    Alpha7 = 55,
    Alpha8 = 56,
    Alpha9 = 57,
    Colon = 58,
    Semicolon = 59,
    Less = 60,
    Equals = 61,
    Greater = 62,
    Question = 63,
    At = 64,
    LeftBracket = 91,
    Backslash = 92,
    RightBracket = 93,
    Caret = 94,
    Underscore = 95,
    BackQuote = 96,
    A = 97,
    B = 98,
    C = 99,
    D = 100,
    E = 101,
    F = 102,
    G = 103,
    H = 104,
    I = 105,
    J = 106,
    K = 107,
    L = 108,
    M = 109,
    N = 110,
    O = 111,
    P = 112,
    Q = 113,
    R = 114,
    S = 115,
    T = 116,
    U = 117,
    V = 118,
    W = 119,
    X = 120,
    Y = 121,
    Z = 122,
    LeftCurlyBracket = 123,
    Pipe = 124,
    RightCurlyBracket = 125,
    Tilde = 126,
    Delete = 127,
    Keypad0 = 256,
    Keypad1 = 257,
    Keypad2 = 258,
    Keypad3 = 259,
    Keypad4 = 260,
    Keypad5 = 261,
    Keypad6 = 262,
    Keypad7 = 263,
    Keypad8 = 264,
    Keypad9 = 265,
    KeypadPeriod = 266,
    KeypadDivide = 267,
    KeypadMultiply = 268,
    KeypadMinus = 269,
    KeypadPlus = 270,
    KeypadEnter = 271,
    KeypadEquals = 272,
    UpArrow = 273,
    DownArrow = 274,
    RightArrow = 275,
    LeftArrow = 276,
    Insert = 277,
    Home = 278,
    End = 279,
    PageUp = 280,
    PageDown = 281,
    F1 = 282,
    F2 = 283,
    F3 = 284,
    F4 = 285,
    F5 = 286,
    F6 = 287,
    F7 = 288,
    F8 = 289,
    F9 = 290,
    F10 = 291,
    F11 = 292,
    F12 = 293,
    F13 = 294,
    F14 = 295,
    F15 = 296,
    Numlock = 300,
    CapsLock = 301,
    ScrollLock = 302,
    RightShift = 303,
    LeftShift = 304,
    RightControl = 305,
    LeftControl = 306,
    RightAlt = 307,
    LeftAlt = 308,
    RightCommand = 309,
    RightApple = 309,
    LeftCommand = 310,
    LeftApple = 310,
    LeftWindows = 311,
    RightWindows = 312,
    AltGr = 313,
    Help = 315,
    Print = 316,
    SysReq = 317,
    Break = 318,
    Menu = 319,
    Mouse0 = 323,
    Mouse1 = 324,
    Mouse2 = 325,
    Mouse3 = 326,
    Mouse4 = 327,
    Mouse5 = 328,
    Mouse6 = 329,
    JoystickButton0 = 330,
    JoystickButton1 = 331,
    JoystickButton2 = 332,
    JoystickButton3 = 333,
    JoystickButton4 = 334,
    JoystickButton5 = 335,
    JoystickButton6 = 336,
    JoystickButton7 = 337,
    JoystickButton8 = 338,
    JoystickButton9 = 339,
    JoystickButton10 = 340,
    JoystickButton11 = 341,
    JoystickButton12 = 342,
    JoystickButton13 = 343,
    JoystickButton14 = 344,
    JoystickButton15 = 345,
    JoystickButton16 = 346,
    JoystickButton17 = 347,
    JoystickButton18 = 348,
    JoystickButton19 = 349,
    Joystick1Button0 = 350,
    Joystick1Button1 = 351,
    Joystick1Button2 = 352,
    Joystick1Button3 = 353,
    Joystick1Button4 = 354,
    Joystick1Button5 = 355,
    Joystick1Button6 = 356,
    Joystick1Button7 = 357,
    Joystick1Button8 = 358,
    Joystick1Button9 = 359,
    Joystick1Button10 = 360,
    Joystick1Button11 = 361,
    Joystick1Button12 = 362,
    Joystick1Button13 = 363,
    Joystick1Button14 = 364,
    Joystick1Button15 = 365,
    Joystick1Button16 = 366,
    Joystick1Button17 = 367,
    Joystick1Button18 = 368,
    Joystick1Button19 = 369,
    Joystick2Button0 = 370,
    Joystick2Button1 = 371,
    Joystick2Button2 = 372,
    Joystick2Button3 = 373,
    Joystick2Button4 = 374,
    Joystick2Button5 = 375,
    Joystick2Button6 = 376,
    Joystick2Button7 = 377,
    Joystick2Button8 = 378,
    Joystick2Button9 = 379,
    Joystick2Button10 = 380,
    Joystick2Button11 = 381,
    Joystick2Button12 = 382,
    Joystick2Button13 = 383,
    Joystick2Button14 = 384,
    Joystick2Button15 = 385,
    Joystick2Button16 = 386,
    Joystick2Button17 = 387,
    Joystick2Button18 = 388,
    Joystick2Button19 = 389,
    Joystick3Button0 = 390,
    Joystick3Button1 = 391,
    Joystick3Button2 = 392,
    Joystick3Button3 = 393,
    Joystick3Button4 = 394,
    Joystick3Button5 = 395,
    Joystick3Button6 = 396,
    Joystick3Button7 = 397,
    Joystick3Button8 = 398,
    Joystick3Button9 = 399,
    Joystick3Button10 = 400,
    Joystick3Button11 = 401,
    Joystick3Button12 = 402,
    Joystick3Button13 = 403,
    Joystick3Button14 = 404,
    Joystick3Button15 = 405,
    Joystick3Button16 = 406,
    Joystick3Button17 = 407,
    Joystick3Button18 = 408,
    Joystick3Button19 = 409,
    Joystick4Button0 = 410,
    Joystick4Button1 = 411,
    Joystick4Button2 = 412,
    Joystick4Button3 = 413,
    Joystick4Button4 = 414,
    Joystick4Button5 = 415,
    Joystick4Button6 = 416,
    Joystick4Button7 = 417,
    Joystick4Button8 = 418,
    Joystick4Button9 = 419,
    Joystick4Button10 = 420,
    Joystick4Button11 = 421,
    Joystick4Button12 = 422,
    Joystick4Button13 = 423,
    Joystick4Button14 = 424,
    Joystick4Button15 = 425,
    Joystick4Button16 = 426,
    Joystick4Button17 = 427,
    Joystick4Button18 = 428,
    Joystick4Button19 = 429,
    Joystick5Button0 = 430,
    Joystick5Button1 = 431,
    Joystick5Button2 = 432,
    Joystick5Button3 = 433,
    Joystick5Button4 = 434,
    Joystick5Button5 = 435,
    Joystick5Button6 = 436,
    Joystick5Button7 = 437,
    Joystick5Button8 = 438,
    Joystick5Button9 = 439,
    Joystick5Button10 = 440,
    Joystick5Button11 = 441,
    Joystick5Button12 = 442,
    Joystick5Button13 = 443,
    Joystick5Button14 = 444,
    Joystick5Button15 = 445,
    Joystick5Button16 = 446,
    Joystick5Button17 = 447,
    Joystick5Button18 = 448,
    Joystick5Button19 = 449,
    Joystick6Button0 = 450,
    Joystick6Button1 = 451,
    Joystick6Button2 = 452,
    Joystick6Button3 = 453,
    Joystick6Button4 = 454,
    Joystick6Button5 = 455,
    Joystick6Button6 = 456,
    Joystick6Button7 = 457,
    Joystick6Button8 = 458,
    Joystick6Button9 = 459,
    Joystick6Button10 = 460,
    Joystick6Button11 = 461,
    Joystick6Button12 = 462,
    Joystick6Button13 = 463,
    Joystick6Button14 = 464,
    Joystick6Button15 = 465,
    Joystick6Button16 = 466,
    Joystick6Button17 = 467,
    Joystick6Button18 = 468,
    Joystick6Button19 = 469,
    Joystick7Button0 = 470,
    Joystick7Button1 = 471,
    Joystick7Button2 = 472,
    Joystick7Button3 = 473,
    Joystick7Button4 = 474,
    Joystick7Button5 = 475,
    Joystick7Button6 = 476,
    Joystick7Button7 = 477,
    Joystick7Button8 = 478,
    Joystick7Button9 = 479,
    Joystick7Button10 = 480,
    Joystick7Button11 = 481,
    Joystick7Button12 = 482,
    Joystick7Button13 = 483,
    Joystick7Button14 = 484,
    Joystick7Button15 = 485,
    Joystick7Button16 = 486,
    Joystick7Button17 = 487,
    Joystick7Button18 = 488,
    Joystick7Button19 = 489,
    Joystick8Button0 = 490,
    Joystick8Button1 = 491,
    Joystick8Button2 = 492,
    Joystick8Button3 = 493,
    Joystick8Button4 = 494,
    Joystick8Button5 = 495,
    Joystick8Button6 = 496,
    Joystick8Button7 = 497,
    Joystick8Button8 = 498,
    Joystick8Button9 = 499,
    Joystick8Button10 = 500,
    Joystick8Button11 = 501,
    Joystick8Button12 = 502,
    Joystick8Button13 = 503,
    Joystick8Button14 = 504,
    Joystick8Button15 = 505,
    Joystick8Button16 = 506,
    Joystick8Button17 = 507,
    Joystick8Button18 = 508,
    Joystick8Button19 = 509
}