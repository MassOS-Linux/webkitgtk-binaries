# webkitgtk-binaries
Precompiled binaries of WebKitGTK used on MassOS.

This is necessary because of the following reasons:

1. WebKitGTK takes ridiculously long to compile (3-4+ hours on a decent Intel Core i5).
2. Especially with 2.36+, it is **extremely resource heavy**. You now need about 4x as much RAM as CPU threads, so if your CPU had 8 threads, you'd need 32GB of RAM! Trying to compile it with any less, or with Swap, will cause any of three things to happen:
  - The build could freeze indefinitely, even if the rest of the system doesn't.
  - The whole system could freeze indefinitely, requiring a hard reset.
  - The desktop session could crash if compiling from a graphical environment.

WebKitGTK has a lot of dependencies, but most of them are trivial, and the library API versions aren't likely to change. However, it **does** depend on ICU, which changes its ABI/soname version on every update. Therefore when ICU is updated we'll need to rebuild WebKitGTK.

The MassOS version labelled on the released binaries is the minimum version that the binary package will run on, not the only version, unless something like ICU is updated as mentioned above.
