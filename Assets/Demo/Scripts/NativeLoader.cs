using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

using UnityEngine;
using UnityEngine.SceneManagement;

#if UNITY_EDITOR
using UnityEditor;
#endif


/// 
/// Handles native library (plugin) loading and unloading allowing the iterative
/// process without the need to restart Unity (as when using P/Invoke DllImport)
/// 
class NativeLoader : MonoBehaviour
{
    internal static class Functions
    {
#if UNITY_STANDALONE_WIN
        [DllImport("kernel32.dll", SetLastError = true)]
        internal extern static IntPtr LoadLibrary(string libraryName);

        [DllImport("kernel32.dll", SetLastError = true)]
        internal extern static bool FreeLibrary(IntPtr hModule);

        [DllImport("kernel32.dll", SetLastError = true)]
        internal extern static IntPtr GetProcAddress(IntPtr hModule, string procName);
#else
        [DllImport("libdl")]
        internal extern static IntPtr dlopen(string name, int flags);

        [DllImport("libdl")]
        internal extern static int dlclose(IntPtr lib);

        [DllImport("libdl")]
        internal extern static IntPtr dlsym(IntPtr lib, string name);


        const int RTLD_NOW = 2;
        const int RTLD_GLOBAL = 8;

        internal static IntPtr LoadLibrary(string libraryName)
        {
            return dlopen(libraryName, RTLD_NOW);
        }

        internal static bool FreeLibrary(IntPtr hModule)
        {
            dlclose(hModule);
            return false;
        }

        internal static IntPtr GetProcAddress(IntPtr hModule, string procName)
        {
            IntPtr res = dlsym(hModule, procName);
            return res;
        }
#endif
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void PluginInit(IntPtr entryObject, string monoRt);

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void PluginTick(float dt);

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void PluginShutdown();

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void PluginFixedTick();

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void PluginLateTick();

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void Helper_SceneLoaded();

#if UNITY_STANDALONE_WIN
    public static readonly string pluginExtension = ".dll";
    public static readonly string prefix = "";
#else
    public static readonly string pluginExtension = ".so";
    public static readonly string prefix = "lib";
#endif

    [SerializeField]
    PluginField plugin;

    private IntPtr libHandle;
    private PluginInit _init;
    private PluginShutdown _shutdown;
    private PluginTick _tick;
    private PluginFixedTick _fixedTick;
    private PluginLateTick _lateTick;

    // special helper, won't be called on first load
    private Helper_SceneLoaded _sceneLoaded;

    private GCHandle _objhandle;

    private static NativeLoader instance;

    private void Awake()
    {
        if (instance != null && instance.plugin.PluginName == plugin.PluginName)
        {
            Destroy(this.gameObject);
            return;
        }
        DontDestroyOnLoad(this.gameObject);
        instance = this;
        LoadPlugin();
        InitPlugin();
        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void OnSceneLoaded(Scene arg0, LoadSceneMode arg1)
    {
        if (_sceneLoaded != null)
            _sceneLoaded();
    }

    private void OnApplicationQuit()
    {
        UnloadPlugin();
    }

    private void Update()
    {
        if (_tick != null)
            _tick(Time.deltaTime);
    }

    private void FixedUpdate()
    {
        if (_fixedTick != null)
            _fixedTick();
    }

    private void LateUpdate()
    {
        if (_lateTick != null)
            _lateTick();
    }

    private void InitPlugin()
    {
        if (!_objhandle.IsAllocated)
            _objhandle = GCHandle.Alloc(this);
        _init(GCHandle.ToIntPtr(_objhandle), GetMonoPath());
    }

    void LoadPlugin()
    {
#if UNITY_EDITOR
        Debug.Log($"Loading plugin {plugin.PluginName}");
#endif

        var libPath = plugin.BuildPath(prefix, pluginExtension);
        libHandle = Functions.LoadLibrary(libPath);

        _init = (PluginInit)Marshal.GetDelegateForFunctionPointer(Functions.GetProcAddress(libHandle, nameof(PluginInit)), typeof(PluginInit));
        _shutdown = (PluginShutdown)Marshal.GetDelegateForFunctionPointer(Functions.GetProcAddress(libHandle, nameof(PluginShutdown)), typeof(PluginShutdown));

        IntPtr tickFun = Functions.GetProcAddress(libHandle, nameof(PluginTick));
        if (tickFun != IntPtr.Zero)
            _tick = (PluginTick)Marshal.GetDelegateForFunctionPointer(tickFun, typeof(PluginTick));

        IntPtr fixedTickFun = Functions.GetProcAddress(libHandle, nameof(PluginFixedTick));
        if (fixedTickFun != IntPtr.Zero)
            _fixedTick = (PluginFixedTick)Marshal.GetDelegateForFunctionPointer(fixedTickFun, typeof(PluginFixedTick));

        IntPtr lateTickFun = Functions.GetProcAddress(libHandle, nameof(PluginLateTick));
        if (lateTickFun != IntPtr.Zero)
            _lateTick = (PluginLateTick)Marshal.GetDelegateForFunctionPointer(lateTickFun, typeof(PluginLateTick));

        IntPtr sceneLoadedFun = Functions.GetProcAddress(libHandle, nameof(Helper_SceneLoaded));
        if (sceneLoadedFun != IntPtr.Zero)
            _sceneLoaded = (Helper_SceneLoaded)Marshal.GetDelegateForFunctionPointer(sceneLoadedFun, typeof(Helper_SceneLoaded));
    }

    void UnloadPlugin()
    {
#if UNITY_EDITOR
        Debug.Log($"Closing plugin {plugin.PluginName}");
#endif
        if (libHandle != IntPtr.Zero)
        {
            _shutdown();
            _init = null;
            _shutdown = null;
            _tick = null;
            _fixedTick = null;
            _lateTick = null;
            _sceneLoaded = null;
            while (Functions.FreeLibrary(libHandle))
            {
                // do nothing, repeat until free library release all references
            }
            libHandle = IntPtr.Zero;
            if (_objhandle.IsAllocated)
                _objhandle.Free();
        }
    }

    string GetMonoPath()
    {
        string path = null;
#if !UNITY_STANDALONE_WIN
#  if UNITY_EDITOR
        var editorLocation = System.IO.Path.GetDirectoryName(EditorApplication.applicationPath);
        path = $"{editorLocation}/Data/MonoBleedingEdge/MonoEmbedRuntime";
#  else
        path = $"{Application.dataPath}/MonoBleedingEdge/x86_64";
#  endif
        path += "/libmonobdwgc-2.0.so";
#endif
        return path;
    }
}





/// 
/// Little helper to pick plugin as asset without bothering about OS details
/// 
[System.Serializable]
public class PluginField
{
    [SerializeField]
    private UnityEngine.Object pluginAsset;

    [SerializeField]
    private string pluginName = "";

    [SerializeField]
    private string pluginPath = "";

    public string PluginName
    {
        get { return pluginName; }
    }

    public string BuildPath(string namePrefix, string extension)
    {
        var sep = System.IO.Path.DirectorySeparatorChar;
#if UNITY_EDITOR 
        string basePath = pluginPath;
#else
        string basePath = $"{Application.dataPath}{sep}Plugins";
#endif
        return $"{basePath}{sep}{namePrefix}{pluginName}{extension}";
    }
}

#if UNITY_EDITOR
[CustomPropertyDrawer(typeof(PluginField))]
public class PluginFieldPropertyDrawer : PropertyDrawer
{
    public override void OnGUI(Rect _position, SerializedProperty _property, GUIContent _label)
    {
        // TODO: find a way to filter picker to only show shared libs
        EditorGUI.BeginProperty(_position, GUIContent.none, _property);
        SerializedProperty pluginAsset = _property.FindPropertyRelative("pluginAsset");
        SerializedProperty pluginName = _property.FindPropertyRelative("pluginName");
        SerializedProperty pluginPath = _property.FindPropertyRelative("pluginPath");
        _position = EditorGUI.PrefixLabel(_position, GUIUtility.GetControlID(FocusType.Passive), _label);
        if (pluginAsset != null)
        {
            pluginAsset.objectReferenceValue = EditorGUI.ObjectField(_position, pluginAsset.objectReferenceValue, typeof(UnityEngine.Object), false);
            // "validate" that plugin is picked
            if (pluginAsset.objectReferenceValue != null)
            {
                var plugin = PluginImporter
                    .GetAllImporters()
                    .Where(x => x.assetPath == AssetDatabase.GetAssetPath(pluginAsset.objectReferenceValue))
                    .SingleOrDefault();
                if (plugin == null)
                    pluginAsset.objectReferenceValue = null;
            }
            if (pluginAsset.objectReferenceValue != null)
            {
                pluginPath.stringValue = System.IO.Path.GetDirectoryName(AssetDatabase.GetAssetPath(pluginAsset.objectReferenceValue));
                pluginName.stringValue = System.IO.Path.GetFileNameWithoutExtension(AssetDatabase.GetAssetPath(pluginAsset.objectReferenceValue));
                if (pluginName.stringValue.StartsWith("lib"))
                    pluginName.stringValue = pluginName.stringValue.Remove(0, 3);
            }
            else
            {
                pluginName.stringValue = "";
                pluginPath.stringValue = "";
            }
        }
        EditorGUI.EndProperty();
    }
}
#endif