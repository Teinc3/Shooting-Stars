classdef GameState < handle
    properties (SetObservable)
        state {mustBeMember(state, [0, 1, 2])}
    end

    methods
        function obj = GameState()
            obj.state = 0;
        end

        function update_gamestate(obj, newState)
            obj.state = newState;
        end
    end
end