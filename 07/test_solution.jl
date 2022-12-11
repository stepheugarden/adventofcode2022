using Test

include("solution.jl")

@testset "test is_system_call function" begin
    @test is_system_call("\$ blabla")
    @test is_system_call("blabla") == false
end

@testset "test is_ls_call function" begin
    @test is_ls_call("\$ ls dir")
    @test is_ls_call("\$ cd") == false
end

@testset "test is_cd_call function" begin
    @test is_cd_call("\$ cd dir")
    @test is_cd_call("\$ ls") == false
end

@testset "test return_size function" begin
    @test return_size("123 blabla") == 123
end

@testset "test return_next_directory" begin
    @test return_next_directory("\$ cd blabla") == "blabla"
    @test return_next_directory("\$ cd \\") == "\\"
end

@testset "test manipulate_current_path" begin
    @test manipulate_current_path("d", ["a", "b", "c"]) == ["a", "b", "c", "d"]
    @test manipulate_current_path("..", ["a", "b", "c"]) == ["a", "b"]
end

@testset "test add_child function" begin
    @test add_child(Dict("/" => Set(["a", "b"])), ["/"], "a") == Dict("/" => Set(["a", "b"]))
    @test add_child(Dict("/" => Set(["a", "b"])), ["/"], "c") == Dict("/" => Set(["a", "b", "c"]))
    @test add_child(Dict("/" => Set(["a", "b"])), ["b"], "c") == Dict("/" => Set(["a", "b"]), "b" => Set(["c"]))
end

@testset "test add_file_size function" begin
    directory_sizes = Dict("a" => 100)
    @test add_file_size(directory_sizes, "/b/a", 200) == Dict("a" => 300)
    directory_sizes = Dict("a" => 100)
    @test add_file_size(directory_sizes, "/b/c", 200) == Dict("a" => 100, "c" => 200)
end

@testset "test get_all_children" begin
    children = Dict("/" => Set(["a", "b", "c"]), "a" => Set(["d", "e"]), "f" => Set(["k"]))
    @test get_all_children(children, "/") == ["a", "b", "c", "d", "e"]
    @test get_all_children(children, "a") == ["d", "e"]
    @test get_all_children(children, "e") == []
end

@testset "test calculate_total_size" begin
    children = Dict("/" => Set(["a", "b", "c"]), "a" => Set(["d", "e"]), "f" => Set(["k"]))
    directory_sizes = Dict("/" => 10, "a" => 11, "b" => 1, "c" => 2, "d" => 4, "e" => 3, "f" => 3, "k" => 1)
    result = Dict(
        "/" => 10+11+1+2+4+3,
        "a" => 11+4+3,
        "b" => 1,
        "c" => 2,
        "d" => 4,
        "e" => 3,
        "f" => 4,
        "k" => 1
        )
    @test calculate_total_size(children, directory_sizes) == result
end