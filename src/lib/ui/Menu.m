classdef Menu < RenderUI
    methods
        function obj = Menu(window, gameState)
            obj@RenderUI(window, gameState);
            
            windowSize = obj.Window.Position(3:4);

            titleLabel = uilabel(Parent=obj.Window, Text="Shooting Stars", FontSize=24, HorizontalAlignment="center");
            titleLabel.Position = [0, windowSize(2) * 0.65,  windowSize(1), 50];
            obj.addRenderObject(titleLabel);

            playButton = uibutton(Parent=window, Text="Start", ButtonPushedFcn=@(btn,event) obj.gameState.update_gamestate(1));
            exitButton = uibutton(Parent=obj.Window, Text="Exit", ButtonPushedFcn=@(btn,event) obj.exitGame());
            obj.addRenderObject(playButton);
            obj.addRenderObject(exitButton);

        end

        function exitGame(obj)
            obj.Window.delete();
        end

        function update(~)

        end
    end
end