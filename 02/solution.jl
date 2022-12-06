using Match
lines = readlines("02/input.txt")

function apply_strategy_part1(lines)
    score = 0

    # A,B,C (or X,Y,Z) for Rock, Paper, Scissors for "you" (or "me")
    # scores 1 for Rock, 2 for Paper, and 3 for Scissors)
    # 0 for a loss, 3 for draw, 6 for win
    for line in lines
        play = split(line)
        you, me = play[1], play[2]

        you = @match play[1] begin
            "A" => "Rock"
            "B" => "Paper"
            "C" => "Scissors"
        end

        me = @match play[2] begin
            "X" => "Rock"
            "Y" => "Paper"
            "Z" => "Scissors"
        end

        if me == "Rock"
            score += 1
        elseif me == "Paper"
            score += 2
        else
            score += 3
        end
        
        if (you == "Rock" && me == "Paper") || (you == "Paper" && me == "Scissors")|| (you == "Scissors" && me == "Rock")
            # I win
            score += 6
        elseif you == me
            # draw
            score += 3
        end

    end
    return score
end


println(apply_strategy_part1(lines))



function apply_strategy_part2(lines)
    score = 0

    # A,B,C (or X,Y,Z) for Rock, Paper, Scissors for "you" (or "me")
    # scores 1 for Rock, 2 for Paper, and 3 for Scissors)
    # 0 for a loss, 3 for draw, 6 for win
    for line in lines
        play = split(line)
        you, me = play[1], play[2]

        you = @match play[1] begin
            "A" => "Rock"
            "B" => "Paper"
            "C" => "Scissors"
        end

        my_goal = @match play[2] begin
            "X" => "lose"
            "Y" => "draw"
            "Z" => "win"
        end

        me = @match (you, my_goal) begin
            ("Rock", "lose")     => "Scissors"
            ("Rock", "win")      => "Paper"
            ("Rock", "draw")     => "Rock"
            ("Paper", "lose")    => "Rock"
            ("Paper", "win")     => "Scissors"
            ("Paper", "draw")    => "Paper"
            ("Scissors", "lose") => "Paper"
            ("Scissors", "win")  => "Rock"
            ("Scissors", "draw") => "Scissors"
        end

        if me == "Rock"
            score += 1
        elseif me == "Paper"
            score += 2
        else
            score += 3
        end
        
        if (you == "Rock" && me == "Paper") || (you == "Paper" && me == "Scissors")|| (you == "Scissors" && me == "Rock")
            # I win
            score += 6
        elseif you == me
            # draw
            score += 3
        end

    end
    return score
end


println(apply_strategy_part2(lines))