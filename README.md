# qb-aircraftshop

**Private job-based dealership menu (works off closest player)**

![image](https://user-images.githubusercontent.com/57848836/138772120-9513fa09-a22f-4a5f-8afe-6dc7756999f4.png)

**Financing a vehicle with configurable max payment amount and minimum downpayment percentage**
![image](https://user-images.githubusercontent.com/57848836/138771328-0b88078c-9f3d-4754-a4c7-bd5b68dd5129.png)

**Financing preview header**

![image](https://user-images.githubusercontent.com/57848836/138773600-d6f510f8-a476-436d-8211-21e8c920eb6b.png)

**Finance vehicle list**

![image](https://user-images.githubusercontent.com/57848836/138771582-727e7fd4-4837-4320-b79a-479a6268b7ac.png)

**Make a payment or pay off vehicle in full**

![image](https://user-images.githubusercontent.com/57848836/138771627-faed7fcb-73c8-4b77-a33f-fffbb738ab03.png)

### Dependencies:

**[PolyZone](https://github.com/qbcore-framework/PolyZone)**

**[qb-menu](https://github.com/qbcore-framework/qb-menu)**

**[qb-input](https://github.com/qbcore-framework/qb-input)**

```lua
Config = {}
Config.UsingTarget = false -- If you are using qb-target (uses entity zones to target vehicles)
Config.Commission = 0.10 -- Percent that goes to sales person from a full car sale - default 10%
Config.FinanceCommission = 0.05 -- Percent that goes to sales person from a finance sale - default 5%
Config.FinanceZone = vector3(-29.53, -1103.67, 26.42) -- Where the finance menu is located
Config.PaymentWarning = 10 -- time in minutes that player has to make payment before repo - default 10
Config.PaymentInterval = 24 -- time in hours between payment being due - default 24
Config.MinimumDown = 10 -- minimum percentage allowed down - default 10
Config.MaximumPayments = 24 -- maximum payments allowed - default 24
Config.Shops = {
    ['pdm'] = {
        ['ShopLabel'] = 'Premium Deluxe Motorsport', -- Blip name
        ['Categories'] = { -- Categories available to browse
            ['sportsclassics'] = 'Sports Classics',
            ['sedans'] = 'Sedans',
            ['coupes'] = 'Coupes',
            ['suvs'] = 'SUVs',
            ['offroad'] = 'Offroad',
            ['muscle'] = 'Muscle',
            ['compacts'] = 'Compacts',
            ['motorcycles'] = 'Motorcycles',
            ['vans'] = 'Vans'
        },
        ['TestDriveTimeLimit'] = 0.5, -- Time in minutes until the vehicle gets deleted - default 0.5 (30 seconds)
        ['Location'] = vector3(-45.67, -1098.34, 26.42), -- Blip Location
        ['ReturnLocation'] = vector3(-44.74, -1082.58, 26.68), -- Location to return vehicle, only enables if the aircraftshop has a job owned
        ['VehicleSpawn'] = vector4(-56.79, -1109.85, 26.43, 71.5), -- Spawn location when vehicle is bought
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-45.65, -1093.66, 25.44, 69.5), -- where the vehicle will spawn on display
                defaultVehicle = 'adder', -- Default display vehicle
                chosenVehicle = 'adder', -- Same as default but is dynamically changed when swapping vehicles
            },
            [2] = {
                coords = vector4(-48.27, -1101.86, 25.44, 294.5),
                defaultVehicle = 'schafter2',
                chosenVehicle = 'schafter2',
            },
            [3] = {
                coords = vector4(-39.6, -1096.01, 25.44, 66.5),
                defaultVehicle = 'comet2',
                chosenVehicle = 'comet2',
            },
            [4] = {
                coords = vector4(-51.21, -1096.77, 25.44, 254.5),
                defaultVehicle = 'vigero',
                chosenVehicle = 'vigero',
            },
            [5] = {
                coords = vector4(-40.18, -1104.13, 25.44, 338.5),
                defaultVehicle = 't20',
                chosenVehicle = 't20',
            },
            [6] = {
                coords = vector4(-43.31, -1099.02, 25.44, 52.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati',
            },
            [7] = {
                coords = vector4(-50.66, -1093.05, 25.44, 222.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati',
            },
            [8] = {
                coords = vector4(-44.28, -1102.47, 25.44, 298.5),
                defaultVehicle = 'bati',
                chosenVehicle = 'bati',
            }
        },
    },
    ['luxury'] = {
        ['ShopLabel'] = 'Luxury Vehicle Shop',
        ['Categories'] = {
            ['super'] = 'Super',
            ['sports'] = 'Sports'
        },
        ['TestDriveTimeLimit'] = 0.5,
        ['Location'] = vector3(-63.59, 68.25, 73.06),
        ['ReturnLocation'] = vector3(-65.05, 81.23, 71.16),
        ['VehicleSpawn'] = vector4(-71.13, 84.04, 71.09, 65.23),
        ['ShowroomVehicles'] = {
            [1] = {
                coords = vector4(-75.96, 74.78, 70.90, 221.69),
                defaultVehicle = 'italirsx',
                chosenVehicle = 'italirsx',
            },
            [2] = {
                coords = vector4(-66.52, 74.33, 70.65, 188.03),
                defaultVehicle = 'italigtb',
                chosenVehicle = 'italigtb',
            },
            [3] = {
                coords = vector4(-71.83, 68.60, 70.75, 276.57),
                defaultVehicle = 'nero',
                chosenVehicle = 'nero',
            },
            [4] = {
                coords = vector4(-59.95, 68.61, 70.85, 181.44),
                defaultVehicle = 'comet2',
                chosenVehicle = 'comet2',
            }
        }
    } -- Add your next table under this comma
}
```

# License

    QBCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>
