using Chain

dict_stack = Dict()
dict_stack["stack1"] = ["P", "F", "M", "Q", "W", "G", "R", "T"] 
dict_stack["stack2"] = ["H", "F", "R"]
dict_stack["stack3"] = ["P", "Z", "R", "V", "G", "H", "S", "D"] 
dict_stack["stack4"] = ["Q", "H", "P", "B", "F", "W", "G"]
dict_stack["stack5"] = ["P", "S", "M", "J", "H"]
dict_stack["stack6"] = ["M", "Z", "T", "H", "S", "R", "P", "L"]
dict_stack["stack7"] = ["P", "T", "H", "N", "M", "L"]
dict_stack["stack8"] = ["F", "D", "Q", "R"]
dict_stack["stack9"] = ["D", "S", "C", "N", "L", "P", "H"]

lines = readlines("05/input.txt")

function solve_first(lines)

    re = r"^move (?<nb_elements>\d+) from (?<from>\d{1}) to (?<to>\d{1})"

    for line in lines
        matched = match(re, line)
        for i in 1:parse(Int64, matched["nb_elements"]) 
            push!(dict_stack["stack"*matched["to"]], pop!(dict_stack["stack"*matched["from"]]))    
        end
    end

    reduce(*, [pop!(dict_stack["stack"*string(i)]) for i in 1:length(dict_stack)])
    
end

println("first solution $(solve_first(lines))")


dict_stack = Dict()
dict_stack["stack1"] = ["P", "F", "M", "Q", "W", "G", "R", "T"] 
dict_stack["stack2"] = ["H", "F", "R"]
dict_stack["stack3"] = ["P", "Z", "R", "V", "G", "H", "S", "D"] 
dict_stack["stack4"] = ["Q", "H", "P", "B", "F", "W", "G"]
dict_stack["stack5"] = ["P", "S", "M", "J", "H"]
dict_stack["stack6"] = ["M", "Z", "T", "H", "S", "R", "P", "L"]
dict_stack["stack7"] = ["P", "T", "H", "N", "M", "L"]
dict_stack["stack8"] = ["F", "D", "Q", "R"]
dict_stack["stack9"] = ["D", "S", "C", "N", "L", "P", "H"]

function solve_second(lines)

    re = r"^move (?<nb_elements>\d+) from (?<from>\d{1}) to (?<to>\d{1})"

    for line in lines
        matched = match(re, line)
        nb_elements = parse(Int64, matched["nb_elements"])
        arr = dict_stack["stack"*matched["from"]][end-nb_elements+1:end]
        dict_stack["stack"*matched["from"]] = dict_stack["stack"*matched["from"]][1:end-nb_elements]
        append!(dict_stack["stack"*matched["to"]], arr)

    end

    reduce(*, [pop!(dict_stack["stack"*string(i)]) for i in 1:length(dict_stack)])
    
end

println("second solution $(solve_second(lines))")