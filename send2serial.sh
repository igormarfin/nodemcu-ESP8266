#!/bin/bash

exec 3<> /dev/ttyUSB0
sleep 2
cat <&3
echo $1 >&3
sleep 1
cat <&3
sleep 1
exec 3>&-

