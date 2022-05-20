-- VAR

	local Constants = {
		SEMI_AUTO = 1,
		BURST_FIRE = 2,
		FULL_AUTO = 3,
	}

	local AllowedAuto = {
		[GetHashKey('GROUP_RIFLE')] = true,
		[GetHashKey('GROUP_SMG')] = true,
	}

	local Weapons = {}

	local healCooldown = false -- DON'T CHANGE THIS
	local armorCooldown = false -- DON'T CHANGE THIS

	DoorIndex = {
	['driver'] = 1,
	['left'] = 1,
	['passenger'] = 2,
	['right'] = 2,
	['rear left passenger'] = 3,
	['rear left'] = 3,
	['rear right passenger'] = 4,
	['rear right'] = 4,
	['hood'] = 5,
	['bonnet'] = 5,
	['trunk'] = 6,
	['boot'] = 6,
	}

-- INIT

	DistantCopCarSirens(false) -- Disables distant cop car sirens
	LockRadioStation("RADIO_27_DLC_PRHEI4", false) -- Unlock Still Slipping Los Santos
	SetFlashLightKeepOnWhileMoving(true) -- Keep weapon flashlight on
	SetWeaponsNoAutoreload(true) -- Stop automatic reloads
	SetWeaponsNoAutoswap(true) -- Stop automatic swap weapon on empty

-- LOOP 0
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			SetArtificialLightsState(Blackout) -- Sets light state to current blackout state
			SetArtificialLightsStateAffectsVehicles(false) -- Re-enables vehicle lights during blackout mode
			HideHudComponentThisFrame(14) -- Hide Reticule
			HideHudComponentThisFrame(2) -- Hide Ammo HUD

			-- decrease dmg output of taser & baton
			SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_STUNGUN'), .1)
			SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_NIGHTSTICK'), .1)
			SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_BEANBAG'), .1)
			SetWeaponDamageModifierThisFrame(GetHashKey('WEAPON_BATON'), .01)

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

			-- Weapon Stuff
			-- Credit: https://github.com/TFNRP/WeaponControl
		end
	end)

-- RECOIL, FIRING MODES, RANDOM MALFUNCTIONS
-- Credit: https://github.com/TFNRP/WeaponControl
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
				-- VAR
			local ped = PlayerPedId()
			local _, weapon = GetCurrentPedWeapon(ped)
			local Weapon = GetWeapon(weapon)

				if IsPedShooting(ped) then
					--[[if not IsPedInAnyVehicle(ped) then
						local iter = 2
						if IsPedSprinting(ped) then
							iter = iter + 1
						end
						CreateThread(function()
							local last = GetGameplayCamRelativePitch()
							for _ = 1, iter do
								local camera = GetGameplayCamRelativePitch()
								local amount = camera - last
								if GetFollowPedCamViewMode() == 4 then
									amount = -amount
								end
								print(amount)
								SetGameplayCamRelativePitch(camera - amount, 1.0)
								last = camera
								Wait(1)
							end
						end)
					end]]
				if AllowedAuto[GetWeapontypeGroup(weapon)] then
					({
						function()
							repeat
								DisablePlayerFiring(PlayerId(), true)
								Wait(0)
							until not (IsControlPressed(0, 24) or IsDisabledControlPressed(0, 24))
						end,
						function()
							Wait(300)
							while IsControlPressed(0, 24) or IsDisabledControlPressed(0, 24) do
								DisablePlayerFiring(PlayerId(), true)
								Wait(0)
							end
						end,
						function() end,
					})[Weapon.FiringMode]()
				end
				-- Jamming
				local _, clipAmmo = GetAmmoInClip(ped, weapon)
				-- 1 in 1000 chance to jam for each bullet
				-- that's 40 mags of a carbine rifle or 100 mags of a pistol
				if math.random(1, 1.2e3) == 1 and clipAmmo > 0 then
					SetAmmoInClip(ped, weapon, 0)
					AddAmmoToPed(ped, weapon, clipAmmo)
					ShowNotification('Your gun is jammed.')
				end
			end
		end
	end)
	RegisterKeyMapping('firingmode', 'Change Firing Mode', 'keyboard', 'x')
	RegisterCommand('firingmode', function()
	local ped = PlayerPedId()
		if DoesEntityExist(ped) and not IsEntityDead(ped) and IsArmed() then
		local _, weapon = GetCurrentPedWeapon(ped)
		if AllowedAuto[GetWeapontypeGroup(weapon)] then
			local Weapon = GetWeapon(weapon)
			Weapon.FiringMode = ({ 2, 3, 1 })[Weapon.FiringMode]
			ShowNotification(({
				[Constants.SEMI_AUTO]  = 'Switched firing mode to ~r~semi-auto.',
				[Constants.BURST_FIRE] = 'Switched firing mode to ~y~burst fire.',
				[Constants.FULL_AUTO]  = 'Switched firing mode to ~g~full-auto.',
			})[Weapon.FiringMode])
			PlayClick(ped)
			end
		end
	end)

-- Discord Rich Presence

	Citizen.CreateThread(function()
		if RichPresence.Enabled == true then
			if RichPresence.AppID ~= nil then
				SetDiscordAppId(tonumber(GetConvar("RichAppId", RichPresence.AppID)))
				SetDiscordRichPresenceAsset(GetConvar("RichAssetId", RichPresence.AssetID))
			end
			--SetDiscordRichPresenceAction(0, "Connect to the server", "fivem://connect/m633od")
			--SetDiscordRichPresenceAction(1, "See our website and servers list", "https://www.policingmp.net")
			SetRichPresence(RichPresence.Text.Line2 .. "\n" .. RichPresence.Text.Line1)
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

-- Delete vehicle
-- Credit: https://github.com/TFNRP/framework

	RegisterFrameworkCommand({ 'dv', 'delveh' }, function()
		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsInOrNear(ped, false)
		if vehicle and vehicle > 1 then
		  if IsPedSittingInVehicle(ped, vehicle) and not GetPedInVehicleSeat(vehicle, -1) == ped then
			ShowNotification('~r~Error: ~s~You must be the driver of the vehicle.')
		  else
			NetworkRequestControlOfEntity(vehicle)
			SetEntityAsMissionEntity(vehicle, true, true)
			DeleteVehicle(vehicle)
			if not (DoesEntityExist(vehicle)) then
			  ShowNotification('~g~Success: ~s~Vehicle deleted.')
			end
		  end
		else
		  ShowNotification('~r~Error: ~w~You must be close to or in a vehicle.')
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

	TriggerEvent('chat:addSuggestion', '/heal', 'Refill your health.')
	RegisterCommand('heal', function(source, args, rawCommand)
		if healCooldown == false then
			TriggerServerEvent('txaLogger:CommandExecuted', rawCommand)
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
			SetEntityHealth(GetPlayerPed(-1), 200)
			ShowInfo("You have been healed. You will be able to heal yourself again in 20 seconds.")
			Wait(20000)
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

-- Toggle Engine
	--https://github.com/TFNRP/framework/blob/main/client.lua

	RegisterKeyMapping('engine', 'Toggle Engine', 'keyboard', 'F6')
	RegisterFrameworkCommand({ 'engine', 'eng' }, function(source, args, raw)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
		  local vehicle = GetVehiclePedIsIn(ped)
		  local on = GetIsVehicleEngineRunning(vehicle)
		  SetVehicleEngineOn(vehicle, not on, false, true)
		end
	  end)

-- Synchronize Vehicle Weapon with Foot Weapon
-- Credit: https://github.com/TFNRP/framework/blob/main/client.lua
	Citizen.CreateThread(function()
		local lastHash
		local lastNotInVehicle = true
		local lastNotInVehicleHash
		local switchedWeapon
		while true do
			Citizen.Wait(1)
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				if lastNotInVehicle then
					SetCurrentPedWeapon(ped, lastNotInVehicleHash, true)
					lastHash = lastNotInVehicleHash
				else
					local _, hash = GetCurrentPedWeapon(ped)
					if hash ~= lastHash then
						Citizen.Wait(1)
						switchedWeapon = true
						SetCurrentPedWeapon(ped, hash, true)
						lastHash = hash
					end
				end
				lastNotInVehicle = false
			else
				if not lastNotInVehicle and lastNotInVehicleHash ~= GetHashKey('WEAPON_UNARMED') and (not CanUseWeaponOnParachute(lastNotInVehicleHash) or not switchedWeapon) then
					SetCurrentPedWeapon(ped, lastNotInVehicleHash, true)
				end
				_, lastNotInVehicleHash = GetCurrentPedWeapon(ped)
				switchedWeapon = false
				lastNotInVehicle = true
			end
			GetCurrentPedVehicleWeapon(ped)
		end
	end)
	
	-- Hood, Trunk, Door and Window commands
	-- Credit: https://github.com/TFNRP/framework/blob/main/client.lua

	RegisterCommandSuggestion('hood', 'Open the hood of the vehicle you\'re near.')
	RegisterCommandSuggestion('trunk', 'Open the trunk of the vehicle you\'re near.')
	RegisterCommandSuggestion('door', 'Open a door of the vehicle you\'re near.', {
	{ name = 'door', help = 'Can be the number of the door or the door\'s name. i.e. "driver", "passenger", "1", "2"' }
	})
	RegisterCommandSuggestion('door f', 'Just like /door, but forces the door to stay open.', {
	{ name = 'door', help = 'Can be the number of the door or the door\'s name. i.e. "driver", "passenger", "1", "2"' }
	})
	RegisterCommandSuggestion('door q', 'Just like /door, but instantly opens/closes doors.', {
	{ name = 'door', help = 'Can be the number of the door or the door\'s name. i.e. "driver", "passenger", "1", "2"' }
	})

	RegisterFrameworkCommand('hood', function()
		local vehicle = GetVehiclePedIsInOrNear(PlayerPedId(), false)
		if vehicle and vehicle > 1 then
		  NetworkRequestControlOfEntity(vehicle)
		  if GetVehicleDoorAngleRatio(vehicle, 4) > 0 then
			SetVehicleDoorShut(vehicle, 4, false)
		  else
			SetVehicleDoorOpen(vehicle, 4, false, false)
			Wait(1e3)
			SetVehicleDoorOpen(vehicle, 4, true, false)
		  end
		end
	  end)
	  
	  RegisterFrameworkCommand('trunk', function()
		local vehicle = GetVehiclePedIsInOrNear(PlayerPedId(), false)
		if vehicle and vehicle > 1 then
		  NetworkRequestControlOfEntity(vehicle)
		  if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
			SetVehicleDoorShut(vehicle, 5, false)
		  else
			SetVehicleDoorOpen(vehicle, 5, false, false)
			Wait(1e3)
			SetVehicleDoorOpen(vehicle, 5, true, false)
		  end
		end
	  end)
	  
	  RegisterFrameworkCommand('door', function(source, args, raw)
		local vehicle = GetVehiclePedIsInOrNear(PlayerPedId(), false)
		local loose = true
		local instant = false
		if #args == 0 then table.insert(args, 1) end
		for _, arg in ipairs(args) do
		  local door = tonumber(arg)
		  if not door then
			arg = arg:lower()
			if DoorIndex[arg] then
			  door = DoorIndex[arg]
			elseif ({ f = true, force = true })[arg] then
			  loose = false
			elseif ({ q = true, quick = true })[arg] then
			  instant = true
			else
			  CommandWarning('Didn\'t understand what "' .. arg .. '" was.')
			end
		  end
		  if door then
			door = door - 1
			if vehicle and vehicle > 1 then
			  local doors = GetNumberOfVehicleDoors(vehicle) - 1
			  if doors < door then door = doors
			  elseif door < 0 then door = 0 end
			  NetworkRequestControlOfEntity(vehicle)
			  if GetVehicleDoorAngleRatio(vehicle, door) > 0 then
				SetVehicleDoorShut(vehicle, door, instant)
			  else
				CreateThread(function()
				  SetVehicleDoorOpen(vehicle, door, false, instant)
				  Wait(1e3)
				  SetVehicleDoorOpen(vehicle, door, loose, instant)
				end)
			  end
			end
		  end
		end
	  end)

	  RegisterCommandSuggestion('window', 'Open a window of the vehicle you\'re in.', {
		{ name = 'door', help = 'Can be the number of the window or the window\'s name. i.e. "driver", "passenger", "1", "2"' }
		})
	  RegisterFrameworkCommand('window', function(source, args, raw)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local window = (tonumber(args[1]) or 1) - 1
		if vehicle and vehicle > 1 then
		  if window > 11 then window = 11
		  elseif window < 0 then window = 0 end
		  local decoratorName = 'WindowRolledDown' .. window
		  if not DecorIsRegisteredAsType(decoratorName, 2) then
			DecorRegister(decoratorName, 2)
		  end
		  if not DecorGetBool(vehicle, decoratorName) then
			DecorSetBool(vehicle, decoratorName, true)
			RollDownWindow(vehicle, window)
		  else
			DecorSetBool(vehicle, decoratorName, false)
			RollUpWindow(vehicle, window)
		  end
		end
	  end)

-- leave engine running
		Citizen.CreateThread(function()
			while true do
			Citizen.Wait(1)
			local ped = PlayerPedId()
		
			if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
				Citizen.Wait(200)
				if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
					local vehicle = GetVehiclePedIsIn(ped, true)
					SetVehicleEngineOn(vehicle, true, true, false)
					TaskLeaveVehicle(ped, vehicle, 0)
					end
				end
			end
		end)

-- Persistent Flashlight compatibility with BetterFlashlight
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(2500)
			if BetterFlashlightInstalled then
				SetFlashLightKeepOnWhileMoving(true)
			end
		end
	end)

-- Functions

	function WeaponStub()
		return {
		FiringMode = 1,
		}
	end
	
	function GetWeapon(hash)
		if not Weapons[hash] then
		Weapons[hash] = WeaponStub()
		end
		return Weapons[hash]
	end
	
	function IsArmed()
		return IsPedArmed(PlayerPedId(), 4)
	end
	
	function PlayClick(ped)
		PlaySoundFromEntity(-1, 'Faster_Click', ped, 'RESPAWN_ONLINE_SOUNDSET', true)
	end

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

	-- https://github.com/TFNRP/framework/blob/main/client.lua
	function GetVehiclePedIsInOrNear(ped, lastVehicle)
	  local vehicle = GetVehiclePedIsIn(ped, lastVehicle)
	  if vehicle and vehicle > 1 then
		return vehicle
	  else
		local position = GetEntityCoords(ped)
		local front = GetOffsetFromEntityInWorldCoords(ped, .0, 3.5, -.5)
		local rayHandle = CastRayPointToPoint(position.x, position.y, position.z, front.x, front.y, front.z, 10, ped, 0)
		local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
		if DoesEntityExist(vehicle) then
		  return vehicle
		end
	  end
	end