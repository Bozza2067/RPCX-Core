RiotMode = false
Blackout = false

RegisterCommand('riot', function(source, args, rawCommand)
	if RiotMode == false then
		RiotMode = true
	else
		RiotMode = false
	end
  end)

RegisterCommand('blackout', function(source, args, rawCommand)
	if Blackout == false then
		Blackout = true
	else
		Blackout = false
	end
end, true)