#using Printf
lines = readlines("01/input.txt")

function return_sums(lines)
    sums = Int64[]
    running_sum = 0
    for num in lines
        if num == ""
            push!(sums, running_sum)
            running_sum = 0
        else
            running_sum += parse(Int64, num)
        end
    end

    return sums
end

x = return_sums(lines)

first_answer = maximum(x)
println("The first answer: $first_answer")

# Second answer
x_sorted = sort(x, rev = true)
second_answer = sum(x_sorted[1:3])
println("The second_answer: $second_answer")