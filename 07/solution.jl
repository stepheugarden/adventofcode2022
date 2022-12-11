lines = readlines("07/input.txt")

function is_system_call(line)
    (line[1] == '$') ? true : false
end

function is_ls_call(line)
    line[3:4] == "ls" ? true : false   
end

function is_cd_call(line)
    line[3:4] == "cd" ? true : false   
end

function is_dir_list(line)
    return line[1:3] == "dir"
end

function return_size(line)
    pattern = r"(?<size>\d+) .*"
    return parse(Int64, match(pattern, line)["size"])
end

function return_next_directory(line)
    return string(line[6:end])
end

function manipulate_current_path(directory, path)
    if directory == ".."
        _ = pop!(path)
    else
        push!(path, directory)
    end

    return path
end

function add_child(children, path, child_directory)
    current_directory = string(path[end])
    if haskey(children, current_directory)
        union!(children[current_directory], Set([child_directory]))
    else
        children[current_directory] = Set([child_directory])
    end

    return children
end

function add_file_size(directory_sizes, path, size)
    current_directory = string(path[end])
    if haskey(directory_sizes, current_directory)
        directory_sizes[current_directory] += size
    else
        directory_sizes[current_directory] = size
    end

    return directory_sizes
end

function calculate_total_size(children, directory_sizes)
    total_size = Dict()

    for (directory, size) in directory_sizes
        total_size[directory] = size
        all_children = get_all_children(children, directory)
        for child in all_children
            total_size[directory] += directory_sizes[child]
        end
    end

    return total_size
end


function get_all_children(children, parent, child_collection = [])
    if !haskey(children, parent)
        return child_collection
    else
        append!(child_collection, collect(children[parent]))
        for child in child_collection
            if haskey(children, child)
                append!(child_collection, collect(children[child]))
            end
        end
    end

    return sort(child_collection)
    
end

function solve_first(lines, offset = 100000)
    path = []
    children = Dict()
    directory_sizes = Dict()
    for (n, line) in enumerate(lines) 
        if n == 1
            append!(path, string("/"))
        elseif is_system_call(line)
            if is_cd_call(line)
                directory = return_next_directory(line)
                if directory != ".."
                    children = add_child(children, path, directory)
                end
                path = manipulate_current_path(directory, path)
            end
        elseif !is_dir_list(line) && !is_ls_call(line)
            size = return_size(line)
            directory_sizes = add_file_size(directory_sizes, path, size)
        end
    end

    # remove too large directory_sizes:
    # 1. get all directories larger than offset
    # 2. remove this directory and the parent directory
    too_large = filter(p -> last(p) > offset, directory_sizes)
    for large in too_large
        delete!(children, large)
        # remove parents if large is in the Set of children
        for (parent, kids) in children
            if large in kids
                delete!(children, parent)
            end
        end
    end
    non_empty = Set([k for (k, v) in directory_sizes])
    for (parent, kids) in children
        intersect!(children[parent], non_empty)
    end

    total_size = calculate_total_size(children, directory_sizes)
    smaller_offset = filter(p -> last(p) <= offset, total_size)
    x = 10

end

println("first solution $(solve_first(lines))")

children = Dict("/" => Set(["a", "b", "c"]), "a" => Set(["d", "e"]), "f" => Set(["k"]))
directory_sizes = Dict("/" => 10, "a" => 11, "b" => 1, "c" => 2, "d" => 4, "e" => 3, "f" => 3, "k" => 1)
    
get_all_children(children, "/")
