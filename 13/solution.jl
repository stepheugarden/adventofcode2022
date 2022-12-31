function parse_input(lines)
    arr = []
    temp = []
    for line in lines
        if line == ""
            push!(arr, temp)
            temp = []
            continue
        end
        push!(temp, eval(Meta.parse(line)))
    end
    push!(arr, temp)
    arr
end

function check_elements(left, right)

    try 
        if isinteger(left) && isinteger(right)
            if left < right
                return 1 # true
            elseif left == right
                return -1 # continue
            else
                return 0 # false
            end
        end
    catch
        try
            if isinteger(left)
                return check_elements([left], right)
            end
        catch
            try 
                if isinteger(right)
                    return check_elements(left, [right])
                end
            catch
                iter = 1
                while iter <= length(left) && iter <= length(right)
                    compare = check_elements(left[iter], right[iter])
                    if compare == -1
                        # continue when not violated
                        iter += 1
                        continue
                    else
                        # return 1 (true) or 0 (false)
                        return compare
                    end

                end
                    
                if length(left) < iter && length(right) >= iter
                    return 1
                elseif length(left) == length(right)
                    return -1
                else
                    return 0
                end
            end 
        end
    end
end

function solve_first(lines)
    total = 0
    arr = parse_input(lines)
    for (indx, (left, right)) in enumerate(arr)
        is_sorted = check_elements(left, right)
        if is_sorted == 1
            total += indx
        end
    end

    return total
end

function solve_second(lines)
   arr = parse_input(lines) 
   flat_arr = []
   for elem in arr
        push!(flat_arr, elem[1])
        push!(flat_arr, elem[2])
   end
   
   push!(flat_arr, [[2]])
   push!(flat_arr, [[6]])

   arr_sorted = sort(flat_arr, lt=(x,y)-> check_elements(x, y) == 1)
   
   divider_key = 1
   for (indx, elem) in enumerate(arr_sorted)
        if in(elem, [[[2]], [[6]]])
            divider_key *= indx
        end
   end

   divider_key
end