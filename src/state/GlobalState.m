classdef GlobalState < handle
    properties (SetObservable)
        gameState {mustBeMember(gameState, [0, 1, 2, 3])}
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
            obj.gameStateCallback = callback;
        end

        function updateGameState(obj, newState)
            obj.gameState = newState;
            obj.gameStateCallback();
        end
    end
end