ModelsWithChildLock = {
    "adspscout",
    "bcsonalamo",
    "bcsospeedo",
    "cfpdalamo2",
    "cfpdalamok9",
    "cfpdscout",
    "cfpdscout2",
    "cfpdstanier",
    "cfpdtorrence",
    "cfpdtorrenceum",
    "dppd",
    "dppdb",
    "dppdcara",
    "dppdcara2",
    "dppdcaraspare",
    "dppdk9",
    "dppdscout",
    "dppdscoutk9",
    "dppdscoutsgt",
    "dppdscoutunmk",
    "dppdsgt",
    "dppdunmk",
    "fbi",
    "glpdalamo",
    "glpdalamo2",
    "glpdbison",
    "glpdbisonum",
    "glpdgresley",
    "glpdgresleyum",
    "glpdscout",
    "glpdstanier",
    "lcpdh1b",
    "lcpd2e",
    "lcpd2f",
    "lcpd3b",
    "lcpd4b",
    "lcpd6a",
    "lcpd6aadl",
    "lcpd6aaqn",
    "lcpdaabahn",
    "lcpdakbd",
    "lcpdt6a",
    "crimetaxi",
    "polalamoold",
    "poleveron",
    "police",
    "police2",
    "police2a",
    "police2c",
    "police2gs",
    "policebufac",
    "police3",
    "police4",
    "police42old",
    "policeold",
    "policeslick",
    "polsadlerk9",
    "polspeedo",
    "pscout",
    "pscoutnew",
    "polprem",
    "polpremslick",
    "polpremumk",
    "lsppalamo",
    "lsppscout",
    "lsppscoutk9",
    "lsppscoutum",
    "lsppstanier",
    "lsppstanier2",
    "sheriff",
    "sheriff2",
    "sheriffalamo",
    "sheriffcq4",
    "sherifffug",
    "sheriffoss",
    "sheriffroamer",
    "sheriffrumpo",
    "sheriffscout",
    "sheriffscoutnew",
    "sheriffstalker",
    "sherprem",
    "sherprem2",
    "sheriffalamoold",
    "sheriffsar",
    "sheriffvanold",
    "sheriffmoon",
    "sherifftrike",
    "sheriffenduro",
    "sheriffold2",
    "sheriffold3",
    "sheriffriataold",
    "sheriffslick",
    "sheriffretro",
    "sheriffretro2",
    "sheriffcont",
    "sheriffintc",
    "sheriffscoutold",
    "sheriffoffroad",
    "sheriffghost",
    "sheriffscout2",
    "lssherbufac",
    "mrcaalamo",
    "mrcacara",
    "amb_rox_sheriff2",
    "rhpdfug",
    "rhpdfugumk",
    "rhpdscout",
    "rhpdscoutk9",
    "rhpdscoutslick",
    "rhpdscoutumk",
    "rhpdstanier",
    "securonscout",
    "securosurge",
    "securotorrence",
    "sadcrnscout",
    "sadcrrumpo",
    "sadcrstanier",
    "sadcrstank9",
    "sadcrtorrence",
    "sadcrtorrslick",
    "sahp",
    "sahp1a",
    "sahp1b",
    "sahp1b2",
    "sahp1b3",
    "sahp1c",
    "sahp1d",
    "sahp1e",
    "sahp2",
    "sahp2a",
    "sahp2b",
    "sahpprem",
    "sahppremslick",
    "parkprem",
}

function VehicleHasChildLock(veh)
	local model = GetEntityModel(veh)
	for i = 1, #ModelsWithChildLock, 1 do
		if model == GetHashKey(ModelsWithChildLock[i]) then
			return true
		end
	end
	return false
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsUsing(ped)

        if IsPedInVehicle(ped, veh, false) then
            if VehicleHasChildLock(veh) then

                if GetPedInVehicleSeat(veh, 1) == ped and GetVehicleDoorAngleRatio(veh, 2) == 0 then
                    DisableControlAction(0, 75, true)
                    DisableControlAction(0, 23, true)
                elseif GetPedInVehicleSeat(veh, 2) == ped and GetVehicleDoorAngleRatio(veh, 3) == 0 then
                    DisableControlAction(0, 75, true)
                    DisableControlAction(0, 23, true)
                end

            end
        end

    end
end)