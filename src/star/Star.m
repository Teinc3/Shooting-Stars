classdef Star < handle
    % Class and implementation of a Star object
    % Star: A polygonal object that moves across the screen
    % Stars can be clicked on to gain score
    % After being hit on / going offscreen, they despawn to free up resources

    % DefineStar generator function (2024 c. Isaac Mear)
    properties (Constant)
        SizeLimit = [10, 60];
        VelocityMultiplier = 150;
        GravityConstant = 1;
    end
    properties
        window % handle to window
        windowSize % sizes of window

        axesHandle % handle to the axes
        plotHandle % handle to the plot

        vertexCount % Number of vertices in the star

        centralPosition % 2x1 Vector of central position
        position % 2D matrix of position of star vertices
        
        timeAlive % time elapsed since star was spawned
        angle % angle of the star's trajectory

        size % magnitude - controls score you get
        ogSize % original size of the star

        color % argument from 0 to 2pi - controls rotation and color of star
        angV % Angular vel - adds to score

        isHit % boolean to check if star is hit
        despawnStar % function handle to despawn the star

    end

    methods
        function obj = Star(window, axesHandle, vertexCount, despawnStar)
            obj.window = window;
            obj.windowSize = window.Position(3:4);

            obj.axesHandle = axesHandle;
            obj.vertexCount = vertexCount;

            obj.centralPosition = zeros(1, 2);

            obj.timeAlive = 0;
            obj.angle = -pi*rand();

            obj.ogSize = rand() * (Star.SizeLimit(2) - Star.SizeLimit(1)) + Star.SizeLimit(1);
            obj.size = obj.ogSize;

            obj.color = rand() * 2*pi;
            obj.angV = sign(rand() - 0.5) * rand() * pi;

            obj.isHit = false;
            obj.despawnStar = despawnStar;

            obj.setInitialPosition(obj.angle);
        end

        function setInitialPosition(obj, angle)
            width = obj.windowSize(1);
            height = obj.windowSize(2);

            isRight = angle < -pi/2;
            if abs(angle + pi/2) < pi/4
                x = (rand() + (isRight)) * width/2;
                y = height;
            else
                x = (isRight) * width;
                y = (1 + rand()) * height/2;
            end

            obj.centralPosition = [x, y];
        end

        function update(obj, deltaTime)

            obj.updatePosition(deltaTime);
            if obj.checkOOB()
                return;
            end
            obj.updateArgument(deltaTime);
            obj.updateModulus(deltaTime);
            
            % Obtain the transformed star from the updated position
            obj.getTransformedStar();

            % Render the star
            obj.render();
        end

        function updatePosition(obj, deltaTime)
            % Equation of y-displacement: s = ut - 0.5gt^2
            obj.timeAlive = obj.timeAlive + deltaTime;
            velDisp = Star.VelocityMultiplier * obj.calculateSizeFactor() * [cos(obj.angle), sin(obj.angle)] * deltaTime;
            gravDisp = 0.5 * Star.GravityConstant * [0, -1] * obj.timeAlive^2;
            obj.centralPosition = obj.centralPosition + velDisp + gravDisp;
            end

        function updateArgument(obj, deltaTime)
            % Update color accordingly to angV
            obj.color = mod(obj.color + deltaTime * obj.angV, 2*pi);
            
            % Change angV randomly but clamped to abs < pi
            obj.angV = obj.angV + (rand() - 0.5) * pi / 10;
            obj.angV = min(abs(obj.angV), pi) * sign(obj.angV);
        end

        function updateModulus(obj, deltaTime)
            if obj.isHit
                % Gradually diminish its size
                obj.size = obj.size - obj.ogSize * deltaTime;
                if isgraphics(obj.plotHandle)
                    obj.plotHandle.EdgeAlpha = max(0, obj.plotHandle.EdgeAlpha - deltaTime);
                end
                if obj.size < 0
                    obj.despawnStar(obj);
                end
            else
                % Use a sine wave to make the star grow and shrink
                % obj.ogSize/2 is the amplitude of the sine wave
                obj.size = obj.ogSize + obj.ogSize/2 * sin(obj.timeAlive);
            end
        end

        function render(obj)
            % Render the star on the Axes

            % Obtain Star information
            obj.getTransformedStar();
            rgbColor = hsv2rgb([obj.color / (2 * pi), 1, 1]);

            % Draw the star on the Axes
            if isgraphics(obj.plotHandle)
                % Change the data directly in the plothandle
                obj.plotHandle.XData = obj.position(1, :);
                obj.plotHandle.YData = obj.position(2, :);
                obj.plotHandle.EdgeColor = rgbColor;
            else
                % New star, save reference to a new plotHandle for future updating
                obj.plotHandle = fill(obj.axesHandle, obj.position(1, :), obj.position(2, :), rgbColor, ...
                    'EdgeColor', 'none', 'LineWidth', min(3, obj.ogSize / 10), 'HitTest', 'off', 'PickableParts', 'none');
                obj.plotHandle.FaceColor = 'none';
            end
        end

        function isOOB = checkOOB(obj)
            % Function to check if the star is out of bounds
            width = obj.windowSize(1);
            height = obj.windowSize(2);

            isOOB = obj.centralPosition(1) < 0 || obj.centralPosition(1) > width || ...
                obj.centralPosition(2) < 0 || obj.centralPosition(2) > height;

            if isOOB
                obj.despawnStar(obj);
            end
        end

        function position = getTransformedStar(obj)
            % Generate a new star with the same properties
            position = DefineStar(obj.vertexCount);
            position = position * obj.size; % Scalar multiplication
            position = rotateShape(position, obj.color);
            position = translateShape(position, obj.centralPosition);

            % Save the position to object state
            obj.position = position;
        end

        function score = onClick(obj, clickPosition)
            % Check polygon collision with mouse click
            % If hit, set isHit to true and return score
            % Else return 0 (no score)

            if inpolygon(clickPosition(1), clickPosition(2), obj.position(1, :), obj.position(2, :))
                if obj.isHit
                    score = 0;
                else
                    obj.isHit = true;
                    % Score gained relative to ogSize, the smaller the better
                    score = ceil((obj.ogSize / obj.size) + abs(obj.angV)/4);
                end
            else % Miss
                score = -1;
            end
        end

        function factor = calculateSizeFactor(obj)
            % Calculate the size factor based on the size of the star
            % The size factor is used to determine the speed of the star
            % The larger the star, the slower it moves - but the less score it has
            factor = (obj.ogSize * 2 / (sum(Star.SizeLimit)));
        end
    end
end