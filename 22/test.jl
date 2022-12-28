using Test

include("solution.jl")

@testset "testing slice_array" begin
    fields = reshape(1:6, 2, 3)

    state = State(1,1,">")
    @test ([1,3,5], 1) == slice_array(state, fields)
    
    state = State(1,1,"<")
    @test ([1,3,5], 1) == slice_array(state, fields)
    
    state = State(1,2,">")
    @test ([1,3,5], 2) == slice_array(state, fields)

    state = State(1,3,"<")
    @test ([1,3,5], 3) == slice_array(state, fields)

    state = State(1,3,"v")
    @test ([5,6], 1) == slice_array(state, fields)

    state = State(1,3,"^")
    @test ([5, 6], 1) == slice_array(state, fields)

    state = State(2,3,"^")
    @test ([5, 6], 2) == slice_array(state, fields)
end

@testset "testing iterate_move" begin
    state = State(1,1,">")
    arr = [".", ".", "#"]
    @test iterate_move(state, 1, 1, arr) == State(1,2,">")
    @test iterate_move(state, 2, 1, arr) == State(1,2,">")
    @test iterate_move(state, 2, 1, arr) == State(1,2,">")
    
    state = State(1,1,"<")
    arr = [".", ".", "#"]
    @test iterate_move(state, 2, 1, arr) == State(1,1,"<")
    @test iterate_move(state, 1, 1, arr) == State(1,1,"<")
    @test iterate_move(state, 2, 2, arr) == State(1,1,"<")

    state = State(1,1,"<")
    arr = [".", " ", " ", ".", ".", "#", ".", " "]
    @test iterate_move(state, 1, 4, arr) == State(1,1,"<")
    @test iterate_move(state, 1, 5, arr) == State(1,4,"<")
    @test iterate_move(state, 2, 5, arr) == State(1,1,"<")
    @test iterate_move(state, 3, 5, arr) == State(1,7,"<")
    @test iterate_move(state, 4, 5, arr) == State(1,7,"<")
end