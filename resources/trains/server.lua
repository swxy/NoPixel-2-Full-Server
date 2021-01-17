local tabletrain = {}

RegisterServerEvent("RequestTrain")
AddEventHandler("RequestTrain",function()
	TriggerClientEvent("AskForTrainConfirmed", source)
end)