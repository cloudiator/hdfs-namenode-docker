docker run -d -p 8020:8020 -p 50070:50070 -p 9000:9000 --rm -e HDFS_NAMENODE_PORT='9000' --name hadoop-hdfs-namenode melodic/hadoop-hdfs-namenode:2.9.0
