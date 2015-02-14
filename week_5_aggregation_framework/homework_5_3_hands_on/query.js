db.grades.aggregate([
    {"$unwind":"$scores"},
    {$match:{"scores.type":{$in: ["exam", "homework"]}}},
    {
      "$group": {
        "_id": {"class_id": "$class_id", "student_id": "$student_id"},
        avg_score: {"$avg": "$scores.score" }
      }
    },
    {$project:{_id:0,class_id:"$_id.class_id", student_id: "$_id.student_id", avg_score:1}},
    {
      "$group": {
        "_id": {"class_id": "$class_id"},
        avg_class_score: {"$avg": "$avg_score" }
      }
    },
    {$sort:{avg_class_score:-1}}
])
