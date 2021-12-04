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
function caluclate_score(boards, checked, draw, idx)
    c = checked[:,:,idx] .|> Bool .|> ~
    b = boards[:,:,idx]

    sum(b[c]) * draw
end


# check if either in a row or column 5 numbers are marked
function winner_idx(checked)
    rows = sum(checked, dims=1)
    cols = sum(checked, dims=2)
    cols = permutedims(cols, (2,1,3))
    findall(x -> x == 5, [cols; rows])
end


# part 1
begin
    checked = zeros(Int, size(boards))

    for draw ∈ draws
        # mark draw
        idx = findall(x -> x == draw, boards)
        checked[idx] .= 1

        # check for completed rows/cols
        win_idx = winner_idx(checked)

        # someone won!
        if length(win_idx) > 0
            @show caluclate_score(boards, checked, draw, win_idx[1][3])
            break
        end
    end
end


# part 2
begin
    checked = zeros(Int, size(boards))

    for draw ∈ draws
        global boards, checked

        # mark draw
        idx = findall(x -> x == draw, boards)
        checked[idx] .= 1

        # check for completed rows/cols
        win_idx = winner_idx(checked)

        # remove completed players / winners
        if length(win_idx) > 0
            players = 1:size(boards, 3)

            # last winning player standing wins
            if length(players) == 1
                @show caluclate_score(boards, checked, draw, 1)
                break
            end

            # remove winners
            winners = [w[3] for w ∈ win_idx]
            players = setdiff(players, winners)
            boards = boards[:,:,players]
            checked = checked[:,:,players]
        end
    end
end
