#!/usr/bin/julia

using DelimitedFiles

file = "test"
# file = "input"
input = readdlm(file, ',', '\n') .|> Int

# preprocess
using StatsBase, DataStructures
population = DefaultDict(0, countmap(input[:])...)


# step function
function breed(pop::DefaultDict)
    new_pop = DefaultDict(0)
    for (k,v) in pop
        if k == 0            # breeding
            new_pop[6] += v  # reset cycle
            new_pop[8] = v   # offspring
        else
            new_pop[(k-1)] += v
        end
    end

    new_pop
end


# part 1
begin
    days = 1:18
    p1 = copy(population)
    for day ∈ days
        global p1
        p1 = breed(p1)
    end
    @show p1 = sum(values(p1))


    # alternative using long arrays
    p1b = copy(input)
    for day ∈ days
        global p1b
        breeders = (p1b .== 0)

        p1b[breeders .|> ~] .-= 1  # decrease non-breeders
        p1b[breeders] .= 6  # reset breeders to 6 days

        babyes = ones(Int, (1, count(breeders))) * 8  # generate offspring (8 days till first breeding)
        p1b = hcat(p1b, babyes)  # add offspring

    end
    @show p1 = length(p1b)
end


# part 2
begin
    days = 1:256
    p2 = copy(population)
    for day in days
        global p2
        p2 = breed(p2)
    end
    @show p2 = sum(values(p2))
end
