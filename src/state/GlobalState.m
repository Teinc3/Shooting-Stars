classdef GlobalState < handle
    % "Global" class that holds states that are shared across different parts of the game
    properties (SetObservable)
        gameState {mustBeMember(gameState, [-1, 0, 1, 2])}
        score {mustBeInteger(score), mustBeNonnegative(score)}
        combo {mustBeInteger(combo), mustBeNonnegative(combo)}
        audioManager

        gameStateCallback
    end

    methods
        function obj = GlobalState()
            obj.gameState = 0;

            obj.score = 0;
            obj.combo = 0;

            obj.audioManager = AudioManager();
        end

        function setCallback(obj, callback)
            % Set callback st when the game state changes, the UI can be updated accordingly (No listeners required)
            obj.gameStateCallback = callback;
        end

        function updateGameState(obj, newState)
            obj.gameState = newState;
            obj.gameStateCallback();
        end
    end
end