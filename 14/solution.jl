using Chain

function parse_input_to_coordinates(lines)
    
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

function create_and_fill_matrix(coordinates_from, coordinates_to)

    x_values = [first(val) for val in coordinates_from]
    append!(x_values, [first(val) for val in coordinates_to])
    x_min, x_max = extrema(x_values)

    y_value = [last(val) for val in coordinates_from]
    append!(y_value, [last(val) for val in coordinates_to])
    y_min, y_max = extrema(y_value)

    mat = Matrix{Char}(y_max+1, x_max-x_min+1)
    mat .= '.'



    
end

parse_input_to_matrx(readlines("14/test_input.txt"))