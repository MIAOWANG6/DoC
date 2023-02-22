#!/bin/bash
#SBATCH -J Tckstats
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
out_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/3-BS_23tracts/1-tract23_stats
in_dir1=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/3-BS_23tracts/0-tract23_mask/$sub
in_dir2=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/1-BS_basic/2-bs_stats/$sub
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
fa=$(ls $in_dir2/fa_fsl*FA.nii.gz)
md=$(ls $in_dir2/fa_fsl*MD.nii.gz)
BS_mask_redwi=$(ls $in_dir2/${sub}_BS_Mask_redwi_MNI.nii)
#output
if [ ! -d $out_dir/${sub} ]; then
    mkdir $out_dir/${sub}
fi

#code
for i in `cat  ${trksmask_dir}/trksmask.txt`
do 
tck_mask=$in_dir1/${i}
tck_trk=$in_dir1/track*${i%%.*}.tck
3dresample -master $dwi -prefix $out_dir/${sub}/${i%%.*}_redwi_MNI.nii -inset $tck_mask
tck_mask_redwi=$(ls $out_dir/${sub}/${i%%.*}_redwi_MNI.nii)
#get tracts metrics
echo ${sub}_${i%%.*} >>${out_dir}/${sub}_metrics.txt
tckstats $tck_trk >>${out_dir}/${sub}_metrics.txt
#get TDI
tdi=$out_dir/${sub}/${i%%.*}_tdi.nii
tckmap -template $mask $tck_trk $tdi
#get tracts体积
echo ${sub}_${i%%.*}_volume >>${out_dir}/${sub}_metrics.txt
fslstats $tdi -V >>${out_dir}/${sub}_metrics.txt
#get tracts lesion体积
tck_les=$out_dir/${sub}/${i%%.*}_Lesion.nii
echo ${sub}_${i%%.*}_Lesion_volume >>${out_dir}/${sub}_metrics.txt
fslmaths $tck_mask -mul $les $tck_les
fslstats $tck_les -V >>${out_dir}/${sub}_metrics.txt
#get tracts mask FA
echo ${sub}_${i%%.*}_FA >>$out_dir/${sub}_FA.txt
fslmeants -i $fa -m $tck_mask_redwi >>$out_dir/${sub}_FA.txt
echo ${sub}_${i%%.*}_MD >>$out_dir/${sub}_FA.txt
fslmeants -i $md -m $tck_mask_redwi >>$out_dir/${sub}_FA.txt
#get tracts FA
tdimask=$out_dir/${sub}/${i%%.*}_tdimask.nii.gz
fslmaths $tdi -bin $tdimask
echo ${i%%.*}_trk_FA >>$out_dir/${sub}_FA.txt
fslmeants -i $fa -m $tdimask >>$out_dir/${sub}_FA.txt
echo ${i%%.*}_trk_MD >>$out_dir/${sub}_FA.txt
fslmeants -i $md -m $tdimask >>$out_dir/${sub}_FA.txt
#get tracts inBS FA
tck_inBS=$out_dir/${sub}/${i%%.*}_inBS.nii
fslmaths $tck_mask_redwi -mul $BS_mask_redwi $tck_inBS
echo ${i%%.*}_inBS_volume >>${out_dir}/${sub}_metrics.txt
fslstats $tck_inBS -V >>${out_dir}/${sub}_metrics.txt
echo ${i%%.*}_trkinBS_FA >>$out_dir/${sub}_FA.txt
fslmeants -i $fa -m $tck_inBS >>$out_dir/${sub}_FA.txt
echo ${i%%.*}_trkinBS_MD >>$out_dir/${sub}_FA.txt
fslmeants -i $md -m $tck_inBS >>$out_dir/${sub}_FA.txt
done
