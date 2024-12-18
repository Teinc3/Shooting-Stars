classdef Battle < RenderUI
    properties
        timeLeftInFrames
        timeLeftInSeconds
        stars % Cell array of Star objects to render
        combo
        axesHandle % Handle to the axes object to render stars
    end
    methods
        function obj = Battle(window, globalState)
            obj@RenderUI(window, globalState); % Call superclass constructor

            obj.timeLeftInSeconds = 90;
            obj.timeLeftInFrames = obj.timeLeftInSeconds * obj.fps;
            obj.combo = 0;

            obj.globalState.score = 0;

            obj.stars = [];
        end

        % UI Layout
        function defineRenderObjects(obj)
            % Time Counter at the top left
            timeCounter = uilabel('Parent', obj.window, 'Text', 'Time Left: 90', 'FontSize', 20, 'HorizontalAlignment', "left");
            timeCounter.Position = [10, obj.windowSize(2) - 40, 120, 30]; % Increased height and width for better visibility
            obj.addRenderObject(timeCounter);

            % Score Counter at the top right
            scoreCounter = uilabel('Parent', obj.window, 'Text', 'Score: 0', 'FontSize', 20, 'HorizontalAlignment', "right");
            scoreCounter.Position = [obj.windowSize(1) - 130, obj.windowSize(2) - 40, 120, 30]; % Increased height and width
            obj.addRenderObject(scoreCounter);

            % Star Counter at the top middle (Debug)
            starCounter = uilabel('Parent', obj.window, 'Text', 'Stars: 0', 'FontSize', 20, 'HorizontalAlignment', "center");
            starCounter.Position = [obj.windowSize(1) / 2 - 60, obj.windowSize(2) - 40, 120, 30]; % Increased height and width
            obj.addRenderObject(starCounter);

            % Attach axes to the ui window
            obj.axesHandle = uiaxes('Parent', obj.window);
            obj.axesHandle.Position = [0, 0, obj.windowSize(1), obj.windowSize(2)];
            obj.axesHandle.XLim = [0, obj.windowSize(1)];
            obj.axesHandle.YLim = [0, obj.windowSize(2)];
            obj.axesHandle.XDir = 'normal';
            obj.axesHandle.YDir = 'normal';
            obj.axesHandle.XTick = [];
            obj.axesHandle.YTick = [];
            obj.axesHandle.Visible = 'off'; % Hide axes borders and ticks
            obj.axesHandle.SortMethod = 'depth'; % Ensure correct rendering order
            obj.axesHandle.ButtonDownFcn = @(~, event) obj.onAxesClick(event);

            hold(obj.axesHandle, 'on');
        end

        function update(obj)
            % Implement game-specific update logic
            obj.timeLeftInFrames = obj.timeLeftInFrames - 1;
            if obj.timeLeftInFrames == 0
                obj.globalState.updateGameState(2);
            elseif mod(obj.timeLeftInFrames, obj.fps) == obj.fps - 1
                obj.timeLeftInSeconds = obj.timeLeftInSeconds - 1;
            end

            % Update the text of the time counter
            obj.RenderObjects{1}.Text = ['Time: ', num2str(obj.timeLeftInSeconds)];
            obj.RenderObjects{2}.Text = ['Score: ', num2str(obj.globalState.score)];
            obj.RenderObjects{3}.Text = ['Stars: ', num2str(length(obj.stars))];

            % Function to spawn and update/render stars
            obj.spawnStars();

            for i = 1:length(obj.stars)
                obj.stars(i).update(obj.timePerFrame);
            end
        end

        function render(obj)
            % Wipe the window clean of stars
            cla(obj.axesHandle);

            hold(obj.axesHandle, 'on');

            % Re-render all stars
            for i = 1:length(obj.stars)
                obj.stars(i).render();
            end

            hold(obj.axesHandle, 'off');
        end

        function spawnStars(obj)
            % Chance of spawning new star is max(0.05-starCount/100, 0)
            starSpawnChance = max(0.05 - length(obj.stars) / 100, 0);

            if rand() < starSpawnChance
                % Randomly generate star properties
                vertexCount = randi([2, 10]);
                star = Star(obj.window, obj.axesHandle, vertexCount, @(s) obj.despawnStar(s));

                % Add star to the list of objects to render
                obj.stars = [obj.stars, star];
            end
        end

        function despawnStar(obj, star)
            % Remove star from the list of objects to render
            obj.stars = obj.stars(obj.stars ~= star);
            if isgraphics(star.plotHandle)
                delete(star.plotHandle);
            end
        end

        function onAxesClick(obj, event)
            % Check if the click was on a star
            clickPosition = [event.IntersectionPoint(1), event.IntersectionPoint(2)];
            for i = 1:length(obj.stars)
                score = obj.stars(i).onClick(clickPosition);
                if score > 0
                    obj.globalState.score = obj.globalState.score + score + obj.combo;
                    obj.combo = obj.combo + 1;
                    % Some stars may overlap with each other, so we check for all and don't break
                end
            end
        end
    end
end