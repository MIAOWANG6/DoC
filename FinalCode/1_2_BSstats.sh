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
out_dir=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/1-BS_basic/2-bs_stats
in_dir1=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/1-BS_basic/0-bs_mask/$sub
in_dir2=/ibmgpfs/cuizaixu_lab/wangmiao/DoC/Brain_Stem_Connectivity/1-BS_basic/1-bs_trk/$sub
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
#input
trkbs=$(ls ${in_dir2}/track_${sub}_BS.tck)
bs_mask=$(ls ${in_dir1}/${sub}_BS_Mask_MNI.nii)
les_bs=$(ls ${in_dir1}/${sub}_Lesion_inBS.nii.gz)
#output
if [ ! -d $out_dir/${sub} ]; then
    mkdir $out_dir/${sub}
fi

#code
3dresample -master $dwi -prefix $out_dir/${sub}/${sub}_BS_Mask_redwi_MNI.nii -inset $bs_mask
bs_mask_redwi=$(ls $out_dir/${sub}/${sub}_BS_Mask_redwi_MNI.nii)
3dresample -master $dwi -prefix $out_dir/${sub}/${sub}_Lesion_inBS_redwi_MNI.nii -inset $les_bs
les_bs_redwi=$(ls $out_dir/${sub}/${sub}_Lesion_inBS_redwi_MNI.nii)

#get BS metrics
echo "BS_metrics:" >>$out_dir/${sub}_metrics.txt
tckstats $trkbs >>$out_dir/${sub}_metrics.txt
tckstats $trkbs -histogram $out_dir/${sub}/hist -force

#get TDI
tckmap -template $mask $trkbs $out_dir/${sub}/${sub}_BS_tdi.nii
tdi=$(ls $out_dir/${sub}/${sub}_BS_tdi.nii)

#get 穿过BS模板的纤维在全脑穿过的总体积
echo "BS_trks_volume:" >>$out_dir/${sub}_metrics.txt
fslstats $tdi -V >>$out_dir/${sub}_metrics.txt

#get 穿过BS模板的纤维在BS穿过的体积
echo "BS_trks_inBS_volume:" >>$out_dir/${sub}_metrics.txt
fslmaths $tdi -mul $bs_mask_redwi $out_dir/${sub}/${sub}_inBS_tdi
tdi_inBS=$(ls $out_dir/${sub}/${sub}_inBS_tdi*)
fslstats $tdi_inBS -V >>$out_dir/${sub}_metrics.txt

#get Lesion体积和Lesion在脑干部分的体积
echo "lesion_volume:" >>$out_dir/${sub}_metrics.txt
fslstats $les -V >>$out_dir/${sub}_metrics.txt
echo "lesion_inBS_volume:" >>$out_dir/${sub}_metrics.txt
fslstats $les_bs -V >>$out_dir/${sub}_metrics.txt

#get 全脑voxels的FA/MD map
echo "FA_map saved in sub's folder" >>$out_dir/${sub}_metrics.txt
echo "MD_map saved in sub's folder" >>$out_dir/${sub}_metrics.txt
dtifit -k $dwi -o $out_dir/${sub}/fa_fsl -m $mask -r $bvec -b $bval
fa=$(ls $out_dir/${sub}/fa_fsl*FA.nii.gz)
md=$(ls $out_dir/${sub}/fa_fsl*MD.nii.gz)

#get BS的平均FA/MD
echo "BS_FA:" >>$out_dir/${sub}_metrics.txt
fslmeants -i $fa -m $bs_mask_redwi >>$out_dir/${sub}_metrics.txt
echo "BS_MD:" >>$out_dir/${sub}_metrics.txt
fslmeants -i $md -m $bs_mask_redwi >>$out_dir/${sub}_metrics.txt

#get BS的lesion内的平均FA/MD
echo "BS_lesion_FA:" >>$out_dir/${sub}_metrics.txt
fslmeants -i $fa -m $les_bs_redwi >>$out_dir/${sub}_metrics.txt
echo "BS_lesion_MD:" >>$out_dir/${sub}_metrics.txt
fslmeants -i $md -m $les_bs_redwi >>$out_dir/${sub}_metrics.txt

#get 穿过BS的trks的平均FA/MD
fslmaths $tdi -bin $out_dir/${sub}/${sub}_BS_tdimask
echo "BS_trks_FA:" >>$out_dir/${sub}_metrics.txt
fslmeants -i $fa -m $out_dir/${sub}/${sub}_BS_tdimask.nii.gz >>$out_dir/${sub}_metrics.txt
echo "BS_trks_MD:" >>$out_dir/${sub}_metrics.txt
fslmeants -i $md -m $out_dir/${sub}/${sub}_BS_tdimask.nii.gz >>$out_dir/${sub}_metrics.txt

#get 穿过BS模板的trks在BS区域的平均FA
fslmaths $tdi_inBS -bin $out_dir/${sub}/${sub}_inBS_tdimask.nii.gz
echo "BS_trks_inBS_FA:" >>$out_dir/${sub}_metrics.txt
fslmeants -i $fa -m $out_dir/${sub}/${sub}_inBS_tdimask.nii.gz >>$out_dir/${sub}_metrics.txt
echo "BS_trks_inBS_MD:" >>$out_dir/${sub}_metrics.txt
fslmeants -i $md -m $out_dir/${sub}/${sub}_inBS_tdimask.nii.gz >>$out_dir/${sub}_metrics.txt
