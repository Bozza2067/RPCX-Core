	RegisterCommand('riot', function(source, args, rawCommand)
		RiotMode = not RiotMode
		if RiotMode then
			print("Riot Mode Enabled")
		else
			print("Riot Mode Disabled")
		end
	end, true)

	RegisterCommand('blackout', function(source, args, rawCommand)
		Blackout = not Blackout
		if Blackout then
			print("Blackout Mode Enabled")
		else
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
