module unity;

import mono;

alias Field = MonoMember;


enum unityDefaultAssembly = "Assembly-CSharp";


@namespace("System")
{
    abstract class Type {}
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

    @symname("Object")
    abstract class Object_
    {
        mixin(monoObjectImpl);

        @property string name();
        @property void name(string);
        @property HideFlags hideFlags();
        @property void hideFlags(HideFlags);
        static void Destroy(Object obj);
        static void Destroy(Object obj, float t);
        static void DontDestroyOnLoad(Object target);
        static Object FindObjectOfType(Type type);
        static T FindObjectOfType(T)() { mixin(monoGenericMethod!T); }
        //static T[] FindObjectsOfType(T)();
        //static Object[] FindObjectsOfType(Type type);
        static Object Instantiate(Object original, Vector3 position, Quaternion rotation, Transform parent);
        static Object Instantiate(Object original);
        static Object Instantiate(Object original, Vector3 position, Quaternion rotation);
        //static T Instantiate(T)(T original, Transform parent, bool worldPositionStays);
        //static T Instantiate(T)(T original, Transform parent);
        //static T Instantiate(T)(T original, Vector3 position, Quaternion rotation, Transform parent);
        //static T Instantiate(T)(T original, Vector3 position, Quaternion rotation);
        //static T Instantiate(T)(T original);
        static Object Instantiate(Object original, Transform parent, bool instantiateInWorldSpace);
        static Object Instantiate(Object original, Transform parent);
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
        /*
        T GetComponentInChildren(T)();
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

        T AddComponent(T : Component)() { mixin(monoGenericMethod!T); }
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


    struct Vector3
    {
        float x, y, z;
    }


    struct Matrix4x4
    {
        float[16] m; // these actually are 16 floats named 'm00' to 'm33'
    }


    struct Quaternion
    {
        float x, y, z, w;
    }


    struct Scene
    {
        @property int handle();
    }


    abstract class YieldInstruction {}


    abstract class Coroutine : YieldInstruction {}


    abstract class Time 
    {
        mixin(monoObjectImpl);

        @property static float realtimeSinceStartup();
        @property static int renderedFrameCount();
        @property static int frameCount();
        @property static float timeScale();
        @property static float timeScale(float val);
        @property static float maximumParticleDeltaTime();
        @property static float maximumParticleDeltaTime(float val);
        @property static float smoothDeltaTime();
        @property static float maximumDeltaTime();
        @property static float maximumDeltaTime(float val);
        @property static int captureFramerate();
        @property static int captureFramerate(float val);
        @property static float fixedDeltaTime();
        @property static float fixedDeltaTime(float val);
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