classdef (Abstract) RenderUI < handle
    properties (Constant)
        fps = 60;
        timePerFrame = 1/60;
    end

    properties
        window % matlab.ui.Figure
        windowSize % double
        isDirty % boolean
        RenderObjects % cell array of RenderObject
        globalState % class encapsulating the game state
    end

    methods
        function obj = RenderUI(window, globalState)
            obj.window = window;
            obj.windowSize = window.Position(3:4);
            obj.RenderObjects = {};
            obj.globalState = globalState;

            obj.defineRenderObjects();
        end

        function addRenderObject(obj, renderObject)
            obj.RenderObjects{end + 1} = renderObject;
        end

        function removeRenderObject(obj, renderObject)
            % Remove and delete the UI component
            delete(renderObject); % Delete the UI component from the figure
            obj.RenderObjects(cellfun(@(x) x == renderObject, obj.RenderObjects)) = [];
        end

        function clean(obj)
            while ~isempty(obj.RenderObjects)
                obj.removeRenderObject(obj.RenderObjects{1});
            end
        end

    end

    methods (Abstract)
        defineRenderObjects(obj)
        update(obj)
    end
    
end