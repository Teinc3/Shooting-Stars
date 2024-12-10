classdef Menu < RenderUI
    methods
        function obj = Menu(window, gameState)
            obj@RenderUI(window, gameState);
            
            windowSize = obj.window.Position(3:4);

            titleLabel = uilabel(Parent=obj.window, Text="Shooting Stars", FontSize=40, HorizontalAlignment="center");
            titleLabel.Position = [0, windowSize(2) * 0.65,  windowSize(1), 50];
            obj.addRenderObject(titleLabel);

            playButton = uibutton('Parent', obj.window, 'Text', "Start", 'ButtonPushedFcn', @(~,~) obj.onStart());
            playButton.Position = [windowSize(1) * 0.3, windowSize(2) * 0.5, windowSize(1) * 0.4, 50];
            obj.addRenderObject(playButton);

            exitButton = uibutton(Parent=obj.window, Text="Exit", ButtonPushedFcn=@(~,~) obj.exitGame());
            exitButton.Position = [windowSize(1) * 0.3, windowSize(2) * 0.4, windowSize(1) * 0.4, 50];
            obj.addRenderObject(exitButton);
        end

        function onStart(obj)
            obj.gameState.update_gamestate(1);
        end

        function exitGame(obj)
            obj.window.delete();
        end

        function update(~)

        end
    end
end