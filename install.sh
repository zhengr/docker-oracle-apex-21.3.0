# Create network 
docker network create oracle-network

# install oracle database XE
docker run --name oracle-21.3.0-xe --network oracle-network -p 21521:1521 -p 25500:5500 -e ORACLE_PWD=oracle -v oradata:/opt/oracle/oradata registry.cn-hangzhou.aliyuncs.com/gcr-google/oracle.express:21.3.0-xe > db.log 2>&1 & 

# create db connection string
sudo rm -R ords_volume
sudo mkdir ords_volume ; echo 'CONN_STRING=sys/oracle@oracle-21.3.0-xe:1521/XEPDB1' > ords_volume/conn_string.txt

# Build Oracle APEX and ORDS
docker run --rm --name ords --network oracle-network -v `pwd`/ords_volume/:/opt/oracle/variables -p 8181:8181 registry.cn-hangzhou.aliyuncs.com/gcr-google/oracle.ords:21.4.1 > apexwithords.log 2>&1 & 
