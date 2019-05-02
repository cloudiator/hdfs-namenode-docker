# operating system
FROM ubuntu:16.04

# install os packages
RUN apt-get update -y &&  apt-get install git curl gettext unzip wget software-properties-common python python-software-properties python-pip ssh python3-pip dnsutils make -y 

# install Java8
RUN add-apt-repository ppa:webupd8team/java -y && apt-get update && apt-get -y install openjdk-8-jdk-headless

# Set java home
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Set the hadoop version
ENV HADOOP_VERSION 2.9.0

# use bpkg to handle complex bash entrypoints
RUN curl -Lo- "https://raw.githubusercontent.com/bpkg/bpkg/master/setup.sh" | bash
RUN bpkg install cha87de/bashutil -g
## add more bash dependencies, if necessary 

# add config, init and source files 
# entrypoint
ADD init /opt/docker-init
RUN chmod +x  /opt/docker-init/entrypoint
#ADD conf /opt/docker-conf


# Download hadoop and unpack in /usr/share
RUN wget -q -O - "http://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" | gunzip | tar -x -C /usr/share

# Set hadoop home environment variable and add to path
ENV HADOOP_HOME /usr/share/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV PATH $PATH:${HADOOP_HOME}/bin


# Create a symlink to /usr/share/hadoop
RUN ln -s $HADOOP_HOME /usr/share/hadoop

# Add customized configuration
ADD etc /usr/share/hadoop/etc

# Add hadoop group
#RUN groupadd hadoop

# Add users for hdfs
#RUN useradd hdfs -G hadoop

# Make the hadoop directory writable
RUN mkdir /var/hadoop 
#&& chown hdfs:hadoop /var/hadoop
#USER hdfs

RUN mkdir -p /var/hadoop/data/nameNode

# Format the namenode
#RUN hdfs namenode -format


# Web
EXPOSE 50070

# Web HTTPS
EXPOSE 50470

# Default
EXPOSE 8020

EXPOSE 9000

# start from init folder
# Start the namenode
WORKDIR /opt/docker-init
ENTRYPOINT ["./entrypoint"]


