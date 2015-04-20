module SystemImageBuilder

using FunctionalData

export buildimage, resetimage

function requires(pkg)
    dir = Pkg.dir(pkg)
    filename = @p joinpath dir "REQUIRE"
    !isfile(filename) && return (pkg,[])
    reqs = @p Base.Pkg.Reqs.read filename | Base.Pkg.Reqs.parse | keys | collect | filter unequal "julia"
    pkg, reqs
end

function recursiverequirements(installed)
    req = @p map installed requires | Dict
    makerec(a,k) = @p map a[k] (x->makerec(a,x)) | flatten | vcat a[k] | filter not*isempty | unique | sort
    map(req, (k,v)->(k,makerec(req,k)))
end

try
    include(joinpath(JULIA_HOME, Base.DATAROOTDIR, "julia", "build_sysimg.jl"))
catch
    script = @p normpath JULIA_HOME ".." ".." "contrib" "build_sysimg.jl"
    include(script)
end

defaultexclude = ["Tk","PyPlot","IJulia","SystemImageBuilder","WinRPM"]

sysimg = default_sysimg_path
if !isfile(sysimg*".ji")
    sysimg = joinpath(dirname(sysimg), "julia", "sys")
end
if !isfile(sysimg*".ji")
    error("$(syimg).ji does not seem to be the correct path of sys.ji")
end

resetimage() = buildimage(reset = true)
function buildimage(;exclude = defaultexclude, include = [], targetpath = sysimg, reset = false)
    base_dir = dirname(Base.find_source_file("sysimg.jl"))
    userimg = @p joinpath base_dir "userimg.jl"

    if reset
        try rm(userimg) end
        println("##  SystemImageBuilder: building clean sys.ji ...\n")
        build_sysimg(sysimg, "native", force = true)
    else
        installed = sort([k for (k,v) in Pkg.installed()])
        req = recursiverequirements(installed)
        packages = filter(x->!in(x,exclude), installed)
        packages = filter(x->isempty(intersect(req[x],exclude)), packages)
        packages = [include; packages]

        println("##  SystemImageBuilder: the following $(length(packages)) packages will be included in the system image:\n")
        println(join(packages, ", "))

        skipped = setdiff(installed, packages)
        if !isempty(skipped)
            println("\n##  SystemImageBuilder: the following $(length(skipped)) packages will be skipped:\n")
            println(join(skipped, ", "))
        end
        println()

        @p map packages (x->"try Base.require(\"$x\") end") | unlines | write userimg
        
        println("##  SystemImageBuilder: invoking build_sysimg ...\n")
        mkpath(targetpath)
        build_sysimg(targetpath, "native", force = true)
    end
end

end # module
