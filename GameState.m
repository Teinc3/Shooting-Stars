classdef GameState
    properties
        state {mustBeMember(state, [0, 1, 2])}
    end

    methods
        function obj = GameState()
            obj.state = 0;
        end

        function obj = update_gamestate(obj, newState)
            obj.state = newState;
        end
    end
end