using Test

include("solution.jl")

@testset "test is_adjacent" begin
    @test is_adjacent((1,1), (1,1))
    @test is_adjacent((1,1), (2,2))
    @test is_adjacent((1,1), (1,2))
    @test is_adjacent((4,1), (5,2))
    @test is_adjacent((1,1), (2,3)) == false
    @test is_adjacent((1,1), (3,3)) == false
end

@testset "test get_direction" begin
    @test get_direction((1,1), (1,1)) == (0,0)
    @test get_direction((0,0), (1,1)) == (1,1)
    @test get_direction((0,0), (-1,-1)) == (-1,-1)
    @test get_direction((0,0), (3,-2)) == (1,-1)
end

@testset "test make_one_head" begin
    @test make_one_head_step((1,1), "U") == ((1,2))
    @test make_one_head_step((1,1), "D") == ((1,0))
    @test make_one_head_step((1,1), "L") == ((0,1))
    @test make_one_head_step((1,1), "R") == ((2,1))
end

@testset "test make_one_tail_step" begin
    @test make_one_tail_step((1,1), (1,1)) == (1,1)
    @test make_one_tail_step((1,1), (2,1)) == (1,1)
    @test make_one_tail_step((1,1), (2,2)) == (1,1)
    @test make_one_tail_step((1,1), (1,3)) == (1,2)
    @test make_one_tail_step((0,0), (-3,-3)) == (-1,-1)
end

@testset "test solve_first" begin
    lines = readlines("test_input.txt")
    @test solve_first(lines) == 13
end