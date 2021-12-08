Config = {}
Config.UsingTarget = false -- If you are using qb-target (uses entity zones to target vehicles)
Config.Commission = 0.30 -- Percent that goes to sales person from a full airship sale 10%
Config.FinanceCommission = 0.05 -- Percent that goes to sales person from a finance sale 5%
Config.FinanceZone = vector3(-1698.83, -3150.0, 24.32) -- Where the finance menu is located
Config.PaymentWarning = 10 -- time in minutes that player has to make payment before repo
Config.PaymentInterval = 24 -- time in hours between payment being due
Config.MinimumDown = 40 -- minimum percentage allowed down
Config.MaximumPayments = 24 -- maximum payments allowed
Config.Shops = {
    ['LAVS'] = {
        ['Job'] = 'airdealer', -- Name of job or none
        ['ShopLabel'] = 'The Great AircraftShop (LSIA)',
        ['Categories'] = {
            ['privatejet'] = 'Private Jet',
            ['helikopter'] = 'Helicopter'
        },
        ['TestDriveTimeLimit'] = 1, -- Time in minutes until the vehicle gets deleted
        ['Location'] = vector3(-1656.79, -3150.95, 13.99), -- Blip Location
        ['ReturnLocation'] = vector3(-1660.93, -3139.55, 13.99), -- Location to return vehicle, only enables if the vehicleshop has a job owned
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
