-- Load l10n file for m17n
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_SydneyHUD", function(loc)
    local LANGUAGE = SydneyHUD._language[SydneyHUD._data.language]
    for _, filename in pairs(file.GetFiles(SydneyHUD._path .. "loc/")) do
        local str = filename:match('^(.*).json$')
        if LANGUAGE == str then
            loc:load_localization_file(SydneyHUD._path .. "loc/" .. filename)
            break
        --[[
        elseif str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
            loc:load_localization_file(SydneyHUD._path .. "loc/" .. filename)
            break
        --]]
        end
    end
    loc:load_localization_file(SydneyHUD._path .. "loc/english.json", false)
    log("[SydneyHUD Info] Current language: " .. LANGUAGE)
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_SydneyHUD", function(menu_manager, nodes)
    if nodes.main then
        MenuHelper:AddMenuItem(nodes.main, "crimenet_contract_special", "menu_cn_premium_buy", "menu_cn_premium_buy_desc", "crimenet", "after")
    end
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_SydneyHUD", function(menu_manager, menu_nodes)
    -- Add "Reset all" option to the SydneyHUD main menu.
    MenuHelper:AddButton({
        id = "SydneyHUD_reset",
        title = "SydneyHUD_reset",
        desc = "SydneyHUD_reset_desc",
        callback = "callback_SydneyHUD_reset",
        menu_id = "SydneyHUD_option",
        priority = 100
    })
    MenuHelper:AddDivider({
        id = "SydneyHUD_reset_divider",
        size = 16,
        menu_id = "SydneyHUD_option",
        priority = 99
    })
end)

-- Setup callback where in menu
Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_SydneyHUD", function(menu_manager)

    -- Menu Tweak
    MenuCallbackHandler.callback_lobby_skins_mode = function(self, item)
        SydneyHUD._data.lobby_skins_mode = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_enable_buy_all_assets = function(self, item)
        SydneyHUD._data.enable_buy_all_assets = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_skip_black_screen = function(self, item)
        SydneyHUD._data.skip_black_screen = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_skip_stat_screen = function(self, item)
        SydneyHUD._data.skip_stat_screen = (item:value() == "on")
        SydneyHUD:Save()
    end
    MenuCallbackHandler.callback_skip_stat_screen_delay = function(self, item)
        SydneyHUD._data.skip_stat_screen_delay = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_skip_card_pick = function(self, item)
        SydneyHUD._data.skip_card_pick = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_skip_loot_screen = function(self, item)
        SydneyHUD._data.skip_loot_screen = (item:value() == "on")
        SydneyHUD:Save()
    end
    MenuCallbackHandler.callback_skip_loot_screen_delay = function(self, item)
        SydneyHUD._data.skip_loot_screen_delay = item:value()
        SydneyHUD:Save()
    end

    -- HUD Tweak
    MenuCallbackHandler.callback_enable_pacified = function(self, item)
        SydneyHUD._data.enable_pacified = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_center_assault_banner = function(self, item)
        SydneyHUD._data.center_assault_banner = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_enable_enhanced_assault_banner = function(self, item)
        SydneyHUD._data.enable_enhanced_assault_banner = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_show_interaction_circle = function(self, item)
        SydneyHUD._data.show_interaction_circle = (item:value() == "on")
        SydneyHUD:Save()
    end
    MenuCallbackHandler.callback_show_interaction_text = function(self, item)
        SydneyHUD._data.show_interaction_text = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_show_text_borders = function(self, item)
        SydneyHUD._data.show_text_borders = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_enable_objective_animation = function(self, item)
        SydneyHUD._data.enable_objective_animation = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_show_suspicion_text = function(self, item)
        SydneyHUD._data.show_suspicion_text = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_show_reload_interaction = function(self, item)
        SydneyHUD._data.show_reload_interaction = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_show_melee_interaction = function(self, item)
        SydneyHUD._data.show_melee_interaction = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_anti_bobble = function(self, item)
        SydneyHUD._data.anti_bobble = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_interaction_color_r = function(self, item)
        SydneyHUD._data.interaction_color_r = item:value()
        SydneyHUD:Save()
    end
    MenuCallbackHandler.callback_interaction_color_g = function(self, item)
        SydneyHUD._data.interaction_color_g = item:value()
        SydneyHUD:Save()
    end
    MenuCallbackHandler.callback_interaction_color_b = function(self, item)
        SydneyHUD._data.interaction_color_b = item:value()
        SydneyHUD:Save()
    end

    -- Interact Tweak
    MenuCallbackHandler.callback_hold_to_pick = function(self, item)
        SydneyHUD._data.hold_to_pick = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_hold_to_pick_delay = function(self, item)
        SydneyHUD._data.hold_to_pick_delay = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_push_to_interact = function(self, item)
        SydneyHUD._data.push_to_interact = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_equipment_interrupt = function(self, item)
        SydneyHUD._data.equipment_interrupt = (item:value() == "on")
        SydneyHUD:Save()
    end

    -- Gadget Tweak
    MenuCallbackHandler.callback_enable_flashlight_extender = function(self, item)
        SydneyHUD._data.enable_flashlight_extender = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_flashlight_range = function(self, item)
        SydneyHUD._data.flashlight_range = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_flashlight_angle = function(self, item)
        SydneyHUD._data.flashlight_angle = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_enable_laser_options = function(self, item)
        SydneyHUD._data.enable_laser_options = (item:value() == "on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_laser_color_r = function(self, item)
        SydneyHUD._data.laser_color_r = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_laser_color_g = function(self, item)
        SydneyHUD._data.laser_color_g = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_laser_color_b = function(self, item)
        SydneyHUD._data.laser_color_b = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_laser_color_rainbow = function(self, item)
        SydneyHUD._data.laser_color_rainbow = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_laser_light = function(self, item)
        SydneyHUD._data.laser_light = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_laser_glow = function(self, item)
        SydneyHUD._data.laser_glow = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_laser_color_a = function(self, item)
        SydneyHUD._data.laser_color_a = item:value()
        SydneyHUD:Save()
    end

    -- Gameplay Tweak
    MenuCallbackHandler.callback_anti_stealth_grenades = function(self, item)
        SydneyHUD._data.anti_stealth_grenades = (item:value() == "on")
        SydneyHUD:Save()
    end

    -- SydneyHUD
    MenuCallbackHandler.callback_sydneyhud_language = function(self, item)
        SydneyHUD._data.language = item:value()
        SydneyHUD:Save()
    end

    -- Reset All
    MenuCallbackHandler.callback_SydneyHUD_reset = function(self, item)
        local menu_title = managers.localization:text("SydneyHUD_reset")
        local menu_message = managers.localization:text("SydneyHUD_reset_message")
        local menu_options = {
            [1] = {
                text = managers.localization:text("SydneyHUD_reset_ok"),
                callback = function()
                    SydneyHUD:LoadDefault()
                    SydneyHUD:ForceReloadAllMenu()
                    SydneyHUD:Save()
                end,
            },
            [2] = {
                text = managers.localization:text("SydneyHUD_reset_cancel"),
                is_cancel_button = true,
            },
        }
        QuickMenu:new(menu_title, menu_message, menu_options, true)
    end

    -- Load saved data from save file.
    SydneyHUD:Load()
    SydneyHUD:InitAllMenu()

    -- Set keybind default
    LuaModManager:SetPlayerKeybind("load_pre", LuaModManager:GetPlayerKeybind("load_pre") or "f5")
    LuaModManager:SetPlayerKeybind("save_pre", LuaModManager:GetPlayerKeybind("save_pre") or "f6")
end)
