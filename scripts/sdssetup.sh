#!/bin/bash

#Variables should have been set in the OS by vagrant
#FIRSTMDMIP=192.168.50.202
#SECONDMDMIP=192.168.50.203
#TBIP=192.168.50.201
#PASSWORD=Scaleio123
#DEVICE="/home/vagrant/scaleio1"

echo "Logging in"
scli --login --username admin --password $PASSWORD --approve_certificate
echo "Adding 3 SDS"
scli --add_sds --sds_ip $FIRSTMDMIP --device_path $DEVICE --sds_name sds1 --protection_domain_name pdomain1 --storage_pool_name pool1
scli --add_sds --sds_ip $SECONDMDMIP}--device_path $DEVICE --sds_name sds2 --protection_domain_name pdomain1 --storage_pool_name pool1
scli --add_sds --sds_ip $TBIP --device_path $DEVICE --sds_name sds3 --protection_domain_name pdomain1 --storage_pool_name pool1
