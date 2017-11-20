#!/bin/sh

gProduct=$1
gFile=$2
gFileLocation=$3

echo "${gProduct}"
echo "${gFile}"

if [[ -n "$gFile" ]] ; then
        export gFileGREP=${gFileLocation}/${gFile}
else
        echo 'Error, check file output from prior step'
        exit 0
fi

if [[ -n "$gProduct" ]] ; then
        export gProdGREP=${gProduct}
else
        echo 'Error, check output from prior step'
        exit 0
fi

# 2 "
GREPVAL=$(grep -m1 product ${gFileGREP} | cut -d= -f2 | grep -o -n '"' | cut -d : -f 2 | uniq -c)
prodVal=$(echo "$GREPVAL" | cut -d\   -f4)


echo 'GREPVAL is'
echo "$GREPVAL"

echo 'prodval is'
echo "$prodVal"

echo 'Value'
echo "$GREPVAL" | cut -d' ' -f4
if [[ -z "$prodVal" ]] ; then
	touch ${gProduct}_res
	exit 0
fi

OLDIFS=$IFS
IFS=$'\n'
if [[ "${prodVal}" = 2 ]] ; then
	RVAL=$(grep -m1 product "${gFileGREP}" | cut -d\" -f2)
#	grep product "${RVAL}" | cut -d\" -f2
	echo "${RVAL}" > ${gProduct}_res
else
	finalGrepVal=($(grep -A2 product ${gFileGREP}))
	RVAL1=$(echo "${finalGrepVal[0]}" | cut -d= -f2) 
	RVAL2=$(echo "${finalGrepVal[1]}" | cut -d= -f2 | sed -e 's/^[[:space:]]*//')
	RVAL=$(echo "$RVAL1 $RVAL2")
	echo "${RVAL}" >> ${gProduct}_res
	echo "$RVAL" | sed -e 's/\"//g' >> ${gProduct}_res
fi
IFS=$OLDIFS
