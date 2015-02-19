use enron

db.messages.aggregate([
    {"$unwind":"$headers.To"},
    {"$project":
     {_id:0,
      'from':'$headers.From',
      'to':'$headers.To'
     }
   },
   {$group:{_id: {from:"$from", to:"$to"}, count:{$sum:1} }},
   {$sort:{count:-1}},
    {"$limit": 10},

])

// asnwer
// susan.mara@enron.com to richard.shapiro@enron.com
