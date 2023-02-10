#!/bin/bash
#SBATCH -J TRKSTATS
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem-per-cpu 16000
#SBATCH -p q_fat_l

module load fsl
module load ants
module load mrtrix3
module unload gcc/5.5.0
module load afni

sub=$1   
site=$2

qsiprep_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/
anat_dir=${qsiprep_dir}/${sub}/qsiprep/${sub}/anat
dwi_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${sub}/qsiprep/${sub}/ses-*/dwi

dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/TracksMask_22sub
sub_dir=$dir/${sub}
trksmask_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/Materials/all_bn_atlas_mask

bval=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.bval)
bvec=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.bvec)
dwi=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.nii.gz)
mask=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-brain_mask.nii.gz)
t1=$(ls ${anat_dir}/${sub}_desc-preproc_T1w.nii.gz)

dtifit -k $dwi -o $sub_dir/fa_fsl -m $mask -r $bvec -b $bval
3dresample -master $t1 -prefix $sub_dir/fa_afni_FA.nii.gz -inset $sub_dir/fa_fsl_FA.nii.gz

for i in `cat  ${trksmask_dir}/trksmask.txt`
do 
tck_mask=$sub_dir/${i}
#get FA
echo ${sub}_${i%%.*}_fa >>${dir}/${sub}_fa.txt
fslmeants -i $sub_dir/fa_afni_FA.nii.gz -m $tck_mask >>${dir}/${sub}_fa.txt
done


