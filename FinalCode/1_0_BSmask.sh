#!/bin/bash
#SBATCH -J BSmask
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem-per-cpu 16000
#SBATCH -p q_fat_l

module load fsl
module load afni
module load ants
module load mrtrix3
module unload gcc/5.5.0

sub=$1
out_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/1-BS_basic/0-bs_mask
in_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/Materials/bs_mask
data_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/Data_22/$sub
les_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/LesionMask
#data
xfm_MNI_ind=$(ls ${data_dir}/${sub}_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5)
xfm_ind_MNI=$(ls ${data_dir}/${sub}_from-T1w_to-MNI152NLin2009cAsym_mode-image_xfm.h5)
t1=$(ls ${data_dir}/${sub}_*T1w.nii.gz)
mask=$(ls ${data_dir}/${sub}_*mask.nii.gz)
bval=$(ls ${data_dir}/${sub}_*.bval)
bvec=$(ls ${data_dir}/${sub}_*.bvec)
dwi=$(ls ${data_dir}/${sub}_*dwi.nii.gz)
json=$(ls ${data_dir}/${sub}_*.b)
tck=$(ls ${data_dir}/${sub}_*.tck)
les=$(ls ${les_dir}/${sub}.nii.gz)
#output
if [ ! -d $out_dir/${sub} ]; then
    mkdir $out_dir/${sub}
fi
#code
antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input $in_dir/Final_BS_Mask_MNI.nii --interpolation NearestNeighbor --output $out_dir/${sub}/${sub}_Final_BS_Mask_MNI.nii --reference-image $t1 --transform $xfm_MNI_ind

antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input $in_dir/BS_Mask_MNI_icbm15209c.nii --interpolation NearestNeighbor --output $out_dir/${sub}/${sub}_BS_Mask_MNI.nii --reference-image $t1 --transform $xfm_MNI_ind

mrconvert  $out_dir/${sub}/${sub}_BS_Mask_MNI.nii  $out_dir/${sub}/${sub}_BS_Mask_MNI.mif
