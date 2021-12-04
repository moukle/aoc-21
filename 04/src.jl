#!/usr/bin/julia

file = "input"
input = readlines(file)

# parse input
draws = input[1]
draws = split.(draws, ',')
draws = parse.(Int, draws)

boards = input[3:end] .|> split
boards = Iterators.flatten(boards) |> collect
boards = reshape(boards, (5, 5, :))
boards = permutedims(boards, (2, 1, 3))
boards = parse.(Int, boards)


# sum all unmarked numbers and multiply by last draw
function caluclate_score(boards, marked, draw, idx)
    c = marked[:,:,idx] .|> Bool .|> ~
    b = boards[:,:,idx]

    sum(b[c]) * draw
end


# check if either in a row or column 5 numbers are marked
function winner_idx(marked)
    rows = sum(marked, dims=1)
    cols = sum(marked, dims=2)
    cols = permutedims(cols, (2,1,3))

    findall(x -> x == 5, [cols; rows])
end


# mark draw on checkerboard (set to 1/true)
function mark_draw!(marked, draw)
    idx = findall(x -> x == draw, boards)
    marked[idx] .= 1

    return
end


# part 1
begin
    marked = zeros(Int, size(boards))

    for draw ∈ draws
        mark_draw!(marked, draw)
        win_idx = winner_idx(marked)

        if length(win_idx) > 0
            @show caluclate_score(boards, marked, draw, win_idx[1][3])
            break
        end
    end
end


# part 2
begin
    marked = zeros(Int, size(boards))

    for draw ∈ draws
        global boards, marked

        mark_draw!(marked, draw)
        win_idx = winner_idx(marked)

        if length(win_idx) > 0
            players = 1:size(boards, 3)

            if length(players) == 1
                @show caluclate_score(boards, marked, draw, 1)
                break
            end

            # remove winners
            winners = [w[3] for w ∈ win_idx]
            players = setdiff(players, winners)
            boards = boards[:,:,players]
            marked = marked[:,:,players]
        end
    end
end
