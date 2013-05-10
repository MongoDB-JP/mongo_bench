#What's this
#### mongo_bench.sh

   You can get the benchmark of the local MongoDB

#### How to use

   1. Setup local MongoDB in /usr/local/mongo.

       This script is requiring the PID file at /usr/local/mongo/logs/mongod.pid

       You can also use mongod.conf

   2. Build mongo_bench.

       type "make" at this directory.

       See "How to build" for details

   3. Run mongo_bench_mini.sh

       This bench is treating 400 MB data.

       First of all, you should run mongo_bench_mini.sh for test.

   4. Run mongo_bench.sh

       This bench is treating 40 GB data.

       But it will continue to run more than a overnight.

#Ease to try this

    make prepare
    make test
    ./mongo_bench_mini.sh


#Outputs

####[insert]

 Below outputs means,

  Inserted 1000,000 around 400 bytes documents from 10 threads.

  - It tooks 47.8652 seconds.
  - mongod used 124.872 CPU in avarage.
  - mongod could store 20892 documents per seconds.
  - Client sends 385000000 bytes data.
  - Actually,mongod saved 408000000 bytes data.
  - Throuput was 7.67081 MB per seconds.

 
    === insert_test* : 400 : 1000000 : 10 ===
    TIME: 47.8652 CPU: 124.872
     ALL>     20892 n/s, COL:  408000000 , TOTAL:  385000000 B,  0.358559 GB,   7.67081 MB/s,

####[update]

 Below outputs means,

  Updated number column from double to double.

  - mongod updated 21000000 bytes in total.


    === update_test<double>* : 400 : 1000000 : 1 ===
    TIME: 9.6226 CPU: 88.5416
     ALL>    103922 n/s, TOTAL:    21000000 B,2.08126e-06 MB/s,

####[update]

 Below outputs means,

  Updated number column from double (64bit) to long long (64bit).


    === update_test<long long>* : 400 : 1000000 : 1 ===
    TIME: 34.6098 CPU: 96.1578
     ALL>   28893.6 n/s, TOTAL:   21000000 B,  0.578656 MB/s,


####[fetch by $in]
 Below outputs means,

  Fetched 40000 documents by using $in operator from collection was housing 1000000 documents from 1 thread.

   It means RANDOM fetch.

  - Client received 15560000 bytes of BSON objects in total.


    === query_in_test* : 400 : 1000000 : 1 ===
    TIME: 0.366799 CPU: 27.2629
     ALL>   40000,     109052 n/s, TOTAL:   15560000 B, 0.0144914 GB,   40.4559 MB/s,

 Below outputs means,
  Fetched 40000 documents from collection was housing 1000000 documents from 100 thread.

    === query_in_test* : 400 : 1000000 : 100 ===

####[fetch by direct value]

  Fetched 40000 documents by specifing value from collection was housing 1000000 documents from 1 thread.

   It means RANDOM fetch.

    === query_test* : 400 : 1000000 : 1 ===

####[fetch by range]

 Below outputs means,

  Fetched 40000 documents by using $gte and $lt operators from collection was housing 1000000 documents from 1 thread.

   It means SEQUENCIAL fetch.

    === query_range_test* : 400 : 1000000 : 1 ===
    TIME: 0.092688 CPU: 86.3111
     ALL>   40000,     431555 n/s, TOTAL:   15560000 B, 0.0144914 GB,   160.098 MB/s,


#How to setup mongodb

    sudo mkdir -p $@
    sudo chmod 777 $@
    mkdir -p $@/conf
    mkdir -p $@/logs
    mkdir -p $@/data
    cp mongoctrl  $@/
    cp mongod.conf $@/conf
    wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.3.tgz
    tar xzf mongodb-linux-x86_64-2.4.3.tgz
    rm mongodb-linux-x86_64-${MONGO_VERSION}.tgz
    mv mongodb-linux-x86_64-2.4.3/bin $@/

#How to build

    sudo yum install boost-devel.x86_64
    export MONGO_VERSION=2.4.3
    wget http://downloads.mongodb.org/cxx-driver/mongodb-linux-x86_64-${MONGO_VERSION}.tgz
    tar xzf mongodb-linux-x86_64-${MONGO_VERSION}.tgz
    pushd mongo-cxx-driver-v2.4
    scons
    popd

#How to run

    g++ mongo_bench.cpp -o mongo_bench -O3 -pthread  -L mongo-cxx-driver-v2.4/build/ -l mongoclient -lboost_thread-mt -lboost_filesystem -I mongo-cxx-driver-v2.4/src/
    nice ./mongo_bench 127.0.0.1:27017 test.TEST `cat /usr/local/mongo/logs/mongod.pid` 4000 100000 10
