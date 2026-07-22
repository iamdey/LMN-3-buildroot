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
echo "Note, O and BR2_EXTERNAL are already defined in the container and does not need to be exported"
echo ""
echo "Load config then run make"
echo ""
echo "    make defconfig BR2_DEFCONFIG=/configs/rpi2_x_defconfig"
echo "    make menuconfig"
echo "    make savedefconfig BR2_DEFCONFIG=/configs/rpi2_x_defconfig"
echo "    make"


docker run --rm -it \
    -v ./${distributionDir}:/dist \
    -v ./${brExternal}:/br_external  \
    -v ./${configDir}:/configs  \
    --env O=/dist \
    --env BR2_EXTERNAL=/br_external/ \
    --env FORCE_UNSAFE_CONFIGURE=1 \
    $baseImageName
