classdef Menu < RenderUI
    methods
        function defineRenderObjects(obj)
            % Title
            titleLabel = uilabel(Parent=obj.window, Text="Shooting Stars", FontSize=40, HorizontalAlignment="center");
            titleLabel.Position = [0, obj.windowSize(2) * 0.65,  obj.windowSize(1), 50];
            obj.addRenderObject(titleLabel);

            % Start button
            playButton = uibutton('Parent', obj.window, 'Text', "Start", 'ButtonPushedFcn', @(~,~) obj.globalState.updateGameState(1));
            playButton.Position = [obj.windowSize(1) * 0.3, obj.windowSize(2) * 0.5, obj.windowSize(1) * 0.4, 50];
            obj.addRenderObject(playButton);

            % Exit button
            exitButton = uibutton(Parent=obj.window, Text="Exit", ButtonPushedFcn=@(~,~) obj.globalState.updateGameState(-1));
            exitButton.Position = [obj.windowSize(1) * 0.3, obj.windowSize(2) * 0.4, obj.windowSize(1) * 0.4, 50];
            obj.addRenderObject(exitButton);
        end
    end
end