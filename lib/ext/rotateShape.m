function newshape = rotateShape(shape, angle)
% rotateShape
% Rotates a shape in the form of a 2xn matrix consisting of n points
% by the provided angle (in radians) in the anticlockwise direction

rotationMatrix2D = [cos(angle), -sin(angle); sin(angle), cos(angle)];
newshape = rotationMatrix2D * shape;
end