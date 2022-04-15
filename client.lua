-- INIT

	DistantCopCarSirens(false) -- Disables distant cop car sirens
	LockRadioStation("RADIO_27_DLC_PRHEI4", false) -- Unlock Still Slipping Los Santos

-- General Functions

	function ShowInfo(text)
		SetTextComponentFormat("STRING")
		AddTextComponentString(text)
		DisplayHelpTextFromStringLabel(0, 0, 0, -1)
	end

	function ShowNotification(text)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(text)
		DrawNotification(false, false)
	end

-- LOOP 0

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			SetArtificialLightsState(Blackout)
			SetArtificialLightsStateAffectsVehicles(false) -- Re-enables vehicle lights during blackout mode

			-- Disable combat rolling & Climbing whilst aiming
			-- CREDIT: https://github.com/TFNRP/framework
			if IsPlayerFreeAiming(PlayerId()) then
				DisableControlAction(0, 22, true)
			end

			-- disable pistol-whip 
			-- CREDIT: https://github.com/TFNRP/framework
			if IsPedArmed(PlayerPedId(), 6) and not IsPedInAnyVehicle(PlayerPedId()) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			end
		end
	end)

-- Discord Rich Presence

	Citizen.CreateThread(function()
		local testServer = true
		SetDiscordAppId(tonumber(GetConvar("RichAppId", "858521709236453416")))
		SetDiscordRichPresenceAsset(GetConvar("RichAssetId", "sa"))
		if not testServer then
			SetDiscordRichPresenceAction(0, "Connect to the server", "fivem://connect/m633od")
		end
		SetDiscordRichPresenceAction(1, "See our website and servers list", "https://www.policingmp.net")
		while true do
			Citizen.Wait(0)
			if testServer then
				SetRichPresence("Developing the future of PolicingMP")
			else
				SetRichPresence("A free-to-use platform")
				Citizen.Wait(10000)
				SetRichPresence("for Code Zero-esque stuff")
				Citizen.Wait(10000)
				SetRichPresence("with some cool mods")
				Citizen.Wait(10000)
			end
		end
	end)

-- Save Wheel Position
-- Credit: https://github.com/TFNRP/framework

	Citizen.CreateThread(function()
		local vehicle
		local angle
		while true do
			Citizen.Wait(1)
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
			vehicle = GetVehiclePedIsIn(ped)
			local current = GetVehicleSteeringAngle(vehicle)
			if current > 20 then
				angle = 40.0
			elseif current < -20 then
				angle = -40.0
			elseif current > 5 or current < -5 then
				angle = current
			end
			end
		
			if angle and vehicle and DoesEntityExist(vehicle) and (IsPedOnFoot(ped) or IsPedStopped(ped)) then
			SetVehicleSteeringAngle(vehicle, angle)
			end
		end
	end)

-- Manage Riot Mode

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5000)
			SetRiotModeEnabled(RiotMode)
		end
	end)

-- Keep AI Calm, Disable emergency response
-- Credit: https://github.com/TFNRP/keepcalm

	function SetPedsToCalm(exists, handle, iter)
		if exists then
			SetBlockingOfNonTemporaryEvents(handle, true)
			SetPedFleeAttributes(handle, 0, 0)
			SetPedCombatAttributes(handle, 17, 1)
			local exists, handle = FindNextPed(iter)
			SetPedsToCalm(exists, handle, iter)
		else
			EndFindPed(iter)
		end
	end
		
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			for i = 1, 12 do
				EnableDispatchService(i, false)
			end
			if RiotMode == true then
				SetEveryoneIgnorePlayer(player, false)
				SetPlayerCanBeHassledByGangs(player, false)
				SetIgnoreLowPriorityShockingEvents(player, false)
				SetPedsToCalm(false, handle, iter)
			else
				local player = PlayerId()
				SetPoliceIgnorePlayer(player, true)
				SetDispatchCopsForPlayer(player, false)
				SetPlayerCanBeHassledByGangs(player, true)
				SetIgnoreLowPriorityShockingEvents(player, true)
				SetPlayerWantedLevel(player, 0, false)
				SetPlayerWantedLevelNow(player, false)
				SetPlayerWantedLevel(player, 0, false)
				local iter, handle = FindFirstPed()
				SetPedsToCalm(true, handle, iter)
			end
		end
	end)

	-- Heal self and replenish armor commands

	local healCooldown = false -- DON'T CHANGE THIS
	local armorCooldown = false -- DON'T CHANGE THIS
	local enableCoolDownTimer = false

	TriggerEvent('chat:addSuggestion', '/heal', 'Refill your health.')
	RegisterCommand('heal', function(source, args, rawCommand)
		if healCooldown == false then
			TriggerServerEvent('txaLogger:CommandExecuted', rawCommand)
			if enableCoolDownTimer then
				healCooldown = true
				ShowInfo("You will be healed in 15 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 14 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 13 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 12 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 11 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 10 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 9 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 8 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 7 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 6 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 6 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 5 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 4 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 3 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 2 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You will be healed in 1 seconds. Please wait.")
				Wait(1000)
				ShowInfo("You have been healed. You will be able to heal yourself again in 20 seconds.")
				Wait(20000)
			else
				ShowInfo("You have been healed.")
			end
			SetEntityHealth(GetPlayerPed(-1), 200)
			healCooldown = false
		else
			ShowInfo("You cannot heal yourself now.")
		end
	end)
	
	RegisterCommandSuggestion({ 'armour', 'armor' }, 'Set your armour.', {
		{ name = 'amount', help = '0 = none, 1 = some, 2 = under half, 3 = over half, 4 = almost max, 5 = max.' }
	})
	RegisterFrameworkCommand({ 'armour', 'armor' }, function(source, args, raw)
		local amount = (tonumber(args[1]) or 5) * 20
		if armorCooldown == false then
			TriggerServerEvent('txaLogger:CommandExecuted', rawCommand)
			if not IsPlayerDead(PlayerId()) then
				armorCooldown = true
				ShowInfo("Replenishing your armor. Please wait 5 seconds.")
				Wait(1000)
				ShowInfo("Replenishing your armor. Please wait 4 seconds.")
				Wait(1000)
				ShowInfo("Replenishing your armor. Please wait 3 seconds.")
				Wait(1000)
				ShowInfo("Replenishing your armor. Please wait 2 seconds.")
				Wait(1000)
				ShowInfo("Replenishing your armor. Please wait 1 second.")
				Wait(1000)
				ShowInfo("Your armor has been replenished. You will be able to replenish it again in 10 seconds.")
				Wait(10000)
				if amount > 100 then 
					amount = 100
				elseif amount < 0 then 
					amount = 0 
				end
				SetPedArmour(PlayerPedId(), amount)
				armorCooldown = false
			else
				ShowInfo("You cannot replenish your armor now.")
			end
		end
	end)

