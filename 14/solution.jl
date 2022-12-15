using Chain


function parse_input_to_coord(lines)
    
    coordinates_from, coordinates_to = [], []

    for line in lines
        elements = @chain line begin
            split(_, " -> ")
            map(x -> parse.(Int64, split(x, ",")), _)
        end

        zipped = zip(elements[1:end-1], elements[2:end])
        for (from, to) in zipped
            delta = to - from
            
            if first(delta) == 0 
                # vertical, i.e. constant x
                x = first(from)
                y_from, y_to = extrema([last(from), last(to)])
                push!(coordinates_from, [x, y_from])
                push!(coordinates_to, [x, y_to])
            elseif last(delta) == 0
                # horizontal, i.e. constant y
                y = last(to)
                x_from, x_to = extrema([first(from), first(to)])
                push!(coordinates_from, [x_from, y])
                push!(coordinates_to, [x_to, y])
            else
                print("error parsing")
            end
        end
    end
    
    return coordinates_from, coordinates_to
end

function fill_and_shift(coordinates_from, coordinates_to, source=500)

    x_values = [first(val) for val in coordinates_from]
    append!(x_values, [first(val) for val in coordinates_to])
    x_min, x_max = extrema(x_values)
    source = source - x_min + 1

    y_value = [last(val) for val in coordinates_from]
    append!(y_value, [last(val) for val in coordinates_to])
    y_max = maximum(y_value)

    mat = Matrix{Char}(undef, y_max+1, x_max-x_min+1)
    mat .= '.'

    @assert length(coordinates_from) == length(coordinates_to) "coordinate vectors not the same length"
    for i in eachindex(coordinates_from)
        from, to = coordinates_from[i], coordinates_to[i]
        from = from + [-x_min + 1, 0]
        to = to + [-x_min + 1, 0]

        for x_draw in first(from):first(to)
            for y_draw in last(from):last(to)
                mat[y_draw, x_draw] = '#'
            end
        end
    end

    return mat, source
end

function print_matrix(mat, source)
    source_row = Matrix{String}(undef, 1, size(mat, 2))
    source_row .= " "
    source_row[source] = "+"
    println(reduce(*, source_row))

    for row in eachrow(mat)
        println(reduce(*, row))
    end
end

function check_if_coord_is_inside(x,y,mat)
    (1 <= x <= size(mat,2)) && (1 <= y <= size(mat,1))    
end

function check_if_coord_is_free(x,y, mat)
    mat[y,x] == '.'
end


function get_next_coord_state(x,y,mat)

    down = [x,y+1]
    if check_if_coord_is_inside(down..., mat)
        if check_if_coord_is_free(down..., mat)
            return "down", down
        end
    else
        return "outside", down
    end

    left = [x-1,y+1]
    if check_if_coord_is_inside(left..., mat)
        if check_if_coord_is_free(left..., mat)
            return "left", left
        end
    else
        return "outside", left
    end

    right = [x+1,y+1]
    if check_if_coord_is_inside(right..., mat)
        if check_if_coord_is_free(right..., mat)
            return "right", right
        end
    else
        return "outside", right
    end

    return "final", [x,y]
end

function solve_first(lines, plot_matrix = false)
    coord_x, coord_y = parse_input_to_coord(lines)
    mat, source = fill_and_shift(coord_x, coord_y)
    print_matrix(mat, source)

    cnt = 0
    all_inside = true

    while all_inside
        iter_active = true
        x, y = source, 1
        while iter_active
            state, (x,y) = get_next_coord_state(x,y,mat)

            if state == "final"
                mat[y,x] = 'o'
                iter_active = false
                cnt +=1
                if plot_matrix
                    print_matrix(mat, source)
                end
            elseif state == "outside"
                iter_active = false
                all_inside = false
            end
        end
    end

    return cnt

end

lines = readlines("14/test_input.txt")
println("first solution: $(solve_first(lines))")

lines = readlines("14/input.txt")
println("first solution: $(solve_first(lines))")


function enlarge_matrix(mat, source, cols_to_add)

    nrow, ncol = size(mat)

    new_mat = Matrix{Char}(undef, nrow+2, ncol+2*cols_to_add)
    new_mat .= '.'
    new_mat[end, :] .= '#'
    new_mat[2:size(mat,1)+1, cols_to_add+1:cols_to_add+size(mat, 2)] = mat
    new_mat[1, source + cols_to_add] = '+'

    return new_mat
end

function solve_second(lines, cols_to_add, plot_matrix=false)
    coord_x, coord_y = parse_input_to_coord(lines)
    mat, source = fill_and_shift(coord_x, coord_y)

    mat = enlarge_matrix(mat, source, cols_to_add)
    source = source + cols_to_add

    cnt = 0
    all_inside = true

    while all_inside
        iter_active = true
        x, y = source, 1
        while iter_active
            state, (x,y) = get_next_coord_state(x,y,mat)

            if state == "final"
                mat[y,x] = 'o'
                iter_active = false
                cnt +=1
                if plot_matrix
                    print_matrix(mat, source)
                end
                if x == source && y == 1
                    iter_active = false
                    all_inside = false
                end
            elseif state == "outside"
                println("outside")
                iter_active = false
                all_inside = false
            end
        end
    end

    return cnt


end

lines = readlines("14/test_input.txt")
println("second solution: $(solve_second(lines, 10))")

lines = readlines("14/input.txt")
println("second solution: $(solve_second(lines, 1000))")