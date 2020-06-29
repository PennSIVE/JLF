#!/bin/bash

set -euf

for subj in $(ls /cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all | grep ^sub)
do
    mkdir -p /cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all/derivatives/${subj}/ses-001/{oasis_to_t1,oasis_thalamus_to_t1} || true
    qsub -t 1-10 -b y -cwd -l h_vmem=8G -o \$JOB_ID.jlf -e \$JOB_ID.jlf SINGULARITYENV_INDEX=\$SGE_TASK_ID singularity run --cleanenv \
    -B /cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all/derivatives/${subj}/ses-001/t1_n4_brain.nii.gz:/N4_T1_strip.nii.gz:ro \
    -B /cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all/derivatives/${subj}/ses-001:/out \
    /cbica/home/robertft/singularity_images/jlf_latest.sif
done