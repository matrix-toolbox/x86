#!/usr/bin/env bash

# wojtek[at]bitologia.org
# 2021-01-23
# 2021-01-25 DEPRECATED -- use ASCII.c instead!
# GIMP_RGB_data_converter.sh

echo "1. conversion from binary to text (to help BASH to deal with zeros)"
echo "-- should preserve file size!"
hexdump -v -e '/1 "%u\n"' $1 | while read c; do
if [ $c -eq 255 ]
then
 	echo -n "1" >> $1"_2"
else
	echo -n "0" >> $1"_2"
fi
done
################################################################################
echo "2. conversion from monochromatic RGB triplets to 0s or 1s"
echo "-- should reduce file size 3 times"
while read -r -d '' -n 3 TRIPLET; do
    # echo "$TRIPLET"
    if [ $TRIPLET -eq "111" ]
    then
    	echo -n "1" >> $1"_3"
    else
    	echo -n "0" >> $1"_3"
    fi
done < $1"_2"
################################################################################
echo "3. change every chunk of 8 bytes (treated as 8 bits) into decimal representation"
echo "-- should reduce file size 8 times"
while read -r -d '' -n 8 OCTET; do
    T=$(echo "obase=16;ibase=2;"$OCTET | bc) # order of bases DOES MATTER!
    echo -n -e \\x"$T" >> $1"_4"
done < $1"_3"



