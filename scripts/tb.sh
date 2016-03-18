#!/bin/bash
while [[ $# > 1 ]]
do
  key="$1"

  case $key in
    -t|--packagetb)
    PACKAGETB="$2"
    shift
	;;
    -s|--sds)
    SDS="$2"
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
    *)
    # unknown option
    ;;
  esac
  shift
done
echo PACKAGETB = "${PACKAGETB}"
echo PACKAGESDS  = "${SDS}"
echo PACKAGESDC  = "${PACKAGESDC}"
echo DEVICE  = "${DEVICE}"
echo FIRSTMDMIP    = "${FIRSTMDMIP}"
echo SECONDMDMIP    = "${SECONDMDMIP}"

truncate -s 100GB ${DEVICE}
echo "installing required packages...."
yum install numactl libaio java-1.8.0-openjdk -y > /dev/null
echo "installing scaleio"

cd /vagrant/scaleio/

echo "installing TB"
MDM_ROLE_IS_MANAGER=0 rpm -i ${PACKAGETB}
sleep 5

echo "installing SDS"
rpm -i ${SDS}
sleep 5

echo "installing SDC"
MDM_IP=${FIRSTMDMIP},${SECONDMDMIP} rpm -i ${PACKAGESDC}
sleep 5

if [[ -n $1 ]]; then
  echo "Last line of file specified as non-opt/last argument:"
  tail -1 $1
fi


