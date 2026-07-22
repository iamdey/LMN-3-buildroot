#!/bin/bash

cwd=$(dirname $0)/../

docker build --tag iamdey/lmn-3-buildroot $cwd
