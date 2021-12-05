#!/usr/bin/julia

using DelimitedFiles

# parse input
input = readdlm("input", ' ', '\n')[:, [1, 3]]
input = split.(input, ',')

input = [vcat(row...) for row in eachrow(input)]
input = Iterators.flatten(input) |> collect
input = reshape(input, (4,:))
input = parse.(Int, input) |> transpose

# preprocessing
input .+= 1 # my array indexing starts at 1 -- urgs
m = maximum(input[:,[1,3]])
n = maximum(input[:,[2,4]])

# part 1
begin
    area = zeros(Int, (m,n))

    for (x1, y1, x2, y2) ∈ eachrow(input)
        if ((x1 == x2) || (y1 == y2))
            xs = range(minmax(x1, x2)...)
            ys = range(minmax(y1, y2)...)
            area[ys, xs] .+= 1
        end
    end
    @show p1 = sum(area .> 1)
end


# part 2
begin
    area = zeros(Int, (m,n))

    for (x1, y1, x2, y2) ∈ eachrow(input)
        if ((x1 == x2) || (y1 == y2)) # vertical / horizontal line
            xs = range(minmax(x1, x2)...)
            ys = range(minmax(y1, y2)...)
            area[xs, ys] .+= 1
        else # diagonal line
            xs = range(minmax(x1, x2)...)
            ys = range(minmax(y1, y2)...)

            x1 > x2 && (xs = reverse(xs))
            y1 > y2 && (ys = reverse(ys))

            xy = CartesianIndex.([xy for xy in zip(xs,ys)])
            area[xy] .+= 1
        end
    end
    @show p2 = sum(area .> 1)
end
