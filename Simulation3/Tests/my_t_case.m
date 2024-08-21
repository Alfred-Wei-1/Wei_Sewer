%%% Suppose input = [0,1,3,5] and t = 4, then this function returns 3,
%%% i.e., t is in between the 3rd and 4th element, that is in the 3rd
%%% interval introduced by the array.

%%% Note input must be an ordered array.

function output = my_t_case(input,t)
    if t < min(input)
        error('t is smaller than the minimum of input.');
    end
    if t > max(input)
        output = length(input);
        return;
    end
    for i = 1:1:length(input)
        if t > input(i) && t <= input(i+1)
            output = i;
            break;
        else
            continue;
        end
    end
end