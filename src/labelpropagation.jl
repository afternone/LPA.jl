"""
This function finds the most frequent labels of neighbors
and randomly returns one of them
"""
function maxvote{T}(label_count::Dict{Int,T})
  max_count = maximum(values(label_count))
  candidate_labels = Int[]
  for (k,v) in label_count
    if v == max_count
      push!(candidate_labels, k)
    end
  end
  sample(candidate_labels)
end

"""
Applies the value of label for each neighbor
and calls maxvote function
"""
function applyvote!{V}(v::V, g::AbstractGraph{V}, Label::Vector{Int})
  v_neighbors = out_neighbors(v, g)
  if length(v_neighbors)>0
    nLabels = Array(Int, length(v_neighbors))
    for (i, u) in enumerate(v_neighbors)
      nLabels[i] = Label[vertex_index(u, g)]
    end
    Label[vertex_index(v, g)] = maxvote(countmap(nLabels))
  end
end

function applyvote!{V}(v::V, g::AbstractGraph{V}, Label::Vector{Int}, ns::Vector{Float64}, λ::Real=1.0)
  v_edges = out_edges(v, g)
  if length(v_edges)>0
    label_count = Dict{Int,Float64}()
    for e in v_edges
      e_idx = edge_index(e, g)
      u = target(e, g)
      u_idx = vertex_index(u, g)
      if haskey(label_count, Label[u_idx])
        label_count[Label[u_idx]] += 1.0 + λ*ns[e_idx]
      else
        label_count[Label[u_idx]] = 1.0 + λ*ns[e_idx]
      end
    end
    Label[vertex_index(v, g)] = maxvote(label_count)
  end
end

"""
Perform label propagation alghrithm for each node in a random order
up to `iterations` times
"""
function label_propagation{V}(g::AbstractGraph{V}; iterations::Int=20)
  Label = [1:num_vertices(g)]
  for i=1:iterations
    order = shuffle(collect(vertices(g)))
    for v in order
      applyvote!(v, g, Label)
    end
  end
  permute_labels!(Label)
  Label
end

function label_propagation{V}(g::AbstractGraph{V}, ns::Vector{Float64}; λ::Real=1.0, iterations::Int=20)
  Label = [1:num_vertices(g)]
  for i=1:iterations
    order = shuffle(collect(vertices(g)))
    for v in order
      applyvote!(v, g, Label, ns, λ)
    end
  end
  permute_labels!(Label)
  Label
end
