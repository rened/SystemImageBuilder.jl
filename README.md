## SystemImageBuilder

[![Build Status](https://travis-ci.org/rened/SystemImageBuilder.jl.png)](https://travis-ci.org/rened/SystemImageBuilder.jl)

`SystemImageBuilder` is a wrapper around the `build_sysimg` utility function. It allows to build a `sys.ji` image of all installed packages, skipping the packages which are on a curated `exclude` list themselves or depend on such an excluded package.

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

#### Excluded packages

`SystemImageBuilder.defaultexclude` contains a set of packages which are known not to be pre-compilable. Additional packages can be skipped by specifying the `exclude` parameter.

```jl
buildimage(exclude = [SystemImageBuilder.defaultexclude; "SomePackage"])
```

You can force the inclusion of a package of specifying the `include` parameter:

```jl
buildimage(include = "SomePackage")
```


