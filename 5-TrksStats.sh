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

sub=$1
site=$2
dwi_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${sub}/qsiprep/${sub}/ses-*/dwi
dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/TracksMask_22sub
sub_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/TracksMask_22sub/${sub}
trksmask_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/Materials/all_bn_atlas_mask
lesion_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionMask
lesion=${lesion_dir}/${sub}.nii.gz
mask=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-brain_mask.nii.gz)

for i in `cat  ${trksmask_dir}/trksmask.txt`
do 
tck_mask=$sub_dir/${i}
#get BS whole tracts
echo ${sub}_${i%%.*} >>${dir}/${sub}_metrics.txt
tckstats $sub_dir/track*${i%%.*}.tck >>${dir}/${sub}_metrics.txt

#get TDI
tckmap -template $mask $sub_dir/track*${i%%.*}.tck $sub_dir/${i%%.*}_tdi.nii

#get tracts体积
echo ${sub}_${i%%.*}_volume >>${dir}/${sub}_metrics.txt
fslstats $sub_dir/${i%%.*}_tdi.nii -V >>${dir}/${sub}_metrics.txt

# Lesion体积
echo ${sub}_${i%%.*}_Lesion_volume >>${dir}/${sub}_metrics.txt
fslmaths $lesion -mul $tck_mask $sub_dir/${i%%.*}_Lesion
fslstats $sub_dir/${i%%.*}_Lesion* -V >>${dir}/${sub}_metrics.txt
done
