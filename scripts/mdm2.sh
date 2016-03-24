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
    *)
    # unknown option
    ;;
  esac
  shift
done
echo PACKAGEMDM = "${PACKAGEMDM}"
echo PACKAGESDS  = "{PACKAGESDS}"
echo PACKAGESDC  = "${PACKAGESDC}"
echo DEVICE  = "${DEVICE}"
echo FIRSTMDMIP    = "${FIRSTMDMIP}"
echo SECONDMDMIP    = "${SECONDMDMIP}"


#echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)
truncate -s 100GB ${DEVICE}
echo "installing required packages...."
yum install numactl libaio java-1.8.0-openjdk -y > /dev/null
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


if [[ -n $1 ]]; then
  echo "Last line of file specified as non-opt/last argument:"
  tail -1 $1
fi
