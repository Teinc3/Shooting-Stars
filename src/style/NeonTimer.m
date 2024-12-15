classdef NeonTimer < handle
    properties
        offset          % Global offset for color changes
        baseColors      % Structure holding base colors for components
        colorRange      % Structure defining color fluctuation ranges
        timerHandle     % Handle to the timer
        step            % Increment step for offset
        maxOffset       % Maximum offset value before reset
        currentColors   % Current colors applied to components
    end
    
    methods
        function obj = NeonTimer()
            % Constructor: Initializes properties and starts the timer
            obj.offset = 0;
            obj.step = 0.05; % Adjust for speed of color change
            obj.maxOffset = 2 * pi; % For cyclical changes using sine wave
            
            % Define base colors for different components
            obj.baseColors.background = [0, 0, 0];       % Black background
            obj.baseColors.button = [1, 0, 0];           % Red buttons
            obj.baseColors.label = [0, 1, 1];            % Cyan labels
            
            % Define color ranges (how much each component can vary)
            obj.colorRange.background = [0.05, 0.05, 0.05]; % Subtle variation
            obj.colorRange.button = [0.2, 0.2, 0.2];       % More noticeable
            obj.colorRange.label = [0.2, 0.2, 0.2];        % More noticeable
            
            % Initialize current colors with base colors
            obj.currentColors.background = obj.baseColors.background;
            obj.currentColors.button = obj.baseColors.button;
            obj.currentColors.label = obj.baseColors.label;
            
            % Start the timer
            obj.startTimer();
        end
        
        function startTimer(obj)
            % startTimer - Initializes and starts the timer
            obj.timerHandle = timer('TimerFcn', @(~,~) obj.onTimer(), 'ExecutionMode', 'fixedRate', 'Period', 0.05);
            start(obj.timerHandle);
        end
        
        function onTimer(obj)
            % onTimer - Function called on each timer tick to update colors
            % Update the offset
            obj.offset = obj.offset + obj.step;
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
        
        function stopTimer(obj)
            % stopTimer - Stops and deletes the timer
            stop(obj.timerHandle);
            delete(obj.timerHandle);
        end
        
        function update(obj, uiComponent)
            
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