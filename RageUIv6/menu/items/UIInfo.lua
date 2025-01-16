function RageUIv6.Info(Title, RightText, LeftText)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText("~h~" .. Title .. "~h~", 390 + 100, 75, 0, 0.36, 255, 255, 255, 255, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 390 + 100, Title ~= nil and 106, 10, 0.28, 255, 255, 255, 255, 0)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 390 + 420 + 100, Title ~= nil and 106, 200, 0.28, 255, 255, 255, 255, 2)
    end
    RenderRectangle(385 + 100, 70, 430, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 125)
end