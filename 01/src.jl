#!/usr/bin/julia

ys = parse.(Int, readlines("input"))

@show sum(ys[2:end] .> ys[1:end-1])
@show sum([sum(ys[i+1:i+3]) > sum(ys[i:i+2]) for i ∈ 1:length(ys)-3])

# using BenchmarkTools
# @show @benchmark sum(ys[2:end] .> ys[1:end-1])
# @show @benchmark sum([sum(ys[i+1:i+3]) > sum(ys[i:i+2]) for i ∈ 1:length(ys)-3])
