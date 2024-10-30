function [] = draw(shape,colour)
    xcoord = shape(1,:);
    ycoord = shape(2,:);
    plot(xcoord,ycoord, colour) %plots x,y in the specified colour
end