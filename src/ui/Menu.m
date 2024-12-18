classdef Menu < RenderUI
    methods
        function defineRenderObjects(obj)
            titleLabel = uilabel(Parent=obj.window, Text="Shooting Stars", FontSize=40, HorizontalAlignment="center");
            titleLabel.Position = [0, obj.windowSize(2) * 0.65,  obj.windowSize(1), 50];
            obj.addRenderObject(titleLabel);

            playButton = uibutton('Parent', obj.window, 'Text', "Start", 'ButtonPushedFcn', @(~,~) obj.onStart());
            playButton.Position = [obj.windowSize(1) * 0.3, obj.windowSize(2) * 0.5, obj.windowSize(1) * 0.4, 50];
            obj.addRenderObject(playButton);

            exitButton = uibutton(Parent=obj.window, Text="Exit", ButtonPushedFcn=@(~,~) obj.exitGame());
            exitButton.Position = [obj.windowSize(1) * 0.3, obj.windowSize(2) * 0.4, obj.windowSize(1) * 0.4, 50];
            obj.addRenderObject(exitButton);
        end

        function onStart(obj)
            obj.globalState.updateGameState(1);
        end

        function exitGame(obj)
            obj.globalState.updateGameState(3);
        end
    end
end