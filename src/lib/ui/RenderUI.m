classdef (Abstract) RenderUI < handle
    properties
        window % matlab.ui.Figure
        isDirty % boolean
        RenderObjects % cell array of RenderObject
        gameState % class encapsulating the game state
    end

    methods
        function obj = RenderUI(window, gameState)
            obj.window = window;
            obj.isDirty = true;
            obj.RenderObjects = {};
            obj.gameState = gameState;
        end

        function addRenderObject(obj, renderObject)
            obj.RenderObjects{end + 1} = renderObject;
            obj.isDirty = true;
        end

        function removeRenderObject(obj, renderObject)
            for i = 1:length(obj.RenderObjects)
                if obj.RenderObjects{i} == renderObject
                    obj.RenderObjects(i) = [];
                    obj.isDirty = true;
                    break;
                end
            end
        end

        function render(obj)
            if obj.isDirty
                % Delete rendered old components
                
            end
        end

        function clean(obj)
            while ~isempty(obj.RenderObjects)
                obj.removeRenderObject(obj.RenderObjects{1});
            end
            obj.isDirty = true;
        end

    end

    methods (Abstract)
        update(obj)
    end
    
end