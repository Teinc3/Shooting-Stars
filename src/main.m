% Shooting Stars
% A simple game made in MATLAB, where you shoot stars to gain points.

% Clean initial workspace
close all
clear variables
clc

% Display Configuration
window = uifigure('Name', "Shooting Stars", 'Position', [100, 100, 800, 600]);

% Game State
% 0: Main Menu, 1: Game, 2: Results
globalState = GlobalState();

neonTimer = NeonTimer();

renderState = RenderState(window, globalState, neonTimer);

% Set callback into globalState so whenever it changes render ui can be updated.
globalState.setCallback(@() renderState.updateRenderUI(window, globalState))

% Main Loop
% averageDeltaTime = zeros(1, 10);
prev = tic;
while isvalid(window) && globalState.gameState ~= -1
    try % grandfather clause
        % Calculate the time elapsed
        deltaTime = toc(prev);
        prev = tic;

        % Limit the frame rate (otherwise it will take ages to load up some basic stuff)
        if deltaTime < renderState.renderUI.minTimePerFrame
            pause(renderState.renderUI.minTimePerFrame - deltaTime);
        end
        
        % Update the neontimer
        neonTimer.update(deltaTime);
        % Also update the background's neon style
        neonTimer.setStyle(window);

        % Finally, call the update function for the current game state
        renderState.update(deltaTime);

        % Pop the first element and append the new deltaTime
        %averageDeltaTime = [averageDeltaTime(2:end), deltaTime];
        % Calculate the average time per frame
        %disp(['FPS: ', num2str(1/mean(averageDeltaTime))]);
    catch ME
        disp(ME.message);
        disp(ME.stack);
    end
end

if isvalid(window)
    close(window);
end

% Clean ending workspace
close all
clear variables
clc