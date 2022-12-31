using Test

include("solution.jl")

@testset "test check_elements" begin
    
    left = [[1],1,2,1,1]
    right = [1,1,5,1,1]
    @test check_elements(left, right) == 1

    left = [[1],[2,3,4]]
    right = [[1],4]
    @test check_elements(left, right) == 1

    left = [9]
    right= [[8,7,6]]
    @test check_elements(left, right) == 0

    left = [[4,4],4,4]
    right = [[4,4],4,4,4]
    @test check_elements(left, right) == 1

    left = [7,7,7,7]
    right = [7,7,7]
    @test check_elements(left, right) == 0

    left = []
    right = [3]
    @test check_elements(left, right) == 1

    left = [[[]]]
    right = [[]]
    @test check_elements(left, right) == 0

    left = [1,[2,[3,[4,[5,6,7]]]],8,9]
    right = [1,[2,[3,[4,[5,6,0]]]],8,9]
    @test check_elements(left, right) == 0

end