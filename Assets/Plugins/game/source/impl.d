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


extern(C)
export void PluginInit(void* owner)
{
    auto mrt = GetModuleHandle("mono-2.0-bdwgc.dll");
    Loader.Load(mrt);
    onPluginLoaded(owner);
}

void onPluginLoaded(void* obj)
{
    auto dom = MonoDomainHandle.get();
    auto ass = dom.openAssembly("UnityEngine");
    MonoClassHandle cls = ass.image.classFromName("UnityEngine", "Debug");
    auto m = cls.getMethod!(Debug.Log)();
    auto mb_class = ass.image.classFromName("UnityEngine", "MonoBehaviour");
    auto go_class = ass.image.classFromName("UnityEngine", "GameObject");
    auto light_class = ass.image.classFromName("UnityEngine", "Light");
    auto vec_class = ass.image.classFromName("UnityEngine", "Vector3");


    MonoBehaviour mb = new MonoImplement!MonoBehaviour(cast(MonoObject*)mono_gchandle_get_target(cast(uint)obj));
    try 
    {
        Transform tf = mb.transform;
        Vector3 pos = tf.localPosition;
        Debug.Log(format("x:%s y:%s z:%s", pos.x, pos.y, pos.z));

        auto tag = mb.tag;
        Debug.Log(tag);
        mb.print(tag);

        GameObject other = new MonoImplement!GameObject("Test Object");
        
        //throw new Exception("test exception");
    }
    catch (Exception e)
    {
        import std.file;
        Debug.Log(format("%s\n%s:%s", e.msg, e.file, e.line));
    }

    //Debug.Log(to!string(mono_class_get_method_from_name(vec_class.handle, "op_Multiply", 2)));
/*
    auto light_type = mono_class_get_type(light_class.handle);
    // obtains System.Type
    auto rt = mono_type_get_object(dom.handle, light_type);
    //m.call(rt);

    // description sucks...
    //auto mdesc = mono_method_desc_new (":AddComponent(System.Type)", false);
    //scope(exit) mono_method_desc_free(mdesc);
    //auto instantiate = mono_method_desc_search_in_class(mdesc, go_class.handle);

    auto instantiate = mono_class_get_method_from_name(go_class.handle, "AddComponent", 0);

    //m.call(boxify(instantiate ? "yay" : "nay"));
    if (instantiate)
    {
        import mono_internal;
        auto gi = new _MonoGenericInst();
        gi.id = -1;
        gi.is_open = 0;
        gi.type_argc = 1;
        gi.type_argv = cast(MonoType**) light_type;
        auto ctx = _MonoGenericContext(null, gi);
        auto inflated = mono_class_inflate_generic_method(instantiate, cast(mono.MonoGenericContext*) &ctx);
        //m.call( to!string(inflated).toStringz.boxify );
        if (inflated)
            mono_runtime_invoke(inflated, go_handle, null, null);

    }
*/

    //DumpMethods(go_class.handle, m.handle);
}

extern(C)
export void PluginShutdown()
{
    
}


MonoMethod* DumpMethods(MonoClass* klass, MonoMethod* logger)
{
    import core.stdc.string;
    void* iter;
    MonoMethod* m;
    m = mono_class_get_methods(klass, &iter);
    while (m !is null)
    {
        auto cstr = mono_method_get_name(m);
        auto sig = mono_method_signature(m);
        auto pnum = mono_signature_get_param_count(sig);

        //auto desc = mono_method_desc_from_method(m);
        auto logmsg = mono_string_new(MonoDomainHandle.get().handle, mono_method_get_reflection_name(m));
        void*[2] args;
        args[0] = logmsg;
        mono_runtime_invoke(logger, null, args.ptr, null);
        //mono_method_desc_free(desc);


        m = mono_class_get_methods(klass, &iter);
    }
    return null;
}

version(app_target)
void main()
{
    import unity;
    Debug.Log("test");
}