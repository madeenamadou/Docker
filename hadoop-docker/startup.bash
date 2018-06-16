#docker pull centos:latest
#docker build -t centos-hadoop .

docker run -it --name hadoop \
-v ~/tmp/hadoop_image/logs:/opt/hadoop/logs \
-v ~/tmp/hadoop_image/shared:/root/shared \
-p 49707:49707 -p 8031:8031 -p 8032:8032 -p 8033:8033 \
-p 8040:8040 -p 8030:8030 -p 8080:8080 -p 8888:8888 \
-p 11000:11000 -p 10001:10001 -p 15000:15000 -p 10000:10000 \
-p 50070:50070 -p 50075:50075 -p 50090:50090 -p 50020:50020 \
-p 50010:50010 -p 2222:22 -p 8042:8042 -p 8088:8088 \
-d centos-hadoop

alias hadoop-dckr='docker ps -l -q'

docker exec -it `hadoop-dckr` bash