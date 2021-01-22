Config = {}

Config.version = "1.1.0"

------- Modules -------
Config.enableDebug = true
Config.enableGrids = true
Config.enableRadio = true
Config.enablePhone = true
Config.enableCar = true
Config.enableSpeaker = false
Config.enableSubmixes = false
Config.enableFilters = {
  phone = false,
  radio = true
}

------- Default Settings -------

Config.settings = {
    ["releaseDelay"] = 200,
    ["stereoAudio"] = true,
    ["localClickOn"] = true,
    ["localClickOff"] = true,
    ["remoteClickOn"] = true,
    ["remoteClickOff"] = true,
    ["clickVolume"] = 0.3,
    ["radioVolume"] = 0.3,
    ["phoneVolume"] = 0.8,
    ["vehicleVolume"] = 0.5
}

------- Voice Proximity -------

Config.voiceRanges = {
    { name = "whisper", range = 4.0 },
    { name = "normal", range = 10.0 },
    { name = "shout", range = 20.0 }
}

------- Hotkeys Config -------

Config.cycleProximityHotkey = "l"
Config.cycleRadioChannelHotkey = "i"
Config.transmitToRadioHotkey = "capital"
Config.phoneLoudSpeaker = "plus"

------- Modules Config -------

-- Speaker Module
Config.speakerDistance = 2.0
Config.radioSpeaker = true
Config.phoneSpeaker = true

-- Radio Module
Config.enableMultiFrequency = false

-- Grid Module
Config.gridSize = 512
-- Config.gridSize = 128
Config.gridEdge = 256 --20
Config.gridMinX = -4600
Config.gridMaxX = 4600
Config.gridMaxY = 9200