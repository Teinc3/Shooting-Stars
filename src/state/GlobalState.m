classdef GlobalState < handle
    properties (SetObservable)
        gameState {mustBeMember(gameState, [0, 1, 2, 3])}
        score {mustBeInteger(score), mustBeNonnegative(score)}
        audioManager
    end

    methods
        function obj = GlobalState()
            obj.gameState = 0;
            obj.score = 0;
            obj.audioManager = AudioManager();
        end

        function updateGameState(obj, newState)
            obj.gameState = newState;
        end
    end
end