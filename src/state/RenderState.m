classdef RenderState < handle
    properties
        exists = false;
        renderUI % Make sure this is not empty
        neonTimer
    end

    methods
        function obj = RenderState(window, globalState, neonTimer)
            % RenderState - Constructor for the RenderState class
            obj.neonTimer = neonTimer;
            obj.updateRenderUI(window, globalState);
        end

        function updateRenderUI(obj, window, globalState)
            if obj.exists
                obj.renderUI.clean();
            end
            
            % RenderState - Update the UI based on the game state
            switch globalState.gameState
                case 0
                    obj.renderUI = Menu(window, globalState);
                case 1
                    obj.renderUI = Battle(window, globalState);
                case 2
                    obj.renderUI = Results(window, globalState);
                otherwise
                    obj.exists = false;
                    return
            end

            obj.exists = true;
        end

        function update(obj)
            % update - Update the UI based on the game state

            % Update the neon styling
            for i = 1:length(obj.renderUI.RenderObjects)
                obj.neonTimer.update(obj.renderUI.RenderObjects{i});
            end
            
            % Update mechanics
            obj.renderUI.update();
        end
    end
end