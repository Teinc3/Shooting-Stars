% main.m
% A shooting range game
% Made as mini-project for Comp2b
% Author: Teinc3 (Ron Shum)

% Variables

% Clear existing
clc
clear variables
close all

% Game State
% 0: Main Menu, 1: Game, 2: Results
gameState = GameState();

% Display Configuration
window = uifigure(Name="Shooting Stars", Position=[100, 100, 800, 600]);

% FPS Settings
fps = 60;
timePerFrame = 1/fps;

% Render UI
renderUI = updateRenderUI(gameState);

% Event Listener for game state change
addlistener(gameState, "state", "PostSet", @(src, event) renderUI = updateRenderUI(gameState));

% Main Loop
while true
    renderUI.update();
    renderUI.render();
    pause(timePerFrame);
end


function ui = updateRenderUI(gameState)
    % updateRenderUI - Update the UI based on the game state
    switch gameState.state
        case 0
            ui = MainMenu(window, gameState);
        case 1
            ui = Game(window, gameState);
        case 2
            ui = Results(window, gameState);
        otherwise
            error("Invalid game state");
    end
end