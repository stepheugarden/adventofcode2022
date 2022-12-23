function regex_resolved(line)
    pattern = r"^(?<name>[a-z]+): (?<number>\d+)$"
    matched = match(pattern, line)

    if isnothing(matched)
        return nothing
    end
    return matched["name"], parse(Float64, matched["number"])
end

function regex_unresolved(line)
    pattern = r"^(?<name>[a-z]+): (?<operand1>[a-z]+) (?<operation>[+*-/]{1}) (?<operand2>[a-z]+)$"
    matched = match(pattern, line)

    if isnothing(matched)
        return nothing
    end
    return matched["name"], matched["operand1"], matched["operation"], matched["operand2"]
end

function parse_input(lines)

    valves = Dict()
    for line in lines
        matched = regex_resolved(line)
        if !isnothing(matched)
            name, number = first(matched), last(matched)
            valves[name] = [number]
        else
            (name, op1, op, op2) = regex_unresolved(line)
            valves[name] = [op1, op, op2]
        end
    end

    return valves
end


function resolve_1(valves, name)

    this_valve = valves[name]

    if length(this_valve) == 1
        # we have the value
        return first(this_valve)
    end

    op1 = resolve_1(valves, this_valve[1])
    operation = this_valve[2]
    op2 = resolve_1(valves,this_valve[3])

    mapping = Dict("+" => +, "*" => *, "-" => -, "/" => /)
    value = reduce(mapping[operation], [op1, op2])
    valves[name] = value

    return value
end

function solve_first(lines, key_name)
    valves = parse_input(lines)

    return resolve_1(valves, key_name)
end


function resolve_2(valves, name, humn_value)

    if name == "humn"
        return humn_value
    end

    this_valve = valves[name]

    if length(this_valve) == 1
        # we have the value
        return first(this_valve)
    end

    op1 = resolve_2(valves, this_valve[1], humn_value)
    operation = this_valve[2]
    op2 = resolve_2(valves, this_valve[3], humn_value)

    mapping = Dict("+" => +, "*" => *, "-" => -, "/" => /)
    value = reduce(mapping[operation], [op1, op2])
    valves[name] = value

    return value
end

function solve_second(lines)
    valves = parse_input(lines)
    
    root_op1 = first(valves["root"])
    root_op2 = last(valves["root"])

    # one of the two is independent of humn
    if resolve_2(deepcopy(valves), root_op1, 10) == resolve_2(deepcopy(valves), root_op1, 100)
        independent = root_op1
        dependent = root_op2
    elseif resolve_2(deepcopy(valves), root_op2, 10) == resolve_2(deepcopy(valves), root_op2, 100)
        independent = root_op2
        dependent = root_op1 
    else
        error("both $(root_op1) and $(root_op2) depend on root")
    end

    # binary search 
    match_value = resolve_1(deepcopy(valves), independent) # we must match this value
    left, right = 0, 100000000000000 # resolve_2(.., left) > resolve_2(..., right)

    while left < right
        mid = floor((right + left) / 2)
        val_mid = resolve_2(deepcopy(valves), dependent, mid)

        diff = match_value - val_mid

        if diff < 0
            left = mid
        elseif diff == 0
            return mid
        else
            right = mid
        end         

    end






    return


end
