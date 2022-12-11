struct monkey
    worry_level::Vector{UInt128}
    operation
    div::UInt128
    div_true::Int64
    div_false::Int64
    pops::Vector{Int64}

end

monkey0 = monkey(
    [71, 56, 50, 73],
    x -> x * 11,
    13,
    1,
    7,
    []
)

monkey1 = monkey(
    [70, 89, 82],
    x -> x + 1,
    7,
    3,
    6,
    []
)

monkey2 = monkey(
    [52, 95],
    x -> x^2 ,
    3,
    5,
    4,
    []
)

monkey3 = monkey(
    [94, 64, 69, 87, 70],
    x -> x + 2,
    19,
    2,
    6,
    []
)

monkey4 = monkey(
    [98, 72, 98, 53, 97, 51],
    x -> x + 6,
    5,
    0,
    5,
    []
)

monkey5 = monkey(
    [79],
    x -> x + 7,
    2,
    7,
    0,
    []
)

monkey6 = monkey(
    [77, 55, 63, 93, 66, 90, 88, 71],
    x -> x * 7,
    11,
    2,
    4,
    []
)

monkey7 = monkey(
    [54, 97, 87, 70, 59, 82, 59],
    x -> x + 8,
    17,
    1,
    3,
    []
)