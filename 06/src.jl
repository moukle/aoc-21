#!/usr/bin/julia

using DelimitedFiles

file = "test"
file = "input"
input = readdlm(file, ',', '\n') .|> Int

# part 1
begin
    days = 1:80
    population = copy(input)
    for day ∈ days
        global population
        breeders = (population .== 0)

        population[breeders .|> ~] .-= 1  # decrease non-breeders
        population[breeders] .= 6  # reset breeders to 6 days

        babyes = ones(Int, (1, count(breeders))) * 8  # generate offspring (8 days till first breeding)
        population = hcat(population, babyes)  # add offspring

    end
    @show p1 = length(population)
end


# step function
using DataStructures
function step(population)
    new_pop = DefaultDict(0)
    for (k,v) in population
        if k == 0
            new_pop[6] += v  # reset cycle
            new_pop[8] = v   # breeding
        else
            new_pop[(k-1)] += v
        end
    end

    new_pop
end


# part 2
begin
    using StatsBase
    population = countmap(input[:])

    days = 1:256
    for day in days
        global population
        population = step(population)
    end
    @show p2 = sum(values(population))
end
