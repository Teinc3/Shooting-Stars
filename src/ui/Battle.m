classdef Battle < RenderUI
    properties (Constant)
        TimeLimit = 90;

        MinSpawnRate = 2;
        MaxStarCount = 10;
        MinStarVertices = 3;
        MaxStarVertices = 10;
    end
    properties
        timeLeftInSeconds
        stars % Cell array of Star objects to render
        axesHandle % Handle to the axes object to render stars
    end
    methods
        function obj = Battle(window, globalState)
            obj@RenderUI(window, globalState); % Call superclass constructor

            obj.timeLeftInSeconds = Battle.TimeLimit;

            obj.globalState.score = 0;
            obj.globalState.combo = 0;

            obj.stars = [];
        end

        % UI Layout
        function defineRenderObjects(obj)
            % Time Counter at the top left
            timeCounter = uilabel('Parent', obj.window, 'Text', 'Time Left: 90', 'FontSize', 20, 'HorizontalAlignment', "left");
            timeCounter.Position = [10, obj.windowSize(2) - 40, 120, 30]; % Increased height and width for better visibility
            obj.addRenderObject(timeCounter);

            % Combo Counter at the top middle
            comboCounter = uilabel('Parent', obj.window, 'Text', 'Combo: 0', 'FontSize', 20, 'HorizontalAlignment', "center");
            comboCounter.Position = [obj.windowSize(1) / 2 - 60, obj.windowSize(2) - 40, 120, 30]; % Increased height and width
            obj.addRenderObject(comboCounter);

            % Score Counter at the top right
            scoreCounter = uilabel('Parent', obj.window, 'Text', 'Score: 0', 'FontSize', 20, 'HorizontalAlignment', "right");
            scoreCounter.Position = [obj.windowSize(1) - 130, obj.windowSize(2) - 40, 120, 30]; % Increased height and width
            obj.addRenderObject(scoreCounter);

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

            obj.axesHandle.HitTest = 'on';
            obj.axesHandle.PickableParts = 'all';
            obj.axesHandle.ButtonDownFcn = @(~, event) obj.onAxesClick(event);

            hold(obj.axesHandle, 'on');
        end

        function update(obj, deltaTime)
            % Implement game-specific update logic

            obj.timeLeftInSeconds = obj.timeLeftInSeconds - deltaTime;
            if obj.timeLeftInSeconds <= 0
                % Despawn all stars
                for i = length(obj.stars):-1:1
                    obj.despawnStar(obj.stars(i));
                end

                % Move to results screen
                obj.globalState.updateGameState(2);
            end

            % Update the text of the time counter
            obj.RenderObjects{1}.Text = ['Time: ', num2str(ceil(obj.timeLeftInSeconds))];
            obj.RenderObjects{2}.Text = ['Combo: ', num2str(obj.globalState.combo)];
            obj.RenderObjects{3}.Text = ['Score: ', num2str(obj.globalState.score)];

            % Function to spawn and update/render stars
            obj.spawnStars(deltaTime);

            for i = length(obj.stars):-1:1
                obj.stars(i).update(deltaTime);
            end
        end

        function spawnStars(obj, deltaTime)
            % Chance of spawning new star
            % At 0 stars: MinSpawnRate per second
            % At MaxStarCount: 0 per second (Capped)
            % If due to lagspike and chance ends up > 1, spawn star and compare next frame
            starSpawnChance = max(0, Battle.MinSpawnRate * (1 - length(obj.stars) / Battle.MaxStarCount)) * deltaTime;

            while rand() < starSpawnChance
                % Randomly generate star properties
                vertexCount = randi([Battle.MinStarVertices, Battle.MaxStarVertices]);
                star = Star(obj.window, obj.axesHandle, vertexCount, @(s) obj.despawnStar(s));

                % Add star to the list of objects to render
                obj.stars = [obj.stars, star];

                % To allow for multiple stars to be spawned in the same frame if a lagspike occurs
                starSpawnChance = starSpawnChance - 1;
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
            for i = length(obj.stars):-1:1
                score = obj.stars(i).onClick(clickPosition);
                if score > 0
                    obj.globalState.score = obj.globalState.score + score + obj.globalState.combo;
                    obj.globalState.combo = obj.globalState.combo + 1;
                    return;
                end
            end
            % Combo lost
            obj.globalState.combo = 0;
        end
    end
end