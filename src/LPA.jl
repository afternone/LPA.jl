module LPA

using StatsBase
using Graphs

export label_propagation, modularity, nmi, voi, neighbor_strength

include("labelpropagation.jl")
include("modularity.jl")
include("nmi.jl")
include("voi.jl")
include("utils.jl")

end # module
