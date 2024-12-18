classdef Battle < RenderUI
    properties
        timeLeftInFrames
        timeLeftInSeconds
        stars % Cell array of Star objects to render
        combo
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

            % Re-render all stars
            for i = 1:length(obj.stars)
                obj.stars(i).render();
            end
        end

        function spawnStars(obj)
            % Chance of spawning new star is max(0.05-starCount/100, 0)
            starSpawnChance = max(0.05 - length(obj.stars) / 100, 0);

            if rand() < starSpawnChance
                % Randomly generate star properties
                vertexCount = randi([2, 10]);
                star = Star(obj.window, vertexCount, @(s) obj.despawnStar(s));

                % Add star to the list of objects to render
                obj.stars = [obj.stars, star];
            end
        end

        function despawnStar(obj, star)
            % Remove star from the list of objects to render
            obj.stars = obj.stars(obj.stars ~= star);
        end
    end
end