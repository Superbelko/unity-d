# [PoC] Unity API D language Wrapper 

Allows to write Unity Engine scripts using D language.

This repository itself is a basic "Asteroids" like game Unity project, simply open it in Unity.

See Assets/Plugins/game/readme.md for more information.

## Building (game plugin)

```
cd Assets/Plugins/game
dub build --arch=x86_64 --compiler=ldc2 --config=sharedlib
```

Currently on Windows x64 is supported.

## License

MIT License