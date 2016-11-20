local _get_max_move_speed_original = HuskPlayerMovement._get_max_move_speed

function HuskPlayerMovement:_get_max_move_speed(...)
    return _get_max_move_speed_original(self, ...) * 2 -- Const but, will be changeable by future
end