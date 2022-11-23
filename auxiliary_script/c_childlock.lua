ModelsWithChildLock = {
    "adspscout",

    "bcsonalamo",
    "bcsospeedo",

    "cfpdalamo2",
    "cfpdscout",
    "cfpdscout2",
    "cfpdstanier",
    "cfpdtorrence",
    "cfpdtorrenceum",

    "dppd",
    "dppdcara",
    "dppdcara2",
    "dppdcaraspare",
    "dppdk9",
    "dppdscout",
    
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

    "lsiascoutII",
    "lsiastanierk9",
    "lsiastanier",
    "lsiastanierumk",
    "lsiafug",

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
    "polspeedo",
    "pscout",
    "pscoutnew",
    "polprem",
    "polpremslick",
    "polpremumk",
    "lspdstalker",
    "polroamer",
    "policefug",
    "policefug2",
    "policefug3",

    "lsppalamo",
    "lsppscout",
    "lsppscoutum",
    "lsppstanier",
    "lsppstanier2",
    
    "sheriff",
    "sheriff2",
    "sheriffalamo",
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
    "sheriffscout2",
    "lssherbufac",

    "mcsoalamo",
    "mcsoalamo2",
    "mcsoalamo3",
    "mcsocara",
    "mcsocara2",
    "mcsocara3",
    "mcsoscout",
    "mcsoscout2",
    "mcsoscout3",
    "mcsoscout4",
    "mcsostalker",
    "mcsostanier",
    "mcsostanier2",
    "mcsotorr",
    "mcsotorr2",
    "mcsoyosemite",

    "mrcaalamo",
    "mrcacara",

    "amb_rox_sheriff2",
    "amb_rox_swat",
    "roxpolmav",

    "rhpdfug",
    "rhpdfugumk",
    "rhpdscout",
    "rhpdscoutk9",
    "rhpdscoutslick",
    "rhpdscoutumk",
    "rhpdstanier",

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

    "unipd",
    "unipd2",
    "unipd3",
    "unipd4",
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