#!/bin/bash

#Before running this ensure you have ssh setup to the remote machine without password (i.e ssh-keygen; ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.148.204)
#Current script uses fixed values, more work needed :)

#ssh to remove SDS machine and encrypt the device
ssh 192.168.148.204 'svm encrypt /dev/sdb'

#ssh to remove SDS machine get a list of encrypted disks which include the mount points we need
ssh 192.168.148.204 'svm status' > tmp

#remove the unwanted information and blank lines and save the clean output to devices.txt
more tmp | awk '{print substr($5, 1, length($5)-1)}'  > tmp2
grep '[^[:blank:]]' < tmp2 > devices.txt
rm -f tmp tmp2

echo "Logging in"
scli --login --username admin --password $PASSWORD --approve_certificate
echo "Adding 3 SDS"
scli --add_sds --sds_ip 192.168.148.204 --device_path /dev/sdb --sds_name sds1 --protection_domain_name pdomain1 --storage_pool_name pool1

