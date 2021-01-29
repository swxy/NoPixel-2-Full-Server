RegisterNetEvent('FinishMoneyCheckForVeh')
RegisterNetEvent('vehshop:spawnVehicle')
local vehshop_blips = {}
local financedPlates = {}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local vehicle_price = 0
local backlock = false
local firstspawn = 0
local commissionbuy = 0
local insideVehShop = false
local rank = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
local currentCarSpawnLocation = 0
local ownerMenu = false

local vehshopDefault = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
				{name = "Cycles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Job Vehicles", description = ''},
			}
		},
		["jobvehicles"] = {
			title = "job vehicles",
			name = "job vehicles",
			buttons = {
				{name = "Taxi Cab", costs = 4000, description = {}, model = "taxi"},
				{name = "Flat Bed", costs = 4000, description = {}, model = "flatbed"},
				{name = "News Rumpo", costs = 4000, description = {}, model = "rumpo"},
				{name = "Food Truck New", costs = 4000, description = {}, model = "taco"},
			}
		},
		["cycles"] = {
			title = "cycles",
			name = "cycles",
			buttons = {
				{name = "BMX", costs = 150, description = {}, model = "bmx"},
				{name = "Cruiser", costs = 240, description = {}, model = "cruiser"},
				{name = "Fixter", costs = 270, description = {}, model = "fixter"},
				{name = "Scorcher", costs = 300, description = {}, model = "scorcher"},
				{name = "Pro 1", costs = 2500, description = {}, model = "tribike"},
				{name = "Pro 2", costs = 2600, description = {}, model = "tribike2"},
				{name = "Pro 3", costs = 2900, description = {}, model = "tribike3"},
			}
		},		
	}
}

vehshop = vehshopDefault
local vehshopOwner = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
				{name = "Motorcycles", description = ""},
				{name = "Cycles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Job Vehicles", description = ''},
				{name = "Compacts", description = ''},
				{name = "Coupes", description = ''},
				{name = "Sedans", description = ''},
				{name = "Sports", description = ''},
				{name = "Sports Classics", description = ''},
				{name = "Super", description = '', rank = 5},
				{name = "Muscle", description = ''},
				{name = "Off-Road", description = ''},
				{name = "SUVs", description = ''},
				{name = "Vans", description = ''},
			}
		},
		["jobvehicles"] = {
			title = "job vehicles",
			name = "job vehicles",
			buttons = {
				{name = "Taxi Cab", costs = 4000, description = {}, model = "taxi"},
		--		{name = "Flat Bed", costs = 4000, description = {}, model = "flatbed"},
		--		{name = "Flat Bed Deluxe", costs = 52000, description = {}, model = "flatbed3"},
				{name = "News Rumpo", costs = 4000, description = {}, model = "rumpo"},
			}
		},
		["compacts"] = {
			title = "compacts",
			name = "compacts",
			buttons = {			
				{name = "Blista", costs = 12000, description = {}, model = "blista"},
				{name = "Brioso R/A", costs = 22000, description = {}, model = "brioso"},
				{name = "Dilettante", costs = 7000, description = {}, model = "Dilettante"},
				{name = "Issi", costs = 14000, description = {}, model = "issi2"},
				{name = "Panto", costs = 8000, description = {}, model = "panto"},
				{name = "Prairie", costs = 8000, description = {}, model = "prairie"},
				{name = "Rhapsody", costs = 6000, description = {}, model = "rhapsody"},

				--GTAWiseGuy
				{name = "Issi Classic", costs = 60000, description = {}, model = "issi3"},
				{name = "Futo", costs = 25000, description = {}, model = "Futo"},
			}
		},
		["coupes"] = {
			title = "coupes",
			name = "coupes",
			buttons = {
				{name = "Cognoscenti Cabrio", costs = 180000, description = {}, model = "cogcabrio"},
				{name = "Exemplar", costs = 70000, description = {}, model = "exemplar"},
				{name = "F620", costs = 80000, description = {}, model = "f620"},
				{name = "Felon", costs = 40000, description = {}, model = "felon"},
				{name = "Felon GT", costs = 45000, description = {}, model = "felon2"},
				{name = "Jackal", costs = 36000, description = {}, model = "jackal"},
				{name = "Oracle", costs = 17000, description = {}, model = "oracle"},
				{name = "Oracle XS", costs = 18000, description = {}, model = "oracle2"},
				{name = "Sentinel", costs = 15000, description = {}, model = "sentinel"},
				{name = "Sentinel XS", costs = 17000, description = {}, model = "sentinel2"},
				{name = "Windsor", costs = 140000, description = {}, model = "windsor"},
				{name = "Windsor Drop", costs = 150000, description = {}, model = "windsor2"},
				{name = "Zion", costs = 6000, description = {}, model = "zion"},
				{name = "Zion Cabrio", costs = 12000, description = {}, model = "zion2"},
			}
		},
		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				{name = "9F", costs = 200000, description = {}, model = "ninef"},
				{name = "9F Cabrio", costs = 210000, description = {}, model = "ninef2"},
				{name = "Alpha", costs = 11000, description = {}, model = "alpha"},
				{name = "Banshee", costs = 140000, description = {}, model = "banshee"},
				{name = "Bestia GTS", costs = 160000, description = {}, model = "bestiagts"},

				{name = "Buffalo", costs = 15000, description = {}, model = "buffalo"},
				{name = "Buffalo S", costs = 19000, description = {}, model = "buffalo2"},
				{name = "Carbonizzare", costs = 225000, description = {}, model = "carbonizzare"},
				{name = "Comet", costs = 190000, description = {}, model = "comet2"},
				{name = "Coquette", costs = 138000, description = {}, model = "coquette"},
				{name = "Drift Tampa", costs = 250000, description = {}, model = "tampa2"},
				{name = "Feltzer", costs = 60000, description = {}, model = "feltzer2"},
				{name = "Furore GT", costs = 44800, description = {}, model = "furoregt"},
				{name = "Fusilade", costs = 15000, description = {}, model = "fusilade"},
				{name = "Jester", costs = 230000, description = {}, model = "jester"},
				{name = "Kuruma", costs = 95000, description = {}, model = "kuruma"},
				{name = "Lynx", costs = 135000, description = {}, model = "lynx"},
				{name = "Massacro", costs = 165000, description = {}, model = "massacro"},
				{name = "Omnis", costs = 121000, description = {}, model = "omnis"},
				{name = "Penumbra", costs = 9000, description = {}, model = "penumbra"},
				{name = "Rapid GT", costs = 45000, description = {}, model = "rapidgt"},
				{name = "Rapid GT Convertible", costs = 50000, description = {}, model = "rapidgt2"},
				{name = "Schafter V12", costs = 50000, description = {}, model = "schafter3"},
				{name = "Sultan", costs = 70000, description = {}, model = "sultan"},
				{name = "Surano", costs = 110000, description = {}, model = "surano"},
				{name = "Tropos", costs = 276000, description = {}, model = "tropos"},
				{name = "Verkierer", costs = 195000, description = {}, model = "verlierer2"},
				{name = "Neon", costs = 210000, description = {}, model = "npneon"}, -- doomsday Heist , handling done
				{name = "Comet SR", costs = 270000, description = {}, model = "comet5"}, -- doomsday Heist , handling done
				{name = "Sentinel Classic", costs = 80000, description = {}, model = "sentinel3"}, -- doomsday Heist , handling done
				{name = "Revolter", costs = 90000, description = {}, model = "revolter"}, -- doomsday Heist , handling done
				{name = "Streiter", costs = 230000, description = {}, model = "streiter"}, -- doomsday Heist , handling done
				{name = "Comet Safari", costs = 250000, description = {}, model = "comet4"}, -- doomsday Heist , handling done
				{name = "Pariah", costs = 180000, description = {}, model = "pariah"}, -- doomsday Heist , handling done
				{name = "Raiden", costs = 220000, description = {}, model = "raiden"}, -- doomsday Heist , handling done

				-- GTAWiseGuy
				{name = "Sentinel SG4", costs = 150000, description = {}, model = "sentinelsg4"},
				{name = "Elegy RH8", costs = 150000, description = {}, model = "elegy2"},
				--imports 
				{name = "Lamborghini Aventador LP700R", costs = 400000, description = {}, model = "lp700r"},
                {name = "Porsche 911 Turbo S", costs = 325000, description = {}, model = "911turbos"},
                {name = "Mazda RX7 RB", costs = 275000, description = {}, model = "rx7rb"},
                {name = "Subaru Impreza WRX", costs = 250000, description = {}, model = "subwrx"},
                {name = "Subaru WRX", costs = 240000, description = {}, model = "ff4wrx"},
                {name = "Ford Mustang RMod", costs = 375000, description = {}, model = "rmodmustang"},
                {name = "Honda Civic EG", costs = 250000, description = {}, model = "delsoleg"},
                {name = "Nissan Skyline R34 GTR", costs = 325000, description = {}, model = "fnf4r34"},
                {name = "Honda S2000", costs = 275000, description = {}, model = "ap2"},
				{name = "Mitsubishi Lancer Evolution X MR FQ-400", costs = 275000, description = {}, model = "evo10"},
				
				-- pack 2
				
                {name = "BMW i8", costs = 300000, description = {}, model = "acs8"},
                {name = "Datsun 510", costs = 325000, description = {}, model = "510"},

                -- pack 3

                {name = "Nissan GTR R35 LW", costs = 350000, description = {}, model = "LWGTR"},
                {name = "Toyota Supra Mk.IV", costs = 335000, description = {}, model = "a80"},
                {name = "Nissan 370Z", costs = 300000, description = {}, model = "370Z"},
                {name = "1966 Ford Mustang", costs = 275000, description = {}, model = "66fastback"},
                {name = "BMW M3 E46", costs = 250000, description = {}, model = "E46"},

				-- GTA Wise Guy new vehicles pack 1
				
                {name = "Mazda MX5 NA", costs = 200000, description = {}, model = "na6"},
                {name = "2019 Ford Mustang", costs = 350000, description = {}, model = "mustang19"},
                {name = "Yamaha R1", costs = 250000, description = {}, model = "r1"},
                {name = "Audi RS6", costs = 325000, description = {}, model = "audirs6tk"},
                {name = "Mercedes AMG GT63", costs = 375000, description = {}, model = "gt63"},
                {name = "1969 Dodge Charger", costs = 300000, description = {}, model = "69charger"},
                {name = "Corvette C7", costs = 350000, description = {}, model = "c7"},
				{name = "McLaren 650S LW", costs = 650000, description = {}, model = "650slw"},

				-- GTA Wise Guy new vehicles pack 2

				-- {name = "S14 RB Boss", costs = 650000, description = {}, model = "s14boss"},
				{name = "Mazda RX7 FD3S", costs = 275000, description = {}, model = "fnfrx7"},
				{name = "Nissan Silvia S15", costs = 300000, description = {}, model = "s15rb"},
				{name = "Honda Civic Type-R FK8", costs = 300000, description = {}, model = "fk8"},
				{name = "Ford Focus RS", costs = 285000, description = {}, model = "focusrs"},
				{name = "Ford Raptor F150", costs = 250000, description = {}, model = "f150"},
				{name = "Jeep Grand Cherokee SRT8", costs = 325000, description = {}, model = "srt8b"},
				{name = "Porsche Panamera Turbo", costs = 375000, description = {}, model = "panamera17turbo"},
				{name = "Camaro ZL1", costs = 350000, description = {}, model = "exor"},
				{name = "Porsche 911 GT3RS", costs = 390000, description = {}, model = "gt3rs"},
				-- {name = "Lamborghini Murcielago LP670", costs = 450000, description = {}, model = "lp670"},
				-- {name = "Schwartzer, costs = 80000, description = {}, model = "schwarzer"},
			}
		},
		["sportsclassics"] = {
			title = "sports classics",
			name = "sportsclassics",
			buttons = {
				{name = "Casco", costs = 280000, description = {}, model = "casco"},
				{name = "Coquette Classic", costs = 65000, description = {}, model = "coquette2"},
				{name = "JB 700", costs = 290000, description = {}, model = "jb700"},
				{name = "Pigalle", costs = 9000, description = {}, model = "pigalle"},
				{name = "Stinger", costs = 210000, description = {}, model = "stinger"},
				{name = "Stinger GT", costs = 275000, description = {}, model = "stingergt"},
				{name = "Stirling GT", costs = 275000, description = {}, model = "feltzer3"},

				{name = "Rapid GT Classic", costs = 100000, description = {}, model = "rapidgt3"}, -- smugglers run , handling done
				{name = "Retinue", costs = 110000, description = {}, model = "retinue"}, -- smugglers run , handling done
				{name = "Viseris", costs = 110000, description = {}, model = "viseris"}, -- doomsday Heist , handling done 
				{name = "190z", costs = 90000, description = {}, model = "z190"}, -- doomsday Heist , handling done
				{name = "GT500", costs = 120000, description = {}, model = "gt500"}, -- doomsday Heist , handling done
				{name = "Savestra", costs = 110000, description = {}, model = "savestra"}, -- doomsday Heist , handling done

				-- GTAWiseGuy
				{name = "Cheburek", costs = 30000, description = {}, model = "Cheburek"}, 
				{name = "Tornado Lowrider", costs = 40000, description = {}, model = "tornado5"}, 
				{name = "Buccaneer Lowrider", costs = 45000, description = {}, model = "buccaneer2"},
				{name = "Voodoo Lowrider", costs = 50000, description = {}, model = "voodoo"},
				{name = "Chino Lowrider", costs = 45000, description = {}, model = "chino2"},
				{name = "Moonbeam Lowrider", costs = 60000, description = {}, model = "moonbeam2"},
				-- {name = "Sabre GT Lowrider", costs = 275000, description = {}, model = "sabregt2"},
				-- {name = "Slamvan Lowrider", costs = 275000, description = {}, model = "slamvan3"},
				-- {name = "Virgo Lowrider", costs = 275000, description = {}, model = "virgo2"},
				{name = "Michelli GT", costs = 140000, description = {}, model = "michelli"},
				-- {name = "Fagaloa", costs = 60000, description = {}, model = "fagaloa"},
				-- {name = "Clique", costs = 275000, description = {}, model = "clique"},
				
			}
		},
		["super"] = {
			title = "super",
			name = "super",
			buttons = {
				-- {name = "Adder", costs = 1000000, description = {}, model = "adder"},
				-- {name = "Banshee 900R", costs = 365000, description = {}, model = "banshee2"},
				-- {name = "Bullet", costs = 355000, description = {}, model = "bullet"},
				-- {name = "Cheetah", costs = 650000, description = {}, model = "cheetah"},
				-- {name = "Entity XF", costs = 1495000, description = {}, model = "entityxf"},
				-- {name = "ETR1", costs = 2359500, description = {}, model = "sheava"},
				-- {name = "FMJ", costs = 1750000, description = {}, model = "fmj"},
				-- {name = "Infernus", costs = 250000, description = {}, model = "infernus"},
				-- {name = "Osiris", costs = 1550000, description = {}, model = "osiris"},
				-- {name = "RE-7B", costs = 3475000, description = {}, model = "le7b"},
				-- {name = "Reaper", costs = 295000, description = {}, model = "reaper"},
				-- {name = "Sultan RS", costs = 95000, description = {}, model = "sultanrs"},
				-- {name = "T20", costs = 2200000, description = {}, model = "t20"},
				-- {name = "Turismo R", costs = 2000000, description = {}, model = "turismor"},
				-- {name = "Tyrus", costs = 2550000, description = {}, model = "tyrus"},
				-- {name = "Vacca", costs = 150000, description = {}, model = "vacca"},
				-- {name = "Voltic", costs = 69000, description = {}, model = "voltic"},
				-- {name = "X80 Proto", costs = 3300000, description = {}, model = "prototipo"},
				-- {name = "Zentorno", costs = 725000, description = {}, model = "zentorno"},
				-- {name = "Cyclone", costs = 960000, description = {}, model = "cyclone"}, -- smugglers run , handling done
				-- {name = "Visione", costs = 895000, description = {}, model = "visione"}, -- smugglers run , handling done
				-- {name = "Autarch", costs = 2800000, description = {}, model = "autarch"}, -- doomsday Heist , handling done
				-- {name = "SC1", costs = 1050000, description = {}, model = "sc1"}, -- doomsday Heist , handling done

				-- GTAWiseGuy
				{name = "Turismo Classic", costs = 450000, description = {}, model = "turismo2"},
				{name = "WCR Patriot Stretch", costs = 150000, description = {}, model = "patriot2"},
				{name = "Scuffvan Lowrider", costs = 70000, description = {}, model = "minivan2"},

			}
		},
		["muscle"] = {
			title = "muscle",
			name = "muscle",
			buttons = {
				{name = "Blade", costs = 20000, description = {}, model = "blade"},
				{name = "Buccaneer", costs = 22000, description = {}, model = "buccaneer"},
				{name = "Chino", costs = 25000, description = {}, model = "chino"},
				{name = "Coquette BlackFin", costs = 99500, description = {}, model = "coquette3"},
				{name = "Dominator", costs = 35000, description = {}, model = "dominator"},
				{name = "Dukes", costs = 72000, description = {}, model = "dukes"},
				{name = "Gauntlet", costs = 39000, description = {}, model = "gauntlet"},
				{name = "Hotknife", costs = 69000, description = {}, model = "hotknife"},
				{name = "Faction", costs = 36000, description = {}, model = "faction"},
				{name = "Faction 2", costs = 42000, description = {}, model = "faction2"},
				{name = "Faction 3", costs = 42000, description = {}, model = "faction3"},
				{name = "Nightshade", costs = 85000, description = {}, model = "nightshade"},
				{name = "Picador", costs = 9000, description = {}, model = "picador"},
				{name = "Sabre Turbo", costs = 35000, description = {}, model = "sabregt"},
				{name = "Tampa", costs = 35000, description = {}, model = "tampa"},
				{name = "Virgo", costs = 15000, description = {}, model = "virgo"},
				{name = "Vigero", costs = 41000, description = {}, model = "vigero"},
				{name = "Hustler", costs = 7000, description = {}, model = "hustler"}, -- doomsday Heist , handling done
				{name = "Hermes", costs = 127000, description = {}, model = "hermes"}, -- doomsday Heist , handling done
				{name = "Yosemite", costs = 70000, description = {}, model = "yosemite"}, -- doomsday Heist , handling done

				-- GTA Wise Guy
				{name = "Phoenix", costs = 35000, description = {}, model = "Phoenix"},
				{name = "Ruiner", costs = 30000, description = {}, model = "ruiner"},
				{name = "Dominator GTX", costs = 180000, description = {}, model = "dominator3"},
				{name = "Vamos", costs = 140000, description = {}, model = "vamos"},
				-- {name = "Impaler", costs = 60000, description = {}, model = "impaler"},
				-- {name = "Tulip", costs = 60000, description = {}, model = "tulip"},
			}
		},
		["offroad"] = {
			title = "off-road",
			name = "off-road",
			buttons = {
				{name = "Bifta", costs = 75000, description = {}, model = "bifta"},
				{name = "Blazer", costs = 8000, description = {}, model = "blazer"},
				{name = "Brawler", costs = 71500, description = {}, model = "brawler"},
				{name = "Bubsta 6x6", costs = 159000, description = {}, model = "dubsta3"},
				{name = "Dune Buggy", costs = 5000, description = {}, model = "dune"},
				{name = "Rebel", costs = 22000, description = {}, model = "rebel2"},
				{name = "Sandking", costs = 38000, description = {}, model = "sandking"},
				{name = "Trophy Truck", costs = 210000, description = {}, model = "trophytruck"},
				{name = "Kamacho", costs = 280000, description = {}, model = "kamacho"}, -- doomsday Heist , handling done
				{name = "Riata", costs = 190000, description = {}, model = "riata"}, -- doomsday Heist , handling done
				
				--GTA Wise Guy
				{name = "Lifted Mesa", costs = 90000, description = {}, model = "mesa3"},
				{name = "Lego Car", costs = 40000, description = {}, model = "kalahari"},
				{name = "Street Blazer", costs = 35000, description = {}, model = "blazer4"},
			}
		},
		["suvs"] = {
			title = "suvs",
			name = "suvs",
			buttons = {
				{name = "Baller", costs = 60000, description = {}, model = "baller"},
				{name = "Cavalcade", costs = 20000, description = {}, model = "cavalcade"},
				{name = "Granger", costs = 55000, description = {}, model = "granger"},
				{name = "Huntley S", costs = 195000, description = {}, model = "huntley"},
				{name = "Landstalker", costs = 38000, description = {}, model = "landstalker"},
				{name = "Radius", costs = 22000, description = {}, model = "radi"},
				{name = "Rocoto", costs = 85000, description = {}, model = "rocoto"},
				{name = "Seminole", costs = 10000, description = {}, model = "seminole"},
				{name = "XLS", costs = 90000, description = {}, model = "xls"},

				--GTA Wise Guy
				{name = "Mesa", costs = 60000, description = {}, model = "Mesa"},
				{name = "Baller LE", costs = 210000, description = {}, model = "baller3"},
			}
		},
		["vans"] = {
			title = "vans",
			name = "vans",
			buttons = {
				{name = "Bison", costs = 30000, description = {}, model = "bison"},
				{name = "Bobcat XL", costs = 15000, description = {}, model = "bobcatxl"},
				{name = "Gang Burrito", costs = 15000, description = {}, model = "gburrito"},
				{name = "Journey", costs = 5000, description = {}, model = "journey"},
				{name = "Minivan", costs = 3000, description = {}, model = "minivan"},
				{name = "Paradise", costs = 5000, description = {}, model = "paradise"},
				{name = "Surfer", costs = 5000, description = {}, model = "surfer"},
				{name = "Youga", costs = 6000, description = {}, model = "youga"},
			}
		},
		["sedans"] = {
			title = "sedans",
			name = "sedans",
			buttons = {
				{name = "Emperor", costs = 2000, description = {}, model = "emperor2"},
				{name = "Tornado", costs = 2000, description = {}, model = "tornado3"},
				{name = "Tornado +", costs = 2900, description = {}, model = "tornado6"},
				{name = "Bodhi", costs = 3000, description = {}, model = "bodhi2"},
				{name = "Youga", costs = 5000, description = {}, model = "youga2"},
				{name = "Rumpo", costs = 16000, description = {}, model = "rumpo3"},			
				{name = "Asea", costs = 8000, description = {}, model = "asea"},
				{name = "Asterope", costs = 10000, description = {}, model = "asterope"},
				{name = "Fugitive", costs = 28000, description = {}, model = "fugitive"},
				{name = "Glendale", costs = 8000, description = {}, model = "glendale"},
				{name = "Ingot", costs = 9000, description = {}, model = "ingot"},
				{name = "Intruder", costs = 25000, description = {}, model = "intruder"},
				{name = "Premier", costs = 10000, description = {}, model = "premier"},
				{name = "Primo", costs = 9000, description = {}, model = "primo"},
				{name = "Primo Custom", costs = 9500, description = {}, model = "primo2"},
				{name = "Regina", costs = 8000, description = {}, model = "regina"},
				{name = "Schafter", costs = 45000, description = {}, model = "schafter2"},
				{name = "Stanier", costs = 10000, description = {}, model = "stanier"},
				{name = "Stratum", costs = 10000, description = {}, model = "stratum"},
				{name = "Stretch", costs = 30000, description = {}, model = "stretch"},
				{name = "Super Diamond", costs = 200000, description = {}, model = "superd"},
				{name = "Surge", costs = 18000, description = {}, model = "surge"},
				{name = "Warrener", costs = 80000, description = {}, model = "warrener"},
				{name = "Washington", costs = 15000, description = {}, model = "washington"},
				-- Gta wise guy
				{name = "Tailgater", costs = 90000, description = {}, model = "tailgater"},
				{model = "taxirooster", name = "Rooster Cab Co Taxi", costs = 5000, description = {} },
				{name = "Cognoscenti 55", costs = 125000, description = {}, model = "cog55"},
				{name = "Cognoscenti", costs = 150000, description = {}, model = "cognoscenti"},


			}
		},
		["motorcycles"] = {
			title = "MOTORCYCLES",
			name = "motorcycles",
			buttons = {
			--	{name = "Ratbike", costs = 4000, description = {}, model = "ratbike"},			
				{name = "Akuma", costs = 9000, description = {}, model = "AKUMA"},
				{name = "Bagger", costs = 25000, description = {}, model = "bagger"},
				{name = "Bati 801", costs = 15000, description = {}, model = "bati"},
				{name = "Bati 801RR", costs = 15000, description = {}, model = "bati2"},
			--	{name = "BF400", costs = 95000, description = {}, model = "bf400"},
				{name = "Carbon RS", costs = 11000, description = {}, model = "carbonrs"},
			--	{name = "Cliffhanger", costs = 32500, description = {}, model = "cliffhanger"},
				{name = "Daemon", costs = 25000, description = {}, model = "daemon"},
				{name = "Double T", costs = 12000, description = {}, model = "double"},
			--	{name = "Enduro", costs = 48000, description = {}, model = "enduro"},
				{name = "Faggio", costs = 2000, description = {}, model = "faggio2"},
			--	{name = "Gargoyle", costs = 70000, description = {}, model = "gargoyle"},
				{name = "Hakuchou", costs = 32000, description = {}, model = "hakuchou"},
				{name = "Hexer", costs = 25000, description = {}, model = "hexer"},
			--	{name = "Innovation", costs = 30000, description = {}, model = "innovation"},
				{name = "Lectro", costs = 32000, description = {}, model = "lectro"},
				{name = "Nemesis", costs = 12000, description = {}, model = "nemesis"},
				{name = "PCJ-600", costs = 9000, description = {}, model = "pcj"},
				{name = "Ruffian", costs = 9000, description = {}, model = "ruffian"},
				{name = "Sanchez", costs = 17000, description = {}, model = "sanchez"},
				{name = "Sovereign", costs = 62000, description = {}, model = "sovereign"},
			--	{name = "Thrust", costs = 75000, description = {}, model = "thrust"},
			--	{name = "Shotaro", costs = 189000, description = {}, model = "SHOTARO"},
			--	{name = "Vindicator", costs = 41000, description = {}, model = "vindicator"},
			--	{name = "Zombiea", costs = 60000, description = {}, model = "zombiea"},
			--	{name = "Zombieb", costs = 65000, description = {}, model = "zombieb"},
			--	{name = "Wolfsbane", costs = 70000, description = {}, model = "wolfsbane"},
			--	{name = "Nightblade", costs = 90000, description = {}, model = "nightblade"},

			-- gtawiseguy
				{name = "Faggio Custom", costs = 25000, description = {}, model = "faggio3"},
				{name = "Cliffhanger", costs = 40000, description = {}, model = "Cliffhanger"},
				{name = "Daemon Custom", costs = 40000, description = {}, model = "daemon2"},
				{name = "Faggio", costs = 8000, description = {}, model = "faggio"},

			}
		},
		["cycles"] = {
			title = "cycles",
			name = "cycles",
			buttons = {
				{name = "BMX", costs = 150, description = {}, model = "bmx"},
				{name = "Cruiser", costs = 240, description = {}, model = "cruiser"},
				{name = "Fixter", costs = 270, description = {}, model = "fixter"},
				{name = "Scorcher", costs = 300, description = {}, model = "scorcher"},
				{name = "Pro 1", costs = 2500, description = {}, model = "tribike"},
				{name = "Pro 2", costs = 2600, description = {}, model = "tribike2"},
				{name = "Pro 3", costs = 2900, description = {}, model = "tribike3"},
			}
		},		
	}
}




local fakecar = {model = '', car = nil}
local vehshop_locations = {
	{
		entering = {-33.737,-1102.322,26.422},
		inside = {-61.166320800781,-1107.8854980469,26.43579864502,76.141090393066},
		outside = {-61.166320800781,-1107.8854980469,26.43579864502,76.141090393066},
	}
}

local carspawns = {
	[1] =  { ['x'] = -38.25,['y'] = -1104.18,['z'] = 26.43,['h'] = 14.46, ['info'] = ' Car Spot 1' },
	[2] =  { ['x'] = -36.36,['y'] = -1097.3,['z'] = 26.43,['h'] = 109.4, ['info'] = ' Car Spot 2' },
	[3] =  { ['x'] = -43.11,['y'] = -1095.02,['z'] = 26.43,['h'] = 67.77, ['info'] = ' Car Spot 3' },
	[4] =  { ['x'] = -50.45,['y'] = -1092.66,['z'] = 26.43,['h'] = 116.33, ['info'] = ' Car Spot 4' },
	[5] =  { ['x'] = -56.24,['y'] = -1094.33,['z'] = 26.43,['h'] = 157.08, ['info'] = ' Car Spot 5' },
	[6] =  { ['x'] = -49.73,['y'] = -1098.63,['z'] = 26.43,['h'] = 240.99, ['info'] = ' Car Spot 6' },
	[7] =  { ['x'] = -45.58,['y'] = -1101.4,['z'] = 26.43,['h'] = 287.3, ['info'] = ' Car Spot 7' },
}

local carTable = {
	[1] = { ["model"] = "gauntlet", ["baseprice"] = 100000, ["commission"] = 15 }, 
	[2] = { ["model"] = "dubsta3", ["baseprice"] = 100000, ["commission"] = 15 },
	[3] = { ["model"] = "landstalker", ["baseprice"] = 100000, ["commission"] = 15 },
	[4] = { ["model"] = "bobcatxl", ["baseprice"] = 100000, ["commission"] = 15 },
	[5] = { ["model"] = "surfer", ["baseprice"] = 100000, ["commission"] = 15 },
	[6] = { ["model"] = "glendale", ["baseprice"] = 100000, ["commission"] = 15 },
	[7] = { ["model"] = "washington", ["baseprice"] = 100000, ["commission"] = 15 },
}

function updateCarTable(model,price,name)
	carTable[currentCarSpawnLocation]["model"] = model
	carTable[currentCarSpawnLocation]["baseprice"] = price
	carTable[currentCarSpawnLocation]["name"] = name
	TriggerServerEvent("carshop:table",carTable)
end



local myspawnedvehs = {}

RegisterNetEvent("car:testdrive")
AddEventHandler("car:testdrive", function()
	if rank == 0 or #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 then
		return
	end	

	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		TriggerEvent("DoLongHudText","Could not locate vehicle",2)
		return
	end
	
	local model = GetEntityModel(veh)
	local veh = GetClosestVehicle(-51.51, -1077.96, 26.92, 3.000, 0, 70)

	if not DoesEntityExist(veh) then

		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model,-51.51, -1077.96, 26.92,80.0,true,false)
		local vehplate = "CAR"..math.random(10000,99999) 
		SetVehicleNumberPlateText(veh, vehplate)
		Citizen.Wait(100)
		local plt = GetVehicleNumberPlateText(veh)
		print('plate ', plt)
		TriggerEvent("keys:addNew",veh, plt)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)

		TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
		myspawnedvehs[veh] = true
	else

		TriggerEvent("DoLongHudText","A car is on the spawn point.",2)

	end

end)

RegisterCommand('finance', function()
TriggerEvent('finance')
end)
	

RegisterNetEvent("finance")
AddEventHandler("finance", function()
	if rank == 0 or #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 then
		return
	end	
	local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		TriggerEvent("DoLongHudText","Could not locate vehicle",2)
		return
	end
	local vehplate = GetVehicleNumberPlateText(veh)	
	TriggerServerEvent("finance:enable",vehplate)
end)

RegisterNetEvent("finance:enableOnClient")
AddEventHandler("finance:enableOnClient", function(addplate)
	financedPlates[addplate] = true
	Citizen.Wait(60000)
	financedPlates[addplate] = nil
end)	

RegisterNetEvent("commission")
AddEventHandler("commission", function(newAmount)
	if rank == 0 or #(vector3(-51.51, -1077.96, 26.92) - GetEntityCoords(PlayerPedId())) > 50.0 then
		return
	end
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			carTable[i]["commission"] = tonumber(newAmount)
			TriggerServerEvent("carshop:table",carTable)

		end
	end
end)

RegisterNetEvent("veh_shop:returnTable")
AddEventHandler("veh_shop:returnTable", function(newTable)

	carTable = newTable
	DespawnSaleVehicles()
	SpawnSaleVehicles()

end)

local hasspawned = false

local spawnedvehicles = {}
local vehicles_spawned = false
function BuyMenu()
	for i = 1, #carspawns do

		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
				ClearPedTasksImmediately(PlayerPedId())
			end
			DisableControlAction(0,23)
			if IsControlJustReleased(0,47) then
				TriggerEvent("DoLongHudText","Attempting Purchase")
				AttemptBuy(i,false)
			end

			if IsControlJustReleased(0,23) or IsDisabledControlJustReleased(0,23) then
				local veh = GetClosestVehicle(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], 3.000, 0, 70)
				local addplate = GetVehicleNumberPlateText(veh)
				if financedPlates[addplate] ~= nil then
					TriggerEvent("DoLongHudText","Attempting Purchase")
					AttemptBuy(i,true)
				end
			end
		end
	end
end

function AttemptBuy(tableid,financed)

	local veh = GetClosestVehicle(carspawns[tableid]["x"],carspawns[tableid]["y"],carspawns[tableid]["z"], 3.000, 0, 70)
	if not DoesEntityExist(veh) then
		TriggerEvent("DoLongHudText","Could not locate vehicle",2)
		return
	end

	local model = carTable[tableid]["model"]
	local commission = carTable[tableid]["commission"]
	local baseprice = carTable[tableid]["baseprice"]
	local name = carTable[tableid]["name"]
	local price = baseprice + (baseprice * commission/100)

	if baseprice > 10000 and not financed then
		TriggerEvent("DoLongHudText","This vehicle must be financed.",2)
		return
	end
	currentlocation = vehshop_blips[1]
	TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
	TriggerServerEvent('CheckMoneyForVeh',name, model, price, financed)
	commissionbuy = (baseprice * commission/200)

end



function OwnerMenu()

	if not vehshop.opened then
		currentCarSpawnLocation = 0
		ownerMenu = false
	end
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.0 then
			ownerMenu = true
			currentCarSpawnLocation = i
			if IsControlJustReleased(0,38) then
				TriggerEvent("DoLongHudText","We Opened")
				if vehshop.opened then
					CloseCreator()
				else
					OpenCreator()
				end
			end
		end
	end

end

function DrawPrices()
	for i = 1, #carspawns do
		if #(vector3(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]) - GetEntityCoords(PlayerPedId())) < 2.5 then
			local commission = carTable[i]["commission"]
			local baseprice = carTable[i]["baseprice"]
			local price = baseprice + (baseprice * commission/100)
			local veh = GetClosestVehicle(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"], 3.000, 0, 70)
			local addplate = GetVehicleNumberPlateText(veh)
			if rank > 0 then
				if financedPlates[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change | [G] to buy | [F] to Finance ")
				else
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " | Com: %" ..commission.. " | [E] to change | [G] to buy. ")
				end
			else
				if financedPlates[addplate] ~= nil then
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " [G] to buy | $" .. math.ceil(price/4) .. " upfront, $" .. math.ceil(price) .. " over 10 weeks, [F] to finance. ")
				else
					DrawText3D(carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"],"$" .. math.ceil(price) .. " [G] to buy. ")
				end			
			end
		end
	end
end
function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
function SpawnSaleVehicles()
	if not hasspawned then
		TriggerServerEvent("carshop:requesttable")
		Citizen.Wait(1500)
	end
	DespawnSaleVehicles(true)
	hasspawned = true
	for i = 1, #carTable do
		local model = GetHashKey(carTable[i]["model"])
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model,carspawns[i]["x"],carspawns[i]["y"],carspawns[i]["z"]-1,carspawns[i]["h"],false,false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)

		FreezeEntityPosition(veh,true)
		spawnedvehicles[#spawnedvehicles+1] = veh
		SetVehicleNumberPlateText(veh, i .. "CARSALE")
	end
	vehicles_spawned = true
end

function DespawnSaleVehicles(pDontWait)
	if pDontWait == nil and not pDontWait then
		Wait(15000)
	end
	for i = 1, #spawnedvehicles do
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(spawnedvehicles[i]))
	end
	vehicles_spawned = false
end




Controlkey = {["generalUse"] = {38,"E"},["generalUseSecondary"] = {18,"Enter"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["generalUse"] = table["generalUse"]
	Controlkey["generalUseSecondary"] = table["generalUseSecondary"]
end)

--[[Functions]]--

function LocalPed()
	return PlayerPedId()
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

function ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,326)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Vehicle Shop')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			SetBlipScale(blip, 0.8)
			SetBlipColour(blip, 3)
			vehshop_blips[#vehshop_blips+1]= {blip = blip, pos = loc}
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(1)
				local inrange = false

				if #(vector3(-45.98,-1082.97, 26.27) - GetEntityCoords(LocalPed())) < 5.0 then
					local veh = GetVehiclePedIsUsing(LocalPed())
					if myspawnedvehs[veh] ~= nil then
						DrawText3D(-45.98,-1082.97, 26.27,"["..Controlkey["generalUse"][2].."] return vehicle")
						if IsControlJustReleased(0,Controlkey["generalUse"][1]) then
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
						end
					end
				end

				for i,b in ipairs(vehshop_blips) do
					if insideVehShop then
						currentlocation = b
						if not vehicles_spawned then
							SpawnSaleVehicles()
						end
						if #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 25 then
							DrawPrices()
						end

						DrawMarker(27,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]-0.9,0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,50,0,0,0,0)
						
						if vehshop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) <= 1 then

							DisplayHelpText('~g~'..Controlkey["generalUse"][2]..'~s~ to browse')
							
							inrange = true
						end

						if vehshop.opened == true then
							DisplayHelpText('~g~'..Controlkey["generalUse"][2]..'~s~ or ~g~'..Controlkey["generalUseSecondary"][2]..'~s~ Accepts ~g~Arrows~s~ Move ~g~Backspace~s~ Exit')
						end

						if rank > 0 then
							OwnerMenu()
						end

						BuyMenu()
						

					else
						if vehicles_spawned then
							DespawnSaleVehicles()
						end
						Citizen.Wait(1000)
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

function f(n)
	return n + 0.0001
end

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreator()
	boughtcar = false
	
	if ownerMenu then
		vehshop = vehshopOwner	
	else
		vehshop = vehshopDefault
	end


	local ped = LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])




	vehshop.currentmenu = "main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end
local endingCreator = false
function CloseCreator(name, veh, price, financed)
	Citizen.CreateThread(function()
		if not endingCreator then
			endingCreator = true
			local ped = LocalPed()
			if not boughtcar then
				local pos = currentlocation.pos.entering
				SetEntityCoords(ped,pos[1],pos[2],pos[3])
				FreezeEntityPosition(ped,false)
				SetEntityVisible(ped,true)
			else			
				local name = name	
				local vehicle = veh
				local price = price		
				local veh = GetVehiclePedIsUsing(ped)
				local model = GetEntityModel(veh)
				local colors = table.pack(GetVehicleColours(veh))
				local extra_colors = table.pack(GetVehicleExtraColours(veh))

				local mods = {}
				for i = 0,24 do
					mods[i] = GetVehicleMod(veh,i)
				end
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
				local pos = currentlocation.pos.outside

				FreezeEntityPosition(ped,false)
				RequestModel(model)
				while not HasModelLoaded(model) do
					Citizen.Wait(0)
				end
				personalvehicle = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
				SetModelAsNoLongerNeeded(model)

				if name == "rumpo" then
					SetVehicleLivery(personalvehicle,0)
				end

				if name == "taxi" then
					SetVehicleExtra(personalvehicle, 8, 0)
					SetVehicleExtra(personalvehicle, 9, 0)
					SetVehicleExtra(personalvehicle, 5, 1)
				end



				for i,mod in pairs(mods) do
					SetVehicleModKit(personalvehicle,0)
					SetVehicleMod(personalvehicle,i,mod)
				end

				SetVehicleOnGroundProperly(personalvehicle)

				local plate = GetVehicleNumberPlateText(personalvehicle)
				SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
				local id = NetworkGetNetworkIdFromEntity(personalvehicle)
				SetNetworkIdCanMigrate(id, true)
				Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
				SetVehicleColours(personalvehicle,colors[1],colors[2])
				SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
				TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
				TriggerEvent("keys:addNew", model, plate)
				local vehname = GetDisplayNameFromVehicleModel(model)
				print(vehname)
				SetEntityVisible(ped,true)			
				local primarycolor = colors[1]
				local secondarycolor = colors[2]	
				local pearlescentcolor = extra_colors[1]
				local wheelcolor = extra_colors[2]
				TriggerServerEvent('BuyForVeh', plate, vehname, vehicle, price, financed)
				DespawnSaleVehicles()
				SpawnSaleVehicles()

			end
			vehshop.opened = false
			vehshop.menu.from = 1
			vehshop.menu.to = 10
			endingCreator = false
		end
	end)
end


RegisterNetEvent("carshop:failedpurchase")
AddEventHandler("carshop:failedpurchase", function()
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	TaskLeaveVehicle(PlayerPedId(),veh,0)
end)
RegisterNetEvent("veh_shop:setPlate")
AddEventHandler("veh_shop:setPlate", function(vehicle, plate)

	print('setting plate ', plate)

	SetVehicleNumberPlateText(vehicle, plate)
	Citizen.Wait(1000)
	TriggerEvent("keys:addNew", vehicle, plate)

	TriggerServerEvent('garages:SetVehOut', vehicle, plate)
	TriggerServerEvent('veh.getVehicles', plate, vehicle)
	TriggerServerEvent("garages:CheckGarageForVeh")

	local plt = GetVehicleNumberPlateText(vehicle)
	TriggerServerEvent("request:illegal:upgrades",plate)

end)




function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,51,122,181,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(250,250,250, 255)
	else
		SetTextColour(0, 0, 0, 255)
		
	end
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,51,122,181,250)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255, 255, 255,250) 
	end
	

end

function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end



function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = PlayerPedId()
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Vehicles" then
			OpenMenu('vehicles')
		elseif btn == "Motorcycles" then
			OpenMenu('motorcycles')
		elseif btn == "Cycles" then
			OpenMenu('cycles')
		end
	elseif this == "vehicles" then
		if btn == "Sports" then
			OpenMenu('sports')
		elseif btn == "Sedans" then
			OpenMenu('sedans')
		elseif btn == "Job Vehicles" then
			OpenMenu('jobvehicles')
		elseif btn == "Compacts" then
			OpenMenu('compacts')
		elseif btn == "Coupes" then
			OpenMenu('coupes')
		elseif btn == "Sports Classics" then
			OpenMenu("sportsclassics")
		elseif btn == "Super" then
			OpenMenu('super')
		elseif btn == "Muscle" then
			OpenMenu('muscle')
		elseif btn == "Off-Road" then
			OpenMenu('offroad')
		elseif btn == "SUVs" then
			OpenMenu('suvs')
		elseif btn == "Vans" then
			OpenMenu('vans')
		end

	elseif this == "jobvehicles" or this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "super" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" or this == "cycles" or this == "motorcycles" then

		if ownerMenu then

			updateCarTable(button.model,button.costs,button.name)

		else

			TriggerServerEvent('CheckMoneyForVeh',button.name, button.model, button.costs)

		end
		
	end

end

function OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end

function resetscaleform(topspeed,handling,braking,accel,resetscaleform,i)
    scaleform = RequestScaleformMovie(resetscaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

	topspeedc = topspeed / 20
	handlingc = handling / 20
	brakingc = braking / 20
	accelc = accel / 20

    PushScaleformMovieFunction(scaleform, "SET_VEHICLE_INFOR_AND_STATS")
    PushScaleformMovieFunctionParameterString("LOADING")
    PushScaleformMovieFunctionParameterString("Brand New Vehicle")
    PushScaleformMovieFunctionParameterString("MPCarHUD")
    PushScaleformMovieFunctionParameterString("Annis")
    PushScaleformMovieFunctionParameterString("Top Speed")
    PushScaleformMovieFunctionParameterString("Handling")
    PushScaleformMovieFunctionParameterString("Braking")
    PushScaleformMovieFunctionParameterString("Downforce")


	PushScaleformMovieFunctionParameterInt( (20 * i)-1 )
	PushScaleformMovieFunctionParameterInt( (20 * i)-1 )
	PushScaleformMovieFunctionParameterInt( (20 * i)-1 )
    PushScaleformMovieFunctionParameterInt( (20 * i)-1 )

	PopScaleformMovieFunctionVoid()

end


--[[Citizen]]--
function Initialize(scaleform,veh,vehname)

    scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    PushScaleformMovieFunction(scaleform, "SET_VEHICLE_INFOR_AND_STATS")
    PushScaleformMovieFunctionParameterString(vehname)
    PushScaleformMovieFunctionParameterString("Brand New Vehicle")
    PushScaleformMovieFunctionParameterString("MPCarHUD")
    PushScaleformMovieFunctionParameterString("Annis")
    PushScaleformMovieFunctionParameterString("Top Speed")
    PushScaleformMovieFunctionParameterString("Handling")
    PushScaleformMovieFunctionParameterString("Braking")
    PushScaleformMovieFunctionParameterString("Downforce")

	local topspeed = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 4)
    local handling = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock') * 2)
    local braking = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce') * 100)
    local accel = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce') * 100) 

    if topspeed > 100 then
    	topspeed = 100
    end
    if handling > 100 then
    	handling = 100
    end
    if braking > 100 then
    	braking = 100
    end
    if accel > 100 then
    	accel = 100
    end
    Citizen.Trace(topspeed)
    Citizen.Trace(handling)
    Citizen.Trace(braking)
    Citizen.Trace(accel)

    PushScaleformMovieFunctionParameterInt( topspeed )
    PushScaleformMovieFunctionParameterInt( handling )
    PushScaleformMovieFunctionParameterInt( braking )
    PushScaleformMovieFunctionParameterInt( accel )
    PopScaleformMovieFunctionVoid()

    return scaleform
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1]) ) and IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if vehshop.opened then

			local ped = LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			local y = vehshop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false
			for i,button in pairs(menu.buttons) do
				local br = button.rank ~= nil and button.rank or 0
				if rank >= br and i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,vehshop.menu.x,y,selected)
					if button.costs ~= nil then

						drawMenuRight("$"..button.costs,vehshop.menu.x,y,selected)

					end
					y = y + 0.04
					if vehshop.currentmenu == "jobvehicles" or vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								end
								local pos = currentlocation.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								while not HasModelLoaded(hash) do
									Citizen.Wait(0)


								end
								local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
								SetModelAsNoLongerNeeded(hash)
								local timer = 9000
								while not DoesEntityExist(veh) and timer > 0 do
									timer = timer - 1
									Citizen.Wait(1)
								end
								TriggerEvent("vehsearch:disable",veh)

	


								FreezeEntityPosition(veh,true)
								SetEntityInvincible(veh,true)
								SetVehicleDoorsLocked(veh,4)
								--SetEntityCollision(veh,false,false)
								TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
								for i = 0,24 do
									SetVehicleModKit(veh,0)
									RemoveVehicleMod(veh,i)
								end
								fakecar = { model = button.model, car = veh}

									local topspeed = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 2)
								    local handling = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fSteeringLock') * 2)
								    local braking = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeForce') * 100)
								    local accel = math.ceil(GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce') * 100) 
								
								if button.model == "rumpo" then
									SetVehicleLivery(veh,2)
								end


								-- not sure why it doesnt refresh itself, but blocks need to be set to their maximum 20 40 60 80 100 before a new number is pushed.
								for i = 1, 5 do
								 	scaleform = resetscaleform(topspeed,handling,braking,accel,"mp_car_stats_01",i)
							        x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
							        Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x-1,y+1.8,z+7.0, 0.0, 180.0, 90.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0)
								end

								scaleform = Initialize("mp_car_stats_01",fakecar.car,fakecar.model)
							end
						end
					end
					if selected and ( IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1, Controlkey["generalUseSecondary"][1])  ) then
						ButtonSelected(button)
					end
				end
			end

			if DoesEntityExist(fakecar.car) then
				if vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
					daz = 6.0
					if fakecar.model == "Chimera" then
						daz = 8.0
					end
					if fakecar.model == "bmx" then
						daz = 8.0
					end
					 x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, daz))
		        	Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 7.0, 7.0, 7.0, 0)
				else
		       		x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, -1.5, 10.0))
		       		Citizen.InvokeNative(0x87D51D72255D4E78,scaleform, x,y,z, 0.0, 180.0, 100.0, 1.0, 1.0, 1.0, 10.0, 10.0, 10.0, 0)		
				end
				TaskWarpPedIntoVehicle(LocalPed(),fakecar.car,-1)
		    end

		end
		if vehshop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)

AddEventHandler('FinishMoneyCheckForVeh', function(name, vehicle, price,financed)	
	local name = name
	local vehicle = vehicle
	local price = price
	boughtcar = true
	CloseCreator(name, vehicle, price, financed)
	TriggerEvent("fistpump")
	local plt = GetVehicleNumberPlateText(vehicle)
	print('plate ', plt)
	TriggerEvent("keys:addNew",vehicle, plt)
	TriggerServerEvent("server:GroupPayment","car_shop",commissionbuy)
end)

ShowVehshopBlips(true)
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	--326 car blip 227 225
	ShowVehshopBlips(true)
	firstspawn = 1
end
end)

AddEventHandler('vehshop:spawnVehicle', function(v)
	local car = GetHashKey(v)
	local playerPed = PlayerPedId()
	if playerPed and playerPed ~= -1 then
		RequestModel(car)
		while not HasModelLoaded(car) do
				Citizen.Wait(0)
		end
		local playerCoords = GetEntityCoords(playerPed)
		veh = CreateVehicle(car, playerCoords, 0.0, true, false)
		local plate = GetVehicleNumberPlateText(veh)
		SetModelAsNoLongerNeeded(car)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
		SetEntityInvincible(veh, true)
		TriggerEvent('veh_shop:setPlate', veh, plate)
	end
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		RemoveIpl('v_carshowroom')
		RemoveIpl('shutter_open')
		RemoveIpl('shutter_closed')
		RemoveIpl('shr_int')
		RemoveIpl('csr_inMission')
		RequestIpl('v_carshowroom')
		RequestIpl('shr_int')
		RequestIpl('shutter_closed')
		firstspawn = 1
	end
end)

local vehshopLoc = PolyZone:Create({
	vector2(-17.224317550659, -1125.9611816406),
	vector2(-70.010810852051, -1128.2976074219),
	vector2(-76.185691833496, -1127.8470458984),
	vector2(-79.25121307373, -1123.7583007813),
	vector2(-79.670585632324, -1118.4036865234),
	vector2(-59.549613952637, -1063.388671875),
	vector2(-1.2465063333511, -1081.7679443359)
}, {
    name = "veh_shop",
    minZ = 0,
    maxZ = 40.5,
    debugGrid = false,
    gridDivisions = 25
})

local HeadBone = 0x796e;
Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetPedBoneCoords(plyPed, HeadBone)
        local inPoly = vehshopLoc:isPointInside(coord)
        -- if true, then player just entered zone
        if inPoly and not insideVehShop then
            insideVehShop = true
        elseif not inPoly and insideVehShop then
            insideVehShop = false
        end
        Citizen.Wait(500)
    end
end)

local isExportReady = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if insideVehShop and isExportReady then
            rank = exports["isPed"]:GroupRank("car_shop")
            Citizen.Wait(10000)
        end
    end
end)

AddEventHandler("np-base:exportsReady", function()
	Wait(1)
	isExportReady = true
end)