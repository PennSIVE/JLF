#!/bin/bash


set -euf
# for example
for subj in $(ls /cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all | grep ^sub)
do
	dir="/cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all/derivatives/${subj}/ses-001"
	mkdir -p "${dir}/thalamus" || true
	qsub -b y -cwd -l h_vmem=8G -o \$JOB_ID.ants -e \$JOB_ID.ants \
	singularity exec --cleanenv -B $dir \
	/cbica/home/robertft/singularity_images/ants_latest.sif \
	antsJointFusion -t "${dir}/t1_n4_brain.nii.gz" -g $(find "${dir}/oasis_to_t1" -type f | tr "\n" " ") -l $(find "${dir}/oasis_thalamus_to_t1" -type f | tr "\n" " ") -b 4.0 -c 0 -o "${dir}/thalamus/jlf_thalamus.nii.gz" -v 0
	# ^ singularity pull docker://dorianps/ants
done