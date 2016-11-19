local update_original = IngameWaitingForPlayersState.update
local SKIP_BLACK_SCREEN = SydneyHUD:GetOption("skip_black_screen")

function IngameWaitingForPlayersState:update(...)
    update_original(self, ...)
    if self._skip_promt_shown and SKIP_BLACK_SCREEN then
        self:_skip()
    end
end
