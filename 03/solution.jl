using Chain
lines = readlines("03/input.txt")

function return_sum(elements)
    letters = collect('a':'z')
    append!(letters, collect('A':'Z'))
    letter_to_number = Dict()

    for (n, elem) in enumerate(letters)
        letter_to_number[elem] = n
    end

    sum([letter_to_number[only(letter)] for letter in elements])
    
end

function solve_first(lines)
    common = String[]
    
    for line in lines 
        arr = split(line, "")
        midpoint = Int64(length(arr) / 2)
        compartement_1 = Set(arr[1:midpoint])
        compartement_2 = Set(arr[(midpoint+1):end])
    
        push!(common, pop!(intersect(compartement_1, compartement_2)))
    end

    return_sum(common)
end


println("First solution: $(solve_first(lines))") 


function solve_second(lines)
    badges = []

    function set_of_line(line)
        @chain line begin
            split(_, "")
            Set(_)
        end
    end

    for group in 1:3:length(lines)
        set_1 = set_of_line(lines[group])
        set_2 = set_of_line(lines[group+1])
        set_3 = set_of_line(lines[group+2])
        append!(badges, intersect(set_1, set_2, set_3))
    end

    return_sum(badges)
    
end

println("Second solution: $(solve_second(lines))")