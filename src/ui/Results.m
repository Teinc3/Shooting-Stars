classdef Results < RenderUI
    methods
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
            playAgainButton = uibutton('Parent', obj.window, 'Text', "Play Again", 'ButtonPushedFcn', @(~,~) obj.globalState.updateGameState(1));
            playAgainButton.Position = [obj.windowSize(1) * 0.3, obj.windowSize(2) * 0.45, obj.windowSize(1) * 0.4, 50];
            obj.addRenderObject(playAgainButton);
            
            % Main Menu Button
            mainMenuButton = uibutton('Parent', obj.window, 'Text', "Main Menu", 'ButtonPushedFcn', @(~,~) obj.globalState.updateGameState(0));
            mainMenuButton.Position = [obj.windowSize(1) * 0.3, obj.windowSize(2) * 0.35, obj.windowSize(1) * 0.4, 50];
            obj.addRenderObject(mainMenuButton);
        end
    end
end