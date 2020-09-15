ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function handleOrientation(orientation)
	if orientation == "right" then
		return 1320
	elseif orientation == "left" then
		return 0
	end
end

_menuPool = NativeUI.CreatePool()

-- PARA CAMBIAR LA POSICION DEL MENU, CAMBIA ABAJO EL right DE handleOrientation("right") A LAS POSICIONES INDICADAS EN LA FUNCION handleOrientation(orientation)
if Config.HideCredits then
    mainMenu = NativeUI.CreateMenu("Vehicle Menu", "", handleOrientation(Config.MenuPosition), 275)
else
    mainMenu = NativeUI.CreateMenu("Vehicle Menu", "~b~Desarrollado por ~w~alejandromume#1031", handleOrientation(Config.MenuPosition), 275)
end

_menuPool:Add(mainMenu)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

_menuPool:MouseControlsEnabled (false)
_menuPool:MouseEdgeEnabled(false)

local otro = NativeUI.CreateItem(_U("spawn"), _U("DESC_spawn"))
local otro1 = NativeUI.CreateItem(_U("spawn_plate"), _U("DESC_spawn_plate"))
local otro2 = NativeUI.CreateItem(_U("delete"), _U("DESC_delete"))
local otro3 = NativeUI.CreateItem(_U("delete_front"), _U("DESC_delete_front"))
local otro4 = NativeUI.CreateItem(_U("fix"), _U("DESC_fix"))
local otro5 = NativeUI.CreateItem(_U("break"), _U("DESC_break"))
--local otro6 = NativeUI.CreateItem("~o~Nitro!", "Activa el nitro y vuela!")

mainMenu:AddItem(otro)
mainMenu:AddItem(otro1)
mainMenu:AddItem(otro2)
mainMenu:AddItem(otro3)
mainMenu:AddItem(otro4)
mainMenu:AddItem(otro5)
--mainMenu:AddItem(otro6)



mainMenu.OnItemSelect = function(sender, item, index)  
    if item == otro then
        AddTextEntry('FMMC_KEY_TIP1', _U("vehicle_name"))
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()

        RequestModel(GetHashKey(result))

        while not HasModelLoaded(GetHashKey(result)) do
            RequestModel(GetHashKey(result))
            Citizen.Wait(0)
        end

        local vehicle = CreateVehicle(GetHashKey(result), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())+90, 1, 0)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
    end

    elseif item == otro2 then
        if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) == "CARNOTFOUND" then
            ShowNotification(_U("in_vehicle"))
        else
            SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false), true, true )
            deleteCar(GetVehiclePedIsIn(GetPlayerPed(-1), false))
            ShowNotification(_U("deleted"))
        end

    elseif item == otro3 then

        local distanceToCheck = 20.0

        local ped = GetPlayerPed( -1 )
        local playerPos = GetEntityCoords( GetPlayerPed(-1), 1 )
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
        local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )
        SetEntityAsMissionEntity( vehicle, true, true )
        deleteCar( vehicle )
        ShowNotification(_U("deleting"))

    elseif item == otro4 then
        if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) == "CARNOTFOUND" then
            ShowNotification(_U("in_vehicle"))
        else
            car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetVehicleFixed(car)
            ShowNotification(_U("fixed"))
        end
    elseif item == otro5 then
        if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) == "CARNOTFOUND" then
            ShowNotification(_U("in_vehicle"))
        else
            car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            
            SetVehicleEngineHealth(car, 0)
            SetVehicleFuelLevel(car, 0)
            SetVehicleBodyHealth(car, 0)

            ShowNotification(_U("breaked"))
        end

    elseif item == otro1 then

            local result2
            AddTextEntry('FMMC_MPM_NA', _U("vehicle_name"))
            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            local result1 = GetOnscreenKeyboardResult()
            AddTextEntry('FMMC_MPM_NA', _U("plate_text"))
            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
            while (UpdateOnscreenKeyboard() == 0) do
                DisableAllControlActions(0);
                Wait(0);
                if (GetOnscreenKeyboardResult()) then
                    result2 = GetOnscreenKeyboardResult()
                    -- result1 = nombre deñ vehiculo
                    --result2 = texto de la matricula
                end
            
            end

            RequestModel(GetHashKey(result1))

            while not HasModelLoaded(GetHashKey(result1)) do
                RequestModel(GetHashKey(result1))
                Citizen.Wait(0)
            end

            local vehicle3 = CreateVehicle(GetHashKey(result1), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())+90, 1, 0)
            SetVehicleNumberPlateText(vehicle3, result2)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle3, -1)
            --SetVehicleCustomPrimaryColour(vehicle3, 255, 0, 255)

        end
    elseif item == otro6 then
        --SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false), true, true)
        SetVehicleForwardSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), 60.0)
        SetVehicleBoostActive(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, 1)
        StartScreenEffect("RaceTurbo", 0, 0)
    end
end

local allowedToUse = false

Citizen.CreateThread(function()
    TriggerServerEvent("vehiclemenu:getIsAllowed")
end)

RegisterNetEvent("vehiclemenu:returnIsAllowed")
AddEventHandler("vehiclemenu:returnIsAllowed", function(isAllowed)
    allowedToUse = isAllowed
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        
            if IsControlJustPressed(1, 344) then
                if allowedToUse then
                mainMenu:Visible(not mainMenu:Visible())
                else
                    ShowNotification(_U("no_perms"))
                end
        end
    end
end)



function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
    --Citizen.InvokeNative( 0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized( entity ) )
end
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end