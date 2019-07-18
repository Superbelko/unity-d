# [PoC] Unity API D language Wrapper 

Allows to write Unity Engine scripts using D language.

This repository itself is a basic "Asteroids" like game Unity project, simply open it in Unity.

See Assets/Plugins/game/readme.md for more information.

## Building (game plugin)

```
cd Assets/Plugins/game
dub build --arch=x86_64 --compiler=ldc2 --config=sharedlib
```

## Platform support

- Windows x64 - ok
- Windows x86 - ok, but not very well tested
- Linux x64 - works, lacks testing
- Linux x86 - unknown, but seems it reaches the end of support from Unity, so no problem
- Mac OS - untested, may require some modifications
- iOS - not until JIT are allowed, also I have concerns about D support on that platform
- Android - likely to work with mono runtime and some modifications, but *since major D Android contributor left the community, platform support by D is unknown*
- other platforms are too exotic for D yet, so likely not gonna happen.

## License

MIT License