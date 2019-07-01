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


Not yet, but may in future:
- Operator overloads
- Delegates
- Events

Unknown: 
- Implement method using native function
- Native inheritance
- Ability to create classes that are usable from .NET


## How it is implemented

There are several key elements that provides the core functionality

- `MonoImplement(T)` template - creates subclass that implements virtual methods and constructors
- `MonoObjectImpl` / `monoObjectImpl` mixins - the former just injects wrapper handle and constructor, the latter also implements all static methods in current class
- `monoGenericMethod` mixin - implements current templated method as generic
- `MonoMember(T, string name)` mixin - implements field accessor
- annotations like `namespace("name")` and `assembly("name")` - used to describe where specific classes can be found
- `symname("name")` attribute to use with reserved names like `object`

The most ugly parts is MonoMember and monoGenericMethod, there is no way to make these aspects completely invisible to the API. Mixins with `camelCase` names are string mixins.

Keep in mind that `object` type in C# is basically what `void*` does in D, however to keep things opaque to the users this internally overloaded and implemented as templates. Note that `object` is reserved, so instead it expects `Object`. And for example Unity also has `Object` class, as workaround I chose to append underscore and just rename it instead.

It is also worth mention there is also `boxify` and `monounwrap` templates that behind the scenes implements packing and unpacking data back and forth between .NET and native code.

Be aware that current implementation is far from optimal, it produces a lot of short living garbage (relatively small though, object with 1-2 extra pointers). It generates lots of text mixins, which negatively affects compile times, and results in binary code bloat.

And finally keep in mind that you shouldn't store references in your code as objects can be moved any time (do they? is default conservative GC does that?), so instead you should pin them to take GC handle instead and when needed later on obtain the object back from that handle.