#!/bin/sh

GARG=$1
fileARG=$2

if [[ -n "$GARG" ]] ; then
	export GLISTNAME=${GARG}
else
	echo 'Error, please provide a gene list'
	echo 'ARG1 is gene list name, ARG2 is GeneBank File Name'
	exit 0
fi

if [[ -n "$fileARG" ]] ; then 
	export LISTARRFILE=${fileARG}
else
	echo 'Error, please provide a genebank file'
        echo 'ARG1 is gene list name, ARG2 is GeneBank File Name'
	exit 0
fi

# add list name here of list of genes
# export GLISTNAME='testFileList.txt'

# add genebank file name here
# export LISTARRFILE='GCF_001660625.1_IpCoco_1.2_genomic.gbff'


OLDIFS=$IFS
IFS=$'\n'
LISTARR=($(<${GLISTNAME}))
now=$(date +%Y%m%d%H%M%S)
export TMPDIR=$(echo "tmpScanFiles_${now}")
PDIR=$(pwd)
mkdir ${PDIR}/${TMPDIR}
export DIRLOC=${PDIR}/${TMPDIR}

echo 'starting analysis'
for i in "${LISTARR[@]}" ; do 
	VARRA=$(echo "$i") ; 
	echo "scanning ${VARRA}" ; 
	egrep -A5 -w "${VARRA}" "${LISTARRFILE}" | tee >> ./${TMPDIR}/scan_${VARRA}.txt | grep product | cut -d= -f2 ; 
	sleep 1
	(./findGeneProduct.sh ${VARRA} scan_${VARRA}.txt ${DIRLOC})
	GPRODRES=$(<${VARRA}_res)
	echo "Return value is ${GPRODRES}"
	echo '##'
	if [[ -n "$GPRODRES" ]] ; then
		echo "${VARRA}    ${GPRODRES}"
	else
		echo "${VARRA}"
	fi
	sleep 5
done

IFS=$OLDIFS
