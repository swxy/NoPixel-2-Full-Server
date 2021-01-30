---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
    RightText = { X = 420, Y = 4, Scale = 0.35 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

local SettingsProgress = {
    Background = { X = 8, Y = 33, Width = 415, Height = 20 },
    Bar = { X = 11.75, Y = 36.75, Width = 407.5, Height = 12.5 },
    Height = 60
}

---Progress
---@param Label string
---@param ProgressStart number
---@param ProgressMax number
---@param Description string
---@param Counter number
---@param Enabled boolean
---@param Callback function
---@return nil
---@public
function RageUI.Progress(Label, ProgressStart, ProgressMax, Description, Counter, Enabled, Callback)

    ---@type table
    local CurrentMenu = RageUI.CurrentMenu;

    if CurrentMenu ~= nil then
        if CurrentMenu() then

            local Items = {}
            for i = 1, ProgressMax do
                table.insert(Items, i)
            end

            ---@type number
            local Option = RageUI.Options + 1

            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then

                ---@type number
                local Selected = CurrentMenu.Index == Option

                ---@type boolean
                local ProgressHovered = false

                RageUI.ItemsSafeZone(CurrentMenu)

                local Hovered = false;

                ---@type boolean
                if CurrentMenu.EnableMouse == true then
                    Hovered = RageUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton);
                end

                local ProgressText = (Counter and ProgressStart .. "/" .. #Items or (type(Items[ProgressStart]) == "table") and tostring(Items[ProgressStart].Name) or tostring(Items[ProgressStart]))

                if Selected then
                    RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsProgress.Height)
                    ProgressHovered = RageUI.IsMouseInBounds(CurrentMenu.X + SettingsProgress.Bar.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + SettingsProgress.Bar.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset - 12, SettingsProgress.Bar.Width + CurrentMenu.WidthOffset, SettingsProgress.Bar.Height + 24)
                end

                if Enabled == true or Enabled == nil then
                    if Selected then
                        RenderText(ProgressText, CurrentMenu.X + SettingsButton.RightText.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, 0, 0, 0, 255, 2)

                        RenderText(Label, CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)

                        RenderRectangle(CurrentMenu.X + SettingsProgress.Background.X, CurrentMenu.Y + SettingsProgress.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsProgress.Background.Width + CurrentMenu.WidthOffset, SettingsProgress.Background.Height, 0, 0, 0, 255)
                        RenderRectangle(CurrentMenu.X + SettingsProgress.Bar.X, CurrentMenu.Y + SettingsProgress.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, ((ProgressStart / #Items) * (SettingsProgress.Bar.Width + CurrentMenu.WidthOffset)), SettingsProgress.Bar.Height, 240, 240, 240, 255)
                    else
                        RenderText(ProgressText, CurrentMenu.X + SettingsButton.RightText.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, 245, 245, 245, 255, 2)

                        RenderText(Label, CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)

                        RenderRectangle(CurrentMenu.X + SettingsProgress.Background.X, CurrentMenu.Y + SettingsProgress.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsProgress.Background.Width + CurrentMenu.WidthOffset, SettingsProgress.Background.Height, 240, 240, 240, 255)
                        RenderRectangle(CurrentMenu.X + SettingsProgress.Bar.X, CurrentMenu.Y + SettingsProgress.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, ((ProgressStart / #Items) * (SettingsProgress.Bar.Width + CurrentMenu.WidthOffset)), SettingsProgress.Bar.Height, 0, 0, 0, 255)
                    end
                else
                    RenderText(ProgressText, CurrentMenu.X + SettingsButton.RightText.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, 163, 159, 148, 255, 2)

                    RenderText(Label, CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
                    if Selected then
                        RenderRectangle(CurrentMenu.X + SettingsProgress.Background.X, CurrentMenu.Y + SettingsProgress.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsProgress.Background.Width + CurrentMenu.WidthOffset, SettingsProgress.Background.Height, 0, 0, 0, 255)
                    else
                        RenderRectangle(CurrentMenu.X + SettingsProgress.Background.X, CurrentMenu.Y + SettingsProgress.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsProgress.Background.Width + CurrentMenu.WidthOffset, SettingsProgress.Background.Height, 240, 240, 240, 255)
                    end
                end

                RageUI.ItemOffset = RageUI.ItemOffset + SettingsProgress.Height

                RageUI.ItemsDescription(CurrentMenu, Description, Selected);

                if Selected and CurrentMenu.Controls.Left.Active and not CurrentMenu.Controls.Right.Active then
                    ProgressStart = ProgressStart - 1

                    if ProgressStart < 0 then
                        ProgressStart = #Items
                    end

                    local Audio = RageUI.Settings.Audio
                    RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
                elseif Selected and CurrentMenu.Controls.Right.Active and not CurrentMenu.Controls.Left.Active then
                    ProgressStart = ProgressStart + 1

                    if ProgressStart > #Items then
                        ProgressStart = 0
                    end
                    local Audio = RageUI.Settings.Audio
                    RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
                end

                if Selected and (CurrentMenu.Controls.Select.Active or ((Hovered and CurrentMenu.Controls.Click.Active) and not ProgressHovered)) then
                    local Audio = RageUI.Settings.Audio
                    RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
                elseif Selected and (Hovered and CurrentMenu.Controls.Click.Active and ProgressHovered) then

                    ---@type number
                    local Progress = (math.round(GetControlNormal(0, 239) * 1920) - CurrentMenu.SafeZoneSize.X) - SettingsProgress.Bar.X

                    ---@type number
                    local Barsize = SettingsProgress.Bar.Width + CurrentMenu.WidthOffset

                    if Progress > Barsize then
                        Progress = Barsize
                    elseif Progress < 0 then
                        Progress = 0
                    end

                    ProgressStart = math.round(#Items * (Progress / Barsize))

                    if ProgressStart > #Items or ProgressStart < 0 then
                        ProgressStart = 0
                    end

                end

                if (Enabled) then
                    Callback(Hovered, Selected, ((CurrentMenu.Controls.Select.Active or ((Hovered and CurrentMenu.Controls.Click.Active) and not ProgressHovered)) and Selected), ProgressStart)
                end
            end
            RageUI.Options = RageUI.Options + 1

            Items = nil
        end
    end
end


