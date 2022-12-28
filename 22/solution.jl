using Chain

struct State 
    row::Int64
    col::Int64
    orientation::String
end

function parse_input(lines)
    lines = map(x -> split(x, ""), lines)

    rows = length(lines) - 2
    cols = @chain lines begin
        _[1:end-2]
        map(x -> length(x), _)
        maximum
    end

    commands = pop!(lines)
    _ = pop!(lines)

    instructions = []
    collect_numbers = ""
    for c in commands
        if c == "L" || c == "R"
            if collect_numbers != ""
                push!(instructions, parse(Int64, collect_numbers))
                collect_numbers = ""
            end
            push!(instructions, c)
        else
            collect_numbers *= c
        end
    end

    if collect_numbers != ""
        push!(instructions, parse(Int64, collect_numbers))
        collect_numbers = ""
    end

    field = Matrix{String}(undef, rows, cols)
    field .= " "
    for (row_nb, line) in enumerate(lines)
        field[row_nb, 1:length(line)] .= line
    end

    return instructions, field    
end

function slice_array(state, fields)
    if in(state.orientation, ["<", ">"])
        arr = fields[state.row, :]
        start = state.col
    elseif in(state.orientation, ["v", "^"])
        arr = fields[:, state.col]
        start = state.row
    else
        error("wrong orientation in current state. $(state.orientation) not allowed")
    end

    return arr, start
end

function iterate_move(state, steps, start, arr)
    steps_to_do = steps
    next = start
    last_next = start
    iter_direction = ifelse(in(state.orientation, ["^", "<"]), -1, 1)

    while steps_to_do > 0
        last_next = @chain arr[next] begin
            in(_, ["."])
            ifelse(_, next, last_next)
        end

        next = next + iter_direction
        if next > length(arr)
            # forward direction too large
            next = 1
        end

        if next <= 0 
            # backward direction too small
            next = length(arr)
        end

        if arr[next] == "#"
            next = last_next
            break
        elseif arr[next] == " "
            continue
        else
            steps_to_do -= 1
        end
    end


    if in(state.orientation, ["<", ">"])
        return State(state.row, next, state.orientation)
    else
        return State(next, state.col, state.orientation)
    end
end

function return_new_state(state, fields, steps)

    arr, start = slice_array(state, fields)
    return iterate_move(state, steps, start, arr)

end

function make_turn(state, inst)

    orientation = state.orientation

    if orientation == ">"
        if inst == "R"
            new_orientation = "v"
        else
            new_orientation = "^"
        end
    elseif orientation == "v"
        if inst == "R"
            new_orientation = "<"
        else
            new_orientation = ">"
        end
    elseif orientation == "<"
        if inst == "R"
            new_orientation = "^"
        else
            new_orientation = "v"
        end
    elseif orientation == "^"
        if inst == "R"
            new_orientation = ">"
        else
            new_orientation = "<"
        end
    end

    return State(state.row, state.col, new_orientation)
    
end

function solve_first(lines)
    instructions, fields = parse_input(lines)

    start = findfirst(x -> x == ".", fields[1, :])
    states = [State(1, start, ">")]

    for inst in instructions
        if typeof(inst) == Int64
            push!(states, return_new_state(last(states), fields, inst))
        else
            push!(states, make_turn(last(states), inst))
        end
    end

    final_state = last(states)
    facing_map = Dict(">" => 0, "v" => 1, "<" => 2, "^" => 3)
    return 1000 * final_state.row + 4 * final_state.col + facing_map[final_state.orientation]   
end

lines = readlines("22/test_input.txt")
println("First solution to test_input.txt $(solve_first(lines))")

lines = readlines("22/input.txt")
println("First solution to input.txt $(solve_first(lines))")