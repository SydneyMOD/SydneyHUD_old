if not Steam then
    return
end

SydneyHUD = SydneyHUD or {}

--[[
Log level

Info: Infomation. something successed.
Warn: Warning. something happened, errored, but can keep working
Error: Error. something occurred, can not keep working

Dev: Development. only used by test something
     Usually I delete this log when Release, but IF you find this at Release ver, please think "This is EasterEGG!!! I'm so Lucky!!!"
--]]

-- if SydneyHUD isn't setup, let us set up
if not SydneyHUD.setup then
    -- Grobal util var
    SydneyHUD._path = ModPath
    SydneyHUD._lua_path = ModPath .. "lua/"
    SydneyHUD._data_path = SavePath .. "SydneyHUD.json"
    SydneyHUD._data = {}

    -- array
    SydneyHUD._menu = {
        "SydneyHUD_option"
    }
    SydneyHUD._language = {
        [1] = "english",
        [2] = "japanese"
    }
    SydneyHUD._hook_file = {
        ["lib/managers/menumanager"] = "MenuManager.lua",
        ["lib/states/ingamewaitingforplayers"] = "IngameWaitingForPlayersState.lua",
        ["lib/managers/menu/stageendscreengui"] = "StageEndScreenGUI.lua",
        ["lib/managers/menu/lootdropscreengui"] = "LootDropScreenGUI.lua",
        ["lib/units/beings/player/huskplayermovement"] = "HuskPlayerMovement.lua",
        ["lib/managers/menu/blackmarketgui"] = "BlackMarketGUI.lua",
        ["lib/setups/menusetup"] = "MenuSetup.lua",
        ["lib/states/menutitlescreenstate"] = "MenuTitleScreenState.lua",
        ["lib/managers/hud/hudstatsscreen"] = "HUDStatsScreen.lua",
        ["lib/managers/menu/menunodegui"] = "MenuNodeGUI.lua",
        ["lib/network/base/handlers/connectionnetworkhandler"] = "ConnectionNetworkHandler.lua",
        ["lib/managers/menu/menubackdropgui"] = "MenuBackDropGUI.lua",
        ["lib/units/props/missiondoor"] = "MissionDoor.lua",
        ["lib/units/weapons/newraycastweaponbase"] = "NewRayCastWeaponBase.lua",
        ["lib/units/equipment/ammo_bag/ammobagbase"] = "AmmoBagBase.lua",
        ["lib/units/equipment/bodybags_bag/bodybagsbagbase"] = "BodyBagsBagBase.lua",
        ["lib/units/equipment/doctor_bag/doctorbagbase"] = "DoctorBagBase.lua",
        ["lib/units/equipment/ecm_jammer/ecmjammerbase"] = "ECMJammerBase.lua",
        ["lib/units/equipment/grenade_crate/grenadecratebase"] = "GrenadeCrateBase.lua",
        ["lib/units/equipment/sentry_gun/sentrygunbase"] = "SentryGunBase.lua",
        ["lib/units/enemies/cop/copdamage"] = "CopDamage.lua",
        ["lib/units/props/digitalgui"] = "DigitalGUI.lua",
        ["lib/managers/enemymanager"] = "EnemyManager.lua",
        ["lib/managers/hudmanager"] = "HUDManager.lua",
        ["lib/units/beings/player/playerdamage"] = "PlayerDamage.lua",
        ["lib/managers/playermanager"] = "PlayerManager.lua",
        ["lib/units/beings/player/playermovement"] = "PlayerMovement.lua",
        ["lib/units/props/securitycamera"] = "SecurityCamera.lua",
        ["lib/units/equipment/sentry_gun/sentrygundamage"] = "SentryGunDamage.lua",
        ["lib/units/weapons/sentrygunweapon"] = "SentryGunWeapon.lua",
        ["lib/units/props/timergui"] = "TimerGUI.lua",
        ["lib/units/unitbase"] = "UnitBase.lua",
        ["lib/network/handlers/unitnetworkhandler"] = "UnitNetworkHandler.lua",
        ["lib/managers/group_ai_states/groupaistatebase"] = "GroupAIStateBase.lua",
        ["lib/managers/hud/hudassaultcorner"] = "HUDAssaultCorner.lua",
        ["lib/managers/hud/hudinteraction"] = "HUDInteraction.lua",
        ["lib/managers/hud/hudpresenter"] = "HUDPresenter.lua",
        ["lib/managers/hud/hudsuspicion"] = "HUDSuspicion.lua",
        ["lib/tweak_data/playertweakdata"] = "PlayerTweakData.lua",
        ["lib/units/beings/player/states/playermaskoff"] = "PlayerMaskOff.lua",
        ["lib/managers/missionassetsmanager"] = "MissionAssetsManager.lua",
        ["lib/managers/localizationmanager"] = "LocalizationManager.lua",
        ["lib/managers/objectinteractionmanager"] = "ObjectInteractionManager.lua",
        ["lib/units/beings/player/states/playercivilian"] = "PlayerCivilian.lua",
        ["lib/units/beings/player/states/playerdriving"] = "PlayerDriving.lua",
        ["lib/managers/menu/menuscenemanager"] = "MenuSceneManager.lua",
        ["lib/units/weapons/weaponflashlight"] = "WeaponFlashlight.lua",
        ["lib/units/beings/player/states/playerstandard"] = "PlayerStandard.lua",
        ["lib/units/weapons/weaponlaser"] = "WeaponLaser.lua"
    }

    -- Load default option data
    function SydneyHUD:LoadDefault()
        local default_file = io.open(self._path .."menu/default_value.json")
        self._data = json.decode(default_file:read("*all"))
        default_file:close()
    end

    -- Save data using json
    function SydneyHUD:Save()
        local file = io.open(self._data_path, "w+")
        if file then
            file:write(json.encode(self._data))
            file:close()
        end
    end

    -- Load data from json file
    function SydneyHUD:Load()
        self:LoadDefault()
        local file = io.open(self._data_path, "r")
        if file then
            local configt = json.decode(file:read("*all"))
            file:close()
            for k,v in pairs(configt) do
                self._data[k] = v
            end
        end
        self:Save()
    end

    -- Return Option data
    function SydneyHUD:GetOption(id)
        return self._data[id]
    end

    -- Load all of menu json file
    function SydneyHUD:InitAllMenu()
        for _,menu in pairs(self._menu) do
            MenuHelper:LoadFromJsonFile(self._path .. "menu/" .. menu .. ".json", self, self._data)
        end
    end

    function SydneyHUD:ForceReloadAllMenu()
        for _,menu in pairs(self._menu) do
            for _,_item in pairs(MenuHelper:GetMenu(menu)._items_list) do
                if _item._type == "toggle" then
                    _item.selected = self._data[_item._parameters.name] and 1 or 2
                elseif _item._type == "multi_choice" then
                    _item._current_index = self._data[_item._parameters.name]
                elseif _item._type == "slider" then
                    _item._value = self._data[_item._parameters.name]
                end
            end
        end
    end

    function SydneyHUD:SafeDoFile(fileName)
        local success, errorMsg = pcall(function()
            if io.file_is_readable(fileName) then
                dofile(fileName)
            else
                log("[SydneyHUD Error] Could not open file '" .. fileName .. "'! Does it exist, is it readable?")
            end
        end)
        if not success then
            log("[SydneyHUD Error]\nFile: " .. fileName .. "\n" .. errorMsg)
        end
    end

    function SydneyHUD:MakeOutlineText(panel, bg, txt)
        bg.name = nil
        local bgs = {}
        for i = 1, 4 do
            table.insert(bgs, panel:text(bg))
        end
        bgs[1]:set_x(txt:x() - 1)
        bgs[1]:set_y(txt:y() - 1)
        bgs[2]:set_x(txt:x() + 1)
        bgs[2]:set_y(txt:y() - 1)
        bgs[3]:set_x(txt:x() - 1)
        bgs[3]:set_y(txt:y() + 1)
        bgs[4]:set_x(txt:x() + 1)
        bgs[4]:set_y(txt:y() + 1)
        return bgs
    end

    function SydneyHUD:GetVersion(target)
        local version = nil
        if target == "SydneyHUD" then
            for k, v in pairs(LuaModManager.Mods) do
                local info = v.definition
                if info["name"] == "SydneyHUD" then
                    version = info["version"]
                end
            end
        elseif target == "SydneyHUD-Assets" then
            local path = "assets/mod_overrides/SydneyHUD-Assets/revision.txt"
            if io.file_is_readable(path) then
                file = io.input(path)
                version = io.read()
            end
        end
        return version -- nil for failed to get
    end

    function SydneyHUD:ReceiveChatMessage(prefix, message, color)
        if not message then
            message = prefix
            prefix = nil
        end
        if not tostring(color):find('Color') then
            color = nil
        end
        message = tostring(message)
        if managers and managers.chat and managers.chat._receivers and managers.chat._receivers[1] then
            for __, rcvr in pairs(managers.chat._receivers[1]) do
                rcvr:receive_message(prefix or "*", message, color or tweak_data.chat_colors[5]) 
            end  
          end
    end

    function SydneyHUD:SendChatMessage(prefix, message, color, only)
        if Global.game_settings.single_player == false then
            SydneyHUD:ReceiveChatMessage(prefix, message)
            if Network:is_server() then
                local num_player_slots = BigLobbyGlobals and BigLobbyGlobals:num_player_slots() or 4
                for i=2,num_player_slots do
                    local peer = managers.network:session():peer(i)
                    if peer then
                        peer:send("send_chat_message", ChatManager.GAME, prefix .. message)
                    end
                end
            end
        else
            SydneyHUD:ReceiveChatMessage(prefix, message)
        end
    end

    SydneyHUD:Load()
    SydneyHUD.setup = true
    log("[SydneyHUD Info] Load completed.")
end

if RequiredScript then
    local requiredScript = RequiredScript:lower()
    if SydneyHUD._hook_file[requiredScript] then
        SydneyHUD:SafeDoFile(SydneyHUD._lua_path .. SydneyHUD._hook_file[requiredScript])
    else
        log("[SydneyHUD Warn] unlinked script called: " .. requiredScript)
    end
end
