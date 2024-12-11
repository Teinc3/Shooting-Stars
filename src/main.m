% main.m
% A shooting range game

close all
clear variables
clc

% Display Configuration
window = uifigure(Name="Shooting Stars", Position=[100, 100, 800, 600]);

% Game State
% 0: Main Menu, 1: Game, 2: Results
globalState = GlobalState();

% Render UI
renderState = RenderState(window, globalState);

% Event Listener for game state change
addlistener(globalState, 'gameState', 'PostSet', @(src, event) renderState.updateRenderUI(window, globalState));

% Main Loop
while isvalid(window) && globalState.gameState ~= 3
    renderState.update();
    pause(renderState.renderUI.timePerFrame);
end

if isvalid(window)
    close(window);
end

close all
clear variables
clc