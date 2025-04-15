#!/bin/bash
apt update -y
apt install -y default-jdk wget

# Installer Tomcat
cd /opt
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz
tar -xzf apache-tomcat-9.0.85.tar.gz
mv apache-tomcat-9.0.85 tomcat9

# Lancer Tomcat
chmod +x /opt/tomcat9/bin/*.sh
/opt/tomcat9/bin/startup.sh
