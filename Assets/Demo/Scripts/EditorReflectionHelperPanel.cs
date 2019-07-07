using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;

#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;

public class EditorReflectionHelperPanel : EditorWindow
{
    Vector2 scroll;
    string typename;
    string result;
    bool optFields;
    bool optProperties = true;
    bool optMethods = true;
    bool optNestedTypes;

    [MenuItem("Helpers/Reflection (D Wrapper Maker)")]
    public static void ShowWindow()
    {
        //Show existing window instance. If one doesn't exist, make one.
        EditorWindow.GetWindow(typeof(EditorReflectionHelperPanel));
    }

    private void OnGUI()
    {
        GUILayout.Label("Reflection", EditorStyles.boldLabel);
        typename = EditorGUILayout.TextField("Type Name (Fully Qualified)", typename);
        
        GUILayout.Label("Include", EditorStyles.boldLabel);
        var grp = EditorGUILayout.BeginHorizontal();
        optFields = EditorGUILayout.ToggleLeft("Fields", optFields, GUILayout.Width(position.width/4));
        optProperties = EditorGUILayout.ToggleLeft("Properties", optProperties, GUILayout.Width(position.width / 4));
        optMethods = EditorGUILayout.ToggleLeft("Methods", optMethods, GUILayout.Width(position.width / 4));
        optNestedTypes = EditorGUILayout.ToggleLeft("Nested Types", optNestedTypes, GUILayout.Width(position.width / 4));
        EditorGUILayout.EndHorizontal();

        
        if (Event.current != null && Event.current.isKey)
        {
            if (Event.current.keyCode == KeyCode.Return || Event.current.keyCode == KeyCode.KeypadEnter)
            {
                GenerateWrapper();
            }
            else
            {
                // auto completion?
            }
        }

        scroll = EditorGUILayout.BeginScrollView(scroll);
        EditorGUILayout.TextArea(result, GUILayout.Height(position.height - 60));
        EditorGUILayout.EndScrollView();
    }

    void GenerateWrapper()
    {
        if (typename.Length == 0) 
        {
            return;
        }

        var qualNameParts = typename.Split('.');
        var qualTypeName = qualNameParts.Length == 1 ? qualNameParts[0] : qualNameParts[qualNameParts.Length - 1];

        result = string.Empty;

        var assemblies = System.AppDomain.CurrentDomain.GetAssemblies();
        //var asslist = assemblies.ToList();
        //asslist.Sort(AssemblyNestingComparer.instance);
        try
        {
            var found = assemblies
                 .SelectMany(a => a.GetTypes())
                 .Where(t => t.Namespace == (qualNameParts.Length < 2 ? string.Empty : typename.Substring(0, typename.LastIndexOf('.')))
                    && t.Name == qualTypeName
                    || t.Name.StartsWith(qualTypeName + "`" ) // one of the cases for generics
                 )
                 ;

            var res = found.First();
            bool isPossiblyStruct = res.IsValueType && !res.IsEnum && !res.IsPrimitive;

            var sb = new System.Text.StringBuilder();
            if (res.IsEnum)
            {
                sb.Append($"enum {res.Name}\n{{");
                for (int i = 0; i < res.GetEnumValues().Length; i++)
                    sb.Append($"    {res.GetEnumNames()[i]} = {res.GetEnumValues().GetValue(i)},\n");
                sb.Append("}\n");
            }
            else
            {
                const BindingFlags flags = BindingFlags.DeclaredOnly
                    | BindingFlags.Instance
                    | BindingFlags.Static
                    | BindingFlags.Public
                    //| BindingFlags.NonPublic // it is probably better to remove this one
                    ;

                // this will take care of engine modules, at this moment it is recommended to stick with monolithic assembly
                if (System.IO.Path.GetDirectoryName(res.Assembly.Location).EndsWith("UnityEngine"))
                    sb.AppendLine($"@assembly(\"UnityEngine\");");
                else
                    sb.AppendLine($"@assembly(\"{res.Assembly.GetName().Name}\");");

                sb.AppendLine($"@namespace(\"{res.Namespace}\");");

                sb.Append($"{(isPossiblyStruct ? "struct" : "abstract class")} {AdjustedTypeName(res)}");
                if (res.IsClass)
                {
                    if (res.BaseType != typeof(System.Object) || res.GetInterfaces().Length > 0)
                        sb.Append(" : ");
                    if (res.BaseType != typeof(System.Object))
                        sb.Append(AdjustedTypeName(res.BaseType));
                    for (int i = 0; i < res.GetInterfaces().Length; i++)
                        sb.Append($"{res.GetInterfaces()[i].Name}{(i+1 < res.GetInterfaces().Length ? ", " : "")}");

                }
                sb.AppendLine();
                sb.AppendLine("{");
                sb.AppendLine("    mixin(monoObjectImpl);");
                sb.AppendLine();

                if (optFields)
                {
                    sb.AppendLine("// fields not implemented yet");
                    sb.AppendLine();
                }

                if (optProperties)
                {
                    foreach (var p in res.GetProperties(flags))
                    {
                        if (p.IsSpecialName)
                            continue;
                        if (p.CanRead)
                            sb.AppendLine($"@property {(p.GetMethod.IsStatic ? "static " : "")}{AdjustedTypeName(p.PropertyType)} {p.Name}();");
                        if (p.CanWrite)
                            sb.AppendLine($"@property {(p.SetMethod.IsStatic ? "static " : "")}void {p.Name}({AdjustedTypeName(p.PropertyType)} val);");
                    }
                    sb.AppendLine();
                }
        
                if (optMethods)
                {
                    foreach(var m in res.GetMethods(flags))
                    {
                        if (m.ContainsGenericParameters || m.IsConstructor || m.IsGenericMethod || m.IsSpecialName)
                            continue;
                        sb.Append($"{(m.IsStatic ? "static " : "")}{AdjustedTypeName(m.ReturnType)} {m.Name}(");
                          for (int i = 0; i < m.GetParameters().Length; i++)
                            sb.Append($"{(m.GetParameters()[i].IsOut ? "out " : (m.GetParameters()[i].ParameterType.IsByRef ? "ref " : ""))}{(m.GetParameters()[i].ParameterType.IsByRef ? AdjustedTypeName(m.GetParameters()[i].ParameterType.GetElementType()) : AdjustedTypeName(m.GetParameters()[i].ParameterType))} {m.GetParameters()[i].Name}{(m.GetParameters()[i].HasDefaultValue ? m.GetParameters()[i].DefaultValue.ToString()  : "")}{(i+1 < m.GetParameters().Length ? ", " : "")}");
                        sb.Append(");\n");
                    }
                    sb.AppendLine();
                }

                if (optNestedTypes)
                {
                    sb.AppendLine("// nested types not implemented yet");
                    sb.AppendLine();
                }

                sb.AppendLine("}");
            }

            result = sb.ToString();
        }
        catch (System.Exception e)
        {
            result += "Error:\n";
            result += e.Message;
        }
    }

    private static readonly Dictionary<System.Type, string> Aliases =
    new Dictionary<System.Type, string>()
    {
        { typeof(byte), "ubyte" },
        { typeof(sbyte), "byte" },
        { typeof(short), "short" },
        { typeof(ushort), "ushort" },
        { typeof(int), "int" },
        { typeof(uint), "uint" },
        { typeof(long), "long" },
        { typeof(ulong), "ulong" },
        { typeof(float), "float" },
        { typeof(double), "double" },
        { typeof(decimal), "decimal" },
        { typeof(object), "Object" },
        { typeof(bool), "bool" },
        { typeof(char), "char" },
        { typeof(string), "string" },
        { typeof(void), "void" },
        { typeof(UnityEngine.Object), "Object_" }
    };

    static string AdjustedTypeName(System.Type t)
    {
        return Aliases.ContainsKey(t) ? Aliases[t] : t.Name;
    }
}

class AssemblyNestingComparer : IComparer<Assembly>
{
    public static AssemblyNestingComparer instance { get; } = new AssemblyNestingComparer();

    public int Compare(Assembly x, Assembly y)
    {
        return y.FullName.Count(c => c == '.') - x.FullName.Count(c => c == '.');
    }
}
#endif