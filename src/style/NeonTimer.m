classdef NeonTimer < handle
    % Class to manage neon style for UI Components (Not stars! )
    properties
        offset % Offset for color
        baseColors % Base colors for different types of UI components
        colorRange % Color fluctuation ranges for UI components
        maxOffset % Maximum offset before modulating
        currentColors % Current colors applied to components, fetched dynamically when required
    end
    
    methods
        function obj = NeonTimer()
            % Constructor: Initializes properties and starts the timer
            obj.offset = 0;
            obj.maxOffset = 2 * pi; % For cyclical changes using sine wave
            
            % Define base colors for different components
            obj.baseColors.background = [0, 0, 0];       % Black background
            obj.baseColors.button = [0.5, 0, 0];           % Red buttons
            obj.baseColors.label = [0, 1, 1];            % Cyan labels
            
            % Define color ranges (how much each component can vary)
            obj.colorRange.background = [0.1, 0.1, 0.1]; % Subtle variation
            obj.colorRange.button = [0.2, 0.2, 0.2];       % More noticeable
            obj.colorRange.label = [0.4, 0.4, 0.4];        % More noticeable
            
            % Initialize current colors with base colors
            obj.currentColors.background = obj.baseColors.background;
            obj.currentColors.button = obj.baseColors.button;
            obj.currentColors.label = obj.baseColors.label;
        end
        
        function update(obj, deltaTime)
            % Function called on each timer tick to update colors
            
            % Update the offset
            obj.offset = obj.offset + deltaTime;
            if obj.offset > obj.maxOffset
                obj.offset = obj.offset - obj.maxOffset; % Reset for cyclical effect
            end
            
            % Calculate new colors using sine waves for smooth transitions
            newBackground = obj.baseColors.background + obj.colorRange.background .* [sin(obj.offset), sin(obj.offset + 2), sin(obj.offset + 4)];
            newButton = obj.baseColors.button + obj.colorRange.button .* [sin(obj.offset + 1), sin(obj.offset + 3), sin(obj.offset + 5)];
            newLabel = obj.baseColors.label + obj.colorRange.label .* [sin(obj.offset + 2), sin(obj.offset + 4), sin(obj.offset + 6)];
            
            % Clamp color values to [0, 1]
            newBackground = min(max(newBackground, 0), 1);
            newButton = min(max(newButton, 0), 1);
            newLabel = min(max(newLabel, 0), 1);
            
            % Update currentColors
            obj.currentColors.background = newBackground;
            obj.currentColors.button = newButton;
            obj.currentColors.label = newLabel;
        end
        
        function setStyle(obj, uiComponent)
             
            if isa(uiComponent, 'matlab.ui.Figure')
                neonStyle = obj.getBackgroundStyle();
            elseif isa(uiComponent, 'matlab.ui.control.Button')
                neonStyle = obj.getButtonStyle();
            elseif isa(uiComponent, 'matlab.ui.control.Label')
                neonStyle = obj.getLabelStyle();
            else
                disp("Component not supported");
                disp(class(uiComponent));
            end

            % Apply the style to the component
            fields = fieldnames(neonStyle);
            for i = 1:length(fields)
                uiComponent.(fields{i}) = neonStyle.(fields{i});
            end
        end

        function neonStyle = getBackgroundStyle(obj)
            % Background Style
            neonStyle = struct('Color', obj.currentColors.background);
        end

        function neonStyle = getButtonStyle(obj)
            % Button Style
            neonStyle = struct('BackgroundColor', obj.currentColors.button, ...
                'FontColor', obj.currentColors.label, 'FontWeight', 'bold', 'FontName', 'Segoe UI');
        end

        function neonStyle = getLabelStyle(obj)
            % Label Style
            neonStyle = struct('FontColor', obj.currentColors.label, 'FontWeight', 'bold', 'FontName', 'Segoe UI');
        end
    end
end