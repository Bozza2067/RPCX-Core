	RegisterCommand('riot', function(source, args, rawCommand)
		if RiotMode == false then
			RiotMode = true
			print("Riot Mode Enabled")
		else
			RiotMode = false
			print("Riot Mode Disabled")
		end
	end, true)

	RegisterCommand('blackout', function(source, args, rawCommand)
		if Blackout == false then
			Blackout = true
			print("Blackout Mode Enabled")
		else
			Blackout = false
			print("Blackout Mode Disabled")
		end
	end, true)

-- CREDIT: https://github.com/TFNRP/framework
	function RegisterFrameworkCommand (name, handler, restricted)
		if type(name) == 'table' then
			for _, c in ipairs(name) do
				RegisterFrameworkCommand(c, handler, restricted)
			end
		else
			RegisterCommand(name, handler, restricted)
		end
	end
	function RegisterCommandSuggestion(command, description, parameters, client)
		if type(command) == 'table' then
			for _, c in ipairs(command) do
			RegisterCommandSuggestion(c, description, parameters)
			end
		else
			TriggerEvent('chat:addSuggestion', '/' .. command, description, parameters)
		end
	end