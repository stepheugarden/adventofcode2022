lines = readlines("06/input.txt")

function solve_first(lines, offset)
    letters = lines[1]
    for iter in offset:length(letters)
        if length(unique(letters[(iter-offset+1):iter])) == offset
            return iter
        end
    end
end

println("First solution :$(solve_first(lines, 4))")
println("Second solution :$(solve_first(lines, 14))")