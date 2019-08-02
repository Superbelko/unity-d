module mono;

import core.stdc.inttypes;

import std.traits;
import std.meta;

struct NamespaceAttr { string name; }
@property NamespaceAttr namespace(string ns) { return NamespaceAttr(ns); }

struct AssemblyAttr { string name; }
@property AssemblyAttr assembly(string name) { return AssemblyAttr(name); }

/// Marks symbol with new name to use for wrapper generator, handy for keywords names
struct SymNameAttr { string name; }
/// ditto
@property SymNameAttr symname(string newName) { return SymNameAttr(newName); }



struct MonoDomain;
struct MonoAssembly;
struct MonoImage;
struct MonoClass;
struct MonoMethod;
struct MonoMethodDesc;
struct MonoMethodSignature;
struct MonoType;
struct MonoObject;
struct MonoString;
struct MonoClassField;
struct MonoReflectionType;
struct MonoProperty;
struct MonoArray;
struct MonoVTable;
struct MonoGenericInst;
struct MonoGenericParam;
struct MonoGenericClass;
struct MonoGenericContext;
struct MonoImageSet;
struct MonoEvent;
struct MonoDelegate;
struct MonoThread;

alias MonoError = uint;

immutable MonoObjectSizeOf = 2 * (void*).sizeof;

struct Prototypes
{
extern (C):
static:
    MonoDomain* mono_domain_get();
    MonoAssembly* mono_domain_assembly_open(MonoDomain *domain, const(char)* name);


    MonoImage* mono_assembly_get_image(MonoAssembly *assembly);
    void mono_assembly_close(MonoAssembly* assembly);


    const(char)* mono_class_get_namespace(MonoClass* klass);
    MonoClass* mono_class_from_name(MonoImage* image, const(char)* name_space, const(char)* name);
    MonoVTable* mono_class_vtable(MonoDomain* domain, MonoClass* klass);
    MonoClassField* mono_class_get_fields(MonoClass* klass, void** iter);
    MonoMethod* mono_class_get_methods(MonoClass* klass, void** iter);
    MonoProperty* mono_class_get_properties(MonoClass* klass, void** iter);
    MonoEvent* mono_class_get_events(MonoClass* klass, void** iter);
    MonoClass* mono_class_get_interfaces(MonoClass* klass, void** iter);
    MonoClass* mono_class_get_nested_types(MonoClass* klass, void** iter);
    MonoType* mono_class_get_type(MonoClass* klass);
    MonoProperty* mono_class_get_property_from_name(MonoClass* klass, const(char)* name);
    MonoClassField* mono_class_get_field_from_name(MonoClass* klass, const(char)* name);
    MonoMethod* mono_class_get_method_from_name(MonoClass* klass, const(char)* name, int param_count);
    MonoClass* mono_class_from_generic_parameter(MonoGenericParam* param, MonoImage* image, bool is_mvar);
    MonoMethod* mono_class_inflate_generic_method(MonoMethod* method, MonoGenericContext* context);
    MonoMethod* mono_get_inflated_method(MonoMethod *method);
    MonoType* mono_class_inflate_generic_type_checked(MonoType* type, MonoGenericContext* context, MonoError* error);  // not available in unity
    MonoClass* mono_class_inflate_generic_class_checked(MonoClass* gklass, MonoGenericContext* context, MonoError* error); // not available in unity
    MonoType* mono_class_inflate_generic_type(MonoType* type, MonoGenericContext* context);


    MonoObject* mono_value_box(MonoDomain* domain, MonoClass* klass, void* val);
    void mono_value_copy(void* dest, const void* src, MonoClass *klass);


    MonoObject* mono_object_new(MonoDomain* domain, MonoClass* klass);
    MonoVTable* mono_object_get_vtable(MonoObject* obj);
    MonoDomain* mono_object_get_domain(MonoObject* obj);
    MonoClass* mono_object_get_class(MonoObject* obj);
    void* mono_object_unbox(MonoObject* obj);
    MonoMethod* mono_object_get_virtual_method(MonoObject* obj, MonoMethod* method);
    uint mono_object_get_size(MonoObject* o);



    MonoMethod* mono_get_method(MonoImage* image, uint32_t token, MonoClass* klass);
    MonoMethodSignature* mono_method_get_signature(MonoMethod* method, MonoImage* image, uint32_t token);
    MonoMethodSignature* mono_method_signature(MonoMethod* method);
    const(char)* mono_method_get_name(MonoMethod* method);
    MonoClass* mono_method_get_class(MonoMethod* method);
    MonoMethod* mono_method_desc_search_in_class(MonoMethodDesc* desc, MonoClass* klass);
    MonoMethodDesc* mono_method_desc_new(const(char)* name, bool include_namespace);
    MonoMethodDesc* mono_method_desc_from_method(MonoMethod* method);
    void mono_method_desc_free(MonoMethodDesc* desc);
    char* mono_method_full_name(MonoMethod* method, bool signature);
    char* mono_method_get_reflection_name(MonoMethod* method);
    void* mono_method_get_unmanaged_thunk(MonoMethod* method);
    MonoGenericContext* mono_method_get_context(MonoMethod *method); // (INTERNAL) BE AWARE
    void mono_add_internal_call(const(char)* name, const void* method);

    char* mono_field_full_name(MonoClassField* field);
    uint32_t mono_field_get_offset(MonoClassField* field);
    const(char)* mono_field_get_name(MonoClassField* field);
    MonoType* mono_field_get_type(MonoClassField* field);
    void mono_field_set_value(MonoObject* obj, MonoClassField* field, void* value);
    void mono_field_static_set_value(MonoVTable* vt, MonoClassField* field, void* value);
    void mono_field_get_value(MonoObject* obj, MonoClassField* field, void* value);
    void mono_field_static_get_value(MonoVTable* vt, MonoClassField* field, void* value);

    void mono_property_set_value(MonoProperty* prop, void* obj, void** params, MonoObject** exc);
    MonoObject* mono_property_get_value(MonoProperty* prop, void* obj, void** params, MonoObject** exc);
    MonoMethod* mono_property_get_set_method(MonoProperty* prop);
    MonoMethod* mono_property_get_get_method(MonoProperty* prop);

    const(char)* mono_event_get_name(MonoEvent* event);
    MonoMethod* mono_event_get_add_method(MonoEvent* event);
    MonoMethod* mono_event_get_remove_method(MonoEvent* event);
    MonoMethod* mono_event_get_raise_method(MonoEvent* event);
    MonoClass* mono_event_get_parent(MonoEvent* event);
    uint32_t mono_event_get_flags(MonoEvent* event);


    uint32_t mono_signature_get_param_count(MonoMethodSignature* sig);
    char* mono_signature_get_desc(MonoMethodSignature* sig, bool include_namespace);
    MonoType* mono_signature_get_params(MonoMethodSignature *sig, void** iter);


    char* mono_type_get_name(MonoType* type);
    MonoType* mono_type_get_underlying_type(MonoType* type);
    MonoMethodSignature* mono_type_get_signature(MonoType* type);
    MonoClass* mono_type_get_class(MonoType* type);
    int mono_type_get_type(MonoType* type);

    MonoString* mono_string_new(MonoDomain* domain, const(char)* text);
    MonoString* mono_string_new_utf16(MonoDomain* domain, const(wchar)* text);
    char* mono_string_to_utf8(MonoString* string_obj);
    char* mono_string_to_utf8_checked(MonoString* string_obj, MonoError* error);
    wchar* mono_string_to_utf16(MonoString* string_obj);
    dchar* mono_string_to_utf32(MonoString* string_obj);
    int mono_string_length(MonoString* s);
    MonoObject* mono_runtime_invoke(MonoMethod* method, void* obj, void** params, MonoObject** exc);
    MonoObject* mono_runtime_delegate_invoke(MonoObject* delegate_, void **params, MonoObject **exc);
    MonoArray* mono_runtime_get_main_args();


    MonoArray* mono_array_new(MonoDomain* domain, MonoClass* eclass, uintptr_t n);
    MonoArray* mono_array_new_full(MonoDomain* domain, MonoClass* array_class, uintptr_t* lengths, intptr_t* lower_bounds);
    MonoArray* mono_array_new_specific(MonoVTable* vtable, uintptr_t n);
    MonoArray* mono_array_clone(MonoArray* array);
    char* mono_array_addr_with_size(MonoArray* array, int size, uintptr_t idx);
    uintptr_t mono_array_length(MonoArray* array);


    MonoThread* mono_thread_current();
    void mono_thread_set_main(MonoThread* thread);
    MonoThread* mono_thread_get_main();
    void mono_thread_stop(MonoThread* thread);
    void mono_thread_new_init(intptr_t tid, void* stack_start, void* func);
    void mono_thread_create(MonoDomain* domain, void* func, void* arg);
    MonoThread* mono_thread_attach(MonoDomain* domain);
    void mono_thread_detach(MonoThread* thread);
    void mono_thread_exit();
    char* mono_thread_get_name_utf8(MonoThread* thread);
    int32_t mono_thread_get_managed_id(MonoThread* thread);

    
    MonoImage* mono_get_corlib();
    MonoClass* mono_get_object_class();
    MonoClass* mono_get_byte_class();
    MonoClass* mono_get_void_class();
    MonoClass* mono_get_boolean_class();
    MonoClass* mono_get_sbyte_class();
    MonoClass* mono_get_int16_class();
    MonoClass* mono_get_uint16_class();
    MonoClass* mono_get_int32_class();
    MonoClass* mono_get_uint32_class();
    MonoClass* mono_get_intptr_class();
    MonoClass* mono_get_uintptr_class();
    MonoClass* mono_get_int64_class();
    MonoClass* mono_get_uint64_class();
    MonoClass* mono_get_single_class();
    MonoClass* mono_get_double_class();
    MonoClass* mono_get_char_class();
    MonoClass* mono_get_string_class();
    MonoClass* mono_get_enum_class();
    MonoClass* mono_get_array_class();
    MonoClass* mono_get_thread_class();
    MonoClass* mono_get_exception_class();


    MonoReflectionType* mono_type_get_object(MonoDomain* domain, MonoType* type);
    MonoType* mono_reflection_type_get_type(MonoReflectionType* reftype);


    uint32_t mono_gchandle_new(MonoObject* obj, bool pinned);
    uint32_t mono_gchandle_new_weakref(MonoObject* obj, bool track_resurrection);
    MonoObject* mono_gchandle_get_target(uint32_t gchandle);
    void mono_gchandle_free(uint32_t gchandle);


    void mono_free(void*);


    char* mono_exception_get_managed_backtrace(MonoException* exc); // internal

    MonoGenericInst* mono_metadata_get_generic_inst(int type_argc, MonoType** type_argv); // internal

    ushort mono_error_get_error_code(MonoError* error);
    const(char)* mono_error_get_message(MonoError* error);
    int mono_error_ok(MonoError* error);
}



// this function pointers written explicitly for better IDE experience

extern (C):

MonoDomain* function()  mono_domain_get;
MonoAssembly* function(MonoDomain *domain, const(char)* name)  mono_domain_assembly_open;

MonoImage* function(MonoAssembly *assembly)  mono_assembly_get_image;
void function(MonoAssembly* assembly)  mono_assembly_close;

const(char)* function(MonoClass* klass)  mono_class_get_namespace;
MonoClass* function(MonoImage *image, const(char)* name_space, const(char)* name)  mono_class_from_name;
MonoVTable* function(MonoDomain* domain, MonoClass* klass)  mono_class_vtable;
MonoClassField* function(MonoClass* klass, void** iter)  mono_class_get_fields;
MonoMethod* function(MonoClass* klass, void** iter)  mono_class_get_methods;
MonoProperty* function(MonoClass* klass, void** iter)  mono_class_get_properties;
MonoEvent* function(MonoClass* klass, void** iter)  mono_class_get_events;
MonoClass* function(MonoClass* klass, void** iter)  mono_class_get_interfaces;
MonoClass* function(MonoClass* klass, void** iter)  mono_class_get_nested_types;
MonoType* function(MonoClass* klass)  mono_class_get_type;
MonoProperty* function(MonoClass* klass, const(char)* name)  mono_class_get_property_from_name;
MonoClassField* function(MonoClass* klass, const(char)* name)  mono_class_get_field_from_name;
MonoMethod* function(MonoClass* klass, const(char)* name, int param_count)  mono_class_get_method_from_name;
MonoMethod* function(MonoMethod* method, MonoGenericContext* context)  mono_class_inflate_generic_method;
MonoType* function(MonoType* type, MonoGenericContext* context, MonoError* error)  mono_class_inflate_generic_type_checked;
//MonoClass* function(MonoClass* gklass, MonoGenericContext* context, MonoError* error)  mono_class_inflate_generic_class_checked; // not present in unity mono
MonoType* function(MonoType* type, MonoGenericContext* context)  mono_class_inflate_generic_type;

MonoObject* function(MonoDomain* domain, MonoClass* klass, void* val)   mono_value_box;
void function(void* dest, const void* src, MonoClass *klass)  mono_value_copy;

MonoObject* function(MonoDomain* domain, MonoClass* klass)  mono_object_new;
MonoVTable* function(MonoObject* obj)  mono_object_get_vtable;
MonoDomain* function(MonoObject* obj)  mono_object_get_domain;
MonoClass* function(MonoObject* obj)  mono_object_get_class;
void* function(MonoObject* obj)  mono_object_unbox;
MonoMethod* function(MonoObject* obj, MonoMethod* method)  mono_object_get_virtual_method;
uint function(MonoObject* o)  mono_object_get_size;

MonoMethod* function(MonoImage* image, uint32_t token, MonoClass* klass)  mono_get_method;
MonoMethodSignature* function(MonoMethod* method, MonoImage* image, uint32_t token)  mono_method_get_signature;
MonoMethodSignature* function(MonoMethod* method)  mono_method_signature;
const(char)* function(MonoMethod* method)  mono_method_get_name;
MonoClass* function(MonoMethod* method)  mono_method_get_class;
MonoMethod* function(MonoMethodDesc* desc, MonoClass* klass)  mono_method_desc_search_in_class;
MonoMethodDesc* function(const(char)* name, bool include_namespace)  mono_method_desc_new;
MonoMethodDesc* function(MonoMethod* method)  mono_method_desc_from_method;
void function(MonoMethodDesc* desc)  mono_method_desc_free;
char* function(MonoMethod* method, bool signature)  mono_method_full_name;
char* function(MonoMethod* method)  mono_method_get_reflection_name;
void* function(MonoMethod* method)  mono_method_get_unmanaged_thunk;
MonoGenericContext* function(MonoMethod* method)  mono_method_get_context;
void function(const(char)* name, const void* method)  mono_add_internal_call;

char* function(MonoClassField* field)  mono_field_full_name;
uint32_t function(MonoClassField* field)  mono_field_get_offset;
const(char)* function(MonoClassField* field)  mono_field_get_name;
MonoType* function(MonoClassField* field)  mono_field_get_type;
void function(MonoObject* obj, MonoClassField* field, void* value)  mono_field_set_value;
void function(MonoVTable* vt, MonoClassField* field, void* value)  mono_field_static_set_value;
void function(MonoObject* obj, MonoClassField* field, void* value)  mono_field_get_value;
void function(MonoVTable* vt, MonoClassField* field, void* value)  mono_field_static_get_value;

void function(MonoProperty* prop, void* obj, void** params, MonoObject** exc)  mono_property_set_value;
MonoObject* function(MonoProperty* prop, void* obj, void** params, MonoObject** exc)   mono_property_get_value;
MonoMethod* function(MonoProperty* prop)  mono_property_get_set_method;
MonoMethod* function(MonoProperty* prop)  mono_property_get_get_method;

const(char)* function(MonoEvent* event)  mono_event_get_name;
MonoMethod* function(MonoEvent* event)  mono_event_get_add_method;
MonoMethod* function(MonoEvent* event)  mono_event_get_remove_method;
MonoMethod* function(MonoEvent* event)  mono_event_get_raise_method;
MonoClass* function(MonoEvent* event)  mono_event_get_parent;
uint32_t function(MonoEvent* event)  mono_event_get_flags;

uint32_t function(MonoMethodSignature* sig)  mono_signature_get_param_count;
char* function(MonoMethodSignature* sig, bool include_namespace)  mono_signature_get_desc;
MonoType* function(MonoMethodSignature *sig, void** iter)  mono_signature_get_params;

char* function(MonoType* type)  mono_type_get_name;
MonoType* function(MonoType* type)  mono_type_get_underlying_type;
MonoMethodSignature* function(MonoType* type)  mono_type_get_signature;
MonoClass* function(MonoType* type)  mono_type_get_class;
int function(MonoType* type)  mono_type_get_type;

MonoString* function(MonoDomain* domain, const(char)* text)  mono_string_new;
MonoString* function(MonoDomain* domain, const(wchar)* text)  mono_string_new_utf16;
char* function(MonoString* string_obj)  mono_string_to_utf8;
char* function(MonoString* string_obj, MonoError* error)  mono_string_to_utf8_checked;
wchar* function(MonoString* string_obj)  mono_string_to_utf16;
dchar* function(MonoString* string_obj)  mono_string_to_utf32;
int function(MonoString *s) mono_string_length;
MonoObject* function(MonoMethod* method, void* obj, void** params, MonoObject** exc)  mono_runtime_invoke;
MonoObject* function(MonoObject* delegate_, void **params, MonoObject **exc)  mono_runtime_delegate_invoke;
MonoArray* function()  mono_runtime_get_main_args;

MonoArray* function(MonoDomain* domain, MonoClass* eclass, uintptr_t n)  mono_array_new;
MonoArray* function(MonoDomain* domain, MonoClass* array_class, uintptr_t* lengths, intptr_t* lower_bounds)  mono_array_new_full;
MonoArray* function(MonoVTable* vtable, uintptr_t n)  mono_array_new_specific;
MonoArray* function(MonoArray* array)  mono_array_clone;
char* function(MonoArray* array, int size, uintptr_t idx)  mono_array_addr_with_size;
uintptr_t function(MonoArray* array)  mono_array_length;

MonoThread* function()  mono_thread_current;
void function(MonoThread* thread)  mono_thread_set_main;
MonoThread* function()  mono_thread_get_main;
void function(MonoThread* thread)  mono_thread_stop;
void function(intptr_t tid, void* stack_start, void* func)  mono_thread_new_init;
void function(MonoDomain* domain, void* func, void* arg)  mono_thread_create;
MonoThread* function(MonoDomain* domain)  mono_thread_attach;
void function(MonoThread* thread)  mono_thread_detach;
void function()  mono_thread_exit;
char* function(MonoThread* thread)  mono_thread_get_name_utf8;
int32_t function(MonoThread* thread)  mono_thread_get_managed_id;

MonoImage* function()  mono_get_corlib;
MonoClass* function()  mono_get_object_class;
MonoClass* function()  mono_get_byte_class;
MonoClass* function()  mono_get_void_class;
MonoClass* function()  mono_get_boolean_class;
MonoClass* function()  mono_get_sbyte_class;
MonoClass* function()  mono_get_int16_class;
MonoClass* function()  mono_get_uint16_class;
MonoClass* function()  mono_get_int32_class;
MonoClass* function()  mono_get_uint32_class;
MonoClass* function()  mono_get_intptr_class;
MonoClass* function()  mono_get_uintptr_class;
MonoClass* function()  mono_get_int64_class;
MonoClass* function()  mono_get_uint64_class;
MonoClass* function()  mono_get_single_class;
MonoClass* function()  mono_get_double_class;
MonoClass* function()  mono_get_char_class;
MonoClass* function()  mono_get_string_class;
MonoClass* function()  mono_get_enum_class;
MonoClass* function()  mono_get_array_class;
MonoClass* function()  mono_get_thread_class;
MonoClass* function()  mono_get_exception_class;

MonoReflectionType* function(MonoDomain* domain, MonoType* type)  mono_type_get_object;
MonoType* function(MonoReflectionType* reftype)  mono_reflection_type_get_type;

uint32_t function(MonoObject* obj, bool pinned)  mono_gchandle_new;
uint32_t function(MonoObject* obj, bool track_resurrection)  mono_gchandle_new_weakref;
MonoObject* function(uint32_t gchandle)   mono_gchandle_get_target;
void function(uint32_t gchandle)  mono_gchandle_free;

void function(void*) mono_free;

MonoGenericInst* function(int type_argc, MonoType** type_argv)  mono_metadata_get_generic_inst; // internal
char* function(MonoException* exc)  mono_exception_get_managed_backtrace;
ushort function(MonoError* error)  mono_error_get_error_code;
const(char)* function(MonoError* error)  mono_error_get_message;
int function(MonoError* error)  mono_error_ok;


T* mono_array_addr(T)(MonoArray* array, size_t index) {
  return cast(T*)mono_array_addr_with_size(array, T.sizeof, index);
}

T mono_array_get(T)(MonoArray* array, size_t index) {
    return *(cast(T*)mono_array_addr!T(array,index));
}

void mono_array_set(T)(MonoArray* array, size_t index, T value) {
    T* __p = cast(T*)mono_array_addr!T(array,index); *__p = value;
}


struct Loader
{
    version(Windows)
    import core.sys.windows.windows;
    version(linux)
    import core.sys.linux.dlfcn;

    import std.traits;
    
    version(Windows) 
    static Load(HMODULE lib)
    {
        static foreach(sym; __traits(allMembers, mono))
        {
            static if (isFunctionPointer!(__traits(getMember, mono, sym)))
                __traits(getMember, mono, sym) = cast(typeof(__traits(getMember, mono, sym))) GetProcAddress(lib, sym);
        }
    }
    else
    static Load(void* lib)
    {
        static foreach(sym; __traits(allMembers, mono))
        {
            static if (isFunctionPointer!(__traits(getMember, mono, sym)))
                __traits(getMember, mono, sym) = cast(typeof(__traits(getMember, mono, sym))) dlsym(lib, sym);
        }
    }
}



// -- high level wrappers -----------------------
extern(D):

import std.string;

final class MonoDomainHandle
{
    private MonoDomain* _domain;

    static __gshared private MonoDomainHandle _default;

    private this(MonoDomain* domain) { _domain = domain; }

    @property static MonoDomainHandle get() 
    {
        if (!_default)
            _default = new MonoDomainHandle(mono_domain_get());
        return _default;
    }

    @property MonoDomain* handle() { return _domain; }

    MonoAssemblyHandle openAssembly(string name)
    {
        return new MonoAssemblyHandle(this, name);
    }
}

class MonoAssemblyHandle
{
    MonoDomainHandle _domainWrapper;
    MonoAssembly* _assembly;
    MonoImageHandle _imageWrapper;
    
    private this(MonoDomainHandle domain, string name)
    {
        _domainWrapper = domain;
        _assembly = mono_domain_assembly_open(_domainWrapper.handle, name.toStringz());
        auto _image = mono_assembly_get_image(_assembly);
        _imageWrapper = new MonoImageHandle(_image, this);
    }

    @property MonoImageHandle image() { return _imageWrapper; }
}


class MonoImageHandle
{
    MonoAssemblyHandle _assembly;
    MonoImage* _image;

    private this(MonoImage* image, MonoAssemblyHandle assembly)
    {
        _image = image;
        _assembly = assembly;
    }


    MonoClassHandle classFromName(string namespace, string classname) 
    {
        return new MonoClassHandle(mono_class_from_name(_image, namespace.toStringz(), classname.toStringz()), _assembly);
    }
}


class MonoClassHandle
{
    MonoAssemblyHandle _assembly;
    MonoClass* _class;

    @property handle() { return _class; }

    @property MonoVTable* vtable() { return mono_class_vtable(_assembly._domainWrapper.handle, _class); }

    private this(MonoClass* class_, MonoAssemblyHandle assembly)
    {
        _assembly = assembly;
        _class = class_;
    }

    import std.traits;
    MonoMethodHandle!(fn)* getMethod(alias fn)() //if (is(fn == function) || is(fn == delegate))
    {
        import core.stdc.string;
        auto name = __traits(identifier, fn);
        void* iter;
        MonoMethod* m;
        m = mono_class_get_methods(_class, &iter);
        while (m !is null)
        {
            auto cstr = mono_method_get_name(m);
            if (strcmp(cstr, name.ptr)==0)
            {
                auto sig = mono_method_signature(m);
                if (mono_signature_get_param_count(sig) == Parameters!fn.length)
                    break;
            }
            m = mono_class_get_methods(_class, &iter);
        }
        if (m)
        {
            return new MonoMethodHandle!(fn)(m);
        }
        return null;
    }
}


struct MonoMethodHandle(alias fn) 
{
    MonoMethod* _method;

    

    @property handle() { return _method; }

    this(MonoMethod* method) { _method = method; }

    MonoObject* call(ReplaceAll!(Object, void*, Parameters!fn))
    {
        void*[Parameters!fn.length] args;
        static foreach(i; 0..args.length)
        {
            args[i] = mixin("_param_", cast(int) i);
        }
        return mono_runtime_invoke(_method, null, args.ptr, null);
    }
}

struct MonoArrayHandle(T)
{
    private MonoArray* _arr;

    @property MonoArray* handle() { return _arr; }

    @disable this();
    // not sure, so non copyable for now
    @disable this(this) {}

    this(size_t len)
    {
        auto dom = MonoDomainHandle.get();
        MonoClass* arrayClass;
        static if (is(T == Object))
        {
          arrayClass = mono_get_object_class();
        }
        else static if (is(T == class))
        {
          MonoAssemblyHandle ass = dom.openAssembly(getAssembly!(T,"netstandard"));
          auto cls = ass.image.classFromName(getNamespace!T, getClassname!T);
          arrayClass = cls.handle;
        }
        else static if (is(T == struct))
        {
          // untested
          // TODO: mark assemblies to not assume that all structs is from UnityEngine
          MonoAssemblyHandle ass = dom.openAssembly(getAssembly!(T,"UnityEngine"));
          auto cls = ass.image.classFromName(getNamespace!T, getClassname!T);
          arrayClass = cls.handle;
        }
        else
        {
          arrayClass = mapType!T();
        }
        this(arrayClass, len);
    }

    this(T[] values)
    {
        this(values.length);
        foreach(i, ref T item; values)
            this[i] = item;
    }

    private this(MonoClass* arrayClass, size_t len)
    {
        auto dom = MonoDomainHandle.get();
        _arr = mono_array_new(dom.handle, arrayClass, len);
    }

    private this(MonoArray* array)
    {
        _arr = array;
    }

    T opIndex(size_t index)
    {
        return mono_array_get!(T)(_arr, index);
    }

    void opIndexAssign(T val, size_t index)
    {
        static if(__traits(hasMember, T, "_obj") && is(typeof(val._obj) == MonoObject*))
          mono_array_set!(MonoObject*)(_arr, index, val._obj);
        else static if (__traits(hasMember, T, "handle") && is(typeof(val._obj) == MonoObject*))
          mono_array_set!(MonoObject*)(_arr, index, val.handle);
        else
          mono_array_set!T(_arr, index, val);
    }
}


// types that requires boxing/unboxing
bool isValueType(T)()
{
    import std.traits;
    return isBasicType!T;
}


MonoObject* boxify(T)(T t)
{
    import std.string : toStringz;
    import std.range : ElementType;
    static if (is(T : Object) || is(T : MonoObject*))
        return cast(MonoObject*) t;
    else static if (isSomeString!T && !isStaticArray!T)
        return cast(MonoObject*)mono_string_new(mono_domain_get(), toStringz(t));
    else static if (is(Unqual!T : const(char)*))
        return cast(MonoObject*)mono_string_new(mono_domain_get(), t);
    else static if (isSomeFunction!(mapType!T))
        return mono_value_box(mono_domain_get(), mapType!T(), &t);
    else static if (isArray!T)
        return cast(MonoObject*) MonoArrayHandle!(ElementType!T)(t).handle;
    else
        static assert(0);
}

private template mapType(T) {
    static if (is(T==byte))
        alias mapType = mono_get_sbyte_class;
    else static if (is(T==ubyte))
        alias mapType = mono_get_byte_class;
    else static if (is(T==short))
        alias mapType = mono_get_int16_class;
    else static if (is(T==ushort))
        alias mapType = mono_get_uint16_class;
    else static if (is(T==int))
        alias mapType = mono_get_int32_class;
    else static if (is(T==uint))
        alias mapType = mono_get_uint32_class;
    else static if (is(T==long))
        alias mapType = mono_get_int64_class;
    else static if (is(T==ulong))
        alias mapType = mono_get_uint64_class;
    else static if (is(T==float))
        alias mapType = mono_get_single_class;
    else static if (is(T==double))
        alias mapType = mono_get_double_class;
    else
        alias mapType = void;
}


private string paramSeq(int total)
{
    import std.conv : to;
    char[] res;
    foreach(i; 0..total)
    {
        res ~= "_param_" ~ to!string(i);
        if (i+1 < total)
            res ~= ", ";
    }
    return cast(string)res;
}


enum bool overridable(alias T) = isSomeFunction!T && !(__traits(isStaticFunction, T) || isFinal!T || __traits(identifier, T) == "__ctor");
enum bool notInObject(string T) = !__traits(hasMember, Object, T);


/// Wraps object of type T implementing necessary methods
template MonoImplement(T)
{
    private alias getMember(string nm) = __traits(getMember, T, nm);

    final class MonoImplement : T {

        static if (!__traits(hasMember, T, "_obj"))
        {
            public MonoObject* _obj;
        }

        // BUG: new ctors should go before mixin
        static foreach(m; __traits(getOverloads, T, "__ctor"))
        {
            static if( Parameters!m.length == 1 && is(Parameters!m[0] == MonoObject*))
                {} // do nothing
            else
                //mixin Fun!(T, m);
            {
                //pragma(mangle, m.mangleof)
                this(Parameters!m)
                {
                    import std.range;
                    import std.algorithm;
                    import std.array;
                    import std.conv : to;
                    
                    auto dom = MonoDomainHandle.get();
                    auto ass = dom.openAssembly(getAssembly!(T, "UnityEngine"));
                    MonoClassHandle cls = ass.image.classFromName(getNamespace!T, getClassname!T);
                    auto meth = mono_class_get_method_from_name(cls.handle, ".ctor", Parameters!m.length);
                    void*[Parameters!m.length] args;
                    static foreach(i; 0..args.length)
                    {
                        static if (__traits(hasMember, Parameters!m[i], "_obj"))
                        args[i] = mixin("_param_", cast(int) i)._obj;
                        else static if (!isPointer!(Parameters!m[i]) && (isBasicType!(Parameters!m[i]) || is(Parameters!m[i] == struct)))
                        args[i] = cast(void*) mixin("&_param_", cast(int) i);
                        else static if (is(Parameters!m[i] == string) || isArray!(Parameters!m[i]))
                        args[i] = cast(void*) mixin("_param_", cast(int) i, ".boxify");
                        else
                        args[i] = cast(void*) mixin("_param_", cast(int) i);
                    }
                    MonoObject* self = mono_object_new(dom.handle, cls.handle);
                    MonoObject* exception;
                    auto res = mono_runtime_invoke(meth, self, args.ptr, &exception);
                    if (exception)
                        throw new MonoException(exception);
                    super(self);
                }
            }
        }

        this(MonoObject* obj) 
        { 
            super(obj);
            //static if (__traits(compiles, new T(cast(MonoObject*)null)))
            //    super(obj);
            //else
            //    _obj = obj;
        }

        //mixin MonoObjectImpl t;
        static if (__traits(getOverloads, T, "__ctor").length)
          mixin(`alias __ctor = _mono_impl_`, T.stringof, ".__ctor;");

        static foreach(fsym; __traits(allMembers, T))
        {
            static foreach(fn; __traits(getOverloads, T, fsym))
                static if (overridable!fn && notInObject!fsym)
                {
                    mixin Fun!(T, fn);
                }
        }
    }
}


/// Implements regular functions
mixin template Fun(T, alias fn, string suffix = null)
{
    import std.traits;
    import std.meta;
    import std.conv : text;
        //`pragma(mangle, "`, fn.mangleof, `") `,
    mixin(
        __traits(identifier, fn) == "__ctor" ? "this " : text(`final`, __traits(isStaticFunction, fn) ? " static " : (is(T==struct) ? " " : " override "), `ReturnType!fn `, __traits(identifier, fn)), suffix, `(Parameters!fn)`,
        q{{
                auto dom = MonoDomainHandle.get();
                auto ass = dom.openAssembly(getAssembly!(__traits(parent,fn), "UnityEngine"));
                MonoClassHandle cls = ass.image.classFromName(getNamespace!(__traits(parent, fn)), getClassname!(__traits(parent, fn)));
                static if (staticIndexOf!("@property", __traits(getFunctionAttributes, FunctionTypeOf!(fn))) >= 0)
                  static if (Parameters!(FunctionTypeOf!fn).length == 1)
                    auto m = mono_property_get_set_method(mono_class_get_property_from_name(cls.handle, __traits(identifier, fn)));
                  else static if (Parameters!(FunctionTypeOf!fn).length == 0)
                    auto m = mono_property_get_get_method(mono_class_get_property_from_name(cls.handle, __traits(identifier, fn)));
                  else 
                    static assert(0, "invalid parameters for @property");
                else
                  static if (__traits(identifier, fn) == "__ctor")
                    auto m = mono_class_get_method_from_name(cls.handle, ".ctor", Parameters!fn.length);
                else
                  auto m = mono_class_get_method_from_name(cls.handle, __traits(identifier, fn), Parameters!fn.length);
                void*[Parameters!fn.length] args;
                static foreach(i; 0..args.length)
                {
                    static if (__traits(hasMember, Parameters!fn[i], "_obj"))
                    args[i] = mixin("_param_", cast(int)i)._obj;
                    else static if (!isPointer!(Parameters!fn[i]) && (isBasicType!(Parameters!fn[i]) || is(Parameters!fn[i] == struct)))
                    args[i] = cast(void*) mixin("&_param_", cast(int) i);
                    else static if (is(Parameters!fn[i] == string) || isArray!(Parameters!fn[i]))
                    args[i] = cast(void*) mixin("_param_", cast(int) i, ".boxify");
                    else
                    args[i] = cast(void*) mixin("_param_", cast(int) i);
                }
                static if (__traits(isStaticFunction, fn))
                  MonoObject* self = null;
                else static if (__traits(identifier, fn) == "__ctor")
                  MonoObject* self = mono_object_new(dom.handle, cls.handle);
                else static if (is(T==struct))
                  MonoObject* self = cast(MonoObject*) &this;
                else
                  { MonoObject* self = (cast(__traits(parent, fn))this)._obj; m = mono_object_get_virtual_method(self, m); }
                MonoObject* exception;
                auto res = mono_runtime_invoke(m, self, args.ptr, &exception);
                static if (__traits(identifier, fn) == "__ctor")
                    this(res);
                if (exception)
                    throw new MonoException(exception);
                static if (!(is(typeof(return) == void) || __traits(identifier, fn) == "__ctor"))
                    return monounwrap!(ReturnType!(FunctionTypeOf!fn))(res);
        }}
    );
}


string replaceParams(T...)()
{
    import std.conv : to;
    char[] res;
    static foreach(idx, p; T)
    {
        static if (is(p == Object)) {
            res ~= ("T" ~ to!string(idx));
        }
        else
            res ~= (p.stringof);
        if (idx+1 < T.length)
            res ~= ", ";
    }
    return res;
}

string genericList(T...)()
{
    import std.conv : to;
    import std.algorithm;
    import std.meta;
    char[] res;
    static foreach(i; 0..(T.length))
    {
        if (is(T[i] == Object))
        {
            res ~= ("T" ~ to!string(i));
            if (i+1 < staticIndexOf!(T[i..$], Object)+i)
                res ~= ", ";
        }
    }
    if (res.length)
        res ~=")(";
    return res;
}

string delegateCall(T...)()
{
    import std.conv : to;
    char[] res;
    static foreach(i; 0..(T.length))
    {
        if (is(T[i] == Object))
            res~= "cast(Object) boxify(";
        res ~= `_param_` ~ to!string(i);
        if (is(T[i] == Object))
            res ~= ")";
        if (i+1 < T.length)
            res~= ", ";
    }
    return res;
}


/// Use this inside generic method body to automatically insert implementation.
string monoGenericMethod(Args...)()
{
    string str;

    //pragma(msg, Args);

    str ~= "import std.traits;\n";
    str ~= "import mono;\n";
    static foreach(arg; Args) 
     static if (__traits(compiles, moduleName!arg))
      str ~= "import " ~ moduleName!arg ~ ";\n";
    str ~= "bool __anchor__;\n";
    str ~= "alias tmpl = __traits(parent, __anchor__);\n";
    str ~= "alias fn = tmpl!" ~ Args.stringof ~ ";";

    str ~= "enum fname = __traits(identifier, fn);\n";
    str ~= q{
        alias __impl = MonoGenericMethod!(__traits(parent, tmpl), fn, TemplateArgsOf!fn);

        static if (__traits(isStaticFunction, fn))
          enum self = null;
        else static if (is(typeof(this) == struct))
          MonoObject* self = cast(MonoObject*) &this;
        else
          alias self = _obj;

        static if (is(typeof(return) == void))
            __impl(self, ParameterIdentifierTuple!fn);
        else
            return __impl(self, ParameterIdentifierTuple!fn);
    };
    return str;
}

/// Generic method internal implementation
ReturnType!Method MonoGenericMethod(alias Class, alias Method, Args...)(MonoObject* self, Parameters!Method)
{
    import mono_internal;
    import unity;
    import std.conv;

    static if (getUDAs!(Class, AssemblyAttr).length)
        enum src_assemblyName = getUDAs!(Class, AssemblyAttr)[0].name;
    else
        enum src_assemblyName = "UnityEngine";
    static if (getUDAs!(Class, NamespaceAttr).length)
        enum src_nsName = getUDAs!(Class, NamespaceAttr)[0].name;
    else 
        enum src_nsName = "";
    static if (getUDAs!(Class, SymNameAttr).length)
        enum src_clsName = getUDAs!(Class, SymNameAttr)[0].name;
    else
        enum src_clsName = __traits(identifier, Class);

    MonoObject* res;
    MonoObject* exc;
    auto dom = MonoDomainHandle._default.get();
    MonoAssemblyHandle ass = dom.openAssembly(src_assemblyName);
    auto cls = ass.image.classFromName(src_nsName, __traits(identifier, Class) ==  "Object_" ? "Object" : src_clsName);
    auto genericmeth = mono_class_get_method_from_name(cls.handle, toStringz(__traits(identifier, Method)), Parameters!Method.length);

    //m.call(boxify(instantiate ? "yay" : "nay"));
    if (genericmeth)
    {
        void*[Parameters!Method.length] args;
        static foreach(i; 0..args.length)
        {
            static if (__traits(hasMember, Parameters!Method[i], "_obj"))
            args[i] = mixin("_param_", cast(int) i)._obj;
            else static if (!isPointer!(Parameters!Method[i]) && (isBasicType!(Parameters!Method[i]) || is(Parameters!Method[i] == struct)))
            args[i] = cast(void*) mixin("&_param_", cast(int) i);
            else static if (is(Parameters!Method[i] == string) || isArray!(Parameters!Method[i]))
            args[i] = cast(void*) mixin("_param_", cast(int) i, ".boxify");
            else
            args[i] = cast(void*) mixin("_param_", cast(int) i);
        }

        MonoType*[Args.length] argtypes;
        static foreach(i, arg; Args)
        {
            // this will likely complain when more than one argument provided as it adds to the scope
            static if (getUDAs!(arg, AssemblyAttr).length)
                enum assemblyName = getUDAs!(arg, AssemblyAttr)[0].name;
            else
                enum assemblyName = "UnityEngine";
            static if (getUDAs!(arg, NamespaceAttr).length)
                enum nsName = getUDAs!(arg, NamespaceAttr)[0].name;
            else 
                enum nsName = "";
            static if (getUDAs!(arg, SymNameAttr).length)
                enum clsName = getUDAs!(arg, SymNameAttr)[0].name;
            else
                enum clsName = arg.stringof;
            MonoAssemblyHandle assArg = dom.openAssembly(assemblyName);
            auto clsArg = assArg.image.classFromName(nsName, __traits(identifier, Class) ==  "Object_" ? "Object" : clsName);
            argtypes[i] = mono_class_get_type(clsArg.handle);
            //scope(exit) mono_assembly_close(assArg._assembly);
        }

        // Do not touch argtypes! Read comment about type_args in mono_internal
        //auto gi = new _MonoGenericInst(); 
        // do not use GC, it seems mono internally tries to free the memory later on leading to crash on DLL reload/exit
        // crash relates to mempool_free* function, which is referenced in free_generic_inst()
        // it is also possible that we are supposed to use mono_metadata_get_generic_inst() instead 
        import core.stdc.stdlib;
        auto gi = cast(_MonoGenericInst*) malloc(_MonoGenericInst.sizeof);
        gi.id = -1;
        gi.is_open = 0;
        gi.type_argc = Args.length;
        gi.type_argv[0] = cast(MonoType*) argtypes[0];
        auto ctx = _MonoGenericContext(null, gi);
        auto inflated = mono_class_inflate_generic_method(genericmeth, cast(mono.MonoGenericContext*) &ctx);

        if (inflated)
            res = mono_runtime_invoke(inflated, self, args.ptr, &exc);
    }

    if (exc)
        throw new MonoException(exc);

    static if (!is(ReturnType!Method == void))
        return monounwrap!(ReturnType!(Method))(res);
}


/// Implements overloadable operators excluding indexers
ReturnType!fn MonoOperator(alias fn, U...)(U values) 
  if (!__traits(identifier, fn).startsWith("opIndex"))
{
    alias Class = __traits(parent, TemplateOf!fn);
    enum op = TemplateArgsOf!fn;

    auto dom = MonoDomainHandle._default.get();
    MonoAssemblyHandle ass = dom.openAssembly(getAssembly!(Class, "UnityEngine"));
    auto cls = ass.image.classFromName(getNamespace!(Class), getClassname!(Class));

    static if (U.length == 1) // unary
    {
      auto m = mono_class_get_method_from_name(cls.handle, opUnaryNames[op], values.length);
      auto mmd = mono_method_desc_new(monoMethodDescr!(fn, U).ptr, false);
    }
    else static if (U.length == 2) // binary
    {
      auto m = mono_class_get_method_from_name(cls.handle, opBinaryNames[op], values.length);
      auto mmd = mono_method_desc_new(monoMethodDescr!fn.ptr, false);
    }

    auto mf = mono_method_desc_search_in_class(mmd, cls.handle);
    mono_method_desc_free(mmd);
    if (mf)
        m = mf;

    void*[values.length] args;
    static foreach(i; 0..values.length)
    {
        static if (__traits(hasMember, U[i], "_obj"))
        args[i] = values[i]._obj;
        else static if (!isPointer!(typeof(values[i])) && (isBasicType!(typeof(values[i])) || is(typeof(values[i]) == struct)))
        args[i] = cast(void*) &values[i];
        else static if (is(typeof(values[i]) == string) || isArray!(U[i]))
        args[i] = cast(void*) boxify(values[i]);
        else
        args[i] = cast(void*) values[i];
    }
    MonoObject* exception;
    auto res = mono_runtime_invoke(m, null, args.ptr, &exception);
    if (exception)
        throw new MonoException(exception);
    return monounwrap!(ReturnType!fn)(res);
}


/// Implements indexers
ReturnType!fn MonoOperator(alias fn, U...)(U values) 
  if (__traits(identifier, fn) == "opIndex" || __traits(identifier, fn) == "opIndexAssign")
{
    static if (__traits(identifier, fn) == "opIndexAssign" && !isPointer!(U[0]))
        static assert(0, "opIndexAssign has no effect due to pass by value, consider passing &this instead");

    alias Class = __traits(parent, fn);

    auto dom = MonoDomainHandle._default.get();
    MonoAssemblyHandle ass = dom.openAssembly(getAssembly!(Class, "UnityEngine"));
    auto cls = ass.image.classFromName(getNamespace!(Class), getClassname!(Class));
    auto m = mono_class_get_method_from_name(cls.handle, "Item", values.length);
    auto mmd = mono_method_desc_new(monoMethodDescr!(fn, U).ptr, false);
    auto mf = mono_method_desc_search_in_class(mmd, cls.handle);
    mono_method_desc_free(mmd);
    if (mf)
        m = mf;

    // this block does ugly +1 -1 adjustments because we pass 'this' as parameter
    void*[values.length] args;
    static foreach(i; 1..values.length)
    {
        static if (__traits(hasMember, U[i], "_obj"))
        args[i-1] = values[i]._obj;
        else static if (!isPointer!(typeof(values[i])) && (isBasicType!(typeof(values[i])) || is(typeof(values[i]) == struct)))
        args[i-1] = cast(void*) &values[i];
        else static if (is(typeof(values[i]) == string))
        args[i-1] = cast(void*) boxify(values[i]);
        else
        args[i-1] = cast(void*) values[i];
    }
    MonoObject* exception;
    static if (__traits(identifier, fn) == "opIndexAssign")
    auto res = mono_runtime_invoke(m, cast(MonoObject*)values[0], args.ptr, &exception);
    else
    auto res = mono_runtime_invoke(m, cast(MonoObject*)&values[0], args.ptr, &exception);

    if (exception)
        throw new MonoException(exception);
    static if (!is(ReturnType!fn == void))
      return monounwrap!(ReturnType!fn)(res);
}


enum opBinaryNames = [
    "+" : "op_Addition",
    "-" : "op_Subtraction",
    "/" : "op_Division",
    "*" : "op_Multiply",
    "%" : "op_Modulus",
    "&" : "op_BitwiseAnd",
    "|" : "op_BitwiseOr",
    "^" : "op_ExclusiveOr",
    "<<" : "op_LeftShift",
    ">>" : "op_RightShift",
    // binary ~ (complement operator) is not overloadable
];

enum opUnaryNames = [
    "+" : "op_UnaryPlus",
    "-" : "op_UnaryNegation",
    "~" : "op_OnesComplement",
    "++" : "op_Increment",
    "--" : "op_Decrement",
];


/// assembly name for user defined type
enum getAssembly(alias T) = getUDAs!(T, AssemblyAttr)[0].name;


/// same, but with custom default
template getAssembly(alias T, string default_)
{
    static if (getUDAs!(T, AssemblyAttr).length)
        enum getAssembly = getUDAs!(T, AssemblyAttr)[0].name;
    else 
        enum getAssembly = default_;
} 


/// Retrieves C# namespace for user defined type
template getNamespace(alias T)
{
    static if (hasUDA!(T, NamespaceAttr))
        enum getNamespace = getUDAs!(T, NamespaceAttr)[0].name;
    else
        enum getNamespace = "";
}


/// Resulting type name (if rename is present)
template getClassname(alias T)
{
    static if (getUDAs!(T, SymNameAttr).length)
        enum getClassname = getUDAs!(T, SymNameAttr)[0].name;
    else
        enum getClassname = __traits(identifier, T);
}


string monoMethodDescr(alias fn)() 
  if (is(isSomeFunction!fn))
{
    string res;
    res ~= ":" ~ __traits(identifier, fn) ~ "(";
    res ~= monoSignatureDescr!fn();
    res ~= ")";
    return res;
}


string monoMethodDescr(alias fn)() 
  if (__traits(identifier, fn).startsWith("opBinary"))
{
    string res;
    res ~= ":" ~ opBinaryNames[TemplateArgsOf!fn[0]] ~ "(";
    static if (__traits(identifier, fn) == "opBinaryRight")
    {
      res ~= monoSignatureTypeName!(Parameters!fn[0]) ~ "," ~ monoSignatureTypeName!(__traits(parent, TemplateOf!fn));
    }
    else
    {
      res ~= monoSignatureTypeName!(__traits(parent, TemplateOf!fn)) ~ "," ~ monoSignatureTypeName!(Parameters!fn[0]);
    }
    res ~= ")";
    return res;
}


string monoMethodDescr(alias fn, U...)() 
  if (__traits(identifier, fn) == "opUnary" && U.length == 1)
{
    string res;
    res ~= ":" ~ opUnaryNames[TemplateArgsOf!fn[0]] ~ "(";
    res ~= monoSignatureTypeName!(U);
    res ~= ")";
    return res;
}


string monoMethodDescr(alias fn, U...)() 
  if (__traits(identifier, fn).startsWith("opIndex"))
{
    // U[0] is 'this', so adjust
    string res;
    static if (__traits(identifier, fn) == "opIndex")
      res ~= ":get_Item(";
    else static if (__traits(identifier, fn) == "opIndexAssign")
      res ~= ":set_Item(";
    foreach(i, p; U[1..$])
    {
        res ~= monoSignatureTypeName!p();
        if (i+1 < U.length-1)
            res ~=",";
    }
    res ~= ")";
    return res;
}


/// assembles parameters specification string
string monoSignatureDescr(alias fn)()
{
    string res;
    foreach(i, p; Parameters!fn)
    {
        res ~= monoSignatureTypeName!p();
        if (i+1 < Parameters!fn.length)
            res ~=",";
    }
    return res;
}


/// Builds type name for mono method description
string monoSignatureTypeName(T)()
{
    static if (is(T == struct) || is(T == class) || is(T == interface))
    {
        auto res = getNamespace!(T);
        if (res)
            res ~= ".";
        res ~= getClassname!(T);
        return res;
    }
    // mono types shortcuts
    else static if(is(T == char)) return  "char";
    else static if(is(T == bool)) return  "bool";
    else static if(is(T == ubyte)) return  "byte";
    else static if(is(T == byte)) return  "sbyte";
    else static if(is(T == ushort)) return  "uint16";
    else static if(is(T == short)) return  "int16";
    else static if(is(T == uint)) return  "uint";
    else static if(is(T == int)) return  "int";
    else static if(is(T == ulong)) return  "ulong";
    else static if(is(T == long)) return  "long";
    else static if(is(T == size_t)) return  "uintptr"; // not guaranteed, may or may not match void* size
    else static if(is(T == void*)) return  "intptr";
    else static if(is(T == float)) return  "single";
    else static if(is(T == double)) return  "double";
    else static if(is(T == string)) return  "string";
    else static if(is(T == Object)) return  "object";
    else 
        static assert(0, "unsupported type");
}


T MonoMemberGet(Class, T, string name)(MonoObject* obj)
{
    enum assemblyName = getUDAs!(Class, AssemblyAttr)[0].name;
    static if (getUDAs!(Class, NamespaceAttr).length)
        enum nsName = getUDAs!(Class, NamespaceAttr)[0].name;
    else 
        enum nsName = "";
    static if (getUDAs!(Class, SymNameAttr).length)
        enum clsName = getUDAs!(Class, SymNameAttr)[0].name;
    else
        enum clsName = __traits(identifier, Class);

    auto dom = MonoDomainHandle._default.get();
    MonoAssemblyHandle ass = dom.openAssembly(assemblyName); //"UnityEngine");
    auto cls = ass.image.classFromName(nsName, clsName);
    auto field = mono_class_get_field_from_name(cls.handle, toStringz(name));

    // TODO: type check
    //auto ty = mono_type_get_type(mono_field_get_type(field));

    T res;
    MonoObject* refval;

    static if (isValueType!T)
    {
        if (obj) 
            mono_field_get_value(obj, field, &res);
        else 
            mono_field_static_get_value(cls.vtable, field, &res);
    }
    else
    {
        if (obj)
            mono_field_get_value(obj, field, &refval);
        else
            mono_field_static_get_value(cls.vtable, field, &refval);
        res = monounwrap!T(refval);
    }

    return res;
}

void MonoMemberSet(Class, T, string name)(MonoObject* obj, T val)
{
    enum assemblyName = getUDAs!(Class, AssemblyAttr)[0].name;
    static if (getUDAs!(Class, NamespaceAttr).length)
        enum nsName = getUDAs!(Class, NamespaceAttr)[0].name;
    else 
        enum nsName = "";
    static if (getUDAs!(Class, SymNameAttr).length)
        enum clsName = getUDAs!(Class, SymNameAttr)[0].name;
    else
        enum clsName = __traits(identifier, Class);

    auto dom = MonoDomainHandle._default.get();
    MonoAssemblyHandle ass = dom.openAssembly(assemblyName); //"UnityEngine");
    auto cls = ass.image.classFromName(nsName, clsName);
    auto field = mono_class_get_field_from_name(cls.handle, toStringz(name));
    static if (isValueType!T)
    {
        if (obj)
            mono_field_set_value(obj, field, &val);
        else
            mono_field_static_set_value(cls.vtable, field, &val);
    }
    else
    {
        if (obj)
            mono_field_set_value(obj, field, boxify(val));
        else
            mono_field_static_set_value(cls.vtable, field, boxify(val));
    }
}


/// Inserts member accessor of type T.
mixin template MonoMember(T, string name)
{
    import std.typecons;

    version(unittest)
    struct _MonoMember
    {
        import std.traits;
        import std.array;
        import std.string;
        import std.typecons : Proxy;

        static isNumber(U)(U ch) { return '0' <= ch && ch <= '9'; }

        // returns mangled name for this template instance without its name part
        enum mangled = replace(MonoMember.mangleof, "10MonoMember", "").idup;

        // grabs possible variable name for this template instantiation
        enum identifier = MonoMember.mangleof.split!isNumber[$-2];
    }

    mixin(
        "@property " ~ '\n' ~
        "{" ~ '\n' ~
        `    final T ` ~ name ~ ` () { MonoObject* self; static if (!__traits(isStaticFunction, (__traits(parent, self)))) self = _obj; return MonoMemberGet!(typeof(this), T, "` ~ name ~ `")(self); }` ~ '\n' ~
        `    final T ` ~ name ~ ` (T val) { MonoObject* self; static if (!__traits(isStaticFunction, (__traits(parent, self)))) self = _obj; MonoMemberSet!(typeof(this), T, "` ~ name ~ `")(self, val); return val; } ` ~ '\n' ~
        "}"
    );

}


ReturnType!fn MonoMethodImpl(Class, alias fn, T...)(auto ref Class this_, T args) if (isSomeFunction!fn && !__traits(isTemplate, fn))
{
    auto dom = MonoDomainHandle.get();
    auto ass = dom.openAssembly(getAssembly!(Class, "UnityEngine"));
    MonoClassHandle cls = ass.image.classFromName(getNamespace!Class, getClassname!Class);

    // --- method picker
    static if (staticIndexOf!("@property", __traits(getFunctionAttributes, FunctionTypeOf!(fn))) >= 0)
      static if (Parameters!(FunctionTypeOf!fn).length == 1)
        auto m = mono_property_get_set_method(mono_class_get_property_from_name(cls.handle, __traits(identifier, fn)));
      else static if (Parameters!(FunctionTypeOf!fn).length == 0)
        auto m = mono_property_get_get_method(mono_class_get_property_from_name(cls.handle, __traits(identifier, fn)));
      else 
        static assert(0, "invalid parameters for @property");
    else
      static if (__traits(identifier, fn) == "__ctor")
        auto m = mono_class_get_method_from_name(cls.handle, ".ctor", Parameters!fn.length);
    else
      auto m = mono_class_get_method_from_name(cls.handle, __traits(identifier, fn), Parameters!fn.length);

    // --- extract as params packer
    void*[Parameters!fn.length] fnargs;
    static foreach(i; 0..fnargs.length)
    {
        static if (__traits(hasMember, Parameters!fn[i], "_obj"))
        fnargs[i] = mixin("_param_", cast(int)i+1)._obj;
        else static if (!isPointer!(Parameters!fn[i]) && (isBasicType!(Parameters!fn[i]) || is(Parameters!fn[i] == struct)))
        fnargs[i] = cast(void*) mixin("&_param_", cast(int) i+1);
        else static if (is(Parameters!fn[i] == string) || isArray!(Parameters!fn[i]))
        fnargs[i] = cast(void*) mixin("_param_", cast(int) i+1, ".boxify");
        else
        fnargs[i] = cast(void*) mixin("_param_", cast(int) i+1);
    }

    // --- static/virtual selector
    static if (__traits(isStaticFunction, fn))
      MonoObject* self = null;
    else static if (__traits(identifier, fn) == "__ctor")
      MonoObject* self = mono_object_new(dom.handle, cls.handle);
    else static if (is(T==struct))
      MonoObject* self = cast(MonoObject*) &this_;
    else
      { MonoObject* self = this_._obj; m = mono_object_get_virtual_method(self, m); }
    
    // --- actual call
    MonoObject* exception;
    auto res = mono_runtime_invoke(m, self, fnargs.ptr, &exception);
    static if (__traits(identifier, fn) == "__ctor")
        this_.__ctor(res);
    if (exception)
        throw new MonoException(exception);
    static if (!(is(typeof(return) == void) || __traits(identifier, fn) == "__ctor"))
        return monounwrap!(ReturnType!(FunctionTypeOf!fn))(res);
}


private auto inflateGenericClass(Args...)(MonoClass* base)
{
    import unity;

    auto dom = MonoDomainHandle.get();

    auto ty = mono_class_get_type(base);
    Type type = new MonoImplement!Type(cast(MonoObject*) mono_type_get_object(dom.handle, ty));
    Type[Args.length] genericParams;
    static foreach(i, arg; Args)
    {
        genericParams[i] = monoTypeOf!arg;
    }
    auto genericType = type.MakeGenericType(genericParams);

    // MonoClass* can be obtained using Type.TypeHandle.Value property
    return genericType;
}


alias EventFrom(alias fn) = extern(C) ReturnType!fn function (Parameters!fn);

// C# event wrapper
struct MonoEventImpl(Class, string eventName, alias del)
{
    auto Add(EventFrom!del d, MonoObject* inst = null)
    {
        return doIt(inst, d, mono_event_get_add_method);
    }

    void Remove(MonoObject* del, MonoObject* inst = null)
    {
        doIt(inst, del, mono_event_get_remove_method);
    }

    private MonoObject* doIt(MonoObject* inst, void* theDelegate, typeof(mono_event_get_add_method) eventAction)
    {
        import std.conv : to;
        import std.string : format;
        import unity;

        enum isGenericDel = __traits(compiles, TemplateArgsOf!del);

        auto dom = MonoDomainHandle.get();
        MonoAssemblyHandle ass = dom.openAssembly(getAssembly!(Class, "UnityEngine"));
        auto cls = ass.image.classFromName(getNamespace!Class, getClassname!Class);

        MonoEvent* e = findEvent(cls.handle, eventName);
        if (!e)
            throw new Exception(format("Event '%s' not found in class '%s'", eventName, __traits(identifier, Class)));

        // constructs class name for regular/generic names in form such as List`1 or IList
        static if (isGenericDel)
            enum classNameDel = getClassname!del ~ "`" ~ to!string(TemplateArgsOf!del.length);
        else
            enum classNameDel = getClassname!del;

        MonoAssemblyHandle delegateAssembly = dom.openAssembly(getAssembly!(del, "UnityEngine"));
        auto delegateClass = delegateAssembly.image.classFromName(getNamespace!del, classNameDel);

        Type delegateType;
        static if (isGenericDel)
        {
            delegateType = inflateGenericClass!(TemplateArgsOf!del)(delegateClass.handle);
        }
        else
        {
            delegateType = new MonoImplement!Type(cast(MonoObject*)delegateClass.handle);
        }

        if (!(delegateType && delegateType._obj))
            throw new Exception("delegate type error");

        //Debug.Log(cast(Object) delegateType._obj);

        void*[1] args = [ theDelegate ];

        if (eventAction == mono_event_get_add_method)
        {
            // delegates implicitly derived from Delegate class, and have constructor that takes context and method parameters
            auto fnptr = mono_value_box(mono_domain_get(), mono_get_intptr_class(), &theDelegate);
            auto dlg = Activator.CreateInstance(delegateType, [cast(Object) inst, cast(Object) fnptr]);
            args[0] = dlg;
        }

        MonoObject* exc;
        mono_runtime_invoke(eventAction(e), inst, args.ptr, &exc);
        if (exc)
            throw new MonoException(exc);

        if (eventAction == mono_event_get_add_method)
            return cast(MonoObject*) args[0];
        return null;
    }

    static MonoEvent* findEvent(MonoClass* cls, string event)
    {
        import core.stdc.string;
        void* it;
        MonoEvent* e = mono_class_get_events(cls, &it);
        while(e)
        {
            if (e && strcmp(mono_event_get_name(e), eventName.ptr) == 0)
                return e;
            e = mono_class_get_events(cls, &it);
        }
        return null;
    }
}


// return System.Type equivalent for specific type
MonoReflectionType* getSystemType(Class)()
{
    static if (getUDAs!(Class, AssemblyAttr).length)
        enum assemblyName = getUDAs!(Class, AssemblyAttr)[0].name;
    else
        enum assemblyName = "UnityEngine";
    static if (getUDAs!(Class, NamespaceAttr).length)
        enum nsName = getUDAs!(Class, NamespaceAttr)[0].name;
    else 
        enum nsName = "";
    static if (getUDAs!(Class, SymNameAttr).length)
        enum clsName = getUDAs!(Class, SymNameAttr)[0].name;
    else
        enum clsName = __traits(identifier, Class);

    auto dom = MonoDomainHandle._default.get();
    MonoAssemblyHandle ass = dom.openAssembly(assemblyName);
    auto cls = ass.image.classFromName(nsName, clsName);
    auto ty = mono_class_get_type(cls.handle);
    return mono_type_get_object(dom.handle, ty);
}


auto monoTypeOf(Class)()
{
    import unity : Type;
    Type t = new MonoImplement!Type(cast(MonoObject*) getSystemType!Class());
    return t;
}


version(none) unittest
{
    struct Test
    {
        struct Inner
        {
            mixin MonoMember!Nested _i;
        }
        static struct Nested
        {
            mixin MonoMember!string s;
        }
        mixin MonoMember!float _a;
    }

    static assert(Test._a.MonoMember.identifier == "_a");
    static assert(Test.Inner._i.MonoMember.identifier == "_i");
    static assert(Test.Nested.s.MonoMember.identifier == "s");
}

class MonoException : Exception
{
    MonoObject* _exc;
    this (MonoObject* exc) { _exc = exc; super("Runtime Exception"); }
}

T monounwrap(T)(MonoObject* value)
{
    import unity;
    static if (isBasicType!(T) || is(T == enum))
    {
        T res = void;
        res = *cast(T*)mono_object_unbox(value);
        return res;
    }
    else static if (is(T == void*))
    {
        return value;
    }
    else static if (is(T == struct))
    {
        return *(cast(T*) ((cast(void*)value)+MonoObjectSizeOf)); 
    }
    else static if (is(T == interface))
    {
        // implement me
        return null;
    }
    else static if (__traits(compiles, new MonoImplement!T(value)))
    {
        return new MonoImplement!T(value);
    }
    else static if (is(T : string))
    {
        import std.conv : to;
        import std.string : fromStringz;
        import std.utf;
        import core.stdc.string;
        char* s = mono_string_to_utf8(cast(MonoString*)value);
        string res = fromStringz(s).dup;
        scope(exit) mono_free(s);
        return res;
    }
    else static if (isArray!T)
    {
        import std.range : ElementType;
        auto arr = MonoArrayHandle!(ElementType!T)(cast(MonoArray*) value);
        const len = mono_array_length(cast(MonoArray*) value);
        T res = new ElementType!(T)[len];
        foreach(i; 0..len)
        {
            static if (__traits(hasMember, ElementType!T, "_obj") && is(typeof(ElementType!T._obj) == MonoObject*))
              res[i] = monounwrap!(ElementType!T)(cast(MonoObject*) arr[i]);
            else static if (is(ElementType!T == struct))
            {
              auto tmp = arr[i];
              res[i] = monounwrap!(ElementType!T)(cast(MonoObject*) &tmp);
            }
            else static if (isValueType!(ElementType!T))
              res[i] = arr[i];
            else 
              pragma(msg, __FILE__, ":", __LINE__,  " fix me - ", T.stringof);
        }
        return res;
    }
    else static assert(0);
}


template hasObjectParam(alias fn)
{
    static if (isSomeFunction!fn) 
        enum hasObjectParam = staticIndexOf!(Object, Parameters!(FunctionTypeOf!fn)) >= 0; // weird bug with "!= -1" ?
    else
        enum hasObjectParam = false;
}

template hasOverloadWithObjectParam(T, string name)
{
    import std.meta;
    import std.traits;

    enum hasOverloadWithObjectParam = Filter!(hasObjectParam, __traits(getOverloads, T, name)).length > 0;
}

version(none) @("test bug with hasObjectParam")
{
import unity;
static assert(hasObjectParam!(Object_.Equals));
static assert(hasOverloadWithObjectParam!(Object_, "Destroy"));
static assert(!hasObjectParam!(Object_.name));
static assert(!hasOverloadWithObjectParam!(Object_, "name"));

//pragma(msg, hasObjectParam!(Object_.name));
//pragma(msg, staticIndexOf!(Object, Parameters!(Object_.name)));
//pragma(msg, Filter!(hasObjectParam, __traits(getOverloads, Object_, "name")));
//pragma(msg, staticMap!(hasObjectParam, __traits(getOverloads, Object_, "name")));
}


/// Full wrapper mixin string, add everything required to make C# class acessible
@property string monoObjectImpl()
{
    import std.conv : text;
    return text(
        "import std.traits;", '\n',
        "import std.meta;", '\n',
        `mixin("mixin MonoObjectImpl _mono_impl_", typeof(this).stringof, ";");`, '\n',
        q{
            static foreach(m; __traits(derivedMembers, typeof(this)))
            {
                static foreach(fn; __traits(getOverloads, typeof(this), m))
                {
                    static if(__traits(isStaticFunction, fn) || is(typeof(this) == struct))
                    {
                        // ---------------------------------------
                        // inserts generic helper for Object params
                        static if (hasObjectParam!(fn))
                        {
                            mixin(
                            `// `, typeof(this).stringof, " | GeneralizedFun", '\n',
                            `final`, __traits(isStaticFunction, fn) ? " static " : " ", `ReturnType!fn `, __traits(identifier, fn), 
                            `(`,
                            genericList!(Parameters!fn),
                            replaceParams!(Parameters!fn),
                            `) {`, 
                            '\n',
                                (is(ReturnType!fn == void)) ? "" : "return ", typeof(this).stringof, ".",
                                __traits(identifier,fn), "(", delegateCall!(Parameters!fn)(), ");", '\n',
                            "}"
                            );
                        }
                        static if (m == "opIndex" || m == "opIndexAssign") {}
                        else
                        // actual static method implementation
                        mixin(
                            `pragma(mangle, "`, fn.mangleof, `")`, "\n",
                            `final`, __traits(isStaticFunction, fn) ? " static " : (is(typeof(this) == struct) ? " " : " override "), (ReturnType!fn).stringof, " ", __traits(identifier, fn), `_Impl (Parameters!fn)`, 
                            q{{
                                    auto dom = MonoDomainHandle.get();
                                    auto ass = dom.openAssembly(getAssembly!(__traits(parent, fn), "UnityEngine"));
                                    MonoClassHandle cls = ass.image.classFromName(getNamespace!(__traits(parent, fn)), getClassname!(__traits(parent, fn)));
                                    static if (-1 != staticIndexOf!("@property", __traits(getFunctionAttributes, FunctionTypeOf!(fn))))
                                    static if (is(typeof(return) == void))
                                        auto m = mono_property_get_set_method(mono_class_get_property_from_name(cls.handle, __traits(identifier, fn)));
                                    else
                                        auto m = mono_property_get_get_method(mono_class_get_property_from_name(cls.handle, __traits(identifier, fn)));
                                    else
                                    auto m = mono_class_get_method_from_name(cls.handle, __traits(identifier, fn), Parameters!fn.length);
                                    void*[Parameters!fn.length] args;
                                    static foreach(i; 0..args.length)
                                    {
                                        static if (__traits(hasMember, Parameters!fn[i], "_obj"))
                                        args[i] = mixin("_param_", cast(int) i)._obj;
                                        else static if (!isPointer!(Parameters!fn[i]) && (isBasicType!(Parameters!fn[i]) || is(Parameters!fn[i] == struct)))
                                        args[i] = cast(void*) mixin("&_param_", cast(int) i);
                                        else static if (is(Parameters!fn[i] == string) || isArray!(Parameters!fn[i]))
                                        args[i] = cast(void*) mixin("boxify(_param_", cast(int) i, ")");
                                        else
                                        args[i] = cast(void*) mixin("_param_", cast(int) i);
                                    }
                                    static if (__traits(isStaticFunction, fn))
                                      MonoObject* self = null;
                                    else static if (is(typeof(this) == struct))
                                      MonoObject* self = cast(MonoObject*) &this;
                                    else
                                    { MonoObject* self = (cast(__traits(parent, fn))this)._obj; m = mono_object_get_virtual_method(self, m); }
                                    MonoObject* exception;
                                    auto res = mono_runtime_invoke(m, self, args.ptr, &exception);
                                    if (exception)
                                        throw new MonoException(exception);
                                    static if (!is(typeof(return) == void))
                                        return monounwrap!(ReturnType!(FunctionTypeOf!fn))(res);
                            }}
                        );
                        // ---------------------------------------
                    }
                }
            }
        }
    );
}

/// Minimal wrapper mixin, just adds the constructor and object handle fields.
mixin template MonoObjectImpl()
{
    static if (is(typeof(this) == struct))
    {

    }
    else
    {
        static if (!is(typeof(__traits(getMember, typeof(this), "_obj"))))
            public MonoObject* _obj;

        this(MonoObject* obj) 
        {
            static if (__traits(compiles, super(obj)))
                super(obj);
            else
                _obj = obj;
        }
    }
}