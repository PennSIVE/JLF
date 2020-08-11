#!/bin/bash

dir=$1
container=$2
if [ $# = 2 ]
then
    for subj in $(ls $dir | grep .nii.gz)
    do
        subj_label=$(basename $subj .nii.gz)
        mkdir -p $dir/${subj_label}_jlf/{oasis_to_t1,oasis_thalamus_to_t1,thalamus}
        
        bsub -n 16 -J "jlf[1-10]%1" \
        SINGULARITYENV_INDEX=\$LSB_JOBINDEX singularity run --cleanenv \
        -B $dir/$subj:/N4_T1_strip.nii.gz:ro \
        -B $dir/${subj_label}_jlf:/out \
        $container --out /out --type both

    done
else
    echo "Usage: ./qsub.sh /path/to/niftis /path/to/container"
fi