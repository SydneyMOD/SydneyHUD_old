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
    MenuCallbackHandler.callback_skip_black_screen = function(self, item)
        SydneyHUD._data.skip_black_screen = (item:value() =="on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_skip_stat_screen = function(self, item)
        SydneyHUD._data.skip_stat_screen = (item:value() =="on")
        SydneyHUD:Save()
    end
    MenuCallbackHandler.callback_skip_stat_screen_delay = function(self, item)
        SydneyHUD._data.skip_stat_screen_delay = item:value()
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_skip_card_pick = function(self, item)
        SydneyHUD._data.skip_card_pick = (item:value() =="on")
        SydneyHUD:Save()
    end

    MenuCallbackHandler.callback_skip_loot_screen = function(self, item)
        SydneyHUD._data.skip_loot_screen = (item:value() =="on")
        SydneyHUD:Save()
    end
    MenuCallbackHandler.callback_skip_loot_screen_delay = function(self, item)
        SydneyHUD._data.skip_loot_screen_delay = item:value()
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
