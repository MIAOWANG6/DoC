#!/bin/bash
#SBATCH -J ANTS
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem-per-cpu 16000
#SBATCH -p q_fat
#SBATCH -o job.%j.log
#SBATCH -e job.%j.err

module load fsl
module load ants
module load mrtrix3
module unload parallel
module unload gcc/5.5.0

sub=$1
out_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/5-Hierarchy
in_dir1=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/3-BS_23tracts/0-tract23_mask/$sub
in_dir2=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/1-BS_basic/0-bs_mask/$sub
data_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/Data_22/$sub
les_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/LesionMask
trksmask_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/Materials/all_bn_atlas_mask
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
#input
bs_mask=$(ls $in_dir2/${sub}_BS_Mask*.nii)
bs_mif=$(ls $in_dir2/${sub}_BS_Mask*.mif)
#output
if [ ! -d $out_dir/${sub} ]; then
    mkdir $out_dir/${sub}
fi
#code
for i in `cat  ${networks_dir}/networks.txt`
do 
net_mif=$(ls $out_dir/${sub}/${i%.*}.mif)
bsnet=$out_dir/${sub}/track_${sub}_BS_${i%.*}.tck
tckedit $tck $bsnet -include $bs_mif -include $net_mif
#get tracts metrics
echo BS_${i%.*} >>$out_dir/${sub}_BSmetrics.txt
tckstats $bsnet >>$out_dir/${sub}_BSmetrics.txt
#get TDI
bs_tdi=$out_dir/${sub}/BS_${i%.*}_tdi.nii
tckmap -template $mask $bs_tdi
#get tracts体积
echo BS_${i%.*}_volume >>$out_dir/${sub}_BSmetrics.txt
fslstats $bs_tdi -V -n >>$out_dir/${sub}_BSmetrics.txt
done
