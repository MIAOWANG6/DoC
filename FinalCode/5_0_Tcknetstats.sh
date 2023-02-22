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

sub=$1   
out_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/5-Hierarchy
in_dir1=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/3-BS_23tracts/0-tract23_mask/$sub
in_dir2=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/1-BS_basic/2-bs_stats/$sub
in_dir3=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/3-BS_23tracts/1-tract23_stats/$sub
data_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/Data_22/$sub
les_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/LesionMask
trksmask_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/Materials/all_bn_atlas_mask
networks_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/5-Hierarchy/Schaefer2018-7networks-mask
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
fa=$(ls $in_dir2/fa_fsl*FA.nii.gz)
md=$(ls $in_dir2/fa_fsl*MD.nii.gz)
BS_mask_redwi=$(ls $in_dir2/${sub}_BS_Mask_redwi_MNI.nii)
#output
if [ ! -d $out_dir/${sub} ]; then
    mkdir $out_dir/${sub}
fi

#code
for i in `cat  ${networks_dir}/networks.txt`
do 
net_mif=$out_dir/${sub}/${i%.*}.mif
antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input ${networks_dir}/${i} --interpolation NearestNeighbor --output $out_dir/${sub}/${i} --reference-image ${t1} --transform ${xfm_MNI_ind}
mrconvert $out_dir/${sub}/${i} $net_mif

for j in `cat  ${trksmask_dir}/trksmask.txt`
do
tck_mif=$(ls $in_dir1/${j%%.*}.mif)
trknet=$out_dir/${sub}/track_${sub}_${j%%.*}_${i%.*}.tck
tckedit $tck $trknet -include $tck_mif -include $net_mif
#get tracts metrics
echo ${j%%.*}_${i%.*} >>$out_dir/${sub}_metrics.txt
tckstats $trknet >>$out_dir/${sub}_metrics.txt
#get TDI
trknet_tdi=$out_dir/${sub}/${j%%.*}_${i%.*}_tdi.nii
tckmap -template $mask $trknet $trknet_tdi
#get tracts体积
echo ${j%%.*}_${i%.*}_volume >>$out_dir/${sub}_metrics.txt
fslstats $trknet_tdi -V >>$out_dir/${sub}_metrics.txt
done
done
