using Chain
using DataStructures

function parse_commands(line)
    if line == "noop"
        return nothing
    else
        return parse(Int64, line[6:end])
    end
end

struct command_cycle
    command::Int64
    cycle::Int64
end

function calculate_values(lines)
    cycle_start = 1
    commands = []
    for command in lines
        todo = parse_commands(command)
        if isnothing(todo)
            cycle_start += 1
        else
            cycle_start += 2
            push!(commands, command_cycle(todo, cycle_start))
        end
    end
    
    val = zeros(commands[end].cycle)
    val[1] = 1

    for command in commands
        val[command.cycle] += command.command
    end

    return cumsum(val)
end

function calculat_signal_strength(val)
    signal_strength = 0
    for (iter, iter_val) in enumerate(val)
        if (iter - 20)  % 40 == 0
            signal_strength += iter * iter_val
        end
    end
    
    return signal_strength
end


function solve_first(lines)

    val = calculate_values(lines)

    return calculat_signal_strength(val)
end


lines = readlines("10/test_input.txt")
println("solution to test case: $(solve_first(lines))")

lines = readlines("10/input.txt")
println("first solution: $(solve_first(lines))")