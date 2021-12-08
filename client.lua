-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData() -- Just for resource restart (same as event handler)
local inLAVS = false
local testDriveVeh, inTestDrive = 0, false
local ClosestVehicle, ClosestShop = 1, nil
local zones = {}

-- Handlers

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    local citizenid = PlayerData.citizenid
    local gameTime = GetGameTimer()
    TriggerServerEvent('qb-aircraftshop:server:addPlayer', citizenid, gameTime)
    TriggerServerEvent('qb-aircraftshop:server:checkFinance')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    local citizenid = PlayerData.citizenid
    TriggerServerEvent('qb-aircraftshop:server:removePlayer', citizenid)
    PlayerData = {}
end)

-- Static Headers

local vehHeaderMenu = {
    {
        header = 'Vehicle Options',
        txt = 'Interact with the current vehicle',
        params = {
            event = 'qb-aircraftshop:client:showVehOptions'
        }
    }
}

local financeMenu = {
    {
        header = 'Financed Vehicles',
        txt = 'Browse your owned vehicles',
        params = {
            event = 'qb-aircraftshop:client:getVehicles'
        }
    }
}

local returnTestDrive = {
    {
        header = 'Finish Test Drive',
        params = {
            event = 'qb-aircraftshop:client:TestDriveReturn'
        }
    }
}

-- Functions

local function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

local function comma_value(amount)
    local formatted = amount
    while true do
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
end

local function getVehName()
    return QBCore.Shared.Vehicles[Config.Shops[ClosestShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle]["name"]
end

local function getVehPrice()
    return comma_value(QBCore.Shared.Vehicles[Config.Shops[ClosestShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle]["price"])
end

local function getVehBrand()
    return QBCore.Shared.Vehicles[Config.Shops[ClosestShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle]["brand"]
end

local function setClosestShowroomVehicle()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(Config.Shops[ClosestShop]["ShowroomVehicles"]) do
        local dist2 = #(pos - vector3(Config.Shops[ClosestShop]["ShowroomVehicles"][id].coords.x, Config.Shops[ClosestShop]["ShowroomVehicles"][id].coords.y, Config.Shops[ClosestShop]["ShowroomVehicles"][id].coords.z))
        if current ~= nil then
            if dist2 < dist then
                current = id
                dist = dist2
            end
        else
            dist = dist2
            current = id
        end
    end
    if current ~= ClosestVehicle then
        ClosestVehicle = current
    end
end

local function createTestDriveReturn()
    testDriveZone = BoxZone:Create(
        Config.Shops[ClosestShop]["ReturnLocation"],
        3.0,
        5.0, {
        name="box_zone"
    })

    testDriveZone:onPlayerInOut(function(isPointInside)
        if isPointInside and IsPedInAnyVehicle(PlayerPedId()) then
            exports['qb-menu']:openMenu(returnTestDrive)
        else
            exports['qb-menu']:closeMenu()
        end
    end)
end

local function startTestDriveTimer(testDriveTime)
    local gameTimer = GetGameTimer()
    CreateThread(function()
        while inTestDrive do
            Wait(1)
            if GetGameTimer() < gameTimer+tonumber(1000*testDriveTime) then
                local secondsLeft = GetGameTimer() - gameTimer
                drawTxt('Test Drive Time Remaining: '..math.ceil(testDriveTime - secondsLeft/1000),4,0.5,0.93,0.50,255,255,255,180)
            end
        end
    end)
end

local function createVehZones(ClosestShop) -- This will create an entity zone if config is true that you can use to target and open the vehicle menu
    if not Config.UsingTarget then
        for i = 1, #Config.Shops[ClosestShop]['ShowroomVehicles'] do
            zones[#zones+1] = BoxZone:Create(
                vector3(Config.Shops[ClosestShop]['ShowroomVehicles'][i]['coords'].x,
                Config.Shops[ClosestShop]['ShowroomVehicles'][i]['coords'].y,
                Config.Shops[ClosestShop]['ShowroomVehicles'][i]['coords'].z),
                2.75,
                2.75, {
                name="box_zone",
                debugPoly=false,
            })
        end
        local combo = ComboZone:Create(zones, {name = "vehCombo", debugPoly = false})
        combo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                if PlayerData.job.name == Config.Shops[ClosestShop]['Job'] or Config.Shops[ClosestShop]['Job'] == 'none' then
                    exports['qb-menu']:showHeader(vehHeaderMenu)
                end
            else
                exports['qb-menu']:closeMenu()
            end
        end)
    else
        exports['qb-target']:AddGlobalVehicle({
            options = {
                {
                    type = "client",
                    event = "qb-aircraftshop:client:showVehOptions",
                    icon = "fas fa-car",
                    label = "Vehicle Interaction",
                    canInteract = function(entity)
                        if (inLAVS) and (Config.Shops[ClosestShop]['Job'] == 'none' or PlayerData.job.name == Config.Shops[ClosestShop]['Job']) then
                            return true
                        end
                        return false
                    end
                },
            },
            distance = 2.0
        })
    end
end

-- Zones

---CUSTOM LAVS--
local LAVS = PolyZone:Create({
    vector2(-1673.08, -3100.58),
    vector2(-1676.84, -3106.01),
    vector2(-1680.66, -3103.83),
    vector2(-1707.15, -3159.72),
    vector2(-1647.6, -3194.32),
    vector2(-1609.24, -3150.01),
    vector2(-1604.57, -3140.66),
    vector2(-1673.08, -3100.58),
    


    

  }, {
    name="LAVS",
    minZ = 4,
    maxZ = 40
})

LAVS:onPlayerInOut(function(isPointInside)
    if isPointInside then
        ClosestShop = 'LAVS'
        inLAVS = true
        CreateThread(function()
            while inLAVS do
                setClosestShowroomVehicle()
                vehicleMenu = {
                    {
                        isMenuHeader = true,
                        header = getVehBrand():upper().. ' '..getVehName():upper().. ' - $' ..getVehPrice(),
                    },
                    {
                        header = 'Test Drive',
                        txt = 'Send the closest citizen for a test drive',
                        params = {
                            isServer = true,
                            event = 'qb-aircraftshop:server:customTestDrive',
                            args = {
                                testVehicle = Config.Shops[ClosestShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle
                            }
                        }
                    },
                    {
                        header = "Sell Aircraft",
                        txt = 'Sell Aircraft to closest citizen',
                        params = {
                            isServer = true,
                            event = 'qb-aircraftshop:server:sellShowroomVehicle',
                            args = {
                                buyVehicle = Config.Shops[ClosestShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle
                            }
                        }
                    },
                    {
                        header = 'Finance Aircraft',
                        txt = 'Finance Aircraft to closest citizen',
                        params = {
                            event = 'qb-aircraftshop:client:openCustomFinance',
                            args = {
                                price = getVehPrice(),
                                buyVehicle = Config.Shops[ClosestShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle
                            }
                        }
                    },
                    {
                        header = 'Swap Aircraft',
                        txt = 'Change currently selected Aircraft',
                        params = {
                            event = 'qb-aircraftshop:client:vehCategories',
                        }
                    },
                }
                Wait(1000)
            end
        end)
    else
        inLAVS = false
        ClosestShop = nil
    end
end)
-- Events

RegisterNetEvent('qb-aircraftshop:client:homeMenu', function()
    exports['qb-menu']:openMenu(vehicleMenu)
end)

RegisterNetEvent('qb-aircraftshop:client:showVehOptions', function()
    exports['qb-menu']:openMenu(vehicleMenu)
end)

RegisterNetEvent('qb-aircraftshop:client:TestDrive', function()
    if not inTestDrive and ClosestVehicle ~= 0 then
        inTestDrive = true
        local prevCoords = GetEntityCoords(PlayerPedId())
        QBCore.Functions.SpawnVehicle(Config.Shops[ClosestShop]["ShowroomVehicles"][ClosestVehicle].chosenVehicle, function(veh)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            exports['LegacyFuel']:SetFuel(veh, 100)
            SetVehicleNumberPlateText(veh, 'TESTDRIVE')
            SetEntityAsMissionEntity(veh, true, true)
            SetEntityHeading(veh, Config.Shops[ClosestShop]["VehicleSpawn"].w)
            TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
            TriggerServerEvent('qb-vehicletuning:server:SaveVehicleProps', QBCore.Functions.GetVehicleProperties(veh))
            testDriveVeh = veh
            --QBCore.Functions.Notify('You have '..Config.Shops[ClosestShop]["TestDriveTimeLimit"]..' minutes remaining')
            exports['okokNotify']:Alert("INFO",'You have '..Config.Shops[ClosestShop]["TestDriveTimeLimit"]..' minutes remaining', 5000, 'info')
            SetTimeout(Config.Shops[ClosestShop]["TestDriveTimeLimit"] * 60000, function()
                if testDriveVeh ~= 0 then
                    testDriveVeh = 0
                    inTestDrive = false
                    QBCore.Functions.DeleteVehicle(veh)
                    SetEntityCoords(PlayerPedId(), prevCoords)
                   -- QBCore.Functions.Notify('Vehicle test drive complete')
                    exports['okokNotify']:Alert("INFO",'Vehicle test drive complete', 5000, 'info')
                end
            end)
        end, Config.Shops[ClosestShop]["VehicleSpawn"], false)
        createTestDriveReturn()
        startTestDriveTimer(Config.Shops[ClosestShop]["TestDriveTimeLimit"] * 60)
    else
        --QBCore.Functions.Notify('Already in test drive', 'error')
        exports['okokNotify']:Alert("ERROR",'Already in test drive', 5000, 'error')
    end
end)

RegisterNetEvent('qb-aircraftshop:client:customTestDrive', function(data)
    if not inTestDrive then
        inTestDrive = true
        local vehicle = data.testVehicle
        local prevCoords = GetEntityCoords(PlayerPedId())
        QBCore.Functions.SpawnVehicle(vehicle, function(veh)
            exports['LegacyFuel']:SetFuel(veh, 100)
            SetVehicleNumberPlateText(veh, 'TESTDRIVE')
            SetEntityAsMissionEntity(veh, true, true)
            SetEntityHeading(veh, Config.Shops[ClosestShop]["VehicleSpawn"].w)
            TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
            TriggerServerEvent('qb-vehicletuning:server:SaveVehicleProps', QBCore.Functions.GetVehicleProperties(veh))
            testDriveVeh = veh
            --QBCore.Functions.Notify('You have '..Config.Shops[ClosestShop]["TestDriveTimeLimit"]..' minutes remaining')
            exports['okokNotify']:Alert("INFO",'You have '..Config.Shops[ClosestShop]["TestDriveTimeLimit"]..' minutes remaining', 5000, 'info')
            SetTimeout(Config.Shops[ClosestShop]["TestDriveTimeLimit"] * 60000, function()
                if testDriveVeh ~= 0 then
                    testDriveVeh = 0
                    inTestDrive = false
                    QBCore.Functions.DeleteVehicle(veh)
                    SetEntityCoords(PlayerPedId(), prevCoords)
                    QBCore.Functions.Notify('Vehicle test drive complete')
                end
            end)
        end, Config.Shops[ClosestShop]["VehicleSpawn"], false)
        createTestDriveReturn()
        startTestDriveTimer(Config.Shops[ClosestShop]["TestDriveTimeLimit"] * 60)
    else
        --QBCore.Functions.Notify('Already in test drive', 'error')
        exports['okokNotify']:Alert("ERROR",'Already in test drive', 5000, 'error')
    end
end)

RegisterNetEvent('qb-aircraftshop:client:TestDriveReturn', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    if veh == testDriveVeh then
        testDriveVeh = 0
        inTestDrive = false
        QBCore.Functions.DeleteVehicle(veh)
        exports['qb-menu']:closeMenu()
        testDriveZone:destroy()
    else
        --QBCore.Functions.Notify('This is not your test drive vehicle', 'error')
        exports['okokNotify']:Alert("ERROR",'This is not your test drive vehicle', 5000, 'error')
    end
end)

RegisterNetEvent('qb-aircraftshop:client:vehCategories', function()
    local categoryMenu = {
        {
            header = '< Go Back',
            params = {
                event = 'qb-aircraftshop:client:homeMenu'
            }
        }
    }
    for k,v in pairs(Config.Shops[ClosestShop]['Categories']) do
        categoryMenu[#categoryMenu + 1] = {
            header = v,
            params = {
                event = 'qb-aircraftshop:client:openVehCats',
                args = {
                    catName = k
                }
            }
        }
    end
    exports['qb-menu']:openMenu(categoryMenu)
end)

RegisterNetEvent('qb-aircraftshop:client:openVehCats', function(data)
    local vehicleMenu = {
        {
            header = '< Go Back',
            params = {
                event = 'qb-aircraftshop:client:vehCategories'
            }
        }
    }
    for k,v in pairs(QBCore.Shared.Vehicles) do
        if QBCore.Shared.Vehicles[k]["category"] == data.catName and QBCore.Shared.Vehicles[k]["shop"] == ClosestShop then
            vehicleMenu[#vehicleMenu + 1] = {
                header = v.name,
                txt = 'Price: $'..v.price,
                params = {
                    isServer = true,
                    event = 'qb-aircraftshop:server:swapVehicle',
                    args = {
                        toVehicle = v.model,
                        ClosestVehicle = ClosestVehicle,
                        ClosestShop = ClosestShop
                    }
                }
            }
        end
    end
    exports['qb-menu']:openMenu(vehicleMenu)
end)

RegisterNetEvent('qb-aircraftshop:client:openFinance', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = getVehBrand():upper().. ' ' ..data.buyVehicle:upper().. ' - $' ..data.price,
        submitText = "Submit",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'downPayment',
                text = 'Down Payment Amount - Min ' ..Config.MinimumDown..'%'
            },
            {
                type = 'number',
                isRequired = true,
                name = 'paymentAmount',
                text = 'Total Payments - Min '..Config.MaximumPayments
            }
        }
    })
    if dialog then
        if not dialog.downPayment or not dialog.paymentAmount then return end
        TriggerServerEvent('qb-aircraftshop:server:financeVehicle', dialog.downPayment, dialog.paymentAmount, data.buyVehicle)
    end
end)

RegisterNetEvent('qb-aircraftshop:client:openCustomFinance', function(data)
    TriggerEvent('animations:client:EmoteCommandStart', {"tablet2"})
    local dialog = exports['qb-input']:ShowInput({
        header = getVehBrand():upper().. ' ' ..data.buyVehicle:upper().. ' - $' ..data.price,
        submitText = "Submit",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'downPayment',
                text = 'Down Payment Amount - Min 10%'
            },
            {
                type = 'number',
                isRequired = true,
                name = 'paymentAmount',
                text = 'Total Payments - Max '..Config.MaximumPayments
            }
        }
    })
    if dialog then
        if not dialog.downPayment or not dialog.paymentAmount then return end
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent('qb-aircraftshop:server:sellfinanceVehicle', dialog.downPayment, dialog.paymentAmount, data.buyVehicle)
    end
end)

RegisterNetEvent('qb-aircraftshop:client:swapVehicle', function(data)
    if Config.Shops[data.ClosestShop]["ShowroomVehicles"][data.ClosestVehicle].chosenVehicle ~= data.toVehicle then
        local closestVehicle, closestDistance = QBCore.Functions.GetClosestVehicle(vector3(Config.Shops[data.ClosestShop]["ShowroomVehicles"][data.ClosestVehicle].coords.x, Config.Shops[data.ClosestShop]["ShowroomVehicles"][data.ClosestVehicle].coords.y, Config.Shops[data.ClosestShop]["ShowroomVehicles"][data.ClosestVehicle].coords.z))
        if closestVehicle == 0 then return end
        if closestDistance < 5 then QBCore.Functions.DeleteVehicle(closestVehicle) end
        Wait(250)
        local model = GetHashKey(data.toVehicle)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(250)
        end
        local veh = CreateVehicle(model, Config.Shops[data.ClosestShop]["ShowroomVehicles"][data.ClosestVehicle].coords.x, Config.Shops[data.ClosestShop]["ShowroomVehicles"][data.ClosestVehicle].coords.y, Config.Shops[data.ClosestShop]["ShowroomVehicles"][data.ClosestVehicle].coords.z, false, false)
        SetModelAsNoLongerNeeded(model)
        SetVehicleOnGroundProperly(veh)
        SetEntityInvincible(veh,true)
        SetEntityHeading(veh, Config.Shops[data.ClosestShop]["ShowroomVehicles"][data.ClosestVehicle].coords.w)
        SetVehicleDoorsLocked(veh, 3)
        FreezeEntityPosition(veh, true)
        SetVehicleNumberPlateText(veh, 'BUY ME')
        Config.Shops[data.ClosestShop]["ShowroomVehicles"][data.ClosestVehicle].chosenVehicle = data.toVehicle
    end
end)

RegisterNetEvent('qb-aircraftshop:client:buyShowroomVehicle', function(vehicle, plate)
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, Config.Shops[ClosestShop]["VehicleSpawn"].w)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        TriggerServerEvent("qb-vehicletuning:server:SaveVehicleProps", QBCore.Functions.GetVehicleProperties(veh))
    end, Config.Shops[ClosestShop]["VehicleSpawn"], true)
end)

RegisterNetEvent('qb-aircraftshop:client:getVehicles', function()
    QBCore.Functions.TriggerCallback('qb-aircraftshop:server:getVehicles', function(vehicles)
        local ownedVehicles = {}
        for k,v in pairs(vehicles) do
            if v.balance then
                local name = QBCore.Shared.Vehicles[v.vehicle]["name"]
                local plate = v.plate:upper()
                ownedVehicles[#ownedVehicles + 1] = {
                    header = ''..name..'',
                    txt = 'Plate: ' ..plate,
                    params = {
                        event = 'qb-aircraftshop:client:getVehicleFinance',
                        args = {
                            vehiclePlate = plate,
                            balance = v.balance,
                            paymentsLeft = v.paymentsleft,
                            paymentAmount = v.paymentamount
                        }
                    }
                }
            end
        end
        exports['qb-menu']:openMenu(ownedVehicles)
    end)
end)

RegisterNetEvent('qb-aircraftshop:client:getVehicleFinance', function(data)
    local vehFinance = {
        {
            header = '< Go Back',
            params = {
                event = 'qb-aircraftshop:client:getVehicles'
            }
        },
        {
            isMenuHeader = true,
            header = 'Total Balance Remaining',
            txt = '$'..comma_value(data.balance)..''
        },
        {
            isMenuHeader = true,
            header = 'Total Payments Remaining',
            txt = ''..data.paymentsLeft..''
        },
        {
            isMenuHeader = true,
            header = 'Recurring Payment Amount',
            txt = '$'..comma_value(data.paymentAmount)..''
        },
        {
            header = 'Make a payment',
            params = {
                event = 'qb-aircraftshop:client:financePayment',
                args = {
                    vehData = data,
                    paymentsLeft = data.paymentsleft,
                    paymentAmount = data.paymentamount
                }
            }
        },
        {
            header = 'Payoff vehicle',
            params = {
                isServer = true,
                event = 'qb-aircraftshop:server:financePaymentFull',
                args = {
                    vehBalance = data.balance,
                    vehPlate = data.vehiclePlate
                }
            }
        },
    }
    exports['qb-menu']:openMenu(vehFinance)
end)

RegisterNetEvent('qb-aircraftshop:client:financePayment', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = 'Vehicle Payment',
        submitText = "Make Payment",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'paymentAmount',
                text = 'Payment Amount ($)'
            }
        }
    })
    if dialog then
        if not dialog.paymentAmount then return end
        TriggerServerEvent('qb-aircraftshop:server:financePayment', dialog.paymentAmount, data.vehData)
    end
end)

-- Threads

CreateThread(function()
    for k,v in pairs(Config.Shops) do
        local Dealer = AddBlipForCoord(Config.Shops[k]["Location"])
        SetBlipSprite (Dealer, 423)
        SetBlipDisplay(Dealer, 4)
        SetBlipScale  (Dealer, 0.75)
        SetBlipAsShortRange(Dealer, true)
        SetBlipColour(Dealer, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Shops[k]["ShopLabel"])
        EndTextCommandSetBlipName(Dealer)
    end
end)

CreateThread(function()
    local financeZone = BoxZone:Create(Config.FinanceZone, 2.0, 2.0, {
        name="financeZone",
        offset={0.0, 0.0, 0.0},
        scale={1.0, 1.0, 1.0},
        debugPoly=false,
    })

    financeZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            exports['qb-menu']:showHeader(financeMenu)
        else
            exports['qb-menu']:closeMenu()
        end
    end)
end)

CreateThread(function()
    for k,v in pairs(Config.Shops) do
        for i = 1, #Config.Shops[k]['ShowroomVehicles'] do
            local model = GetHashKey(Config.Shops[k]["ShowroomVehicles"][i].defaultVehicle)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            local veh = CreateVehicle(model, Config.Shops[k]["ShowroomVehicles"][i].coords.x, Config.Shops[k]["ShowroomVehicles"][i].coords.y, Config.Shops[k]["ShowroomVehicles"][i].coords.z, false, false)
            SetModelAsNoLongerNeeded(model)
            SetEntityAsMissionEntity(veh, true, true)
            SetVehicleOnGroundProperly(veh)
            SetEntityInvincible(veh,true)
            SetVehicleDirtLevel(veh, 0.0)
            SetVehicleDoorsLocked(veh, 3)
            SetEntityHeading(veh, Config.Shops[k]["ShowroomVehicles"][i].coords.w)
            FreezeEntityPosition(veh,true)
            SetVehicleNumberPlateText(veh, 'BUY ME')
            createVehZones(k)
        end
    end
end)