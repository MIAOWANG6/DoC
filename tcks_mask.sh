#!/bin/bash
#SBATCH -J ANTS
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem-per-cpu 16000
#SBATCH -p q_fat_l

module load fsl
module load ants
module load mrtrix3
module unload gcc/5.5.0

#get needed files
#\tck\tracks_mask

sub=$1
site=$2
trksmask_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/Materials/all_bn_atlas_mask
qsiprep_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/
anat_dir=${qsiprep_dir}/${sub}/qsiprep/${sub}/anat
tck_dir=${qsiprep_dir}/${sub}/qsirecon/${sub}/ses-*/dwi
out_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/TracksMask_22sub


xfm_MNI_ind=$(ls ${anat_dir}/${sub}_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5)
tck=$(ls ${tck_dir}/${sub}_ses-*tracks_ifod2.tck)
t1=$(ls ${anat_dir}/${sub}_desc-preproc_T1w.nii.gz)


# get individual space tck masks
if [ ! -d $out_dir/${sub} ]; then
    mkdir $out_dir/${sub}
fi

for i in `cat  ${trksmask_dir}/trksmask.txt`
do 
mif=$out_dir/${sub}/${i%%.*}.mif

antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input ${trksmask_dir}/${i} --interpolation NearestNeighbor --output $out_dir/${sub}/${i} --reference-image ${t1} --transform ${xfm_MNI_ind}

mrconvert $out_dir/${sub}/${i} $mif

tckedit $tck $out_dir/${sub}/track_${sub}_${i%%.*}.tck -include $mif
done
