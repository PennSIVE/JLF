#!/bin/bash

dir=$1
container=$2
if [ $# = 2 ]
then
    for subj in $(ls $dir | grep .nii.gz)
    do
        subj_label=$(basename $subj .nii.gz)
        mkdir -p $dir/${subj_label}_jlf/{oasis_to_t1,oasis_thalamus_to_t1,thalamus}
        
        cd $dir/${subj_label}_jlf
        jid=$(qsub -t 1-10 -b y -cwd -l h_vmem=8G -o \$JOB_ID.jlf_pre -e \$JOB_ID.jlf_pre -terse \
        SINGULARITYENV_INDEX=\$SGE_TASK_ID singularity run --cleanenv \
        -B $dir/$subj:/N4_T1_strip.nii.gz:ro \
        -B $dir/${subj_label}_jlf:/out \
        $container --out /out --type preprocessing)
        jid_fmt=$(basename $jid .1-10:1)

        cd $dir/${subj_label}_jlf/thalamus
        qsub -hold_jid $jid_fmt -b y -cwd -l h_vmem=8G -o \$JOB_ID.jlf -e \$JOB_ID.jlf \
        singularity exec --cleanenv -B $dir \
        $container --out /out --type processing
    done

else
    echo "Usage: ./qsub.sh /path/to/niftis /path/to/container"
fi