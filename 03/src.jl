#!/usr/bin/julia

input = readlines("input")

# parse input
n = input |> length
i = split.(input, "")
i = Iterators.flatten(i) |> collect
i = reshape(i, (:, n))
i = (i .== "1") |> transpose

# convert bit-array to decimal
function bits2dec(a::AbstractArray)
    a = Int.(a)
    parse(Int, string(a...), base=2)
end


# part 1
begin
    p = count.(eachcol(i)) ./ n
    γ = (p .> 0.5) .|> Int |> bits2dec
    ϵ = (p .< 0.5) .|> Int |> bits2dec

    @show p1 = γ * ϵ
end


# part 2
begin
    using StatsBase

    ox = i; co₂ = i
    for c ∈ 1:size(i, 2)
        global ox, co₂
        n₁ = size(ox, 1); n₂ = size(co₂, 1)

        # oxygen
        if n₁ > 1
            # argmax doesnt work, because if counts equal, argmax picks false
            # which is not desired
            cm = countmap(ox[:, c])
            oi = cm[1] >= cm[0]

            ox = ox[ox[:, c] .== oi, :]
        end

        # co₂
        if n₂ > 1
            ci = argmin(countmap(co₂[:, c]))
            co₂ = co₂[co₂[:, c] .== ci, :]
        end

    end
    ox  = ox  |> bits2dec; co₂ = co₂ |> bits2dec
    @show p2 = ox * co₂
end
