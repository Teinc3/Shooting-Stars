classdef RenderState < handle
    properties
        renderUI % Make sure this is not empty
    end

    methods
        function obj = RenderState(window, gameState)
            % RenderState - Constructor for the RenderState class
            obj.renderUI = Menu(window, gameState);
        end

        function updateRenderUI(obj, window, gameState)
            % RenderState - Update the UI based on the game state
            switch gameState.state
                case 0
                    obj.renderUI = Menu(window, gameState);
                case 1
                    obj.renderUI = Battle(window, gameState);
                case 2
                    obj.renderUI = Results(window, gameState);
                otherwise
                    error("Invalid game state");
            end
        end

        function update(obj)
            % update - Update the UI based on the game state
            obj.renderUI.update();
        end

        function render(obj)
            % render - Render the UI based on the game state
            obj.renderUI.render();
        end
    end
end