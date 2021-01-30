RageUI.BadgeStyle = {
    None = 1,
    BronzeMedal = 2,
    GoldMedal = 3,
    SilverMedal = 4,
    Alert = 5,
    Crown = 6,
    Ammo = 7,
    Armour = 8,
    Barber = 9,
    Clothes = 10,
    Franklin = 11,
    Bike = 12,
    Car = 13,
    Gun = 14,
    Heart = 15,
    Makeup = 16,
    Mask = 17,
    Michael = 18,
    Star = 19,
    Tattoo = 20,
    Trevor = 21,
    Lock = 22,
    Tick = 23
}

RageUI.BadgeTexture = {
    [1] = function()
        return ""
    end,
    [2] = function()
        return "mp_medal_bronze"
    end,
    [3] = function()
        return "mp_medal_gold"
    end,
    [4] = function()
        return "medal_silver"
    end,
    [5] = function()
        return "mp_alerttriangle"
    end,
    [6] = function()
        return "mp_hostcrown"
    end,
    [7] = function(Selected)
        if Selected then
            return "shop_ammo_icon_b"
        else
            return "shop_ammo_icon_a"
        end
    end,
    [8] = function(Selected)
        if Selected then
            return "shop_armour_icon_b"
        else
            return "shop_armour_icon_a"
        end
    end,
    [9] = function(Selected)
        if Selected then
            return "shop_barber_icon_b"
        else
            return "shop_barber_icon_a"
        end
    end,
    [10] = function(Selected)
        if Selected then
            return "shop_clothing_icon_b"
        else
            return "shop_clothing_icon_a"
        end
    end,
    [11] = function(Selected)
        if Selected then
            return "shop_franklin_icon_b"
        else
            return "shop_franklin_icon_a"
        end
    end,
    [12] = function(Selected)
        if Selected then
            return "shop_garage_bike_icon_b"
        else
            return "shop_garage_bike_icon_a"
        end
    end,
    [13] = function(Selected)
        if Selected then
            return "shop_garage_icon_b"
        else
            return "shop_garage_icon_a"
        end
    end,
    [14] = function(Selected)
        if Selected then
            return "shop_gunclub_icon_b"
        else
            return "shop_gunclub_icon_a"
        end
    end,
    [15] = function(Selected)
        if Selected then
            return "shop_health_icon_b"
        else
            return "shop_health_icon_a"
        end
    end,
    [16] = function(Selected)
        if Selected then
            return "shop_makeup_icon_b"
        else
            return "shop_makeup_icon_a"
        end
    end,
    [17] = function(Selected)
        if Selected then
            return "shop_mask_icon_b"
        else
            return "shop_mask_icon_a"
        end
    end,
    [18] = function(Selected)
        if Selected then
            return "shop_michael_icon_b"
        else
            return "shop_michael_icon_a"
        end
    end,
    [19] = function()
        return "shop_new_star"
    end,
    [20] = function(Selected)
        if Selected then
            return "shop_tattoos_icon_b"
        else
            return "shop_tattoos_icon_a"
        end
    end,
    [21] = function(Selected)
        if Selected then
            return "shop_trevor_icon_b"
        else
            return "shop_trevor_icon_a"
        end
    end,
    [22] = function()
        return "shop_lock"
    end,
    [23] = function()
        return "shop_tick_icon"
    end,
}

RageUI.BadgeDictionary = {
    [1] = function(Selected)
        if Selected then
            return "commonmenu"
        else
            return "commonmenu"
        end
    end,
}

RageUI.BadgeColour = {
    [6] = function(Selected)
        if Selected then
            return 0, 0, 0, 255
        else
            return 255, 255, 255, 255
        end
    end,
    [22] = function(Selected)
        if Selected then
            return 0, 0, 0, 255
        else
            return 255, 255, 255, 255
        end
    end,
    [23] = function(Selected)
        if Selected then
            return 0, 0, 0, 255
        else
            return 255, 255, 255, 255
        end
    end,
}

---GetBadgeTexture
---@param Badge string
---@param Selected boolean
---@return table
---@public
function RageUI.GetBadgeTexture(Badge, Selected)
    if RageUI.BadgeTexture[Badge] then
        return RageUI.BadgeTexture[Badge](Selected)
    else
        return ""
    end
end


function RageUI.CurrentIsEqualTo(Current, To, Style, DefaultStyle)
    if (Current == To) then
        return Style;
    else
        return DefaultStyle or {};
    end
end

---GetBadgeDictionary
---@param Badge string
---@param Selected boolean
---@return table
---@public
function RageUI.GetBadgeDictionary(Badge, Selected)
    if RageUI.BadgeDictionary[Badge] then
        return RageUI.BadgeDictionary[Badge](Selected)
    else
        return "commonmenu"
    end
end

---GetBadgeColour
---@param Badge string
---@param Selected boolean
---@return table
---@public
function RageUI.GetBadgeColour(Badge, Selected)
    if RageUI.BadgeColour[Badge] then
        return RageUI.BadgeColour[Badge](Selected)
    else
        return 255, 255, 255, 255
    end
end
