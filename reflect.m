function [newshape] = reflect(shape,character)
    if character == 'x'
        newshape = [1 0 ; 0 -1]*shape; %reflects in x 
    elseif character == 'y'
        newshape = [-1 0 ; 0 1]*shape; %reflects in y
    else
        disp("please choose whether to reflect in x or y")
    end
end