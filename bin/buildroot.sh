#!/bin/bash

baseImageName=buildroot_rpi

distributionDir=dist
mkdir -p $distributionDir

configDir=config
mkdir -p $configDir

echo "Directory ${distributionDir} will be mounted to /${distributionDir}."
echo "And config dir ${configDir} will be mounted to /${configDir}."
echo "While invoke make, please use instead:"

echo "    make O=/${distributionDir}"

docker run --rm -it -v ./${distributionDir}:/${distributionDir} -v ./${configDir}:/${configDir} $baseImageName