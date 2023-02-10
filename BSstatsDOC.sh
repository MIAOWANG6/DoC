#!/bin/bash
#SBATCH -J ANTS
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem-per-cpu 16000
#SBATCH -p q_cn
#SBATCH -o job.%j.log
#SBATCH -e job.%j.err

module load fsl
module load ants
module load mrtrix3
module unload parallel
module unload gcc/5.5.0
#get needed files
#bs_mask\bvec\bval\dwi\mask\tck\lesion\bs_mif

sub=$1   
site=$2
dwi_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${sub}/qsiprep/${sub}/ses-*/dwi
tck_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${sub}/qsirecon/${sub}/ses-*/dwi
Lshow_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/${sub}_*
sub_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}
tck=$(ls ${tck_dir}/${sub}_ses-*tracks_ifod2.tck)
bval=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.bval)
bvec=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.bvec)
mask=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-brain_mask.nii.gz)
dwi=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.nii.gz)
mif=$(ls ${Lshow_dir}/${sub}_BS_Mask_MNI.mif)
bs_mask=$(ls ${Lshow_dir}/${sub}_BS_Mask_MNI.nii)
    
#get BS whole tracts
cd $sub_dir
tckedit $tck track_${sub}_BS.tck -include $mif -force

#get BS whole tracts
echo ${sub} >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}.txt
tckstats $sub_dir/track_${sub}_BS.tck >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}.txt
tckstats $sub_dir/track_${sub}_BS.tck -histogram $sub_dir/hist -force
dtifit -k $dwi -o fsl_ -m $mask -r $bvec -b $bval

#get TDI
tckmap -force -template $mask track_${sub}_BS.tck ${sub}_BS_tdi.nii

#get tracts体积
echo "BS_tracts_volume:" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}.txt
fslstats ${sub}_BS_tdi.nii -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}.txt

# Lesion体积
echo "Lesion_volume:" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}.txt
fslstats ${sub}.nii.gz -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}.txt
fslmaths ${sub}.nii.gz -mul $bs_mask ${sub}_Lesion_inBS
echo "Lesion_inBS_volume:" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}.txt
fslstats ${sub}_Lesion_inBS.nii.gz -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}.txt
