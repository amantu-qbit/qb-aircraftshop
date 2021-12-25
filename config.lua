Config = {}
Config.UsingTarget = true -- If you are using qb-target (uses entity zones to target vehicles)
Config.Commission = 0.10 -- Percent that goes to sales person from a full airship sale 10%
Config.FinanceCommission = 0.05 -- Percent that goes to sales person from a finance sale 5%
Config.FinanceZone = vector3(-1698.83, -3150.0, 24.32) -- Where the finance menu is located
Config.PaymentWarning = 10 -- time in minutes that player has to make payment before repo
Config.PaymentInterval = 24 -- time in hours between payment being due
Config.MinimumDown = 40 -- minimum percentage allowed down
Config.MaximumPayments = 24 -- maximum payments allowed
Config.Shops = {
    ['LAVS'] = {
        ['Type'] = 'managed',  -- no player interaction is required to purchase a car
        ['Zone'] = {
            ['Shape'] = { --polygon that surrounds the shop
            vector2(-1673.08, -3100.58),
            vector2(-1676.84, -3106.01),
            vector2(-1680.66, -3103.83),
            vector2(-1707.15, -3159.72),
            vector2(-1647.6, -3194.32),
            vector2(-1609.24, -3150.01),
            vector2(-1604.57, -3140.66),
            vector2(-1673.08, -3100.58),
        },
        ['minZ'] = 4,  -- min height of the shop zone
        ['maxZ'] = 40  -- max height of the shop zone
    },

        ['Job'] = 'airdealer', -- Name of job or none
        ['ShopLabel'] = 'The Great AircraftShop (LSIA)',
        ['showBlip'] = true,
        ['Categories'] = {
            ['privatejet'] = 'Private Jet',
            ['helikopter'] = 'Helicopter'
        },
        ['TestDriveTimeLimit'] = 1, -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-1656.79, -3150.95, 13.99), -- Blip Location
        ['ReturnLocation'] = vector3(-1660.93, -3139.55, 13.99), -- Location to return vehicle, only enables if the aircraftshop has a job owned
        ['VehicleSpawn'] = vector4(-1691.08, -2938.44, 13.94, 243.23), -- Spawn location when vehicle is bought
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-1643.79, -3164.68, 13.18, 323.65), -- where the vehicle will spawn on display
                defaultVehicle = 'luxor', -- Default display vehicle
                chosenVehicle = 'luxor', -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-1675.2, -3146.09, 13.18, 326.76), -- where the vehicle will spawn on display
                defaultVehicle = 'havok', -- Default display vehicle
                chosenVehicle = 'havok', -- Same as default but is dynamically changed when swapping vehicles
            },
        },
        
    },
     -- Add your next table under this comma
}
