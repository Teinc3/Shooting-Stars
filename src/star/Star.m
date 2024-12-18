classdef Star < handle
    properties
        window % handle to the window
        axesHandle % handle to the axes

        vertexCount % Number of vertices in the star

        centralPosition % 2x1 Vector of central position
        position % 2D matrix of position of star vertices
        
        time % time elapsed since star was spawned
        angle % angle of the star's trajectory

        size % magnitude - controls score you get
        ogSize % original size of the star

        color % argument from 0 to 2pi - controls rotation and color of star
        angV % Angular vel - adds to score

        starUpdated % boolean to check if star is updated

        isHit % boolean to check if star is hit
        despawnStar % function handle to despawn the star

    end

    methods
        function obj = Star(window, axesHandle, vertexCount, despawnStar)
            obj.window = window;
            obj.axesHandle = axesHandle;
            obj.vertexCount = vertexCount;

            obj.centralPosition = zeros(1, 2);

            obj.time = 0;
            obj.angle = (rand() - 0.5) * 2*pi;

            obj.ogSize = rand() * 6 + 3;
            obj.size = obj.ogSize;

            obj.color = rand() * 2*pi;
            obj.angV = sign(rand() - 0.5) * rand() * pi;

            obj.isHit = false;
            obj.starUpdated = false;

            obj.despawnStar = despawnStar;
        end

        function setInitialPosition(obj, angle)
            width = obj.window.windowSize(1);
            height = obj.window.windowSize(2);

            % Set the initial position of the star according to window size
            x = ((cos(angle) <= 0) + rand()) * width;
            y = ((sin(angle) <= 0) + rand()) * height;

            obj.centralPosition = [x, y];
        end

        function update(obj, timePerFrame)
            obj.starUpdated = true;

            obj.updatePosition(timePerFrame);
            obj.updateArgument(timePerFrame);
            obj.updateModulus();
            
            % Obtain the transformed star from the updated position
            obj.getTransformedStar();
        end

        function updatePosition(obj, timePerFrame)
            obj.time = obj.time + timePerFrame;
            obj.centralPosition = obj.centralPosition + (obj.size/obj.ogSize)^2 * timePerFrame * [cos(obj.angle), sin(obj.angle)];
        end

        function updateArgument(obj, timePerFrame)
            % Update color accordingly to angV
            obj.color = mod(obj.color + timePerFrame * obj.angV, 2*pi);
            
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
                obj.size = obj.ogSize + obj.ogSize/2 * sin(obj.time);
            end
        end

        function render(obj)
            % Render the star on the UI
            if ~obj.starUpdated
                error('Star has not been updated before rendering');
            end

            obj.starUpdated = false;

            % Obtain Star information
            obj.getTransformedStar();
            rgbColor = hsv2rgb([obj.color / (2 * pi), 1, 1]);

            % Draw the star
            fill(obj.axesHandle, obj.position(1, :), obj.position(2, :), rgbColor, 'EdgeColor', 'none', 'PickableParts', 'none');
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
                score = (obj.ogSize / obj.size)^2 + abs(obj.angV)/4;
            else
                score = 0;
            end
        end
    end
end