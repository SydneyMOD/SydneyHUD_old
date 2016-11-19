-- Load l10n file for m17n
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_SydneyHUD", function(loc)
    for _, filename in pairs(file.GetFiles(SydneyHUD._path .. "loc/")) do
        local str = filename:match('^(.*).json$')
        log("[SydneyHUD Dev] str: " .. str)
        if SydneyHUD._data.language == str then
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
    log("[SydneyHUD Dev] language data: " .. SydneyHUD._data.language)
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

--[[
    Setup our menu callbacks, load our saved data, and build the menu from our json file.
]]
Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_SydneyHUD", function(menu_manager)

    --[[
        Setup our callbacks as defined in our item callback keys, and perform our logic on the data retrieved.
    ]]

    --[[
    -- HUD Lists (Buffs)
    MenuCallbackHandler.callback_show_buffs = function(self, item)
        SydneyHUD._data.show_buffs = (item:value() =="on")
        SydneyHUD:Save()
    end
    --]]

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

    --[[
        Load our previously saved data from our save file.
    ]]
    SydneyHUD:Load()
    SydneyHUD:InitAllMenu()

    --[[
        Set keybind defaults
    ]]
    LuaModManager:SetPlayerKeybind("load_pre", LuaModManager:GetPlayerKeybind("load_pre") or "f5")
    LuaModManager:SetPlayerKeybind("save_pre", LuaModManager:GetPlayerKeybind("save_pre") or "f6")
end)
