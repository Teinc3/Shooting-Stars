function Star = DefineStar(points)
% Plotting a star with specified number of points given by input
% Inputs "points" is a number e.g DefineStar(5) for a 5 pointed star 
% Using equations from: https://math.stackexchange.com/questions/3582342/coordinates-of-the-vertices-of-a-five-pointed-star
% Isaac Mear, Aug 2024

% Define how many (x,y) co-ordinates needed on the circle
k=0:points; 

% Outer circle (xo,yo) points
outerX=1*cos((2*pi*k/points)+pi/2);
outerY=1*sin((2*pi*k/points)+pi/2);

% Inner circle (xi,yi) points
innerX=0.4*cos((2*pi*k/points)+pi/2+(2*pi/(2*points)));
innerY=0.4*sin((2*pi*k/points)+pi/2+(2*pi/(2*points)));

% Group them so the points alternate [x01,xi1,x02,xi1,...]
starX = reshape([outerX; innerX], [], 1)';
starY = reshape([outerY; innerY], [], 1)';

% Define shape in format [x;y]
Star=[starX;starY];