classdef Star < handle
    properties (Constant)
        MinimumSize = 10;
        MaximumSize = 80;
        VelocityMultiplier = 200;
    end
    properties
        window % handle to the window
        windowSize % size of the window

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
            obj.angle = (rand() - 0.5) * 2*pi;

            obj.ogSize = rand() * (Star.MaximumSize - Star.MinimumSize) + Star.MinimumSize;
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

            isBottom = angle < 0;
            isRight = abs(angle) > pi/2;

            % First decide which side to stick to and which side is free
            if rand() < 0.5
                % Fix y to top or bottom, depending on angle
                y = (isBottom) * height;
                x = (rand()/2 + (isRight)) * width;
            else
                % Fix x to left or right
                x = (isRight) * width;
                y = (rand()/2 + (~isBottom)) * height;
            end

            obj.centralPosition = [x, y];
        end

        function update(obj, deltaTime)

            obj.updatePosition(deltaTime);
            if obj.checkOOB()
                return;
            end
            obj.updateArgument(deltaTime);
            obj.updateModulus();
            
            % Obtain the transformed star from the updated position
            obj.getTransformedStar();

            % Render the star
            obj.render();
        end

        function updatePosition(obj, deltaTime)
            obj.timeAlive = obj.timeAlive + deltaTime;
            obj.centralPosition = obj.centralPosition + ...
                Star.VelocityMultiplier * obj.calculateSizeFactor() * deltaTime * [cos(obj.angle), sin(obj.angle)];
        end

        function updateArgument(obj, deltaTime)
            % Update color accordingly to angV
            obj.color = mod(obj.color + deltaTime * obj.angV, 2*pi);
            
            % Change angV randomly but clamped to abs < pi
            obj.angV = obj.angV + (rand() - 0.5) * pi / 10;
            obj.angV = min(abs(obj.angV), pi) * sign(obj.angV);
        end

        function updateModulus(obj)
            if obj.isHit
                % Gradually diminish its size
                obj.size = obj.size - obj.ogSize / 100;
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
            % Render the star on the UI

            % Obtain Star information
            obj.getTransformedStar();
            rgbColor = hsv2rgb([obj.color / (2 * pi), 1, 1]);

            % Draw the star
            if isgraphics(obj.plotHandle)
                % Change the data in the plothandle
                obj.plotHandle.XData = obj.position(1, :);
                obj.plotHandle.YData = obj.position(2, :);
                obj.plotHandle.FaceColor = 'none';
                obj.plotHandle.EdgeColor = rgbColor;
            else
                % New star, create a new plothandle
                obj.plotHandle = fill(obj.axesHandle, obj.position(1, :), obj.position(2, :), rgbColor, ...
                    'EdgeColor', 'none', 'LineWidth', min(3, obj.ogSize / 10), 'PickableParts', 'none');
                obj.plotHandle.FaceColor = 'none';
            end
        end

        function isOOB = checkOOB(obj)
            % Check if the star is out of bounds
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
            position = position * obj.size; % Simply scalar multiplication
            position = rotateShape(position, obj.color);
            position = translateShape(position, obj.centralPosition);

            % Save the position to object state
            obj.position = position;
        end

        function score = onClick(obj, clickPosition)
            % Check polygon collision with mouse click
            % If hit, set isHit to true and return score
            % Else return 0 (no score)
            if ~obj.isHit && inpolygon(clickPosition(1), clickPosition(2), obj.position(:, 1), obj.position(:, 2))
                obj.isHit = true;
                % Score gained relative to ogSize, the smaller the better
                score = (obj.ogSize / obj.size) + abs(obj.angV)/4;
            else
                score = 0;
            end
        end

        function factor = calculateSizeFactor(obj)
            % Calculate the size factor based on the size of the star
            % The size factor is used to determine the speed of the star
            % The larger the star, the slower it moves - but the less score it has
            factor = (obj.ogSize * 2 / (Star.MinimumSize + Star.MaximumSize));
        end
    end
end