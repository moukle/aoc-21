#!/usr/bin/julia

using DelimitedFiles

input = readdlm("input", ' ', '\n')

# part 1
begin
    x = 0; y = 0
    for (dir, n) ∈ eachrow(input)
        global x, y
        if     dir == "forward" x += n
        elseif dir == "down"    y += n
        elseif dir == "up"      y -= n
        end
    end

    @show x, y, x*y
end

# alternative part 1
begin
    x  = sum(input[input[:,1] .== "forward", 2])
    y  = sum(input[input[:,1] .== "down",    2])
    y -= sum(input[input[:,1] .== "up",      2])

    @show x, y, x*y
end

# part 2
begin
    x = 0; y = 0; a = 0;
    for (dir, n) ∈ eachrow(input)
        global x, y, a
        if     dir == "forward" x += n; y += a * n
        elseif dir == "down"    a += n
        elseif dir == "up"      a -= n
        end
    end

    @show x, y, x*y
end
