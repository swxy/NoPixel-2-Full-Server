NPX.DataControls = NPX.DataControls or {}
NPX.Controls = NPX.Controls or {}
NPX.Controls.EventHolder = {}


NPX.Controls.Current = {}
-- Current bind name and keys
NPX.Controls.Default = {
  ["tokoptt"] = "CAPS",
  ["loudSpeaker"] = "-",
  ["distanceChange"] = "G",
  ["tokoToggle"] = "LEFTCTRL",
  ["handheld"] = "LEFTSHIFT+P",
  ["carStereo"] = "LEFTALT+P",
  ["switchRadioEmergency"] = "9",
  ["actionBar"] = "TAB",
  ["generalUse"] = "E",
  ["generalPhone"] = "P",
  ["generalInventory"] = "K",
  ["generalChat"] = "T",
  ["generalEscapeMenu"] = "ESC",
  ["generalUseSecondary"] = "ENTER",
  ["generalUseSecondaryWorld"] = "F",
  ["generalUseThird"] = "G",
  ["generalTackle"] = "LEFTALT",
  ["generalMenu"] = "F1",
  ["generalProp"] = "7",
  ["generalScoreboard"] = "U",
  ["movementCrouch"] = "X",
  ["movementCrawl"] = "Z",
  ["vehicleCruise"] = "X",
  ["vehicleSearch"] = "G",
  ["vehicleHotwire"] = "H",
  ["vehicleBelt"] = "B",
  ["vehicleDoors"] = "L",
  ["vehicleSlights"] = "Q",
  ["vehicleSsound"] = "LEFTALT",
  ["vehicleSnavigate"] = "R",
  ["newsTools"] = "H",
  ["newsNormal"] = "E",
  ["newsMovie"] = "M",
  ["housingMain"] = "H",
  ["housingSecondary"] = "G",
  ["heliCam"] = "E",
  ["helivision"] = "INPUTAIM",
  ["helirappel"] = "X",
  ["helispotlight"] = "G",
  ["helilockon"] = "SPACE",
  ["showDispatchLog"] = "z",
  ["radiovolumedown"] = "[",
  ["radiovolumeup"] = "]",
  ["radiotoggle"] = ",",
  ["devmenu"] = "F5",
  ["devnoclip"] = "F2",
  ["devcloak"] = "F3",
  ["devmarker"] = "F6",
}

-- Bindable attributes
NPX.Controls.events = {
	["lowActionItems"] = {
		[0] = {["event"] = "",["bind"] = "",["id"] = 3},
	},
	["general"] = {
		[0] = {["event"] = "police",["bind"] = "vehicleCruise",["id"] = 7,["maxwait"] = 1000},
		[1] = {["event"] = "police",["bind"] = "generalTackle",["id"] = 6,["maxwait"] = 1000},
		[2] = {["event"] = "police",["bind"] = "tokoptt",["id"] = 5,["maxwait"] = 1000},
		[3] = {["event"] = "police",["bind"] = "generalMenu",["id"] = 8,["maxwait"] = 1000},
		-- search and hotwire
		[4] = {["event"] = "npkeys",["bind"] = "vehicleSearch",["id"] = 1,["maxwait"] = 1000},
		[5] = {["event"] = "npkeys",["bind"] = "vehicleHotwire",["id"] = 2,["maxwait"] = 1000},
		-- news action items
		[6] = {["event"] = "newsJob",["bind"] = "newsTools",["id"] = 1,["maxwait"] = 200},
		[7] = {["event"] = "newsJob",["bind"] = "newsNormal",["id"] = 2,["maxwait"] = 200},
		[8] = {["event"] = "newsJob",["bind"] = "newsMovie",["id"] = 3,["maxwait"] = 200},

		--drop propattach 
		[9] = {["event"] = "propAttach",["bind"] = "generalProp",["id"] = 1,["maxwait"] = 1000},

		-- radio
		[10] = {["event"] = "taskBar",["bind"] = "handheld",["id"] = 1,["maxwait"] = 1000},
		-- phone
		[11] = {["event"] = "taskBar",["bind"] = "carStereo",["id"] = 2,["maxwait"] = 1000},
		-- car stereo
		[12] = {["event"] = "taskBar",["bind"] = "generalPhone",["id"] = 3,["maxwait"] = 1000},
		-- inventoryh
		[13] = {["event"] = "taskBar",["bind"] = "generalInventory",["id"] = 4,["maxwait"] = 1000},
		-- escape from gui taskbar
		[14] = {["event"] = "taskBar",["bind"] = "generalEscapeMenu",["id"] = 5,["maxwait"] = 1000},
		-- toggle car door lock
		[15] = {["event"] = "cardoors",["bind"] = "vehicleDoors",["id"] = 1,["maxwait"] = 1000},
		-- toggle belt
		[16] = {["event"] = "vehicleMod",["bind"] = "vehicleBelt",["id"] = 1,["maxwait"] = 1000},
		-- switch emergency radio
		[17] = {["event"] = "tokoChangeEmergency",["bind"] = "switchRadioEmergency",["id"] = 1,["maxwait"] = 1000},

		
		[18] = {["event"] = "police", ["bind"] = "showDispatchLog",["id"] = 9,["maxwait"] = 1000},

		[19] = {["event"] = "tokoChangeVolume",["bind"] = "radiovolumedown",["id"] = 1,["maxwait"] = 200},
		[20] = {["event"] = "tokoChangeVolume",["bind"] = "radiovolumeup",["id"] = 2,["maxwait"] = 200},
		[21] = {["event"] = "tokoRadioToggle",["bind"] = "radiotoggle",["id"] = 1,["maxwait"] = 200},

		[22] = {["event"] = "adminDev",["bind"] = "devmenu",["id"] = 1,["maxwait"] = 200},
		[23] = {["event"] = "adminDev",["bind"] = "devnoclip",["id"] = 2,["maxwait"] = 200},
		[24] = {["event"] = "adminDev",["bind"] = "devcloak",["id"] = 3,["maxwait"] = 200},
		[25] = {["event"] = "adminDev",["bind"] = "devmarker",["id"] = 4,["maxwait"] = 200},

	},
	["general-dist"] = {
		[0] = {["event"] = "distanceCheck",["bind"] = "generalUse",["distanceName"] = "use"},
		[1] = {["event"] = "distanceCheck",["bind"] = "generalUseSecondaryWorld",["distanceName"] = "useSecondary"},
		[2] = {["event"] = "distanceCheck",["bind"] = "generalUseThird",["distanceName"] = "useThird"},
	},
}

NPX.Controls.secondaryBinds = {}

NPX.Controls.Distcheck = {}
NPX.Controls.Distcheck.use = {
	-- create fake id
	[0] = {["pos"] = {2063.89,2990.74,-67.7},	["r"] = 1.7,["event"] = "cid",["id"] = 0,["maxwait"] = 200},
	-- bar Sign on 
	[1] = {["pos"] = {249.29,-369.28,-44.13},	["r"] = 2,["event"] = "police",["id"] = 1,["maxwait"] = 200},
	[2] = {["pos"] = {-1579.71,-580.48,108.53},	["r"] = 2,["event"] = "police",["id"] = 1,["maxwait"] = 200},
	-- evidence locker 1
	[3] = {["pos"] = {474.799,-994.24,26.23},	["r"] = 2,["event"] = "police",["id"] = 2,["maxwait"] = 200},
	[4] = {["pos"] = {2059.51,2993.21,-72.70},	["r"] = 2,["event"] = "police",["id"] = 2,["maxwait"] = 200},
	[5] = {["pos"] = {325.05,-1629.5, -66.78},	["r"] = 2,["event"] = "police",["id"] = 2,["maxwait"] = 200}, 
	-- evidence locker 2
	[6] = {["pos"] = {483.15,-992.61,24.23},	["r"] = 2,["event"] = "police",["id"] = 3,["maxwait"] = 200},
	-- Trash
	[7] = {["pos"] = {446.84, -996.90, 30.68},		["r"] = 2,["event"] = "police",["id"] = 4,["maxwait"] = 200},

	-- Bennys,import,tuner
	[8] = {["pos"] = {938.37,-970.82,39.76},	["r"] = 2,["event"] = "bennys",["id"] = 3,["maxwait"] = 200},
	[9] = {["pos"] = {-772.92,-234.92,37.08},	["r"] = 2,["event"] = "bennys",["id"] = 2,["maxwait"] = 200},
	[10] = {["pos"] = {-34.24, -1053.31, 28.4},	["r"] = 2,["event"] = "bennys",["id"] = 1,["maxwait"] = 200},
	-- boradcaster sign ON 
	[11] ={["pos"] = {1989.08,-1753.94,-158.86},["r"] = 2,["event"] = "broadcast",["id"] = 1,["maxwait"] = 200},
	-- gym 
	[12] ={["pos"] = {-1196.97,-1572.89,4.61,},	["r"] = 1,["event"] = "gym",["id"] = 1,["maxwait"] = 200},--"weights"
	[13] ={["pos"] = {-1199.05,-1574.49,4.60,},	["r"] = 1,["event"] = "gym",["id"] = 2,["maxwait"] = 200},--"weights"
	[14] ={["pos"] = {-1200.58,-1577.50,4.60,},	["r"] = 1,["event"] = "gym",["id"] = 3,["maxwait"] = 200},--"pushUps"
	[15] ={["pos"] = {-1196.01,-1567.36,4.61,},	["r"] = 1,["event"] = "gym",["id"] = 4,["maxwait"] = 200},--"Yoga"
	[16] ={["pos"] = {-1215.02,-1541.68,4.72,},	["r"] = 1,["event"] = "gym",["id"] = 5,["maxwait"] = 200},--"Yoga"
	[17] ={["pos"] = {-1217.59,-1543.16,4.72,},	["r"] = 1,["event"] = "gym",["id"] = 6,["maxwait"] = 200},--"Yoga"
	[18] ={["pos"] = {-1220.84,-1545.02,4.69,},	["r"] = 1,["event"] = "gym",["id"] = 7,["maxwait"] = 200},--"Yoga"
	[19] ={["pos"] = {-1224.69,-1547.24,4.62,},	["r"] = 1,["event"] = "gym",["id"] = 8,["maxwait"] = 200},--"Yoga"
	[20] ={["pos"] = {-1228.49,-1549.42,4.55,},	["r"] = 1,["event"] = "gym",["id"] = 9,["maxwait"] = 200},--"Yoga"
	[21] ={["pos"] = {-1253.41,-1601.65,3.15},	["r"] = 1,["event"] = "gym",["id"] = 10,["maxwait"] = 200},--chinups
	[22] ={["pos"] = {-1252.43,-1603.14,3.13},	["r"] = 1,["event"] = "gym",["id"] = 11,["maxwait"] = 200},--chinups
	[23] ={["pos"] = {-1251.26,-1604.81, 3.14},	["r"] = 1,["event"] = "gym",["id"] = 12,["maxwait"] = 200},--chinups
	-- hospitalization
	[24] ={["pos"] = {309.23,-593.03,43.36},	["r"] = 1,["event"] = "hospitalization",["id"] = 1,["maxwait"] = 200}, -- check in


	[25] ={["pos"] = { 307.93, -594.99, 43.29 },	["r"] = 1,["event"] = "hospitalization",["id"] = 2,["maxwait"] = 200}, -- prescriptions
	[26] ={["pos"] = {  312.3, -592.4, 43.29 },	["r"] = 1,["event"] = "hospitalization",["id"] = 3,["maxwait"] = 200}, --results


	[27] ={["pos"] = { 343.77, -591.44, 43.29 },	["r"] = 1,["event"] = "hospitalization",["id"] = 4,["maxwait"] = 200}, -- checkup


 	[28] ={["pos"] = {-626.53,-238.37,38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 1,["maxwait"] = 9000},
	[29] ={["pos"] = {-625.60, -237.52, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 2,["maxwait"] = 9000},
	[30] ={["pos"] = {-626.91, -235.51, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 3,["maxwait"] = 9000},
	[31] ={["pos"] = {-625.67, -234.60, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 4,["maxwait"] = 9000},
	[32] ={["pos"] = {-626.89, -233.08, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 5,["maxwait"] = 9000},
	[33] ={["pos"] = {-627.95, -233.85, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 6,["maxwait"] = 9000},
	[34] ={["pos"] = {-624.52, -231.05, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 7,["maxwait"] = 9000},
	[35] ={["pos"] = {-623.00, -233.08, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 8,["maxwait"] = 9000},
	[36] ={["pos"] = {-620.10, -233.36, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 9,["maxwait"] = 9000},
	[37] ={["pos"] = {-620.29, -234.41, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 10,["maxwait"] = 9000},
	[38] ={["pos"] = {-619.06, -233.56, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 11,["maxwait"] = 9000},
	[39] ={["pos"] = {-617.48, -230.65, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 12,["maxwait"] = 9000},
	[40] ={["pos"] = {-618.36, -229.42, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 13,["maxwait"] = 9000},
	[41] ={["pos"] = {-619.60, -230.55, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 14,["maxwait"] = 9000},
	[42] ={["pos"] = {-620.89, -228.65, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 15,["maxwait"] = 9000},
	[43] ={["pos"] = {-619.79, -227.56, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 16,["maxwait"] = 9000},
	[44] ={["pos"] = {-620.61, -226.44, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 17,["maxwait"] = 9000},
	[45] ={["pos"] = {-623.99, -228.17, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 18,["maxwait"] = 9000},
	[46] ={["pos"] = {-624.88, -227.86, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 19,["maxwait"] = 9000},
	[47] ={["pos"] = {-623.67, -227.00, 38.05},	["r"] = 1,["event"] = "jewelRob",["id"] = 20,["maxwait"] = 9000},

	-- player changer
	[48] ={["pos"] = {295.75,-1351.54,24.53},	["r"] = 1,["event"] = "login",["id"] = 1,["maxwait"] = 200},
	[49] ={["pos"] = {-1501.84,857.4,180.8},	["r"] = 1,["event"] = "login",["id"] = 2,["maxwait"] = 200},

	-- job center

	[50] ={["pos"] = {172.78, -26.89, 68.35},	["r"] = 1,["event"] = "houserobberies",["id"] = 1,["maxwait"] = 200},
	[51] ={["pos"] = {-1389.412, -475.6651, 72.04217},	["r"] = 1,["event"] = "houserobberies",["id"] = 2,["maxwait"] = 200},

	-- job System
	[52] ={["pos"] = {-1062.96,-248.24,44.03},	["r"] = 1,["event"] = "jobSystem",["id"] = 2,["maxwait"] = 300}, -- Gurgle
	[53] ={["pos"] = {-1082.81,-248.19,37.77},	["r"] = 1,["event"] = "jobSystem",["id"] = 1,["maxwait"] = 300}, -- Payslip
	[54] ={["pos"] = {-1381.527,-477.8708,72.04207},		["r"] = 1,["event"] = "jobSystem",["id"] = 3,["maxwait"] = 300}, -- Job Center

	-- hospital garage
	[55] = {["pos"] = {-475.67,-356.32,34.10},	["r"] = 2,["event"] = "hospitalGarage",["id"] = 1,["maxwait"] = 300},
	[56] = {["pos"] = {364.68, -590.98, 28.69},	["r"] = 2,["event"] = "hospitalGarage",["id"] = 1,["maxwait"] = 300},
	[57] = {["pos"] = {218.34,-1637.68,29.42},	["r"] = 2,["event"] = "hospitalGarage",["id"] = 1,["maxwait"] = 300},
	[58] = {["pos"] = {-1182.32,-1773.28,3.90},	["r"] = 2,["event"] = "hospitalGarage",["id"] = 1,["maxwait"] = 300},
	[59] = {["pos"] = {1198.39,-1455.64,34.967},["r"] = 2,["event"] = "hospitalGarage",["id"] = 1,["maxwait"] = 300},
	-- police garage
	[60] = {["pos"] = {2131.38,2925.52,-61.90},	["r"] = 2,["event"] = "policeGarage",["id"] = 1,["maxwait"] = 300},
	[61] = {["pos"] = {441.25,-981.89,30.68},	["r"] = 2,["event"] = "policeGarage",["id"] = 1,["maxwait"] = 300},
	[62] = {["pos"] = {834.41,-1263.51,26.06},	["r"] = 2,["event"] = "policeGarage",["id"] = 1,["maxwait"] = 300},
	[63] = {["pos"] = {1859.45,3676.70,33.40},	["r"] = 2,["event"] = "policeGarage",["id"] = 1,["maxwait"] = 300},
	[64] = {["pos"] = {-460.09,6023.54,31.34},	["r"] = 2,["event"] = "policeGarage",["id"] = 1,["maxwait"] = 300},



	[65] = {["pos"] = {401.16,-1631.7,28.4},	["r"] = 15,["event"] = "towgarage",["id"] = 1,["maxwait"] = 300},

	[66] = {["pos"] = {123.46,6407.27,31.36},	["r"] = 2,["event"] = "truckerjob",["id"] = 1,["maxwait"] = 300},
	[67] = {["pos"] = {929.36,-3131.95,5.91},	["r"] = 8,["event"] = "truckerjob",["id"] = 2,["maxwait"] = 300},




	-- DoC Trash Locker
	[68] = {["pos"] = {1840.45, 2572.82, 46.02},	["r"] = 2,["event"] = "police",["id"] = 4,["maxwait"] = 200},

	-- DoC Sign on
	[69] = {["pos"] = {1838.07,2591.75,46.02},["r"] = 2,["event"] = "policeGarage",["id"] = 1,["maxwait"] = 300},

	-- DOC upstairs trash
	[70] =  { ['pos'] = {1780.69, 2498.46, 50.43}, ["r"] = 2,["event"] = "police",["id"] = 4,["maxwait"] = 300},

	-- sandypd evidence
	[71] =  { ['pos'] = {1848.47,3694.51,34.28}, ["r"] = 2,["event"] = "police",["id"] = 2,["maxwait"] = 300},
	-- sandypd trash
	[72] =  { ['pos'] = {1851.14,3694.54,34.28}, ["r"] = 2,["event"] = "police",["id"] = 4,["maxwait"] = 300},
	-- paleto trash
	[73] =  { ['pos'] = {-442.0,6005.38,31.72}, ["r"] = 2,["event"] = "police",["id"] = 4,["maxwait"] = 300},

	-- player switches
	[74] ={ ["pos"] = {1768.31,2515.12,45.83},	["r"] = 1,["event"] = "login",["id"] = 3,["maxwait"] = 200},
	[75] ={ ["pos"] = {343.68,-597.65,43.29},	["r"] = 1,["event"] = "login",["id"] = 4,["maxwait"] = 200},


		-- MRPD personal lockers	
		[76] ={ ["pos"] = {474.49,-991.32,26.23},	["r"] = 1,["event"] = "openpersonalpd",["id"] = 1,["maxwait"] = 200},	
		[77] ={ ["pos"] = {480.81,-992.78,24.23},	["r"] = 1,["event"] = "openpersonalpd",["id"] = 1,["maxwait"] = 200},	
		[78] ={ ["pos"] = {477.3,-993.21,24.27},	["r"] = 1,["event"] = "openpersonalpd",["id"] = 1,["maxwait"] = 200},	
		-- Sandy personal lockers	
		[79] ={ ["pos"] = {1860.99,3691.32,34.28},	["r"] = 1,["event"] = "openpersonalpd",["id"] = 2,["maxwait"] = 200},	
		-- paleto personal lockers	
		[80] ={ ["pos"] = {-451.61,6016.21,31.72},	["r"] = 1,["event"] = "openpersonalpd",["id"] = 3,["maxwait"] = 200},	
		[81] = {["pos"] = {727.74, -1088.95, 22.17},	["r"] = 2,["event"] = "bennys",["id"] = 4,["maxwait"] = 200},	
		[82] = {["pos"] = {110.8, 6626.46, 31.89},	["r"] = 2,["event"] = "bennys",["id"] = 5,["maxwait"] = 200},	
	}

NPX.Controls.Distcheck.useSecondary = {
	-- boradcaster sign OFF 
	[0] = {["pos"] = {1989.08,-1753.94,-158.86},["r"] = 2,["event"] = "broadcast",["id"] = 2,["maxwait"] = 300},

	-- hospital garage
	[1] = {["pos"] = {-475.67,-356.32,34.10},["r"] = 2,["event"] = "hospitalGarage",["id"] = 2,["maxwait"] = 300},
	[2] = {["pos"] = {364.68, -590.98, 28.69},["r"] = 2,["event"] = "hospitalGarage",["id"] = 2,["maxwait"] = 300},
	[3] = {["pos"] = {218.34,-1637.68,29.42},["r"] = 2,["event"] = "hospitalGarage",["id"] = 2,["maxwait"] = 300},
	[4] = {["pos"] = {-1182.32,-1773.28,3.90},["r"] = 2,["event"] = "hospitalGarage",["id"] = 2,["maxwait"] = 300},
	[5] = {["pos"] = {1198.39,-1455.64,34.967},["r"] = 2,["event"] = "hospitalGarage",["id"] = 2,["maxwait"] = 300},

}

NPX.Controls.Distcheck.useThird = {
	-- hospital garage
	[0] = {["pos"] = {-475.67,-356.32,34.10},["r"] = 2,["event"] = "hospitalGarage",["id"] = 3,["maxwait"] = 300},
	[1] = {["pos"] = {364.68, -590.98, 28.69},["r"] = 2,["event"] = "hospitalGarage",["id"] = 3,["maxwait"] = 300},
	[2] = {["pos"] = {218.34,-1637.68,29.42},["r"] = 2,["event"] = "hospitalGarage",["id"] = 3,["maxwait"] = 300},
	[3] = {["pos"] = {-1182.32,-1773.28,3.90},["r"] = 2,["event"] = "hospitalGarage",["id"] = 3,["maxwait"] = 300},
	[4] = {["pos"] = {1198.39,-1455.64,34.967},["r"] = 2,["event"] = "hospitalGarage",["id"] = 3,["maxwait"] = 300},
	-- police garage

	[5] = {["pos"] = {2131.38,2925.52,-61.90},["r"] = 2,["event"] = "policeGarage",["id"] = 2,["maxwait"] = 300},
	[6] = {["pos"] = {441.25,-981.8,30.68},["r"] = 2,["event"] = "policeGarage",["id"] = 2,["maxwait"] = 300},
	[7] = {["pos"] = {834.41,-1263.51,26.06},["r"] = 2,["event"] = "policeGarage",["id"] = 2,["maxwait"] = 300},
	[8] = {["pos"] = {1859.45,3676.70,33.40},["r"] = 2,["event"] = "policeGarage",["id"] = 2,["maxwait"] = 300},
	[9] = {["pos"] = {-460.09,6023.54,31.34},["r"] = 2,["event"] = "policeGarage",["id"] = 2,["maxwait"] = 300},


}


-- Set / Getting info functions

function NPX.DataControls.getBindTable()

	local i = 1
	local controlTable = {}
	for k,v in pairs(NPX.Controls.Current) do
		controlTable[i] = {k,v}
		i = i+1
	end

    return controlTable
end

function NPX.DataControls.encodeSetBindTable(self, bindTable)

	local controlTable = {}
	for k,v in pairs(bindTable) do
		controlTable[v[1]] = v[2]
	end

	NPX.DataControls.setBindTable(controlTable,true)
end

function NPX.DataControls.toUpper(table)

	local controlTable = {}
	for k,v in pairs(table) do
		controlTable[k] = string.upper(v)
	end

    return controlTable
end

function NPX.DataControls.setBindTable(controlTable,shouldSend)
	if controlTable == nil then
		NPX.Controls.Current  = NPX.DataControls.toUpper(NPX.Controls.Default) 
		NPX.DataControls.setSecondaryBindTable(NPX.Controls.Current)
		TriggerServerEvent('np-base:sv:player_control_set',NPX.Controls.Current)
		NPX.DataControls.checkForMissing()
	else
		if shouldSend then 
			NPX.Controls.Current = NPX.DataControls.toUpper(controlTable)
			NPX.DataControls.setSecondaryBindTable(NPX.Controls.Current)
			TriggerServerEvent('np-base:sv:player_control_set',NPX.Controls.Current)
			NPX.DataControls.checkForMissing()
		else
			NPX.Controls.Current = NPX.DataControls.toUpper(controlTable)
			NPX.DataControls.setSecondaryBindTable(NPX.Controls.Current)
			NPX.DataControls.checkForMissing()
		end
	end
	TriggerEvent("event:control:update",NPX.DataControls.getTableInKeyNumbers())
end

function NPX.DataControls.setSecondaryBindTable(bindtable)

	NPX.Controls.secondaryBinds = {}
	local i = 0
	for k,v in pairs(bindtable) do
		local keyString = string.upper(v)

		if string.match(keyString, "+")  then
			local result = split(keyString, "+")
			local control1 = Keys[result[1]]
			local control2 = Keys[result[2]]

			local valid = true
			for i=1,#NPX.Controls.secondaryBinds  do
				if NPX.Controls.secondaryBinds[i] and NPX.Controls.secondaryBinds[i][1] == control1 then valid = false end
			end

			if valid then 
				NPX.Controls.secondaryBinds[i] = {}
				NPX.Controls.secondaryBinds[i][1] = control1
				NPX.Controls.secondaryBinds[i][2] = control2
				i = i + 1
			end
				
		end
	end
end

function NPX.DataControls.getTableInKeyNumbers()

	
	local controlTable = {}
	for k,v in pairs(NPX.Controls.Current) do
		controlTable[k] = {}
		controlTable[k][1] = Keys[string.upper(v)]
		controlTable[k][2] = string.upper(v)
	end

	return controlTable
end


function NPX.DataControls.getBindByID(bindID)
	local found = "none"
	for k,v in pairs(NPX.Controls.Current) do
		if k == bindID then
			found = v
			break
		end
	end
	return found
end

-- Action functions

function NPX.DataControls.distanceCall(distcheckName)
	local distanceTable = NPX.Controls.Distcheck[distcheckName]
	local found = -1

	local pedpos = GetEntityCoords(PlayerPedId()) -- to be changed to player data pos at later date

	for i=0,#distanceTable do
		local table = distanceTable[i]
		local v = table.pos

		local dist = #(vector3(v[1], v[2], v[3]) - vector3(pedpos.x,pedpos.y,pedpos.z)) -- check distance here
		if dist <= table.r and found == -1 then
			found = i
			break
		end
	end

	if found ~= -1 then

		local hasTimer = 99999

		local key = distanceTable[found].event.."_"..distanceTable[found].id
		if NPX.Controls.EventHolder[key] then
			hasTimer = (GetGameTimer()-NPX.Controls.EventHolder[key])
		end
		if  hasTimer >= distanceTable[found].maxwait then
			NPX.Controls.EventHolder[key] = GetGameTimer();
			TriggerEvent("event:control:"..distanceTable[found].event,distanceTable[found].id)
		end
	end
end


function NPX.DataControls.checkForMissing()
	local isMissing = false

	for j,h in pairs(NPX.Controls.Default) do
		if NPX.Controls.Current[j] == nil then
			isMissing = true
			NPX.Controls.Current[j] = h
		end
	end
	

	if isMissing then
		NPX.DataControls.setSecondaryBindTable(NPX.Controls.Current)
		TriggerServerEvent('np-base:sv:player_control_set',NPX.Controls.Current)
	end


end

function NPX.DataControls.validEvent(event,id,eventID)
	local v = NPX.Controls.events["general"][eventID]
	local hasTimer = 999999
	local eventKey = event.."_"..id

	if NPX.Controls.EventHolder[eventKey] then
		hasTimer = (GetGameTimer()-NPX.Controls.EventHolder[eventKey])
	end

	if NPX.Controls.EventHolder[eventKey] and hasTimer ~= 999999 then
		if hasTimer >= v.maxwait then
			NPX.Controls.EventHolder[eventKey] = GetGameTimer();
			TriggerEvent("event:control:"..event,id)
		end
	else
		if hasTimer >= 1000 then
			NPX.Controls.EventHolder[eventKey] = GetGameTimer();
			TriggerEvent("event:control:"..event,id)
		end

	end
end


local timer = 0;
local eventTimer = {}
-- General checks 
Citizen.CreateThread(function()
	while true do
		
		if NPX.Controls.Current["tokoptt"] then
			for i=0,#NPX.Controls.events["general"] do
				local v = NPX.Controls.events["general"][i]
				local keyString = NPX.Controls.Current[v["bind"]]
				local key = Keys[keyString]

				if key == 199 then
					if IsDisabledControlJustReleased(1,key) then
						local isConflicted = -1
						for i=0,#NPX.Controls.secondaryBinds do
							if IsControlPressed(1,NPX.Controls.secondaryBinds[i][1]) or IsDisabledControlPressed(1,NPX.Controls.secondaryBinds[i][1]) then
								isConflicted = NPX.Controls.secondaryBinds[i][1]
							end
						end

						if isConflicted ~= -1 then
							Wait(100)
							if IsControlPressed(1,isConflicted) or IsDisabledControlPressed(1,isConflicted) then
								local eventBind, idEvent = findBind(key,isConflicted)
								NPX.DataControls.validEvent(eventBind,idEvent,i)
							else
								NPX.DataControls.validEvent(v.event,v.id,i)
							end
						else
							if (GetGameTimer()-timer) > 400 then
								NPX.DataControls.validEvent(v.event,v.id,i)
							end
						end
					end
				else
					if IsControlJustPressed(1,key) and not IsControlJustPressed(1,0) and not IsControlJustPressed(1,nil) then
						if GetLastInputMethod(0) then
							local validTrigger = true
							if key == 39 or key == 40 then 
								if IsControlJustPressed(1,16) or IsControlJustPressed(1,17) or IsControlJustPressed(1,241) or IsControlJustPressed(1,242) then 
									validTrigger = false 
								end  
							end
							if validTrigger then
								local isConflicted = -1
								for i=0,#NPX.Controls.secondaryBinds do
									if IsControlPressed(1,NPX.Controls.secondaryBinds[i][2]) or IsDisabledControlPressed(1,NPX.Controls.secondaryBinds[i][2]) then
										isConflicted = NPX.Controls.secondaryBinds[i][2]
									end
								end

								if isConflicted ~= -1 then
									Wait(100)

									if IsControlPressed(1,isConflicted) or IsDisabledControlPressed(1,isConflicted) then
										local eventBind, idEvent = findBind(key,isConflicted)
										timer = GetGameTimer();
										NPX.DataControls.validEvent(eventBind,idEvent,i)
									else
										NPX.DataControls.validEvent(v.event,v.id,i)
									end
								else
									NPX.DataControls.validEvent(v.event,v.id,i)
								end
							end
						end
					end
				end
			end
		end
		Wait(5)
	end
end)


function findBind(first,last)

	local event = ""
	local id = 0

	if first == nil then return end

	for i=0,#NPX.Controls.events["general"] do
		local firstCorrect = false
		local secondCorrect = false




		local v = NPX.Controls.events["general"][i]
		local keyString = NPX.Controls.Current[v["bind"]]

		if string.match(keyString, "+")  then
			local result = split(keyString, "+")
			local control1 = Keys[result[1]]
			local control2 = Keys[result[2]]

			if control1== first or control2 == first then
				firstCorrect = true
			end

			if control1 == last or control2 == last then
				secondCorrect = true
			end

			if firstCorrect and secondCorrect then
				event = v.event
				id = v.id
			end

		end
	end

	return event,id
end


function split(source, sep)
    local result, i = {}, 1
    while true do
        local a, b = source:find(sep)
        if not a then break end
        local candidat = source:sub(1, a - 1)
        if candidat ~= "" then 
            result[i] = candidat
        end i=i+1
        source = source:sub(b + 1)
    end
    if source ~= "" then 
        result[i] = source
    end
    return result
end


-- Distance based checks 
Citizen.CreateThread(function()
	while true do

		DisableControlAction(1, 199, true)
		if NPX.Controls.Current["tokoptt"] then
			for i=0,#NPX.Controls.events["general-dist"] do
				local v = NPX.Controls.events["general-dist"][i]
				local key = Keys[NPX.Controls.Current[v["bind"]]]
				local hasTimer = 99999;
				if eventTimer[key] then
					hasTimer = (GetGameTimer()-eventTimer[key])
				end

				if IsControlJustPressed(1,key) and hasTimer > 500 then	
					eventTimer[key] = GetGameTimer();		
					NPX.DataControls.distanceCall(v["distanceName"])
				end	
			end
		end
		Wait(5)
	end
end)


RegisterNetEvent("np-base:cl:player_control")
AddEventHandler("np-base:cl:player_control", function(controlTable)
	NPX.DataControls.setBindTable(controlTable,false)
end)

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["INPUTAIM"] = 25
}



RegisterNetEvent('np-base:setcontrols')
AddEventHandler('np-base:setcontrols', function()
	TriggerServerEvent('np-base:sv:player_controls')
end)

--[[

RegisterNetEvent('event:control:cid')
AddEventHandler('event:control:cid', function()

end)


]]