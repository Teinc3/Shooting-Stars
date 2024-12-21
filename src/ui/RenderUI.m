classdef (Abstract) RenderUI < handle
    % Abstract parent class for holding render objects
    % Swapped out for different UI classes based on game state in RenderState

    properties (Constant)
        minTimePerFrame = 1 / 30; % FPS capped at 30
    end

    properties
        window % matlab.ui.Figure
        windowSize % double
        RenderObjects % cell array of RenderObject
        globalState % class encapsulating the game state
    end

    methods
        function obj = RenderUI(window, globalState)
            % Parent class constructor
            obj.window = window;
            obj.windowSize = window.Position(3:4);
            obj.RenderObjects = {};
            obj.globalState = globalState;

            obj.defineRenderObjects();
        end

        function addRenderObject(obj, renderObject)
            % Add the UI component to a cell array so that it can be handled later
            obj.RenderObjects{end + 1} = renderObject;
        end

        function removeRenderObject(obj, renderObject)
            % Remove and delete the UI component from the cell array
            delete(renderObject); % Delete the UI component from the figure
            obj.RenderObjects(cellfun(@(x) x == renderObject, obj.RenderObjects)) = [];
        end

        function clean(obj)
            while ~isempty(obj.RenderObjects)
                obj.removeRenderObject(obj.RenderObjects{1});
            end
        end

        function update(~, ~)
            % Defaults to nothing, but is overridden in Battle subclass
        end
    end

    methods (Abstract)
        defineRenderObjects(obj) % Function for subclasses to define their render objects
    end
    
end