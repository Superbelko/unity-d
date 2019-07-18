# Unity API D wrapper

This project provides minimal Unity API wrappers, it may lack features or some crucial API's can be missing. It comes with simple demo game project to show how to use it.

**Note: This is just proof-of-concept project, and I Currently doesn't have plans to finish it.**


## Features

Partial support for runtime calls allowing to call most of the C# stuff.

Works:
- Virtual Methods
- Static Methods
- Methods
- Properties
- Constructors
- [Limited] Fields
- [Limited] Generic Methods
- [Experimental] Operator overloading


Not yet, but may in future:
- Delegates
- Events

Unknown: 
- Implement method using native function
- Native inheritance
- Ability to create classes that are usable from .NET
- *There is a chance that all three could be achievable by using runtime code generation (for example with the help of Roslyn-based helper plugin)*


## How it is implemented

There are several key elements that provides the core functionality

- `MonoImplement(T)` template - creates subclass that implements virtual methods and constructors
- `MonoObjectImpl` / `monoObjectImpl` mixins - the former just injects wrapper handle and constructor, the latter also implements all static methods in current class
- `monoGenericMethod` mixin - implements current templated method as generic
- `MonoMember(T, string name)` mixin - implements field accessor
- `MonoOperator(alias op)(...)` - operator overload implementation
- annotations like `namespace("name")` and `assembly("name")` - used to describe where specific classes can be found
- `symname("name")` attribute to use with reserved names like `object`

The most ugly parts is MonoMember and monoGenericMethod, there is no way to make these aspects completely invisible to the API. Mixins with `camelCase` names are string mixins.

Keep in mind that `object` type in C# is basically what `void*` does in D, however to keep things opaque to the users this internally overloaded and implemented as templates. Note that `object` is reserved, so instead it expects `Object`. And for example Unity also has `Object` class, as workaround I chose to append underscore and just rename it instead.

It is also worth mention there is also `boxify` and `monounwrap` templates that behind the scenes implements packing and unpacking data back and forth between .NET and native code.

Be aware that current implementation is far from optimal, it produces a lot of short living garbage (relatively small though, object with 1-2 extra pointers). It generates lots of text mixins, which negatively affects compile times, and results in binary code bloat.

And finally keep in mind that you shouldn't store references in your code as objects can be moved any time (do they? is default conservative GC does that?), so instead you should pin them to take GC handle instead and when needed later on obtain the object back from that handle.

## Linux build notes 

*Beware, this section may be incorrect and/or misleading, as I'm not a Linux guy and may lack required skills, knowledge or could just have wrong understanding of the problem*

Unlike Windows where D rutime and standard library are linked statically so you can just copy resulting binary to other machine and it will work, D compilers use dynamically linked runtime and standard libraries, this and library loading rules makes it impractical to just copy binary to other machine, so the solution is to use static linked runtime and standard library.

Unfortunately default distribution(at least LDC one) contains static libraries incompatible with some other distro's policy where PIC/PIE used by default(such as Ubuntu).

Thankfully LDC comes with handy utility 'ldc-build-runtime', so when you done developing your game and ready to package it is time to build PIC enabled static libs.

But first let's see what our plugin requires
``` sh
$ ldd libdtest.so
	...
	libphobos2-ldc-shared.so.85 => /home/testuser/dlang/ldc-1.15.0/bin/../lib/libphobos2-ldc-shared.so.85 (0x00007f0453f28000)
	libdruntime-ldc-shared.so.85 => /home/testuser/dlang/ldc-1.15.0/bin/../lib/libdruntime-ldc-shared.so.85 (0x00007f0453e08000)
	...
```
Ok, see the problem? We can't simply expect the user have this specific libraries installed on their machine. And at least in my case it is also seems to ignore rpath $ORIGIN (though I'm not entirely sure it will work at all with shared libs)

So, back to problem.

Assuming your LDC is in ~/dlang/ldc-1.xx build libs (note that I used ninja build system here, but you can try default one)
``` sh
cd ~/dlang/ldc-1.15.0
mkdir rtlib
cd rtlib
../bin/ldc-build-runtime --ninja BUILD_SHARED_LIBS=OFF --linkerFlags="-fPIC" --dFlags="-relocation-model=pic"
```

Now let's build the game plugin (by specyfiying empty -defaultlib= we tell ldc to not link default libraries automatically)

``` sh
~/dlang/ldc-1.15.0/bin/ldc2 -shared -defaultlib=  source/impl.d source/mono.d source/mono_internal.d source/unity.d -oflibdtest.so   ~/dlang/ldc-1.15.0/rtlib/ldc-build-runtime.tmp/lib/libphobos2-ldc.a ~/dlang/ldc-1.15.0/rtlib/ldc-build-runtime.tmp/lib/libdruntime-ldc.a
```

Now ldd shows we don't need shared runtime, which hopefully should increase our chances to run this binary on other machines.

``` sh
$ ldd libdtest.so
	linux-vdso.so.1 (0x00007ffd5ed1b000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f1b261c0000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f1b261b8000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f1b26190000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f1b26040000)
	libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f1b26020000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f1b25e30000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f1b26890000)

```
