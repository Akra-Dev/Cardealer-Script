---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 500, Height = 43 },
    Text = { X = 30, Y = 7, Scale = 0.26 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 375, Y = 0, Width = 40, Height = 40 },
    RightText = { X = 395, Y = 7, Scale = 0.26 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---@type table
local SettingsCheckbox = {
    Dictionary = "commonmenu", Textures = {
        "shop_box_blank", -- 1
        "shop_box_tickb", -- 2
        "shop_box_blank", -- 3
        "shop_box_tick", -- 4
        "shop_box_crossb", -- 5
        "shop_box_cross", -- 6
    },
    X = 360, Y = -4.3, Width = 45, Height = 45
}

RageUIv6.CheckboxStyle = {
    Tick = 1,
    Cross = 2
}

---StyleCheckBox
---@param Selected number
---@param Checked boolean
---@param Box number
---@param BoxSelect number
---@return nil
local function StyleCheckBox(Selected, Checked, Box, BoxSelect, OffSet)
    ---@type table
    local CurrentMenu = RageUIv6.CurrentMenu;
    if OffSet == nil then
        OffSet = 0
    end
    if Selected then
        if Checked then
            RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[5], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        else
            RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[1], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        end
    else
        if Checked then
            RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[6], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        else
            RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[3], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        end
    end
end


function RageUIv6.Checkbox(Label, Description, Checked, Style, Actions)
    ---@type table
    local CurrentMenu = RageUIv6.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu() then

            ---@type number
            local Option = RageUIv6.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                ---@type number
                local Selected = CurrentMenu.Index == Option
                local LeftBadgeOffset = ((Style.LeftBadge == RageUIv6.BadgeStyle.None or Style.LeftBadge == nil) and 0 or 27)
                local RightBadgeOffset = ((Style.RightBadge == RageUIv6.BadgeStyle.None or Style.RightBadge == nil) and 0 or 32)
                local BoxOffset = 0
                RageUIv6.ItemsSafeZone(CurrentMenu)

                local Hovered = false;

                ---@type boolean
                if CurrentMenu.EnableMouse == true and (CurrentMenu.CursorStyle == 0) or (CurrentMenu.CursorStyle == 1) then
                    Hovered = RageUIv6.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton);
                end
                if Selected then
                    RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X + 15, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset -30, SettingsButton.SelectedSprite.Height)
                end

                if type(Style) == "table" then
                    if Style.Enabled == true or Style.Enabled == nil then
                        if Selected then
                            RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)
                        else
                            RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)
                        end
                        if type(Style) == 'table' then
                            if Style.LeftBadge ~= nil then
                                if Style.LeftBadge ~= RageUIv6.BadgeStyle.None then
                                    local BadgeData = Style.LeftBadge(Selected)
                                    RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                                end
                            end
                            if Style.RightBadge ~= nil then
                                if Style.RightBadge ~= RageUIv6.BadgeStyle.None then
                                    local BadgeData = Style.RightBadge(Selected)
                                    RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                                end
                            end
                        end
                    else
                        ---@type table
                        local LeftBadge = RageUIv6.BadgeStyle.Lock
                        ---@type number
                        local LeftBadgeOffset = ((LeftBadge == RageUIv6.BadgeStyle.None or LeftBadge == nil) and 0 or 27)

                        if Selected then
                            RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)
                        else
                            RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
                        end

                        if LeftBadge ~= RageUIv6.BadgeStyle.None and LeftBadge ~= nil then
                            local BadgeData = LeftBadge(Selected)

                            RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour.A or 255)
                        end
                    end

                    if Style.Enabled == true or Style.Enabled == nil then
                        if Selected then
                            if Style.RightLabel ~= nil and Style.RightLabel ~= "" then

                                RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, 0, SettingsButton.RightText.Scale, 245, 245, 245, 255, 2)
                                BoxOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                            end
                        else
                            if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                                RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, 0, SettingsButton.RightText.Scale, 245, 245, 245, 255, 2)
                                BoxOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                            end
                        end
                    end

                    BoxOffset = RightBadgeOffset + BoxOffset
                    if Style.Style ~= nil then
                        if Style.Style == RageUIv6.CheckboxStyle.Tick then
                            StyleCheckBox(Selected, Checked, 2, 4, BoxOffset)
                        elseif Style.Style == RageUIv6.CheckboxStyle.Cross then
                            StyleCheckBox(Selected, Checked, 5, 6, BoxOffset)
                        else
                            StyleCheckBox(Selected, Checked, 2, 4, BoxOffset)
                        end
                    else
                        StyleCheckBox(Selected, Checked, 2, 4, BoxOffset)
                    end

                    if Selected and (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and (Style.Enabled == true or Style.Enabled == nil) then
                        local Audio = RageUIv6.Settings.Audio
                        RageUIv6.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
                        Checked = not Checked
                        if (Checked) then
                            if (Actions.onChecked ~= nil) then
                                Actions.onChecked();
                            end
                        else
                            if (Actions.onUnChecked ~= nil) then
                                Actions.onUnChecked();
                            end
                        end
                    end
                else
                    error("UICheckBox Style is not a `table`")
                end

                RageUIv6.ItemOffset = RageUIv6.ItemOffset + SettingsButton.Rectangle.Height

                RageUIv6.ItemsDescription(CurrentMenu, Description, Selected)

                if (Actions.onSelected ~= nil) and (Selected) then
                    Actions.onSelected(Checked);
                end

            end
            RageUIv6.Options = RageUIv6.Options + 1
        end
    end
end


