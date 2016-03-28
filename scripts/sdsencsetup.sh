#!/bin/bash

#Before running this ensure you have ssh setup to the remote machine without password (i.e ssh-keygen; ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.148.204)
#Current script uses fixed values and assumes device info, more work needed :)

#ssh to remove SDS machine and encrypt the device
echo "Trying to encrypt /dev/sdb and /dev/sdc"
ssh 192.168.148.204 'svm encrypt /dev/sdb'
ssh 192.168.148.204 'svm encrypt /dev/sdc'

#ssh to remove SDS machine get a list of encrypted disks which include the mount points we need
echo "Collecting encrypted device information"
ssh 192.168.148.204 'svm status' > tmp

#remove the unwanted information and blank lines and save the clean output to devices.txt
more tmp | awk '{print substr($5, 1, length($5)-1)}'  > tmp2
grep '[^[:blank:]]' < tmp2 > devices.txt
rm -f tmp tmp2


#currently assumes a single SDS device!
PATH=$(head -n 1 devices.txt)


IFS=$'\n' read -d '' -r -a encdev < devices.txt

echo "The following devices were found"
echo "${encdev[@]}"


echo "Logging in"
scli --login --username admin --password $PASSWORD --approve_certificate


#Add all devices on this SDS machine
echo "Adding encrypted SDS"

for i in "${encdev[@]}"
do
	echo "Adding ${encdev[i]}"
	scli --add_sds --sds_ip 192.168.148.204 --device_path "${encdev[i]}" --sds_name sds1 --protection_domain_name pdomain1 --storage_pool_name pool1
done
sc

