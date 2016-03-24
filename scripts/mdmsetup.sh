#!/bin/bash

#Variables should have been set in the OS by vagrant
#FIRSTMDMIP=192.168.50.202
#SECONDMDMIP=192.168.50.203
#TBIP=192.168.50.201
#PASSWORD=Scaleio123
#DEVICE="/home/vagrant/scaleio1"
 
echo "Creating cluster"
scli --create_mdm_cluster --master_mdm_ip $FIRSTMDMIP --master_mdm_management_ip $FIRSTMDMIP --master_mdm_name mdm1 --accept_license --approve_certificate
echo "Logging in"
sleep 10
scli --login --username admin --password admin --approve_certificate
echo "Changing Password"
sleep 5
scli --set_password --old_password admin --new_password $PASSWORD
echo "Logging in and adding MDM1 as standby"
sleep 5
scli --login --username admin --password $PASSWORD --approve_certificate
echo "Adding Standby MDM"
sleep 5
scli --add_standby_mdm --new_mdm_ip $SECONDMDMIP --mdm_role manager --new_mdm_management_ip $SECONDMDMIP --new_mdm_name mdm2
echo "Adding tb as tb"
scli --add_standby_mdm --new_mdm_ip $TBIP --mdm_role tb --new_mdm_name tb
echo "Cluster Details before 3 node cluster setup"
scli --query_cluster
echo "Swithcing to 3 node cluster" 
sleep 5
scli --switch_cluster_mode --cluster_mode 3_node --add_slave_mdm_name mdm2 --add_tb_name tb
echo "Cluster Details"
scli --query_cluster

echo "Adding protectoin domain"
scli --add_protection_domain --protection_domain_name pdomain1

echo "Adding storage pool"
scli --add_storage_pool --protection_domain_name pdomain1 --storage_pool_name pool1
