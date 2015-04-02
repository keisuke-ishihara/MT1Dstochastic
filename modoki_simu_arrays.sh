#!/bin/bash
# modoki_simu_arrays.sh

# this mimicks simu_arrays.sbatch job array script
# as a shell script with loops

for FILENAME in *.mat; do
    INPUT=someletters_12345_moreleters.ext
    SUBSTRING=`echo $FILENAME| cut -d'.' -f 1`
    
    mkdir ${SUBSTRING}_out
    cp ${FILENAME} ./${SUBSTRING}_out/param.mat
    cd ${SUBSTRING}_out

    targetdir=`pwd |sed 's#/[^/]*/[^/]*/[^/]*$##'`  
    echo $targetdir
    
    matlab -nojvm -nosplash -nodesktop < ${targetdir}/callsimu.m

    rm param.mat
    cd ..

done;

