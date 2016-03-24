#!/bin/bash

#Variables should have been set in the OS by vagrant
#FIRSTMDMIP=192.168.50.202
#SECONDMDMIP=192.168.50.203
#TBIP=192.168.50.201
#PASSWORD=Scaleio123
#DEVICE="/home/vagrant/scaleio1"

echo "Using CloudLink Address:" 
echo $CLADDR
 
wget http://$CLADDR/cloudlink/securevm
sh securevm -S $CLADDR

echo "Do you wish to install SecureVM?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) sudo sh securevm -S $CLADDR; break;;
        No ) exit;;
    esac
done

echo "Do you wish to encrypt $DEVICE ?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) sudo svm encrypt $DEVICE; break;;
        No ) exit;;
    esac
done

