local init_original = WeaponFlashLight.init

function WeaponFlashLight:init(unit)
	init_original(self, unit)
	if SydneyHUD:GetOption("enable_flashlight_extender") then
		self._light:set_spot_angle_end(math.clamp(SydneyHUD:GetOption("flashlight_angle"), 0, 160))
		self._light:set_far_range(SydneyHUD:GetOption("flashlight_range"))
	end
end
