function GetAudiocontextForClient(a)
	return Citizen.InvokeNative(`GET_AUDIOCONTEXT_FOR_CLIENT` & 0xFFFFFFFF, a, Citizen.ResultAsLong(), Citizen.ReturnResultAnyway())
end

function GetAudiocontextForServerId(a)
	return Citizen.InvokeNative(`GET_AUDIOCONTEXT_FOR_SERVERID` & 0xFFFFFFFF, a, Citizen.ResultAsLong(), Citizen.ReturnResultAnyway())
end

function AudiocontextGetSource(a)
	return Citizen.InvokeNative(`AUDIOCONTEXT_GET_SOURCE` & 0xFFFFFFFF, a, Citizen.ResultAsLong(), Citizen.ReturnResultAnyway())
end

function AudiocontextGetDestination(a)
	return Citizen.InvokeNative(`AUDIOCONTEXT_GET_DESTINATION` & 0xFFFFFFFF, a, Citizen.ResultAsLong(), Citizen.ReturnResultAnyway())
end

function AudiocontextConnect(a, b, c, d, e)
	Citizen.InvokeNative(`AUDIOCONTEXT_CONNECT` & 0xFFFFFFFF, a, b, c, d, e)
end

function AudiocontextDisconnect(a, b, c, d, e)
	Citizen.InvokeNative(`AUDIOCONTEXT_DISCONNECT` & 0xFFFFFFFF, a, b, c, d, e)
end

function AudiocontextCreateWaveshapernode(a)
	return Citizen.InvokeNative(`AUDIOCONTEXT_CREATE_WAVESHAPERNODE` & 0xFFFFFFFF, a, Citizen.ResultAsLong(), Citizen.ReturnResultAnyway())
end

function AudiocontextCreateBiquadfilternode(a)
	return Citizen.InvokeNative(`AUDIOCONTEXT_CREATE_BIQUADFILTERNODE` & 0xFFFFFFFF, a, Citizen.ResultAsLong(), Citizen.ReturnResultAnyway())
end

function WaveshapernodeSetCurve(a, b)
	Citizen.InvokeNative(`WAVESHAPERNODE_SET_CURVE` & 0xFFFFFFFF, a, b)
end

function BiquadfilternodeSetType(a, b)
	Citizen.InvokeNative(`BIQUADFILTERNODE_SET_TYPE` & 0xFFFFFFFF, a, b)
end

function GetBiquadQuality(a)
	return Citizen.InvokeNative(`BIQUADFILTERNODE_Q` & 0xFFFFFFFF, a, Citizen.ResultAsLong())
end

function GetBiquadGain(a)
	return Citizen.InvokeNative(`BIQUADFILTERNODE_GAIN` & 0xFFFFFFFF, a, Citizen.ResultAsLong())
end

function GetBiquadFrequency(a)
	return Citizen.InvokeNative(`BIQUADFILTERNODE_FREQUENCY` & 0xFFFFFFFF, a, Citizen.ResultAsLong())
end

function GetBiquadDetune(a)
	return Citizen.InvokeNative(`BIQUADFILTERNODE_DETUNE` & 0xFFFFFFFF, a, Citizen.ResultAsLong())
end

function DestroyBiquadFilterNode(a)
	Citizen.InvokeNative(`BIQUADFILTERNODE_DESTROY` & 0xFFFFFFFF, a)
end

function DestroyWaveShaperNode(a)
	Citizen.InvokeNative(`WAVESHAPERNODE_DESTROY` & 0xFFFFFFFF, a)
end

function SetAudioParameterValue(a, b)
	Citizen.InvokeNative(`AUDIOPARAM_SET_VALUE` & 0xFFFFFFFF, a, b)
end