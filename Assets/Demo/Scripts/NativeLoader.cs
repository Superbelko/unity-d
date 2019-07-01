using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

using UnityEngine;

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
#error Implement Me
#endif
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void PluginInit(IntPtr entryObject);

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void PluginTick(float dt);

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void PluginShutdown();

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

    private GCHandle _objhandle;

    private void Awake()
    {
        LoadPlugin();
        InitPlugin();
    }

    private void OnApplicationQuit()
    {
        UnloadPlugin();
    }

    private void InitPlugin()
    {
        if (!_objhandle.IsAllocated)
            _objhandle = GCHandle.Alloc(this);
        _init(GCHandle.ToIntPtr(_objhandle));
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
            while (Functions.FreeLibrary(libHandle))
            {
                // do nothing, repeat until free library release all references
            }
            libHandle = IntPtr.Zero;
            if (_objhandle.IsAllocated)
                _objhandle.Free();
        }
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
        return $"{pluginPath}{sep}{namePrefix}{pluginName}{extension}";
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
                    pluginName.stringValue.Remove(0, 3);
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