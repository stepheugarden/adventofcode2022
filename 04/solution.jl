lines = readlines("04/input.txt")

function return_numbers(line, pattern = r"(?<x1>\d+)-(?<x2>\d+),(?<y1>\d+)-(?<y2>\d+)")
    return map(x -> parse(Int64, x), match(pattern, line))
end

function solve_first(lines)
    contained = 0

    for line in lines
        x1, x2, y1, y2 = return_numbers(line)
        if (x1 <= y1 && y2 <= x2) || (y1 <= x1 && x2 <= y2)
            contained += 1
        end
    end
    
    return contained

end

println("First solution: $(solve_first(lines))")

function solve_second(lines)
    overlap = 0

    for line in lines
        x1, x2, y1, y2 = return_numbers(line)
        if (y1 <= x2 && x1 <= y1) || (x1 <= y2 && y1 <= x1)
            overlap += 1
        end    
    end

    return overlap

end

println("Second solution: $(solve_second(lines))")