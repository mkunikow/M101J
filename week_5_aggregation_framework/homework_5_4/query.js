db.zips.aggregate([
    {$project: {fc: {$substr : ["$city",0,1] }, city:1, state:1, pop:1}	},
    {$match: {fc: {$gte: '0', $lte: '9'}}},
    {"$group": {_id: null,pop: {"$sum": "$pop"}}}
])
