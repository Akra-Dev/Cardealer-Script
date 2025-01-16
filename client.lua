Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.Get.ESX, function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
local NumberCharset = {}
local Charset = {}
for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
local Prixveh = nil 
local NameVeh = nil
local ModelVeh = nil 
local descategories = {}
local allvehicle = {}
function getCategories()
    ESX.TriggerServerCallback('akra:getcategories', function(data)
       descategories = data
    end)
end
function getAllVehicle(catname)
    ESX.TriggerServerCallback('akra:getvehicle', function(data)
        allvehicle = data
    end, catname)
end
function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		-- math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))

		ESX.TriggerServerCallback('vehicle:verifierplaquedispoboutique', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('vehicle:verifierplaquedispoboutique', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end
function GetRandomNumber(length)
	Citizen.Wait(1)
	-- math.randomseed(GetGameTimer()) 

	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	-- math.randomseed(GetGameTimer())

	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end
local VehicleSpawned = {}
local LastVeh = nil
local LastLastVeh = nil
local openmenu = false
local mainmenu = RageUIv6.CreateMenu("", "Concessionaire")
local categories = RageUIv6.CreateSubMenu(mainmenu, "", "Catégories")
local vehicles = RageUIv6.CreateSubMenu(mainmenu, "", "Véhicle")
local buyVehicle =RageUIv6.CreateSubMenu(vehicles, "", "Achat")
function MenuConcess()
    if openmenu then
        openmenu = false
        RageUIv6.Visible(mainmenu, false)
    else
        openmenu = true
        RageUIv6.Visible(mainmenu, true)
        Citizen.CreateThread(function ()
            while openmenu do
                Wait(1)
                RageUIv6.IsVisible(mainmenu, function ()
                    RageUIv6.Button("Catalogue", nil, {RightLabel = "→→"}, true, {
                        onSelected = function ()
                            -- Wait(500)
                            getCategories()
                        end
                    }, categories)
                end)
                RageUIv6.IsVisible(categories, function ()
                    for k,v in pairs(descategories) do
                        RageUIv6.Button(v.label, nil, {RightLabel = "→→"}, true, {
                            onSelected = function ()
                                -- Wait(500)
                                getAllVehicle(v.name)
                            end
                        },vehicles)
                    end
                end)
                RageUIv6.IsVisible(vehicles, function ()
                    for k,v in pairs(allvehicle) do
                        RageUIv6.Button(v.name, nil, {RightLabel = "~b~Prix : ~w~"..v.price.."~g~$"}, true, {
                            onSelected = function ()
                                Prixveh = v.price
                                NameVeh = v.name
                                ModelVeh = v.model
                                if ESX.Game.IsSpawnPointClear(vector3(-42.4860, -1101.4235, 26.4223), 50) then
                                    ESX.Game.SpawnLocalVehicle(GetHashKey(ModelVeh), vector3(-42.4860, -1101.4235, 26.4223), 253.7432, function(vehicle)
                                        LastVeh = vehicle
                                        FreezeEntityPosition(vehicle, true)
                                        SetVehicleDoorsLocked(vehicle, 2)
                                        SetEntityInvincible(vehicle, true)
                                        SetVehicleFixed(vehicle)
                                        SetVehicleDirtLevel(vehicle, 0.0)
                                        SetVehicleEngineOn(vehicle, true, true, true)
                                        SetVehicleLights(vehicle, 2)
                                        SetVehicleCustomPrimaryColour(vehicle, 33,33,33)
                                        SetVehicleCustomSecondaryColour(vehicle, 33,33,33)
                                        table.insert(VehicleSpawned, {model = vehicle})
                                    end)
                                else
                                    DeleteEntity(LastVeh)
                                    DeleteEntity(LastLastVeh)
                                    ESX.Game.SpawnLocalVehicle(GetHashKey(ModelVeh), vector3(-42.4860, -1101.4235, 26.4223), 253.7432, function(vehicle)
                                        lockmenu = true
                                        LastVeh = vehicle
                                        FreezeEntityPosition(vehicle, true)
                                        SetVehicleDoorsLocked(vehicle, 2)
                                        SetEntityInvincible(vehicle, true)
                                        SetVehicleFixed(vehicle)
                                        SetVehicleDirtLevel(vehicle, 0.0)
                                        SetVehicleEngineOn(vehicle, true, true, true)
                                        SetVehicleLights(vehicle, 2)
                                        SetVehicleCustomPrimaryColour(vehicle, 33,33,33)
                                        SetVehicleCustomSecondaryColour(vehicle, 33,33,33)
                                        table.insert(VehicleSpawned, {model = vehicle})
                                    end)
                                end
                            end
                        },buyVehicle)
                    end
                end)
                RageUIv6.IsVisible(buyVehicle, function ()
                    RageUIv6.Separator("~r~Etes vous sur de votre Achat ?")
                    RageUIv6.Line()
                    RageUIv6.Button("Confirmer", nil, {RightLabel = Prixveh}, true, {
                        onSelected = function ()
                                        DeleteEntity(LastVeh)
                                        DeleteEntity(LastLastVeh)
                                        for k,v in pairs(VehicleSpawned) do 
                                            if DoesEntityExist(v.model) then
                                                Wait(150)
                                                DeleteEntity(v.model)
                                                table.remove(VehicleSpawned, k)
                                            end
                                        end
                            TriggerServerEvent("akra:buyvehicle", NameVeh, ModelVeh, tonumber(Prixveh))
                            RageUIv6.CloseAll()
                        end
                    })
                    RageUIv6.Button("Retour", nil, {RightLabel = "→→"}, true, {
                        onSelected = function ()
                            ESX.ShowNotification('Achat non confirmer.')
                                        DeleteEntity(LastVeh)
                                        DeleteEntity(LastLastVeh)
                                        for k,v in pairs(VehicleSpawned) do 
                                            if DoesEntityExist(v.model) then
                                                Wait(150)
                                                DeleteEntity(v.model)
                                                table.remove(VehicleSpawned, k)
                                            end
                                        end
                            RageUIv6.GoBack()
                        end
                    })
                end)
            end
        end)

    end
end


Citizen.CreateThread(function ()
    while true do
        Wait(1)
        for k,v in pairs(Config.Concess.pos) do
            local coords = GetEntityCoords(PlayerPedId())
            local pos = Config.Concess.pos
            local dist = Vdist(coords.x, coords.y, coords.z, pos[k].x, pos[k].y, pos[k].z)
            if dist <= 10 then
                DrawMarker(Config.Get.Marker.Type, pos[k].x, pos[k].y, pos[k].z, 0, 0, 0, Config.Get.Marker.Rotation, nil, nil, Config.Get.Marker.Size[1], Config.Get.Marker.Size[2], Config.Get.Marker.Size[3], Config.Get.Marker.Color[1], Config.Get.Marker.Color[2], Config.Get.Marker.Color[3], 170, 0, 1, 0, 0, nil, nil, 0)
                if dist <= 3 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour regarder le Catalogue")
                    if IsControlJustPressed(0, 51) then
                        MenuConcess()
                    end
                end
            end
        end
    end
end)
