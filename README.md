## SystemImageBuilder

[![Build Status](https://travis-ci.org/rened/SystemImageBuilder.jl.png)](https://travis-ci.org/rened/SystemImageBuilder.jl)

*Julia 0.4 adds the feature of precompiled, cached packages. SystemImageBuilder is thus no longer needed, and therefore deprecated.*

`SystemImageBuilder` is a wrapper around the `build_sysimg` utility function. It allows to build a `sys.ji` image of all installed packages, skipping the packages which are on a curated `exclude` list themselves or depend on such an excluded package.

#### Installing

As the list of packages changes frequently, for now it is recommended to install the latest master directly: 

```jl
Pkg.clone("https://github.com/rened/SystemImageBuilder.jl.git")
```

On OSX and Linux you should be all set, on Windows you might need to install `gcc`:

```jl
Pkg.add("WinRPM")
using WinRPM
WinRPM.install("gcc")
```

#### Using

Usage is simple:

```jl
using SystemImageBuilder
buildimage()
```

If you want to first test the image without overwriting the default (recommended), you can specify a targetpath:

```jl
buildimage(targetpath = "/tmp/mytest/sys")
```

And then restart Julia with

```
julia -J /tmp/mytest/sys.ji
```

In case you did not specify a custom `targetpath`, thus overwriting the default, and want to remove any pre-compiled code, you can run:

```jl
resetimage()
```

#### Include / Exclude packages

`SystemImageBuilder.defaultexclude` contains a set of packages which are known not to be pre-compilable. Additional packages can be skipped by specifying the `exclude` parameter:

```jl
buildimage(exclude = [SystemImageBuilder.defaultexclude; "SomePackage"])
```

If you think a certain package should be part of the default exclusion list, please file an issue!

You can force the inclusion of a package by specifying the `include` parameter:

```jl
buildimage(include = ["SomePackage"])
```

#### Updating

When you change the set of installed packages, like with `Pkg.add()` or `Pkg.update()`, you will need to run `buildimage()` again.


