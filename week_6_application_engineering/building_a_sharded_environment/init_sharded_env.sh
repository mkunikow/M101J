

# Andrew Erlichson
# 10gen
# script to start a sharded environment on localhost

MONGO_SHRADED_HOME=~/Projects/courses/mongodb/M101J/mongodb/shraded
MONGO_SHRADED_CONFIG=$MONGO_SHRADED_HOME/config
MONGO_SHRADED_S00=$MONGO_SHRADED_HOME/shrad0
MONGO_SHRADED_S01=$MONGO_SHRADED_HOME/shrad1
MONGO_SHRADED_S02=$MONGO_SHRADED_HOME/shrad2

# clean everything up
echo "killing mongod and mongos"
killall mongod
killall monogs
echo "removing data files"
rm -rf $MONGO_SHRADED_CONFIG
rm -rf $MONGO_SHRADED_HOME/shard*


# start a replica set and tell it that it will be a shord0
mkdir -p $MONGO_SHRADED_S00/rs0 $MONGO_SHRADED_S00/rs1 $MONGO_SHRADED_S00/rs2
mongod --replSet s0 --logpath "s0-r0.log" --dbpath $MONGO_SHRADED_S00/rs0 --port 37017 --fork --shardsvr --smallfiles
mongod --replSet s0 --logpath "s0-r1.log" --dbpath $MONGO_SHRADED_S00/rs1 --port 37018 --fork --shardsvr --smallfiles
mongod --replSet s0 --logpath "s0-r2.log" --dbpath $MONGO_SHRADED_S00/rs2 --port 37019 --fork --shardsvr --smallfiles

sleep 5
# connect to one server and initiate the set
mongo --port 37017 << 'EOF'
config = { _id: "s0", members:[
          { _id : 0, host : "localhost:37017" },
          { _id : 1, host : "localhost:37018" },
          { _id : 2, host : "localhost:37019" }]};
rs.initiate(config)
EOF

# start a replicate set and tell it that it will be a shard1
mkdir -p $MONGO_SHRADED_S01/rs0 $MONGO_SHRADED_S01/rs1 $MONGO_SHRADED_S01/rs2
mongod --replSet s1 --logpath "s1-r0.log" --dbpath $MONGO_SHRADED_S01/rs0 --port 47017 --fork --shardsvr --smallfiles
mongod --replSet s1 --logpath "s1-r1.log" --dbpath $MONGO_SHRADED_S01/rs1 --port 47018 --fork --shardsvr --smallfiles
mongod --replSet s1 --logpath "s1-r2.log" --dbpath $MONGO_SHRADED_S01/rs2 --port 47019 --fork --shardsvr --smallfiles

sleep 5

mongo --port 47017 << 'EOF'
config = { _id: "s1", members:[
          { _id : 0, host : "localhost:47017" },
          { _id : 1, host : "localhost:47018" },
          { _id : 2, host : "localhost:47019" }]};
rs.initiate(config)
EOF

# start a replicate set and tell it that it will be a shard2
mkdir -p $MONGO_SHRADED_S02/rs0 $MONGO_SHRADED_S02/rs1 $MONGO_SHRADED_S02/rs2
mongod --replSet s2 --logpath "s2-r0.log" --dbpath $MONGO_SHRADED_S02/rs0 --port 57017 --fork --shardsvr --smallfiles
mongod --replSet s2 --logpath "s2-r1.log" --dbpath $MONGO_SHRADED_S02/rs1 --port 57018 --fork --shardsvr --smallfiles
mongod --replSet s2 --logpath "s2-r2.log" --dbpath $MONGO_SHRADED_S02/rs2 --port 57019 --fork --shardsvr --smallfiles

sleep 5

mongo --port 57017 << 'EOF'
config = { _id: "s2", members:[
          { _id : 0, host : "localhost:57017" },
          { _id : 1, host : "localhost:57018" },
          { _id : 2, host : "localhost:57019" }]};
rs.initiate(config)
EOF


# now start 3 config servers
mkdir -p $MONGO_SHRADED_CONFIG/config-a $MONGO_SHRADED_CONFIG/config-b $MONGO_SHRADED_CONFIG/config-c
mongod --logpath "cfg-a.log" --dbpath $MONGO_SHRADED_CONFIG/config-a --port 57040 --fork --configsvr --smallfiles
mongod --logpath "cfg-b.log" --dbpath $MONGO_SHRADED_CONFIG/config-b --port 57041 --fork --configsvr --smallfiles
mongod --logpath "cfg-c.log" --dbpath $MONGO_SHRADED_CONFIG/config-c --port 57042 --fork --configsvr --smallfiles


# now start the mongos on a standard port
mongos --logpath "mongos-1.log" --configdb localhost:57040,localhost:57041,localhost:57042 --fork
echo "Waiting 60 seconds for the replica sets to fully come online"
sleep 60
echo "Connnecting to mongos and enabling sharding"

# add shards and enable sharding on the test db
mongo <<'EOF'
db.adminCommand( { addShard : "s0/"+"localhost:37017" } );
db.adminCommand( { addShard : "s1/"+"localhost:47017" } );
db.adminCommand( { addShard : "s2/"+"localhost:57017" } );
db.adminCommand({enableSharding: "test"})
db.adminCommand({shardCollection: "test.grades", key: {student_id:1}});
EOF
