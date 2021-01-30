local GridPanelHorizontal = {
    Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 275 },
    Grid = { Dictionary = "RageUI", Texture = "horizontal_grid", X = 115.5, Y = 47.5, Width = 200, Height = 200 },
    Circle = { Dictionary = "mpinventory", Texture = "in_world_circle", X = 115.5, Y = 47.5, Width = 20, Height = 20 },
    Text = {
        Left = { X = 57.75, Y = 130, Scale = 0.35 },
        Right = { X = 373.25, Y = 130, Scale = 0.35 },
    },
}

---GridPanelVertical
---@param X number
---@param TopText string
---@param BottomText string
---@param LeftText string
---@param RightText string
---@param Callback table
---@return table
---@public
function RageUI.GridPanelHorizontal(X, LeftText, RightText, Callback)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then

            ---@type boolean
            local Hovered = RageUI.IsMouseInBounds(CurrentMenu.X + GridPanelHorizontal.Grid.X + CurrentMenu.SafeZoneSize.X + 20, CurrentMenu.Y + GridPanelHorizontal.Grid.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 20, GridPanelHorizontal.Grid.Width + CurrentMenu.WidthOffset - 40, GridPanelHorizontal.Grid.Height - 40)

            ---@type boolean
            local Selected = false

            ---@type number
            local CircleX = CurrentMenu.X + GridPanelHorizontal.Grid.X + (CurrentMenu.WidthOffset / 2) + 20

            ---@type number
            local CircleY = CurrentMenu.Y + GridPanelHorizontal.Grid.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 20

            if X < 0.0 or X > 1.0 then
                X = 0.0
            end

            local Y = 0.5

            CircleX = CircleX + ((GridPanelHorizontal.Grid.Width - 40) * X) - (GridPanelHorizontal.Circle.Width / 2)
            CircleY = CircleY + ((GridPanelHorizontal.Grid.Height - 40) * Y) - (GridPanelHorizontal.Circle.Height / 2)

            RenderSprite(GridPanelHorizontal.Background.Dictionary, GridPanelHorizontal.Background.Texture, CurrentMenu.X, CurrentMenu.Y + GridPanelHorizontal.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, GridPanelHorizontal.Background.Width + CurrentMenu.WidthOffset, GridPanelHorizontal.Background.Height)
            RenderSprite(GridPanelHorizontal.Grid.Dictionary, GridPanelHorizontal.Grid.Texture, CurrentMenu.X + GridPanelHorizontal.Grid.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + GridPanelHorizontal.Grid.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, GridPanelHorizontal.Grid.Width, GridPanelHorizontal.Grid.Height)
            RenderSprite(GridPanelHorizontal.Circle.Dictionary, GridPanelHorizontal.Circle.Texture, CircleX, CircleY, GridPanelHorizontal.Circle.Width, GridPanelHorizontal.Circle.Height)

            RenderText(LeftText or "", CurrentMenu.X + GridPanelHorizontal.Text.Left.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + GridPanelHorizontal.Text.Left.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, GridPanelHorizontal.Text.Left.Scale, 245, 245, 245, 255, 1)
            RenderText(RightText or "", CurrentMenu.X + GridPanelHorizontal.Text.Right.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + GridPanelHorizontal.Text.Right.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, GridPanelHorizontal.Text.Right.Scale, 245, 245, 245, 255, 1)

            if Hovered then
                if IsDisabledControlPressed(0, 24) then
                    Selected = true

                    CircleX = math.round(GetControlNormal(0, 239) * 1920) - CurrentMenu.SafeZoneSize.X - (GridPanelHorizontal.Circle.Width / 2)

                    if CircleX > (CurrentMenu.X + GridPanelHorizontal.Grid.X + (CurrentMenu.WidthOffset / 2) + 20 + GridPanelHorizontal.Grid.Width - 40) then
                        CircleX = CurrentMenu.X + GridPanelHorizontal.Grid.X + (CurrentMenu.WidthOffset / 2) + 20 + GridPanelHorizontal.Grid.Width - 40
                    elseif CircleX < (CurrentMenu.X + GridPanelHorizontal.Grid.X + 20 - (GridPanelHorizontal.Circle.Width / 2)) then
                        CircleX = CurrentMenu.X + GridPanelHorizontal.Grid.X + 20 - (GridPanelHorizontal.Circle.Width / 2)
                    end

                    X = math.round((CircleX - (CurrentMenu.X + GridPanelHorizontal.Grid.X + (CurrentMenu.WidthOffset / 2) + 20) + (GridPanelHorizontal.Circle.Width / 2)) / (GridPanelHorizontal.Grid.Width - 40), 2)
                    if X > 1.0 then
                        X = 1.0
                    end
                end
            end
            RageUI.ItemOffset = RageUI.ItemOffset + GridPanelHorizontal.Background.Height + GridPanelHorizontal.Background.Y
            if Hovered and Selected then
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].Slider.audioName, Audio[Audio.Use].Slider.audioRef, true)
            end
            Callback(Hovered, Selected, X)
        end
    end
end

