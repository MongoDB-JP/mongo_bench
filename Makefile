TARGET=mongo_bench
SRC = mongo_bench.cpp
MONGO_VERSION=2.4.3
CPPFLAGS= -O3 -pthread -I mongo-cxx-driver-v2.4/src/
LDFLAGS = -L mongo-cxx-driver-v2.4/build/ -l mongoclient -lboost_thread-mt -lboost_filesystem 

all:${TARGET}

install:all

uninstall:

clean:
	rm -f *.o
	rm -f ${TARGET}

/usr/local/mongo/logs/mongod.pid:
	/usr/local/mongo/mongoctrl start
	sleep 10

test:all /usr/local/mongo/logs/mongod.pid
	nice ./mongo_bench 127.0.0.1:27017 test.TEST `cat /usr/local/mongo/logs/mongod.pid` 4000 100000 10


/usr/include/boost: /usr/lib64/libboost_thread-mt.so /usr/lib64/libboost_filesystem.so
	sudo yum install boost-devel.x86_64 

mongo-cxx-driver-v2.4:
	wget http://downloads.mongodb.org/cxx-driver/mongodb-linux-x86_64-${MONGO_VERSION}.tgz
	tar xzf mongodb-linux-x86_64-${MONGO_VERSION}.tgz
	rm mongodb-linux-x86_64-${MONGO_VERSION}.tgz
	pushd mongo-cxx-driver-v2.4
	scons
	popd

/usr/local/mongo:
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

prepare: /usr/include/boost mongo-cxx-driver-v2.4 /usr/local/mongo


${TARGET}: $(SRC)
	${CXX} $< -o $@ ${CPPFLAGS} ${LDFLAGS} 
