db.zips.aggregate([
  {
    "$match": {
      state: {"$in": ["CT", "NJ"]}
    }
  },
  {
    "$group": {
      "_id": {"state": "$state", "city": "$city"},
      tPop: {"$sum": "$pop" }
    }
  },
  {
    "$match": {
      "tPop": { "$gt": 25000 }
    }
  },
  {
    "$group": {
      _id: "$state",
      average: {"$avg": "$tPop"}
    }
  }
])

db.zips.aggregate([
  {
    "$match": {
      state: {"$in": ["CA", "NY"]}
    }
  },
  {
    "$group": {
      "_id": {"state": "$state", "city": "$city"},
      tPop: {"$sum": "$pop" }
    }
  },
  {
    "$match": {
      "tPop": { "$gt": 25000 }
    }
  },
  {
    "$group": {
      _id: "$state",
      average: {"$avg": "$tPop"}
    }
  }
])
