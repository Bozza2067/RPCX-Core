-- INIT

DistantCopCarSirens(false) -- Disables distant cop car sirens
LockRadioStation("RADIO_27_DLC_PRHEI4", false) -- Unlock Still Slipping Los Santos
SetFlashLightKeepOnWhileMoving(true) -- Keep weapon flashlight on
SetWeaponsNoAutoreload(true) -- Stop automatic reloads
SetWeaponsNoAutoswap(true) -- Stop automatic swap weapon on empty

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
		SetDiscordAppId(tonumber(GetConvar("RichAppId", "858521709236453416")))
		SetDiscordRichPresenceAsset(GetConvar("RichAssetId", "sa"))
		SetDiscordRichPresenceAction(0, "Connect to the server", "fivem://connect/m633od")
		SetDiscordRichPresenceAction(1, "See our website and servers list", "https://www.policingmp.net")
		SetRichPresence("Bottom Text \n Top Text")
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