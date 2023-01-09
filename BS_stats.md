### 脑干纤维束参数统计结果
    module load mrtrix3
    echo "sub-DOC0034" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/tckedit.txt
    tckstats track_sub-DOC0034_BS.tck >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/tckedit.txt
    tckstats track_sub-DOC0034_BS.tck -histogram /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/sub-DOC0034/hist -force

### 全脑FA和MD，必须用dwi的mask
### 方式一：
    module load fsl
    dtifit -k sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.nii.gz -o fa_fsl -m sub-DOC0034_ses-20170223171421_space-T1w_desc-brain_mask.nii.gz -r sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.bvec -b sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.bval
### 方式二：
    dwi2tensor sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.nii.gz sub-DOC0034_dti.nii -fslgrad sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.bvec sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.bval
    tensor2metric -fa fa.nii.gz sub-DOC0034_dti.nii
    fslmaths fa.nii.gz -mul sub-DOC0034_ses-20170223171421_space-T1w_desc-brain_mask.nii.gz fa_mr

### 脑干纤维束参数基于voxel的TDI
    tckmap tdi -template sub-DOC0034_BS_Mask_MNI.nii track_sub-DOC0034_BS.tck sub-DOC0034_BS_in.nii

### Lesion体积
    fslstats sub-DOC0034.nii.gz -V
    fslmaths sub-DOC0034.nii.gz -mul sub-DOC0034_BS_Mask_MNI.nii sub-DOC0034_Lesion_inBS
    fslstats sub-DOC0034_Lesion_inBS.nii.gz -V
    
    
    fslstats track_sub-DOC0060_BS_minl245.nii.gz -V

### parallel.sh
    #!/bin/bash
    #SBATCH -J ANTS
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --ntasks-per-node=2
    #SBATCH --mem-per-cpu 16000
    #SBATCH -p q_fat_c
    
    module load fsl
    module load ants
    module load mrtrix3
    module unload gcc/5.5.0
    
    #get needed files
    #bvec\bval\dwi\mask\tck\lesion\bs_mif
        
    site=$2
    tck_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${1}/qsiprep/${1}/ses-*/dwi
    dwi_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${1}/qsirecon/${1}/ses-*/dwi
    sub_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${1}
    tck=$(ls ${tck_dir}/${1}_ses-*_space-T1w_desc-preproc_space-T1w_desc-tracks_ifod2.tck)
    bval=$(ls ${dwi_dir}/${1}_*_space-T1w_desc-preproc_dwi.bval)
    bvec=$(ls ${dwi_dir}/${1}_*_space-T1w_desc-preproc_dwi.bvec)
    mask=$(ls ${dwi_dir}/${1}_*_space-T1w_desc-brain_mask.nii.gz)
    dwi=$(ls ${dwi_dir}/${1}_*_space-T1w_desc-preproc_dwi.nii.gz)
        
    #get BS whole tracts
    cd $sub_dir
    mif=${1}_BS_Mask_MNI.mif
    tckedit $tck track_${1}_BS.tck -include $mif
  
    #get BS whole tracts
    echo ${1} >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    tckstats $sub_dir/track_${1}_BS.tck >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    tckstats $sub_dir/track_${1}_BS.tck -histogram $sub_dir/hist -force
    dtifit -k $dwi -o fsl_ -m $mask -r $bvec -b $bval
    
    #get TDI
    tckmap tdi -template $mask track_${1}_BS.tck ${1}_BS_tdi.nii
    
    #get tracts体积
    echo BS_tracts_volume: >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    fslstats ${1}_BS_tdi.nii -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    
    # Lesion体积
    echo Lesion_volume: >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    fslstats ${1}.nii.gz -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    fslmaths ${1}.nii.gz -mul ${1}_BS_Mask_MNI.nii ${1}_Lesion_inBS
    echo Lesion_inBS_volume: >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    fslstats ${1}_Lesion_inBS.nii.gz -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    
    
    
