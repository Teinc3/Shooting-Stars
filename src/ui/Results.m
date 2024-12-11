classdef Results < RenderUI
    methods
        function obj = Results(window, globalState)
            % Results - Constructor for the Results class
            obj@RenderUI(window, globalState); % Call superclass constructor
            
            % Implement results UI components here
        end

        function defineRenderObjects(obj)
            % Game Over Label
            gameOverLabel = uilabel('Parent', obj.window, 'Text', 'Game Over', 'FontSize', 40, 'HorizontalAlignment', "center");
            gameOverLabel.Position = [0, obj.windowSize(2) * 0.75, obj.windowSize(1), 50];
            obj.addRenderObject(gameOverLabel);
            
            % Your Score Label
            scoreLabel = uilabel('Parent', obj.window, 'Text', ['Your Score: ', num2str(obj.globalState.score)], 'FontSize', 20, 'HorizontalAlignment', "center");
            scoreLabel.Position = [0, obj.windowSize(2) * 0.65, obj.windowSize(1), 30];
            obj.addRenderObject(scoreLabel);

            % Play Again Button
            playAgainButton = uibutton('Parent', obj.window, 'Text', "Play Again", 'ButtonPushedFcn', @(~,~) obj.onPlayAgain());
            playAgainButton.Position = [obj.windowSize(1) * 0.3, obj.windowSize(2) * 0.45, obj.windowSize(1) * 0.4, 50];
            obj.addRenderObject(playAgainButton);
            
            % Main Menu Button
            mainMenuButton = uibutton('Parent', obj.window, 'Text', "Main Menu", 'ButtonPushedFcn', @(~,~) obj.onMainMenu());
            mainMenuButton.Position = [obj.windowSize(1) * 0.3, obj.windowSize(2) * 0.35, obj.windowSize(1) * 0.4, 50];
            obj.addRenderObject(mainMenuButton);
        end

        function update(~)
            % Implement results-specific update logic
        end

        function onPlayAgain(obj)
            % Callback for Play Again button
            obj.globalState.updateGameState(1); % Transition to the battle gameState
        end

        function onMainMenu(obj)
            % Callback for Main Menu button
            obj.globalState.updateGameState(0); % Transition to the menu gameState
        end
    end
end