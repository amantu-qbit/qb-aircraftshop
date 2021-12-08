# qb-vehicleshop

# qb-vehicleshop

**Add Job to qb-core/share.lua:**
	["airdealer"] = {
		label = "Airship Dealer",
		defaultDuty = true,
		grades = {
            ['0'] = {
                name = "Trainee",
                payment = 1000
            },
			['1'] = {
                name = "CEO",
				isboss = true,
                payment = 10000
            },
        },
	},

**Add to qb-bossmenu/account.json**
{"police":2000,"cardealer":600000,"taxi":0,"realestate":0,"ambulance":34338,"mechanic":9634495,"airdealer":130700000}

**Add to qb-bossmenu/config.lua**
['airdealer'] = vector3(-1702.57, -3155.78, 24.32)

### Dependencies:

**[PolyZone](https://github.com/qbcore-framework/PolyZone)**

**[qb-menu](https://github.com/qbcore-framework/qb-menu)**

**[qb-input](https://github.com/qbcore-framework/qb-input)**
