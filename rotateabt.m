function [newshape] = rotateabt(shape,a,p,q) % for rotating anticlockwise about point (p,q) by angle a 
    temp1=translate(shape,-p,-q); % sets the shape up for a rotation about the origin
    temp2=[cos(a) -1*sin(a) ; sin(a) cos(a)] * temp1; % rotates 
    newshape=translate(temp2,p,q); % puts the shape back in the right position
end