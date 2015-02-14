#!/usr/bin/env bash

MONGO_REPLICA_HOME=~/Projects/courses/mongodb/M101J/mongodb/replica

mkdir -p $MONGO_REPLICA_HOME/rs1 $MONGO_REPLICA_HOME/rs2 $MONGO_REPLICA_HOME/rs3
mongod --replSet m101 --logpath "1.log" --dbpath $MONGO_REPLICA_HOME/rs1 --port 27017 --oplogSize 64 --fork --smallfiles
mongod --replSet m101 --logpath "2.log" --dbpath $MONGO_REPLICA_HOME/rs2 --port 27018 --oplogSize 64 --smallfiles --fork
mongod --replSet m101 --logpath "3.log" --dbpath $MONGO_REPLICA_HOME/rs3 --port 27019 --oplogSize 64 --smallfiles --fork
