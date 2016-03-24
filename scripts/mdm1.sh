#!/bin/bash
while [[ $# > 1 ]]
do
  key="$1"

  case $key in
    -m|--packagemdm)
    PACKAGEMDM="$2"
    shift
	;;
    -s|--packagesds)
    PACKAGESDS="$2"
    shift
	    ;;
    -c|--packagesdc)
    PACKAGESDC="$2"
    shift
    ;;
    -d|--device)
    DEVICE="$2"
    shift
    ;;
    -f|--firstmdmip)
    FIRSTMDMIP="$2"
    shift
    ;;
    -e|--secondmdmip)
    SECONDMDMIP="$2"
    shift
    ;;
	-v|--claddr)
    CLADDR="$2"
    shift
    ;;
	 -t|--tbip)
    TBIP="$2"
    shift
	;;
	-p|--password)
    PASSWORD="$2"
    shift
	;;
    *)
    # unknown option
    ;;
  esac
  shift
done
echo TBIP = "${TBIP}"
echo PACKAGEMDM = "${PACKAGEMDM}"
echo PACKAGESDS  = "${PACKAGESDS}"
echo PACKAGESDC  = "${PACKAGESDC}"
echo DEVICE  = "${DEVICE}"
echo FIRSTMDMIP    = "${FIRSTMDMIP}"
echo SECONDMDMIP    = "${SECONDMDMIP}"
echo CLADDR = "${CLADDR}"


#SET OS VARs for use in later scripts

echo "export TBIP="${TBIP}"" >> /etc/profile.d/customvar.sh
echo "export PACKAGEMDM="${PACKAGEMDM}"" >> /etc/profile.d/customvar.sh
echo "export PACKAGESDS="${PACKAGESDS}"" >> /etc/profile.d/customvar.sh
echo "export PACKAGESDC="${PACKAGESDC}"" >> /etc/profile.d/customvar.sh
echo "export DEVICE="${DEVICE}"" >> /etc/profile.d/customvar.sh
echo "export FIRSTMDMIP="${FIRSTMDMIP}"" >> /etc/profile.d/customvar.sh
echo "export SECONDMDMIP="${SECONDMDMIP}"" >> /etc/profile.d/customvar.sh
echo "export CLADDR="${CLADDR}"" >> /etc/profile.d/customvar.sh
echo "export PASSWORD="${PASSWORD}"" >> /etc/profile.d/customvar.sh
echo "OS VARs Added"

 

#echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)
truncate -s 100GB ${DEVICE}
echo "installing required packages...."
yum install numactl libaio dos2unix java-1.8.0-openjdk -y > /dev/null

echo "installing scaleio"

cd /vagrant/scaleio/

echo "installing MDM"
MDM_ROLE_IS_MANAGER=1 rpm -i ${PACKAGEMDM}
sleep 5

echo "installing SDS"
rpm -i ${PACKAGESDS}
sleep 5

echo "installing SDC"
MDM_IP=${FIRSTMDMIP},${SECONDMDMIP} rpm -i ${PACKAGESDC}
sleep 5

#copy the scripts to run on MDM1
mkdir /scripts
cp -R /vagrant/scripts/* /home/vagrant/scripts
cd /home/vagrant/scripts
dos2unix sdssetup.sh
dos2unix mdmsetup.sh
dos2unix svminstall.sh


if [[ -n $1 ]]; then
  echo "Last line of file specified as non-opt/last argument:"
  tail -1 $1
fi