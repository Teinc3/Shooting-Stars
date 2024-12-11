classdef Battle < RenderUI
    properties
        timeLeftInFrames
        timeLeftInSeconds
        combo
    end
    methods
        function obj = Battle(window, globalState)
            obj@RenderUI(window, globalState); % Call superclass constructor

            obj.timeLeftInSeconds = 90;
            obj.timeLeftInFrames = obj.timeLeftInSeconds * obj.fps;
            obj.combo = 0;

            obj.globalState.score = 0;
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

            % Randomly increase score
            if rand() < 0.01
                obj.globalState.score = obj.globalState.score + 1;
            end
        end
    end
end