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

## BS tract include 
sub=$1   
site=$2
out_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/Hierarchy
anat_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${sub}/qsiprep/${sub}/anat
dwi_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${sub}/qsiprep/${sub}/ses-*/dwi
tck_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${sub}/qsirecon/${sub}/ses-*/dwi
networks_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/Hierarchy/Schaefer2018-7networks-mask
trks_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/TracksMask_22sub


tck=$(ls ${tck_dir}/${sub}_ses-*tracks_ifod2.tck)
xfm_MNI_ind=$(ls ${anat_dir}/${sub}_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5)
t1=$(ls ${anat_dir}/${sub}_desc-preproc_T1w.nii.gz)
mask=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-brain_mask.nii.gz)


# get individual space tck masks
if [ ! -d $out_dir/${sub} ]; then
    mkdir $out_dir/${sub}
fi

# trans from MNI to individual space
for i in `cat  ${networks_dir}/networks.txt`
do 
mif=$out_dir/${sub}/${i%.*}.mif

antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input ${networks_dir}/${i} --interpolation NearestNeighbor --output $out_dir/${sub}/${i} --reference-image ${t1} --transform ${xfm_MNI_ind}

mrconvert $out_dir/${sub}/${i} $mif

for j in `cat  ${trks_dir}/trksmask.txt`
do
outfile=$out_dir/${sub}/track_${sub}_${j%%.*}_${i%.*}.tck
tckedit $tck $outfile -include ${trks_dir}/$sub/${j%%.*}.mif -include $mif

#get tracts metrics
echo ${j%%.*}_${i%.*} >>$out_dir/${sub}_metrics.txt
tckstats $outfile >>$out_dir/${sub}_metrics.txt

#get TDI
tckmap -template $mask $outfile $out_dir/${sub}/${j%%.*}_${i%.*}_tdi.nii

#get tracts体积
echo ${j%%.*}_${i%.*}_volume >>$out_dir/${sub}_metrics.txt
fslstats $out_dir/${sub}/${j%%.*}_${i%.*}_tdi.nii -V >>$out_dir/${sub}_metrics.txt

done
done
