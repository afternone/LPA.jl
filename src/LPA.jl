module LPA

using StatsBase
using Graphs

export label_propagation, modularity, nmi, voi

include("labelpropagation.jl")
include("modularity.jl")
include("nmi.jl")
include("voi")
include("utils.jl")

end # module
