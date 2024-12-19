% Shooting Stars
% A simple game made in MATLAB, where you shoot stars to gain points.
% Heavily OOP based (Not a compliment)

close all
clear variables
clc

% Display Configuration
window = uifigure('Name', "Shooting Stars", 'Position', [100, 100, 800, 600]);

% Game State
% 0: Main Menu, 1: Game, 2: Results
globalState = GlobalState();

% NeonTimer
neonTimer = NeonTimer();

% Render UI
renderState = RenderState(window, globalState, neonTimer);

% Set callback into globalState so whenever it changes render ui can be updated.
globalState.setCallback(@() renderState.updateRenderUI(window, globalState))

% Main Loop
averageDeltaTime = zeros(1, 10);
prev = tic;
while isvalid(window) && globalState.gameState ~= 3
    % try % Wrap everything under a grandfather clause
       
    % catch ME
    %     disp(ME.message);
    %     disp(ME.stack);
    % end

    % Calculate the time elapsed
    deltaTime = toc(prev);
    prev = tic;

    % Limit the frame rate
    if deltaTime < renderState.renderUI.minTimePerFrame
        pause(renderState.renderUI.minTimePerFrame - deltaTime);
        deltaTime = renderState.renderUI.minTimePerFrame;
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
end

if isvalid(window)
    close(window);
end

close all
clear variables
clc