local _setup_item_rows_original = MenuNodeMainGui._setup_item_rows

function MenuNodeMainGui:_setup_item_rows(node, ...)
	_setup_item_rows_original(self, node, ...)

	if alive(self._version_string) then
		local sydneyhud_version = SydneyHUD:GetVersion("SydneyHUD")
		local sydneyhud_assets_version = SydneyHUD:GetVersion("SydneyHUD-Assets")
		local payday2_version = self._version_string:text()

		if payday2_version == Application:version() then
			if sydneyhud_assets_version then
				self._version_string:set_text("PAYDAY2 v" .. payday2_version .. " with SydneyHUD v" .. sydneyhud_version .. " Assets v" .. sydneyhud_assets_version)
			else
				self._version_string:set_text("PAYDAY2 v" .. payday2_version .. " with SydneyHUD v" .. sydneyhud_version)
			end
    		log("[SydneyHUD Dev.] pd2version | Appversion: " .. payday2_version .. " | " .. Application:version())
		end
	end
end
