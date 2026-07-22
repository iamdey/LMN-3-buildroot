#!/bin/bash

baseImageName=iamdey/lmn-3-buildroot
projectDir=$(dirname $0)/..

distributionDir=$projectDir/dist
mkdir -p $distributionDir

configDir=$projectDir/configs
brExternal=$projectDir/br_external

echo "Directory ${distributionDir} will be mounted to /dist."
echo "And config dir ${configDir} will be mounted to /configs."
echo "And br_external dir ${brExternal} will be mounted to /${brExternal}."
echo ""
echo "Load config then run make"
echo ""
echo "    make O=/dist BR2_EXTERNAL=/br_external defconfig BR2_DEFCONFIG=/configs/rpi2_lmn-3_defconfig"
echo "    make O=/dist BR2_EXTERNAL=/br_external menuconfig"
echo "    make O=/dist BR2_EXTERNAL=/br_external savedefconfig BR2_DEFCONFIG=/configs/rpi2_lmn-3_defconfig"
echo "    make O=/dist BR2_EXTERNAL=/br_external"


# FORCE_UNSAFE_CONFIGURE allows buildroot to be run as root
docker run --rm -it \
    -v ./${distributionDir}:/dist \
    -v ./${brExternal}:/br_external  \
    -v ./${configDir}:/configs  \
    --env FORCE_UNSAFE_CONFIGURE=1 \
    $baseImageName
