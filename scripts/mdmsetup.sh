#!/bin/bash

FIRSTMDMIP=192.168.50.202
SECONDMDMIP=192.168.50.203
TBIP=192.168.50.201
PASSWORD=Scaleio123
DEVICE="/home/vagrant/scaleio1"

echo "Creating cluster"
scli --create_mdm_cluster --master_mdm_ip ${FIRSTMDMIP} --master_mdm_management_ip ${SECONDMDMIP} --master_mdm_name mdm2 --accept_license --approve_certificate
echo "Logging in"
scli --login --username admin --password admin --approve_certificate
echo "Changing Password"
scli --set_password --old_password admin --new_password ${PASSWORD}
echo "Logging in and adding MDM1 as standby"
scli --login --username admin --password ${PASSWORD} --approve_certificate
scli --add_standby_mdm --new_mdm_ip ${FIRSTMDMIP} --mdm_role manager --new_mdm_management_ip ${FIRSTMDMIP} --new_mdm_name mdm1
echo "Adding tb as tb"
scli --add_standby_mdm --new_mdm_ip ${TBIP} --mdm_role tb --new_mdm_name tb
echo "Cluster Details before 3 node cluster setup"
scli --query_cluster
echo "Swithcing to 3 node cluster" 
scli --switch_cluster_mode --cluster_mode 3_node --add_slave_mdm_name mdm1 --add_tb_name tb1
echo "Cluster Details"
scli --query_cluster

echo "Adding protectoin domain"
scli --add_protection_domain --protection_domain_name pdomain1

echo "Adding storage pool"
scli --add_storage_pool --protection_domain_name pdomain --storage_pool_name pool1
