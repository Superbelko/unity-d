module mono_internal;

import std.bitmanip : bitfields;

public import mono;

struct CppClassSizeAttr
{
    alias size this;
    size_t size;
}
CppClassSizeAttr cppclasssize(size_t a) { return CppClassSizeAttr(a); }

struct CppSizeAttr
{
    alias size this;
    size_t size;
}
CppSizeAttr cppsize(size_t a) { return CppSizeAttr(a); }


// somewhere (in docs?) I've seen mentions that this struct expected to be on the heap, unlike MonoGenericContext that is expected to be on the stack
extern(C)
@cppclasssize(1) align(1)
struct _MonoGenericInst
{
    @cppsize(4) public int id;
    mixin(bitfields!(
        int, "type_argc", 22,
        int, "is_open", 1,
        int, "", 32-23
    ));
    @cppsize(8) public MonoType*[1] type_argv; // this should be MonoType*[1] on windows and MonoType*[] on linux, however it will be difficult to use in D
    // there is also a quirks mentioned somewhere in the docs about these two structs relations and type_argv 
}
alias MonoGenericInst = _MonoGenericInst;


// somewhere (in docs?) I've seen mentions that this struct expected to be on the stack, unlike MonoGenericInst which should go on the heap
extern(C)
@cppclasssize(16) align(8)
struct _MonoGenericContext
{
    @cppsize(8) public MonoGenericInst* class_inst;
    @cppsize(8) public MonoGenericInst* method_inst;
}
alias MonoGenericContext = _MonoGenericContext;

extern(C)
@cppclasssize(1) align(1)
struct _MonoMethodInflated
{
    extern(C)
    @cppclasssize(1) align(1)
    union _anon1
    {
        @cppsize(1) public MonoMethod method;
        @cppsize(1) public MonoMethodPInvoke pinvoke;
    }
    @cppsize(1) public _anon1 method;
    @cppsize(8) public MonoMethod* declaring;
    @cppsize(16) public MonoGenericContext context;
    @cppsize(8) public MonoImageSet* owner;
}
alias MonoMethodInflated = _MonoMethodInflated;


extern(C)
@cppclasssize(1) align(1)
struct _MonoGenericClass
{
    @cppsize(8) public MonoClass* container_class;
    @cppsize(16) public MonoGenericContext context;
    @cppsize(4) public int is_dynamic;
    @cppsize(4) public int is_tb_open;
    @cppsize(4) public int need_sync;
    @cppsize(8) public MonoClass* cached_class;
    @cppsize(8) public MonoImageSet* owner;
}
alias MonoGenericClass = _MonoGenericClass;


extern(C)
@cppclasssize(1) align(1)
struct AnonType_48
{
    @cppsize(8) public MonoClass* pklass;
    @cppsize(8) public const(char)* name;
    @cppsize(4) public int flags;
    @cppsize(4) public int token;
    @cppsize(8) public MonoClass** constraints;
}
alias MonoGenericParamInfo = AnonType_48;


extern(C)
@cppclasssize(1) align(1)
struct _MonoMethod
{
    @cppsize(4) public int flags;
    @cppsize(4) public int iflags;
    @cppsize(4) public int token;
    @cppsize(8) public MonoClass* klass;
    @cppsize(8) public MonoMethodSignature* signature;
    @cppsize(8) public const(char)* name;
    mixin(bitfields!(
        uint, "inline_info", 1,
        uint, "inline_failure", 1,
        uint, "wrapper_type", 5,
        uint, "string_ctor", 1,
        uint, "save_lmf", 1,
        uint, "dynamic", 1,
        uint, "sre_method", 1,
        uint, "is_generic", 1,
        uint, "is_inflated", 1,
        uint, "skip_visibility", 1,
        uint, "verification_success", 1,
        int, "slot", 16,
        int, "", 1));
}
alias MonoMethod = _MonoMethod;


extern(C)
@cppclasssize(1) align(1)
struct _MonoMethodPInvoke
{
    @cppsize(1) public MonoMethod method;
    @cppsize(4) public int addr;
    @cppsize(4) public int piflags;
    @cppsize(4) public int implmap_idx;
}
alias MonoMethodPInvoke = _MonoMethodPInvoke;