using DataStructures
using Chain

include("input.jl")

all_monkeys = [monkey0, monkey1, monkey2, monkey3, monkey4, monkey5, monkey6, monkey7]

function play_round(monkeys, scale_down)
    for m in monkeys
        push!(m.pops, length(m.worry_level))
        while !isempty(m.worry_level)
            worry_level = popfirst!(m.worry_level)
            new_worry_level = floor(UInt128, m.operation(worry_level) / scale_down)

            # julia arrays are indexed starting at 1 (i.e. add +1)
            if new_worry_level % m.div == 0
                push!(monkeys[m.div_true+1].worry_level, new_worry_level)
            else
                push!(monkeys[m.div_false+1].worry_level, new_worry_level)
            end
        end
    end
end

function solve_first(monkeys, rounds, scale_down)

    monkeys = deepcopy(monkeys)

    for _ in 1:rounds
        play_round(monkeys, scale_down)
    end

    return @chain monkeys begin
        [sum(m.pops) for m in _]
        sort(_, rev=true)
        _[1:2]
        prod(_)
    end
    
end

println("first solution: $(solve_first(all_monkeys, 20, 3))")

