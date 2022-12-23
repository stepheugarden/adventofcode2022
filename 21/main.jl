include("solution.jl")


lines = readlines("21/test_input.txt")
println("first solution for test_input.txt: $(solve_first(lines, "root"))")

lines = readlines("21/input.txt")
println("first solution for input.txt: $(solve_first(lines, "root"))")

println("second solution for input.txt $(solve_second(lines))")
