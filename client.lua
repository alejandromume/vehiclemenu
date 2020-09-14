ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Vehicle Menu", "~b~Menu con muchas opciones aplicables a Vehiculos")
_menuPool:Add(mainMenu)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

_menuPool:MouseControlsEnabled (false)
_menuPool:MouseEdgeEnabled(false)

local otro = NativeUI.CreateItem("Spawnear Vehiculo", "Escribe el modelo del coche y lo spawneara")
local otro2 = NativeUI.CreateItem("Borrar Vehiculo", "Estando subido a un vehiculo, podras borrarlo")
local otro3 = NativeUI.CreateItem("Borrar Vehiculos de delante", "Borrara los vehiculos que tengas enfrente tuya, el rango es modificable")
local otro4 = NativeUI.CreateItem("Arreglar Vehiculo", "Estando subido a un vehiculo, podras arreglarlo")
local otro5 = NativeUI.CreateItem("Romper Vehiculo", "Estando subido a un vehiculo, podras romperlo")

function AddMenuAnotherMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Informacion")

        submenu:AddItem(NativeUI.CreateItem("~p~Discord: ~r~alejandromume#1031", ""))
        submenu:AddItem(NativeUI.CreateItem("~b~Twitter: ~r~alejandromume", ""))

end

mainMenu:AddItem(otro)
mainMenu:AddItem(otro2)
mainMenu:AddItem(otro3)
mainMenu:AddItem(otro4)
mainMenu:AddItem(otro5)
AddMenuAnotherMenu(mainMenu)


mainMenu.OnItemSelect = function(sender, item, index)  
    if item == otro then
        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        RequestModel(GetHashKey(result))
        local vehicle = CreateVehicle(GetHashKey(result), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())+90, 1, 0)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   
    end

    elseif item == otro2 then
        if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) == "CARNOTFOUND" then
            ShowNotification("~r~Debes de estar subido a un vehiculo!")
        else
            deleteCar(GetVehiclePedIsIn(GetPlayerPed(-1), false))
            ShowNotification("~g~Vehiculo eliminado")
        end

    elseif item == otro3 then

        local distanceToCheck = 20.0

        local ped = GetPlayerPed( -1 )
        local playerPos = GetEntityCoords( GetPlayerPed(-1), 1 )
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
        local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )
        SetEntityAsMissionEntity( vehicle, true, true )
        deleteCar( vehicle )
        ShowNotification("~g~Eliminando Vehiculos...")

    elseif item == otro4 then
        if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) == "CARNOTFOUND" then
            ShowNotification("~r~Debes de estar subido a un vehiculo!")
        else
            car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetVehicleFixed(car)
            ShowNotification("~g~Vehiculo arreglado")
        end
    elseif item == otro5 then
        if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))) == "CARNOTFOUND" then
            ShowNotification("~r~Debes de estar subido a un vehiculo!")
        else
            car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            
            SetVehicleEngineHealth(car, 0)
            SetVehicleFuelLevel(car, 0)
            SetVehicleBodyHealth(car, 0)

            ShowNotification("~g~Vehiculo roto")
        end

    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 344) then
            mainMenu:Visible(not mainMenu:Visible())
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