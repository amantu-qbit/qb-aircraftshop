# qb-aircraftshop

**Add Job to qb-core/sharedlua under QBShared.Jobs:**
	['airdealer'] = {
        label = 'Aircraft Dealer',
        defaultDuty = true,
        grades = {
            ['0'] = {
                name = 'Freelancer',
                payment = 1000
            },
            ['1'] = {
                name = 'CEO',
                isboss = true,
                payment = 10000
            },
        }
    },

**Add to qb-bossmenu/config.lua**
['airdealer'] = vector3(-1702.57, -3155.78, 24.32)

### Dependencies:

**[PolyZone](https://github.com/qbcore-framework/PolyZone)**

**[qb-menu](https://github.com/qbcore-framework/qb-menu)**

**[qb-input](https://github.com/qbcore-framework/qb-input)**
