---
--- @author Dylan MALANDAIN
--- @version 2.0.0
--- @since 2020
---
--- RageUIv6 Is Advanced UI Libs in LUA for make beautiful interface like RockStar GAME.
---
---
--- Commercial Info.
--- Any use for commercial purposes is strictly prohibited and will be punished.
---
--- @see RageUIv6
---

RageUIv6.LastControl = false

local ControlActions = {
    'Left',
    'Right',
    'Select',
    'Click',
}

---GoUp
---@param Options number
---@return nil
---@public
function RageUIv6.GoUp(Options)
    local CurrentMenu = RageUIv6.CurrentMenu;
    if CurrentMenu ~= nil then
        Options = CurrentMenu.Options
        if CurrentMenu() then
            if (Options ~= 0) then
                if Options > CurrentMenu.Pagination.Total then
                    if CurrentMenu.Index <= CurrentMenu.Pagination.Minimum then
                        if CurrentMenu.Index == 1 then
                            CurrentMenu.Pagination.Minimum = Options - (CurrentMenu.Pagination.Total - 1)
                            CurrentMenu.Pagination.Maximum = Options
                            CurrentMenu.Index = Options
                        else
                            CurrentMenu.Pagination.Minimum = (CurrentMenu.Pagination.Minimum - 1)
                            CurrentMenu.Pagination.Maximum = (CurrentMenu.Pagination.Maximum - 1)
                            CurrentMenu.Index = CurrentMenu.Index - 1
                        end
                    else
                        CurrentMenu.Index = CurrentMenu.Index - 1
                    end
                else
                    if CurrentMenu.Index == 1 then
                        CurrentMenu.Pagination.Minimum = Options - (CurrentMenu.Pagination.Total - 1)
                        CurrentMenu.Pagination.Maximum = Options
                        CurrentMenu.Index = Options
                    else
                        CurrentMenu.Index = CurrentMenu.Index - 1
                    end
                end

                local Audio = RageUIv6.Settings.Audio
                RageUIv6.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                RageUIv6.LastControl = true
                if (CurrentMenu.onIndexChange ~= nil) then
                    Citizen.CreateThread(function()
                        CurrentMenu.onIndexChange(CurrentMenu.Index)
                    end)
                end
            else
                local Audio = RageUIv6.Settings.Audio
                RageUIv6.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

---GoDown
---@param Options number
---@return nil
---@public
function RageUIv6.GoDown(Options)
    local CurrentMenu = RageUIv6.CurrentMenu;
    if CurrentMenu ~= nil then
        Options = CurrentMenu.Options
        if CurrentMenu() then
            if (Options ~= 0) then
                if Options > CurrentMenu.Pagination.Total then
                    if CurrentMenu.Index >= CurrentMenu.Pagination.Maximum then
                        if CurrentMenu.Index == Options then
                            CurrentMenu.Pagination.Minimum = 1
                            CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total
                            CurrentMenu.Index = 1
                        else
                            CurrentMenu.Pagination.Maximum = (CurrentMenu.Pagination.Maximum + 1)
                            CurrentMenu.Pagination.Minimum = CurrentMenu.Pagination.Maximum - (CurrentMenu.Pagination.Total - 1)
                            CurrentMenu.Index = CurrentMenu.Index + 1
                        end
                    else
                        CurrentMenu.Index = CurrentMenu.Index + 1
                    end
                else
                    if CurrentMenu.Index == Options then
                        CurrentMenu.Pagination.Minimum = 1
                        CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total
                        CurrentMenu.Index = 1
                    else
                        CurrentMenu.Index = CurrentMenu.Index + 1
                    end
                end
                local Audio = RageUIv6.Settings.Audio
                RageUIv6.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                RageUIv6.LastControl = false
                if (CurrentMenu.onIndexChange ~= nil) then
                    Citizen.CreateThread(function()
                        CurrentMenu.onIndexChange(CurrentMenu.Index)
                    end)
                end
            else
                local Audio = RageUIv6.Settings.Audio
                RageUIv6.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

function RageUIv6.GoActionControl(Controls, Action)
    if Controls[Action or 'Left'].Enabled then
        for Index = 1, #Controls[Action or 'Left'].Keys do
            if not Controls[Action or 'Left'].Pressed then
                if IsDisabledControlJustPressed(Controls[Action or 'Left'].Keys[Index][1], Controls[Action or 'Left'].Keys[Index][2]) then
                    Controls[Action or 'Left'].Pressed = true
                    Citizen.CreateThread(function()
                        Controls[Action or 'Left'].Active = true
                        Citizen.Wait(0.01)
                        Controls[Action or 'Left'].Active = false
                        Citizen.Wait(175)
                        while Controls[Action or 'Left'].Enabled and IsDisabledControlPressed(Controls[Action or 'Left'].Keys[Index][1], Controls[Action or 'Left'].Keys[Index][2]) do
                            Controls[Action or 'Left'].Active = true
                            Citizen.Wait(1)
                            Controls[Action or 'Left'].Active = false
                            Citizen.Wait(124)
                        end
                        Controls[Action or 'Left'].Pressed = false
                        if (Action ~= ControlActions[5]) then
                            Citizen.Wait(10)
                        end
                    end)
                    break
                end
            end
        end
    end
end

function RageUIv6.GoActionControlSlider(Controls, Action)
    if Controls[Action].Enabled then
        for Index = 1, #Controls[Action].Keys do
            if not Controls[Action].Pressed then
                if IsDisabledControlJustPressed(Controls[Action].Keys[Index][1], Controls[Action].Keys[Index][2]) then
                    Controls[Action].Pressed = true
                    Citizen.CreateThread(function()
                        Controls[Action].Active = true
                        Citizen.Wait(1)
                        Controls[Action].Active = false
                        while Controls[Action].Enabled and IsDisabledControlPressed(Controls[Action].Keys[Index][1], Controls[Action].Keys[Index][2]) do
                            Controls[Action].Active = true
                            Citizen.Wait(1)
                            Controls[Action].Active = false
                        end
                        Controls[Action].Pressed = false
                    end)
                    break
                end
            end
        end
    end
end

---Controls
---@return nil
---@public
function RageUIv6.Controls()
    local CurrentMenu = RageUIv6.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            if CurrentMenu.Open then

                local Controls = CurrentMenu.Controls;
                ---@type number
                local Options = CurrentMenu.Options
                RageUIv6.Options = CurrentMenu.Options
                if CurrentMenu.EnableMouse then
                    DisableAllControlActions(2)
                end

                if not IsInputDisabled(2) then
                    for Index = 1, #Controls.Enabled.Controller do
                        EnableControlAction(Controls.Enabled.Controller[Index][1], Controls.Enabled.Controller[Index][2], true)
                    end
                else
                    for Index = 1, #Controls.Enabled.Keyboard do
                        EnableControlAction(Controls.Enabled.Keyboard[Index][1], Controls.Enabled.Keyboard[Index][2], true)
                    end
                end

                if Controls.Up.Enabled then
                    for Index = 1, #Controls.Up.Keys do
                        if not Controls.Up.Pressed then
                            if IsDisabledControlJustPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) then
                                Controls.Up.Pressed = true
                                Citizen.CreateThread(function()
                                    RageUIv6.GoUp(Options)
                                    Citizen.Wait(175)
                                    while Controls.Up.Enabled and IsDisabledControlPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) do
                                        RageUIv6.GoUp(Options)
                                        Citizen.Wait(50)
                                    end
                                    Controls.Up.Pressed = false
                                end)
                                break
                            end
                        end
                    end
                end

                if Controls.Down.Enabled then
                    for Index = 1, #Controls.Down.Keys do
                        if not Controls.Down.Pressed then
                            if IsDisabledControlJustPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) then
                                Controls.Down.Pressed = true
                                Citizen.CreateThread(function()
                                    RageUIv6.GoDown(Options)
                                    Citizen.Wait(175)
                                    while Controls.Down.Enabled and IsDisabledControlPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) do
                                        RageUIv6.GoDown(Options)
                                        Citizen.Wait(50)
                                    end
                                    Controls.Down.Pressed = false
                                end)
                                break
                            end
                        end
                    end
                end

                for i = 1, #ControlActions do
                    RageUIv6.GoActionControl(Controls, ControlActions[i])
                end

                RageUIv6.GoActionControlSlider(Controls, 'SliderLeft')
                RageUIv6.GoActionControlSlider(Controls, 'SliderRight')

                if Controls.Back.Enabled then
                    for Index = 1, #Controls.Back.Keys do
                        if not Controls.Back.Pressed then
                            if IsDisabledControlJustPressed(Controls.Back.Keys[Index][1], Controls.Back.Keys[Index][2]) then
                                Controls.Back.Pressed = true
                                Citizen.CreateThread(function()
                                    Citizen.Wait(175)
                                    Controls.Down.Pressed = false
                                end)
                                break
                            end
                        end
                    end
                end

            end
        end
    end
end

---Navigation
---@return nil
---@public
function RageUIv6.Navigation()
    local CurrentMenu = RageUIv6.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu() and (CurrentMenu.Display.Navigation) then
            if CurrentMenu.EnableMouse then
                SetMouseCursorActiveThisFrame()
            end
            if RageUIv6.Options > CurrentMenu.Pagination.Total then

                ---@type boolean
                local UpHovered = false

                ---@type boolean
                local DownHovered = false

                if not CurrentMenu.SafeZoneSize then
                    CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }

                    if CurrentMenu.Safezone then
                        CurrentMenu.SafeZoneSize = RageUIv6.GetSafeZoneBounds()

                        SetScriptGfxAlign(76, 84)
                        SetScriptGfxAlignParams(0, 0, 0, 0)
                    end
                end

                if CurrentMenu.EnableMouse then
                    UpHovered = RageUIv6.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Height)
                    DownHovered = RageUIv6.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + RageUIv6.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Height)

                    if CurrentMenu.Controls.Click.Active then
                        if UpHovered then
                            RageUIv6.GoUp(RageUIv6.Options)
                        elseif DownHovered then
                            RageUIv6.GoDown(RageUIv6.Options)
                        end
                    end

                    if UpHovered then
                        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end

                    if DownHovered then
                        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + RageUIv6.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + RageUIv6.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end
                else
                    RenderRectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    RenderRectangle(CurrentMenu.X, CurrentMenu.Y + RageUIv6.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUIv6.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                end
                RenderSprite(RageUIv6.Settings.Items.Navigation.Arrows.Dictionary, RageUIv6.Settings.Items.Navigation.Arrows.Texture, CurrentMenu.X + RageUIv6.Settings.Items.Navigation.Arrows.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + RageUIv6.Settings.Items.Navigation.Arrows.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, RageUIv6.Settings.Items.Navigation.Arrows.Width, RageUIv6.Settings.Items.Navigation.Arrows.Height)
                RageUIv6.ItemOffset = RageUIv6.ItemOffset + (RageUIv6.Settings.Items.Navigation.Rectangle.Height * 2)
            end
        end
    end
end

---GoBack
---@return nil
---@public
function RageUIv6.GoBack()
    local CurrentMenu = RageUIv6.CurrentMenu
    if CurrentMenu ~= nil then
        local Audio = RageUIv6.Settings.Audio
        RageUIv6.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)
        if CurrentMenu.Parent ~= nil then
            if CurrentMenu.Parent() then
                RageUIv6.NextMenu = CurrentMenu.Parent
            else
                RageUIv6.NextMenu = nil
                RageUIv6.Visible(CurrentMenu, false)
            end
        else
            RageUIv6.NextMenu = nil
            RageUIv6.Visible(CurrentMenu, false)
        end
    end
end
