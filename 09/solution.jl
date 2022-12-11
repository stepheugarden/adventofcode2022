using Chain

lines = readlines("09/input.txt")

function make_one_head_step(head, direction)
    x,y = head

    if direction == 'U'
        return (x, y+1)
    elseif direction == 'D'
        return (x, y-1)
    elseif  direction == 'L'
        return (x-1, y)
    else
        return (x+1, y)
    end
end

function is_adjacent(tail, head)
    tail_x,tail_y = tail
    head_x,head_y = head

    dist_x = abs(tail_x - head_x)
    dist_y = abs(tail_y - head_y)

    if max(dist_x, dist_y) <= 1
        return true
    else
        return false
    end
end

function get_direction(tail, head)
    # where to move tail
    # right is +1, left is -1, neutral is 0
    tail_x,tail_y = tail
    head_x,head_y = head

    x_move_tail = sign(head_x - tail_x)
    y_move_tail = sign(head_y - tail_y)
    
    return (x_move_tail, y_move_tail)
end

function make_one_tail_step(tail, head)
    tail_x,tail_y = tail

    if !is_adjacent(tail, head)
        x_move_tail, y_move_tail= get_direction(tail, head)
        return (tail_x + x_move_tail, tail_y + y_move_tail)
    end

    return tail
end

function solve_first(lines)
    head, tail = (1,1), (1,1)
    collect_tail_coord = [tail]

    for line in lines
        direction = line[1]
        steps = parse(Int8, line[3:end])

        for step in 1:steps
            head = make_one_head_step(head, direction)
            tail = make_one_tail_step(tail, head)
            push!(collect_tail_coord, tail)
        end
    end

    return length(Set(collect_tail_coord))

end

println("First solution: $(solve_first(lines))")


function solve_second(lines)
    start = (1,1)
    rope_positions = repeat([start], outer = 10)
    collect_tail_coord = [start]

    for line in lines
        direction = line[1]
        steps = parse(Int8, line[3:end])

        for step in 1:steps
            rope_positions[1] = make_one_head_step(rope_positions[1], direction)

            for i in 2:length(rope_positions)
                head = rope_positions[i-1]
                tail = rope_positions[i]

                tail = make_one_tail_step(tail, head)
                rope_positions[i] = tail
                
                if i == 10
                    push!(collect_tail_coord, tail)
                end
            end
        end
    end

    return length(Set(collect_tail_coord))

end

println("Solve second: $(solve_second(lines))")