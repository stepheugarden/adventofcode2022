include("solution.jl")

lines = readlines("13/test_input.txt")
println("first solution to test_input.txt $(solve_first(lines))")
println("second solution to test_input.txt $(solve_second(lines))")


lines = readlines("13/input.txt")
println("first solution to input.txt $(solve_first(lines))")
println("second solution to input.txt $(solve_second(lines))")
