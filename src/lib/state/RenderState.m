classdef RenderState < handle
    properties
        exists = false;
        renderUI % Make sure this is not empty
    end

    methods
        function obj = RenderState(window, gameState)
            % RenderState - Constructor for the RenderState class
            obj.updateRenderUI(window, gameState);
        end

        function updateRenderUI(obj, window, gameState)
            if obj.exists
                obj.renderUI.delete();
            end
            
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

            obj.exists = true;
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