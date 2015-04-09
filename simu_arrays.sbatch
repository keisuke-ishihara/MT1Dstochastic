#!/bin/bash 
# simu_arrays.sbatch

#SBATCH -J simu_arrays # A single job name for the array
#SBATCH -p serial_requeue # Partition
#SBATCH -n 1 # one core
#SBATCH -N 1 # on one node
#SBATCH -t 0-2:00 # Running time of 2 hours
#SBATCH --mem 1000 # Memory request of 1 GB
#SBATCH -o slurm_%A_%a.out # Standard output
#SBATCH -e slurm_%A_%a.err # Standard error

# this script is called as
# sbatch --array=1-30 simu_arrays.sbatch

mkdir param${SLURM_ARRAY_TASK_ID}_out
cp param${SLURM_ARRAY_TASK_ID}.mat ./param${SLURM_ARRAY_TASK_ID}_out/param.mat
cd param${SLURM_ARRAY_TASK_ID}_out
#cp param${SLURM_ARRAY_TASK_ID}.mat ./param.mat

scriptdir=`pwd |sed 's#/[^/]*/[^/]*/[^/]*$##'`  
#echo $scriptdir

module load math/matlab-R2014b 
matlab -nojvm -nosplash -nodesktop < $scriptdir/callsimu.m

rm param.mat
cd ..
