using Test

include("solution.jl")

@testset "test parse_commands" begin
    @test parse_commands("noop") === nothing
    @test parse_commands("addx 12") == 12
    @test parse_commands("addx -112") == -112
end

if !isempty(command_queue)
    next_command = first(command_queue)
    if next_command.execution_step == cycle
        execute_cmd = dequeue!(command_queue)
        val += execute_cmd.val
    end
end

if (cycle-20)%40 == 0
    signal_strength += cycle * val
end