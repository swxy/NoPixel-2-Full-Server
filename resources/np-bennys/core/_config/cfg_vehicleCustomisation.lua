--[[
cfg_vehicleCustomisation.lua
Configuration file that contains information regarding the customisation of the vehicles.
]]

--Set to 0 to have all the upgrades.
maxVehiclePerformanceUpgrades = 3

vehicleBaseRepairCost = 400
vehicleRepairCostMultiplier = 1

vehicleCustomisationPrices =
{
    cosmetics = 
    {
        price = 400
    },
    respray = 
    {
        price = 500
    },
    performance = 
    {
        prices = 
        {
            0,
            3250,
            5500,
            10450,
            15250,
            20500
        }
    },
    turbo = 
    {
        price = 15000
    },
    wheels = 
    {
        price = 400
    },
    customwheels = 
    {
        price = 600
    },
    wheelsmoke = 
    {
        price = 400
    },
    windowtint = 
    {
        price = 400
    },
    neonside = 
    {
        price = 100
    },
    neoncolours = 
    {
        price = 500
    },
    headlights = 
    {
        price = 100
    },
    xenoncolours = 
    {
        price = 500
    },
    oldlivery = 
    {
        price = 100
    },
    plateindex = 
    {
        price = 1000
    }
}

vehicleCustomisation = 
{
    {
        category = "Spoiler",
        id = 0
    },
    {
        category = "Front Bumper",
        id = 1
    },
    {
        category = "Rear Bumper",
        id = 2
    },
    {
        category = "Side Skirt",
        id = 3
    },
    {
        category = "Exhaust",
        id = 4
    },
    {
        category = "Roll Cage",
        id = 5
    },
    {
        category = "Grille",
        id = 6
    },
    {
        category = "Hood",
        id = 7
    },
    {
        category = "Left Fender",
        id = 8
    },
    {
        category = "Right Fender",
        id = 9
    },
    {
        category = "Roof",
        id = 10
    },
    {
        category = "Vanity Plates",
        id = 25
    },
    {
        category = "Trim A",
        id = 27
    },
    {
        category = "Ornaments",
        id = 28
    },
    {
        category = "Dashboard",
        id = 29
    },
    {
        category = "Dial",
        id = 30
    },
    {
        category = "Door Speaker",
        id = 31
    },
    {
        category = "Seats",
        id = 32
    },
    {
        category = "Steering Wheel",
        id = 33
    },
    {
        category = "Shifter Leaver",
        id = 34
    },
    {
        category = "Plaque",
        id = 35
    },
    {
        category = "Speaker",
        id = 36
    },
    {
        category = "Trunk",
        id = 37
    },
    {
        category = "Hydraulic",
        id = 38
    },
    {
        category = "Engine Block",
        id = 39
    },
    {
        category = "Air Filter",
        id = 40
    },
    {
        category = "Strut",
        id = 41
    },
    {
        category = "Arch Cover",
        id = 42
    },
    {
        category = "Aerial",
        id = 43
    },
    {
        category = "Trim B",
        id = 44
    },
    {
        category = "Fuel Tank",
        id = 45
    },
    {
        category = "Window",
        id = 46
    },
    {
        category = "Livery",
        id = 48
    },
    {
        category = "Horns",
        id = 14,
        hornNames = 
        {
            {name = "Truck Horn", id = 0},
            {name = "Cop Horn", id = 1},
            {name = "Clown Horn", id = 2},
            {name = "Musical Horn 1", id = 3},
            {name = "Musical Horn 2", id = 4},
            {name = "Musical Horn 3", id = 5},
            {name = "Musical Horn 4", id = 6},
            {name = "Musical Horn 5", id = 7},
            {name = "Sad Trombone", id = 8},
            {name = "Classical Horn 1", id = 9},
            {name = "Classical Horn 2", id = 10},
            {name = "Classical Horn 3", id = 11},
            {name = "Classical Horn 4", id = 12},
            {name = "Classical Horn 5", id = 13},
            {name = "Classical Horn 6", id = 14},
            {name = "Classical Horn 7", id = 15},
            {name = "Scale - Do", id = 16},
            {name = "Scale - Re", id = 17},
            {name = "Scale - Mi", id = 18},
            {name = "Scale - Fa", id = 19},
            {name = "Scale - Sol", id = 20},
            {name = "Scale - La", id = 21},
            {name = "Scale - Ti", id = 22},
            {name = "Scale - Do", id = 23},
            {name = "Jazz Horn 1", id = 24},
            {name = "Jazz Horn 2", id = 25},
            {name = "Jazz Horn 3", id = 26},
            {name = "Jazz Horn Loop", id = 27},
            {name = "Star Spangled Banner 1", id = 28},
            {name = "Star Spangled Banner 2", id = 29},
            {name = "Star Spangled Banner 3", id = 30},
            {name = "Star Spangled Banner 4", id = 31},
            {name = "Classical Horn 8 Loop", id = 32},
            {name = "Classical Horn 9 Loop", id = 33},
            {name = "Classical Horn 10 Loop", id = 34},
            {name = "Classical Horn 8", id = 35},
            {name = "Classical Horn 9", id = 36},
            {name = "Classical Horn 10", id = 37},
            {name = "Funeral Loop", id = 38},
            {name = "Funeral", id = 39},
            {name = "Spooky Loop", id = 40},
            {name = "Spooky", id = 41},
            {name = "San Andreas Loop", id = 42},
            {name = "San Andreas", id = 43},
            {name = "Liberty City Loop", id = 44},
            {name = "Liberty City", id = 45},
            {name = "Festive 1 Loop", id = 46},
            {name = "Festive 1", id = 47},
            {name = "Festive 2 Loop", id = 48},
            {name = "Festive 2", id = 49},
            {name = "Festive 3 Loop", id = 50},
            {name = "Festive 3", id = 51}
        }
    },
    {
        category = "Engine Upgrade",
        id = 11
    },
    {
        category = "Brake Upgrade",
        id = 12
    },
    {
        category = "Transmission Upgrade",
        id = 13
    },
    {
        category = "Suspension Upgrade",
        id = 15
    },
    {
        category = "Armour Upgrade",
        id = 16
    },
    {
        category = "Turbo Upgrade",
        id = 18
    }
}

vehicleWindowTintOptions = 
{
    {
        name = "None",
        id = 0
    },
    {
        name = "Pure Black",
        id = 1    
    },
    {
        name = "Darksmoke",
        id = 2
    },
    {
        name = "Lightsmoke",
        id = 3
    }
}

vehicleWheelOptions = 
{
    {
        category = "Custom Tyres",
        id = -1,
        wheelID = 23
    },
    {
        category = "Tyre Smoke",
        id = 20,
        wheelID = 23
    },
    {
        category = "Sport",
        id = 0,
        wheelID = 23
    },
    {
        category = "Muscle",
        id = 1,
        wheelID = 23
    },
    {
        category = "Lowrider",
        id = 2,
        wheelID = 23
    },
    {
        category = "SUV",
        id = 3,
        wheelID = 23
    },
    {
        category = "Offroad",
        id = 4,
        wheelID = 23
    },
    {
        category = "Tuner",
        id = 5,
        wheelID = 23
    },
    {
        category = "Motorcycle",
        id = 6,
        wheelID = 23
    },
    {
        category = "Highend",
        id = 7,
        wheelID = 23
    }
}

vehicleTyreSmokeOptions = 
{
    {name = "White Smoke", r = 254, g = 254, b = 254},
    {name = "Black Smoke", r = 1, g = 1, b = 1},
    {name = "Blue Smoke", r = 0, g = 150, b = 255},
    {name = "Yellow Smoke", r = 255, g = 255, b = 50},
    {name = "Orange Smoke", r = 255, g = 153, b = 51},
    {name = "Red Smoke", r = 255, g = 10, b = 10},
    {name = "Green Smoke", r = 10, g = 255, b = 10},
    {name = "Purple Smoke", r = 153, g = 10, b = 153},
    {name = "Pink Smoke", r = 255, g = 102, b = 178},
    {name = "Gray Smoke", r = 128, g = 128, b = 128}
}

vehicleResprayCategories = 
{
    {
        category = "Primary Colour",
        id = 0
    },
    {
        category = "Secondary Colour",
        id = 1
    },
    {
        category = "Pearlescent Colour",
        id = 2
    },
    {
        category = "Wheel Colour",
        id = 3
    },
    {
        category = "Dashboard Colour",
        id = 4
    },
    {
        category = "Interior Colour",
        id = 5
    }
}

vehicleResprayOptions =
{
    --[[{
        category = "Classic",
        id = 0,
        colours =
        {
            {name = "Black", id = 0},
            {name = "Carbon Black", id = 147},
            {name = "Graphite", id = 1},
            {name = "Anhracite Black", id = 11},
            {name = "Black Steel", id = 11},
            {name = "Dark Steel", id = 3},
            {name = "Silver", id = 4},
            {name = "Bluish Silver", id = 5},
            {name = "Rolled Steel", id = 6},
            {name = "Shadow Silver", id = 7},
            {name = "Stone Silver", id = 8},
            {name = "Midnight Silver", id = 9},
            {name = "Cast Iron Silver", id = 10},
            {name = "Red", id = 27},
            {name = "Torino Red", id = 28},
            {name = "Formula Red", id = 29},
            {name = "Lava Red", id = 150},
            {name = "Blaze Red", id = 30},
            {name = "Grace Red", id = 31},
            {name = "Garnet Red", id = 32},
            {name = "Sunset Red", id = 33},
            {name = "Cabernet Red", id = 34},
            {name = "Wine Red", id = 143},
            {name = "Candy Red", id = 35},
            {name = "Hot Pink", id = 135},
            {name = "Pfsiter Pink", id = 137},
            {name = "Salmon Pink", id = 136},
            {name = "Sunrise Orange", id = 36},
            {name = "Orange", id = 38},
            {name = "Bright Orange", id = 138},
            {name = "Gold", id = 99},
            {name = "Bronze", id = 90},
            {name = "Yellow", id = 88},
            {name = "Race Yellow", id = 89},
            {name = "Dew Yellow", id = 91},
            {name = "Dark Green", id = 49},
            {name = "Racing Green", id = 50},
            {name = "Sea Green", id = 51},
            {name = "Olive Green", id = 52},
            {name = "Bright Green", id = 53},
            {name = "Gasoline Green", id = 54},
            {name = "Lime Green", id = 92},
            {name = "Midnight Blue", id = 141},
            {name = "Galaxy Blue", id = 61},
            {name = "Dark Blue", id = 62},
            {name = "Saxon Blue", id = 63},
            {name = "Blue", id = 64},
            {name = "Mariner Blue", id = 65},
            {name = "Harbor Blue", id = 66},
            {name = "Diamond Blue", id = 67},
            {name = "Surf Blue", id = 68},
            {name = "Nautical Blue", id = 69},
            {name = "Racing Blue", id = 73},
            {name = "Ultra Blue", id = 70},
            {name = "Light Blue", id = 74},
            {name = "Chocolate Brown", id = 96},
            {name = "Bison Brown", id = 101},
            {name = "Creeen Brown", id = 95},
            {name = "Feltzer Brown", id = 94},
            {name = "Maple Brown", id = 97},
            {name = "Beechwood Brown", id = 103},
            {name = "Sienna Brown", id = 104},
            {name = "Saddle Brown", id = 98},
            {name = "Moss Brown", id = 100},
            {name = "Woodbeech Brown", id = 102},
            {name = "Straw Brown", id = 99},
            {name = "Sandy Brown", id = 105},
            {name = "Bleached Brown", id = 106},
            {name = "Schafter Purple", id = 71},
            {name = "Spinnaker Purple", id = 72},
            {name = "Midnight Purple", id = 142},
            {name = "Bright Purple", id = 145},
            {name = "Cream", id = 107},
            {name = "Ice White", id = 111},
            {name = "Frost White", id = 112}
        }
    },]]
    {
        category = "Metallic",
        id = 1,
        colours = 
        {
            {name = "Black", id = 0},
            {name = "Carbon Black", id = 147},
            {name = "Graphite", id = 1},
            {name = "Anhracite Black", id = 11},
            {name = "Black Steel", id = 11},
            {name = "Dark Steel", id = 3},
            {name = "Silver", id = 4},
            {name = "Bluish Silver", id = 5},
            {name = "Rolled Steel", id = 6},
            {name = "Shadow Silver", id = 7},
            {name = "Stone Silver", id = 8},
            {name = "Midnight Silver", id = 9},
            {name = "Cast Iron Silver", id = 10},
            {name = "Red", id = 27},
            {name = "Torino Red", id = 28},
            {name = "Formula Red", id = 29},
            {name = "Lava Red", id = 150},
            {name = "Blaze Red", id = 30},
            {name = "Grace Red", id = 31},
            {name = "Garnet Red", id = 32},
            {name = "Sunset Red", id = 33},
            {name = "Cabernet Red", id = 34},
            {name = "Wine Red", id = 143},
            {name = "Candy Red", id = 35},
            {name = "Hot Pink", id = 135},
            {name = "Pfsiter Pink", id = 137},
            {name = "Salmon Pink", id = 136},
            {name = "Sunrise Orange", id = 36},
            {name = "Orange", id = 38},
            {name = "Bright Orange", id = 138},
            {name = "Gold", id = 99},
            {name = "Bronze", id = 90},
            {name = "Yellow", id = 88},
            {name = "Race Yellow", id = 89},
            {name = "Dew Yellow", id = 91},
            {name = "Dark Green", id = 49},
            {name = "Racing Green", id = 50},
            {name = "Sea Green", id = 51},
            {name = "Olive Green", id = 52},
            {name = "Bright Green", id = 53},
            {name = "Gasoline Green", id = 54},
            {name = "Lime Green", id = 92},
            {name = "Midnight Blue", id = 141},
            {name = "Galaxy Blue", id = 61},
            {name = "Dark Blue", id = 62},
            {name = "Saxon Blue", id = 63},
            {name = "Blue", id = 64},
            {name = "Mariner Blue", id = 65},
            {name = "Harbor Blue", id = 66},
            {name = "Diamond Blue", id = 67},
            {name = "Surf Blue", id = 68},
            {name = "Nautical Blue", id = 69},
            {name = "Racing Blue", id = 73},
            {name = "Ultra Blue", id = 70},
            {name = "Light Blue", id = 74},
            {name = "Chocolate Brown", id = 96},
            {name = "Bison Brown", id = 101},
            {name = "Creeen Brown", id = 95},
            {name = "Feltzer Brown", id = 94},
            {name = "Maple Brown", id = 97},
            {name = "Beechwood Brown", id = 103},
            {name = "Sienna Brown", id = 104},
            {name = "Saddle Brown", id = 98},
            {name = "Moss Brown", id = 100},
            {name = "Woodbeech Brown", id = 102},
            {name = "Straw Brown", id = 99},
            {name = "Sandy Brown", id = 105},
            {name = "Bleached Brown", id = 106},
            {name = "Schafter Purple", id = 71},
            {name = "Spinnaker Purple", id = 72},
            {name = "Midnight Purple", id = 142},
            {name = "Bright Purple", id = 145},
            {name = "Cream", id = 107},
            {name = "Ice White", id = 111},
            {name = "Frost White", id = 112}
        }
    },
    {
        category = "Matte",
        id = 2,
        colours = 
        {
            {name = "Black", id = 12},
            {name = "Gray", id = 13},
            {name = "Light Gray", id = 14},
            {name = "Ice White", id = 131},
            {name = "Blue", id = 83},
            {name = "Dark Blue", id = 82},
            {name = "Midnight Blue", id = 84},
            {name = "Midnight Purple", id = 149},
            {name = "Schafter Purple", id = 148},
            {name = "Red", id = 39},
            {name = "Dark Red", id = 40},
            {name = "Orange", id = 41},
            {name = "Yellow", id = 42},
            {name = "Lime Green", id = 55},
            {name = "Green", id = 128},
            {name = "Forest Green", id = 151},
            {name = "Foliage Green", id = 155},
            {name = "Olive Darb", id = 152},
            {name = "Dark Earth", id = 153},
            {name = "Desert Tan", id = 154}
        }
    },
    {
        category = "Metals",
        id = 3,
        colours = 
        {
            {name = "Brushed Steel", id = 117},
            {name = "Brushed Black Steel", id = 118},
            {name = "Brushed Aluminium", id = 119},
            {name = "Pure Gold", id = 158},
            {name = "Brushed Gold", id = 159},
            {name = "Chrome", id = 120}
        }
    }
}

vehicleNeonOptions = 
{
    category = "Neons",
    neonTypes = 
    {
        {name = "Front Neon", id = 2},
        {name = "Rear Neon", id = 3},
        {name = "Left Neon", id = 0},
        {name = "Right Neon", id = 1}
    },
    neonColours = 
    {
        {name = "White", r = 222, g = 222, b = 255},
        {name = "Blue", r = 2, g = 21, b = 255},
        {name = "Electric Blue", r = 3, g = 83, b = 255},
        {name = "Mint Green", r = 0, g = 255, b = 140},
        {name = "Lime Green", r = 94, g = 255, b = 1},
        {name = "Yellow", r = 255, g = 255, b = 0},
        {name = "Golden Shower", r = 255, g = 150, b = 0},
        {name = "Orange", r = 255, g = 62, b = 0},
        {name = "Red", r = 255, g = 1, b = 1},
        {name = "Pony Pink", r = 255, g = 50, b = 100},
        {name = "Hot Pink", r = 255, g = 5, b = 190},
        {name = "Purple", r = 35, g = 1, b = 255},
        {name = "Blacklight", r = 15, g = 3, b = 255}
    }
}

vehicleXenonOptions = 
{
    xenonColours = 
    {
        {name = "Stock", id = 255},
        {name = "White", id = 0},
        {name = "Blue", id = 1},
        {name = "Electric Blue", id = 2},
        {name = "Mint Green", id = 3},
        {name = "Lime Green", id = 4},
        {name = "Yellow", id = 5},
        {name = "Golden Shower", id = 6},
        {name = "Orange", id = 7},
        {name = "Red", id = 8},
        {name = "Pony Pink", id = 9},
        {name = "Hot Pink", id = 10},
        {name = "Purple", id = 11},
        {name = "Blacklight", id = 12}
    }
}

