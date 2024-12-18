function [matrix] = translateShape(shape, varargin)
% translateShape
% Translates a shape in the form of a 2xn matrix consisting of n points 
% by the specified amounts of shift.
%
% Usage:
%   matrix = translateShape(shape, xShift, yShift)
%   matrix = translateShape(shape, shiftVector)

% Check the number of input arguments
if nargin == 2
    shiftVector = varargin{1};
    if length(shiftVector) ~= 2
        error('When providing a single shift vector, it must have a length of 2.');
    end
    xShift = shiftVector(1);
    yShift = shiftVector(2);
elseif nargin == 3
    xShift = varargin{1};
    yShift = varargin{2};
else
    error('Invalid number of input arguments. Expected 2 or 3.');
end

% Copy over the matrix
matrix = shape;

% Translate the rows
matrix(1, :) = matrix(1, :) + xShift;
matrix(2, :) = matrix(2, :) + yShift;

end