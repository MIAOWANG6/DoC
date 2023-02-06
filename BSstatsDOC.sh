#!/bin/bash
#SBATCH -J STATS
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
#bs_mask\bvec\bval\dwi\mask\tck\lesion\bs_mif

sub=$1   
qsiprep_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/NewDataBIDS230120/derivatives/qsiprep
anat_dir=${qsiprep_dir}/${sub}/qsiprep/${sub}/anat
dwi_dir=${qsiprep_dir}/${sub}/qsiprep/${sub}/ses-*/dwi
tck_dir=${qsiprep_dir}/${sub}/qsirecon/${sub}/ses-*/dwi

t1=$(ls ${anat_dir}/${sub}_desc-preproc_T1w.nii.gz)
xfm_ind_MNI=$(ls ${anat_dir}/${sub}_from-T1w_to-MNI152NLin2009cAsym_mode-image_xfm.h5)
xfm_MNI_ind=$(ls ${anat_dir}/${sub}_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5)
tck=$(ls ${tck_dir}/${sub}_ses-*ifod2.tck)
bval=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.bval)
bvec=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.bvec)
mask=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-brain_mask.nii.gz)
dwi=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.nii.gz)

sub_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats230120/${sub}
bs_MNI=$(ls ${sub_dir}/BS_Mask_MNI_icbm15209c.nii)
bs_mask=${sub_dir}/${sub}_BS_Mask_MNI.nii
mif=${sub_dir}/${sub}_BS_Mask_MNI.mif


#get individual space BS mask
antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input ${bs_MNI} --interpolation NearestNeighbor --output ${bs_mask} --reference-image ${t1} --transform ${xfm_MNI_ind}
mrconvert ${bs_mask} ${mif}


#get BS whole tracts
cd $sub_dir
tckedit $tck track_${sub}_BS.tck -include $mif

#get BS whole tracts
echo ${sub} >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats230120/metrics.txt
tckstats $sub_dir/track_${sub}_BS.tck >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats230120/metrics.txt
tckstats $sub_dir/track_${sub}_BS.tck -histogram $sub_dir/hist -force
dtifit -k $dwi -o fsl_ -m $mask -r $bvec -b $bval

#get TDI
tckmap -template $mask $sub_dir/track_${sub}_BS.tck $sub_dir/${sub}_BS_tdi.nii

#get tracts体积
echo "BS_tracts_volume:" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats230120/metrics.txt
fslstats $sub_dir/${sub}_BS_tdi.nii -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats230120/metrics.txt

# Lesion体积
echo "Lesion_volume:" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats230120/metrics.txt
fslstats $sub_dir/${sub}.nii.gz -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats230120/metrics.txt
fslmaths $sub_dir/${sub}.nii.gz -mul $sub_dir/$bs_mask $sub_dir/${sub}_Lesion_inBS
echo "Lesion_inBS_volume:" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats230120/metrics.txt
fslstats $sub_dir/${sub}_Lesion_inBS* -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats230120/metrics.txt
