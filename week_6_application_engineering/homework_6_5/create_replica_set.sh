#!/usr/bin/env bash

MONGO_REPLICA_HOME=~/Projects/courses/mongodb/M101J/mongodb/replica_homework

mongod --replSet m101 --logpath "1.log" --dbpath $MONGO_REPLICA_HOME/rs1 --port 27017 --smallfiles --oplogSize 64 --fork
mongod --replSet m101 --logpath "2.log" --dbpath $MONGO_REPLICA_HOME/rs2 --port 27018 --smallfiles --oplogSize 64 --fork
mongod --replSet m101 --logpath "3.log" --dbpath $MONGO_REPLICA_HOME/rs3 --port 27019 --smallfiles --oplogSize 64 --fork
