SydneyHUD.DragAndDropInventory = SydneyHUD.DragAndDropInventory or { from_x = 0, from_y = 0 }
local select_original = BlackMarketGuiSlotItem.select
local deselect_original = BlackMarketGuiSlotItem.deselect
local mouse_pressed_original = BlackMarketGui.mouse_pressed
local mouse_moved_original = BlackMarketGui.mouse_moved
local mouse_released_original = BlackMarketGui.mouse_released

function BlackMarketGuiSlotItem:select(instant, no_sound)
    self._data.hide_unselected_mini_icons = false
    return select_original(self, instant, no_sound)
end

function BlackMarketGuiSlotItem:deselect(instant)
    self._data.hide_unselected_mini_icons = false
    return deselect_original(self, instant)
end

function BlackMarketGui:mouse_pressed(button, x, y)
    local result = mouse_pressed_original(self, button, x, y)

    if self._enabled and not self._data.is_loadout and not self._renaming_item and self._highlighted and button == Idstring("0") and self._tabs[self._highlighted]:inside(x, y) == 1 then
        local ctg = self._slot_data.category
        if (ctg == "masks" and self._slot_data.slot ~= 1 and self._data.topic_id ~= "bm_menu_buy_mask_title") or ((ctg == "primaries" or ctg == "secondaries") and not self._data.buying_weapon) then
            DragAndDropInventory.dragging = false
            DragAndDropInventory.picked = false
            DragAndDropInventory.from_x = x
            DragAndDropInventory.from_y = y
            DragAndDropInventory.slot_src = self._slot_data and not self._slot_data.locked_slot and self._slot_data.slot
            DragAndDropInventory.slot_data = self._slot_data
        end
    end
    return result
end

function BlackMarketGui:mouse_moved(o, x, y)
    local grab = false
    if self._enabled and self._highlighted and DragAndDropInventory.slot_src and self._tabs[self._highlighted] then
        if self._tab_scroll_panel:inside(x, y) and self._tabs[self._highlighted]:inside(x, y) ~= 1 then
            if self._selected ~= self._highlighted then
                self:set_selected_tab(self._highlighted)
            end
        elseif self._tabs[self._highlighted]:inside(x, y) == 1 then
            DragAndDropInventory.dragging = DragAndDropInventory.dragging or math.abs(x - DragAndDropInventory.from_x) > 5 or math.abs(y - DragAndDropInventory.from_y) > 5
            if DragAndDropInventory.dragging then
                if not DragAndDropInventory.picked then
                    DragAndDropInventory.picked = true
                    managers.blackmarket:pickup_crafted_item(self._slot_data.category, self._slot_data.slot)
                end

                if DragAndDropInventory.slot_data.bitmap_texture then
                    local bmp = self._panel:child("DragAndDropInventoryItem") or self._panel:bitmap({
                        name = "DragAndDropInventoryItem",
                        texture = DragAndDropInventory.slot_data.bitmap_texture,
                        layer = tweak_data.gui.MOUSE_LAYER - 50,
                    })
                    bmp:set_center(x, y)
                end
            end
        end
        grab = true
    end

    if grab then
        mouse_moved_original(self, o, x, y)
        return true, "grab"
    else
        return mouse_moved_original(self, o, x, y)
    end
end

function BlackMarketGui:mouse_released(button, x, y)
    if button == Idstring("0") then
        if DragAndDropInventory.dragging and self._highlighted and self._tabs[self._highlighted]:inside(x, y) == 1 then
            local tab = self._tabs[self._highlighted]
            local slot_dst = tab._slots[tab._slot_highlighted]._data
            if slot_dst and not slot_dst.locked_slot and not (slot_dst.category == "masks" and slot_dst.slot == 1) then
                managers.blackmarket:place_crafted_item(slot_dst.category, slot_dst.slot)
                self:reload()
            end
        end

        local bmp = self._panel:child("DragAndDropInventoryItem")
        if bmp then
            self._panel:remove(bmp)
        end
        DragAndDropInventory.dragging = false
        DragAndDropInventory.slot_src = nil
        DragAndDropInventory.slot_data = nil
    end

    return mouse_released_original(self, button, x, y)
end
