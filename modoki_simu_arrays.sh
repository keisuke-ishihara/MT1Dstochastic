#!/bin/bash
# modoki_simu_arrays.sh

# this mimicks simu_arrays.sbatch job array script
# as a shell script with loops

for FILENAME in *.mat; do

    SUBSTRING=`echo $FILENAME| cut -d'.' -f 1`
    
    mkdir ${SUBSTRING}_out
    cp ${FILENAME} ./param.mat
#    cp ${FILENAME} ./${SUBSTRING}_out/param.mat
#    cd ${SUBSTRING}_out

    scriptdir=`pwd |sed 's#/[^/]*/[^/]*$##'`  
#    scriptdir=`pwd |sed 's#/[^/]*/[^/]*/[^/]*$##'`  
    echo $scriptdir

    cd ${SUBSTRING}_out
    
    matlab -nojvm -nosplash -nodesktop < ${scriptdir}/callsimu.m
    
#    rm param.mat
    cd ..
    rm param.mat

done;

