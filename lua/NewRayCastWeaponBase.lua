local on_equip_original = NewRaycastWeaponBase.on_equip

function NewRaycastWeaponBase:on_equip(...)
	if self._has_gadget then
		self:_setup_laser()
		if alive(self._second_gun) then
			self._second_gun:base():_setup_laser()
		end
	end
	return on_equip_original(self, ...)
end

function NewRaycastWeaponBase:_setup_laser()
	for _, part in pairs(self._parts) do
		local base = part.unit and part.unit:base()
		if base and base.set_color_by_theme then
			base:set_color_by_theme("player")
		end
	end
end
