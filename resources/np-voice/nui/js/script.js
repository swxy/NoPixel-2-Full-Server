/* eslint-disable @typescript-eslint/explicit-function-return-type */
const ClickSounds = [
	{ on: "sounds/clicks/01-on.ogg", off: "sounds/clicks/01-off.ogg" },
	{ on: "sounds/clicks/02-on.ogg", off: "sounds/clicks/02-off.ogg" },
];

let IsRadioOn = false;

/* Hud Settings */
let RadioHudStyle = "normal";
let ClickVolume = 0.1;
let ClickSound = ClickSounds[0];

function PlaySound(soundTag = null, file = null, args = null) {
	const sound = document.querySelector(`#${soundTag}`);
	const soundFile = file;

	var args = args;

	for (i = 0; i < sound.attributes.length; i++) {
		if (sound.attributes[i].name != "id") {
			sound.removeAttribute(sound.attributes[i].name);
		}
	}

	if (soundFile == null) {
		sound.setAttribute("src", "");
	} else {
		if (args == null) {
		} else {
			for (const key in args) {
				if (key != "addMultiListener") {
					if (key == "volume") {
						sound.volume = args[key];
					} else {
						sound.setAttribute(key, args[key]);
					}
				}
			}
		}

		sound.setAttribute("src", soundFile);
		sound.play();
	}
}

function SetRadioPowerState(enabled) {
	PlaySound("local", enabled ? "sounds/radioon.ogg" : "sounds/radiooff.ogg", {
		volume: ClickVolume,
	});
}

function PlayLocalClick(transmitting) {
	PlaySound("local", transmitting ? ClickSound.on : ClickSound.off, {
		volume: ClickVolume,
	});
}

function PlayRemoteClick(status) {
	PlaySound("remote", status ? ClickSound.on : ClickSound.off, {
		volume: ClickVolume,
	});
}

function ToggleVoiceWarning(state){
	console.log('test2')
	if (state) {
		console.log('test1')
		let warningElem = document.getElementById("voip-warning");
		let warningItem = document.createElement("div");
		let warningItemTitle = document.createElement("span");
		let warningItemContent = document.createElement("span");

		warningItem.id = "voip-warning-child";
		warningItemTitle.textContent = "[Warning] ";
		warningItemTitle.className = "talking";
		warningItemContent.textContent = "Attiva la chat vocale";

		warningItem.appendChild(warningItemTitle);
		warningItem.appendChild(warningItemContent);
		warningElem.appendChild(warningItem);
	} else {
		//let warningItem = document.getElementById("voip-warning");
		let warningElem = document.getElementById("voip-warning");
		warningElem.innerHTML = '';
	}
}

window.addEventListener("load",function(){

	var aengine = new AudioEngine();
  
	//MESSAGES
	window.addEventListener("message",function(evt){ //lua actions
	//	console.log('test')
	  var data = evt.data;
	 // console.log(data.type)
	if (data.type === "hud") {
		SetHUDVisibility(data.enabled);
	} else if (data.type === "proximity") {
		ChangeVoiceProximity(event.data.proximity);
	} else if (data.type === "voiceStatus") {
		SetVoiceStatus(data.speaking);
	} else if (data.type === "radioPowerState") {
		SetRadioPowerState(data.state);
	} else if (data.type === "localClick") {
		PlayLocalClick(data.state);
	} else if (data.type === "remoteClick") {
		PlayRemoteClick(data.state);
	} else if (data.type === "settings") {
		SetHudSettings(data.settings);
	}
	else if (data.type === 'mumble_state') {
		console.log('test')
		console.log(data.bool)
		ToggleVoiceWarning(data.bool);
	}
	  // AUDIO
	  else if(data.act == "play_audio_source")
		aengine.playAudioSource(data);
	  else if(data.act == "set_audio_source")
		aengine.setAudioSource(data);
	  else if(data.act == "remove_audio_source")
		aengine.removeAudioSource(data);
	  else if(data.act == "audio_listener")
		aengine.setListenerData(data);
	  //VoIP
	  else if(data.act == "configure_voip")
		aengine.configureVoIP(data);
	  else if(data.act == "connect_voice")
		aengine.connectVoice(data);
	  else if(data.act == "disconnect_voice")
		aengine.disconnectVoice(data);
	  else if(data.act == "set_voice_state")
		aengine.setVoiceState(data);
	  else if(data.act == "configure_voice")
		aengine.configureVoice(data);
	  else if(data.act == "set_voice_indicator")
		aengine.setVoiceIndicator(data);
	  else if(data.act == "set_player_positions")
		aengine.setPlayerPositions(data);
	// Radio
	  else if(data.act == "set_radio_player_speaking_state")
	    radio_display.setPlayerSpeakingState(data);
	 });
 });