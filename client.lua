-- INIT

DistantCopCarSirens(false) -- Disables distant cop car sirens

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
-- This section can be optimized. Please do that!!!
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
		local player = PlayerId()
		SetEveryoneIgnorePlayer(player, true)
		SetPoliceIgnorePlayer(player, true)
		SetDispatchCopsForPlayer(player, false)
		for i = 1, 12 do
			EnableDispatchService(i, false)
		end
		SetPlayerCanBeHassledByGangs(player, false)
		SetIgnoreLowPriorityShockingEvents(player, true)
		SetPlayerWantedLevel(player, 0, false)
		SetPlayerWantedLevelNow(player, false)
		SetPlayerWantedLevel(player, 0, false)
		local iter, handle = FindFirstPed()
		SetPedsToCalm(true, handle, iter)
	end
end)