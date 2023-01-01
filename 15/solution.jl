using Chain

struct Sensor
    xs::Int64
    ys::Int64
    xb::Int64
    yb::Int64
    dist::Float64
end

function manhatten_distance(x1, y1, x2, y2)
    return abs(x1-x2) + abs(y1-y2)
end

function parse_input(lines)
    pattern = r"Sensor at x=(?<x_sensor>-?\d+), y=(?<y_sensor>-?\d+): closest beacon is at x=(?<x_beacon>-?\d+), y=(?<y_beacon>-?\d+)"
    arr = []
    for line in lines
        matched = match(pattern, line)
        xs = parse(Int64, matched["x_sensor"])
        ys = parse(Int64, matched["y_sensor"])
        xb = parse(Int64, matched["x_beacon"])
        yb = parse(Int64, matched["y_beacon"])
        dist = manhatten_distance(xs, ys, xb, yb)
        push!(arr, Sensor(xs, ys, xb, yb, dist))
    end

    return arr
    
end

function reaches_row(sensor::Sensor, row)
    (min_y, max_y) = extrema([sensor.ys - sensor.dist, sensor.ys + sensor.dist])
    return min_y <= row <= max_y
end

function solve_first(lines, row)
    arr = parse_input(lines)
    
    clsr(row) = line -> reaches_row(line, row)
    f_row = clsr(row)
    arr_filtered = filter(x -> f_row(x), arr)
   
    # initalize resulting array. We need do shift the coordinates using x_offset
    (lower, upper) = extrema([x.xs for x in arr_filtered])
    maximum_dist = maximum([x.dist for x in arr_filtered]) # buffer
    x_offset = lower + maximum_dist+1
    res = Vector{Char}(undef, Int64(upper - lower + 1 + 2*maximum_dist))
    res .= '.' # default

    # set sensors and beacons
    for indx in 1:length(res)
        coord = (indx-x_offset, row)
        
        for sensor in arr_filtered
            if (sensor.xs, sensor.ys) == coord
                res[indx] = 'S'
            elseif (sensor.xb, sensor.yb) == coord
                res[indx] = 'B'
            elseif manhatten_distance(sensor.xs, sensor.ys, coord...) <= sensor.dist
                res[indx] = '#'
            end
        end
    end

    @chain res begin
        filter(x -> x == '#', _)
        length
    end

    
end

lines = readlines("15/test_input.txt")
println("first solution to test_input.txt: $(solve_first(lines, 10))")

lines = readlines("15/input.txt")
println("first solution to input.txt: $(solve_first(lines, 2000000))")
