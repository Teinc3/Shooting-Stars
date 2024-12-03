% main.m
% A shooting range game

% Variables

% Clear workspace
clc
clear variables
close all

% Display Configuration
window = uifigure(Name="Shooting Stars", Position=[100, 100, 800, 600]);

% FPS Settings
fps = 60;
timePerFrame = 1/fps;

% Game State
% 0: Main Menu, 1: Game, 2: Results
gameState = GameState();

% Render UI
renderState = RenderState(window, gameState);

% Event Listener for game state change
addlistener(gameState, 'state', 'PostSet', @(src, event) renderState.updateRenderUI(window, gameState));

% Main Loop
while isvalid(window)
    renderState.update();
    renderState.render();
    pause(timePerFrame);
end