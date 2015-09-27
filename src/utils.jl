function neighbor_strength{V}(g::AbstractGraph{V})
    △ = zeros(Int, num_edges(g))
    for e in edges(g)
        u, v = source(e, g), target(e, g)
        u_nei, v_nei = out_neighbors(u, g), out_neighbors(v, g)
        uv_nei = intersect(u_nei, v_nei)
        △[edge_index(e, g)] = length(uv_nei)
    end
    △
end

function permute_labels!(membership::Vector{Int})
    N = length(membership)
    if maximum(membership) > N || minimum(membership) < 1
        error("Label must between 1 and |V|")
    end
    label_counters = zeros(Int, N)
    j = 1
    for i=1:length(membership)
        k = membership[i]
        if k >= 1
            if label_counters[k] == 0
                # We have seen this label for the first time
                label_counters[k] = j
                k = j
                j += 1
            else
                k = label_counters[k]
            end
        end
        membership[i] = k
    end
end
