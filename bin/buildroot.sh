#!/bin/bash

baseImageName=iamdey/lmn-3-buildroot
projectDir=$(dirname $0)/..

distributionDir=$projectDir/dist
mkdir -p $distributionDir

configDir=$projectDir/config
mkdir -p $configDir

echo "Directory ${distributionDir} will be mounted to /dist."
echo "And config dir ${configDir} will be mounted to /config."
echo "While invoke make, please use instead:"

echo "    make O=/dist"

docker run --rm -it -v ./${distributionDir}:/dist -v ./${configDir}:/config $baseImageName