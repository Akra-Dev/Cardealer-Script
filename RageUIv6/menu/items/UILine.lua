local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38  },
    Line = { X = -35, Y = 15 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}


function RageUIv6.Line(Style)
    local CurrentMenu = RageUIv6.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUIv6.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                -- RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, 0, 0, 0, 150)
                -- RenderRectangle(CurrentMenu.X + SettingsButton.Line.X + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 60), CurrentMenu.Y + SettingsButton.Line.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, 300, 3, 0, 0, 0, 150)
                RenderRectangle(CurrentMenu.X + SettingsButton.Line.X + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 60), CurrentMenu.Y + SettingsButton.Line.Y + CurrentMenu.SubtitleHeight + RageUIv6.ItemOffset, 300, 3, 255, 0, 161, 255)

                RageUIv6.ItemOffset = RageUIv6.ItemOffset + SettingsButton.Rectangle.Height
                if (CurrentMenu.Index == Option) then
                    if (RageUIv6.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = RageUIv6.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end
            RageUIv6.Options = RageUIv6.Options + 1
        end
    end
end