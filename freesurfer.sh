#!/bin/bash
#SBATCH -J Freesurfer
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem-per-cpu 16000
#SBATCH -p q_cn

module load singularity/3.7.0
module load freesurfer
module load fastcsr/fastcsr_cpu
module load fsl
module load n3

# module load perl/5.14.4

#User inputs:
subj=$1
ses=$2
bids_root_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p #site
bids_root_dir_output=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p #site
bids_root_dir_output_wd4singularity=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p_WK 
nthreads=8

if [ ! -d $bids_root_dir_output/derivatives ]; then
    mkdir $bids_root_dir/derivatives
fi

if [ ! -d $bids_root_dir_output/derivatives/fastcsr ]; then
    mkdir $bids_root_dir/derivatives/fastcsr
fi

if [ ! -d $bids_root_dir_output/derivatives/fastcsr/$subj$ses ]; then
    mkdir $bids_root_dir/derivatives/fastcsr/$subj$ses
    mkdir $bids_root_dir/derivatives/fastcsr/$subj$ses/mri
    mkdir $bids_root_dir/derivatives/fastcsr/$subj$ses/mri/orig
    mri_convert $bids_root_dir/$subj/$ses/anat/${subj}_${ses}_T1w.nii.gz $bids_root_dir/derivatives/fastcsr/$subj$ses/mri/orig/001.mgz
    mri_convert $bids_root_dir/$subj/$ses/anat/${subj}_${ses}_T1w.nii.gz $bids_root_dir/derivatives/fastcsr/$subj$ses/mri/orig.mgz
fi

if [ ! -f $bids_root_dir_output/derivatives/fastcsr/$subj$ses/stats/wmparc.stats ];then
    SUBJECTS_DIR=$bids_root_dir/derivatives/fastcsr/
    recon-all -autorecon1 -subjid $subj$ses
    recon-all -autorecon2 -subjid $subj$ses
fi
