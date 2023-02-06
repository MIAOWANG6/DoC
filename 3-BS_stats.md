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
    #bs_mask\bvec\bval\dwi\mask\tck\lesion\bs_mif

    sub=$1   
    site=$2
    dwi_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${sub}/qsiprep/${sub}/ses-*/dwi
    tck_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/${site}/derivatives/qsiprep/${sub}/qsirecon/${sub}/ses-*/dwi
    Lshow_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/${sub}_*
    sub_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/${sub}
    tck=$(ls ${tck_dir}/${sub}_ses-*_space-T1w_desc-preproc_space-T1w_desc-tracks_ifod2.tck)
    bval=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.bval)
    bvec=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.bvec)
    mask=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-brain_mask.nii.gz)
    dwi=$(ls ${dwi_dir}/${sub}_*_space-T1w_desc-preproc_dwi.nii.gz)
    mif=$(ls ${Lshow_dir}/${sub}_BS_Mask_MNI.mif)
    bs_mask=$(ls ${Lshow_dir}/${sub}_BS_Mask_MNI.nii)
    
    #get BS whole tracts
    cd $sub_dir
    tckedit $tck track_${sub}_BS.tck -include $mif

    #get BS whole tracts
    echo ${sub} >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    tckstats $sub_dir/track_${sub}_BS.tck >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    tckstats $sub_dir/track_${sub}_BS.tck -histogram $sub_dir/hist -force
    dtifit -k $dwi -o fsl_ -m $mask -r $bvec -b $bval

    #get TDI
    tckmap -template $mask track_${sub}_BS.tck ${sub}_BS_tdi.nii

    #get tracts体积
    echo "BS_tracts_volume:" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    fslstats ${sub}_BS_tdi.nii -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt

    # Lesion体积
    echo "Lesion_volume:" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    fslstats ${sub}.nii.gz -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    fslmaths ${sub}.nii.gz -mul $bs_mask ${sub}_Lesion_inBS
    echo "Lesion_inBS_volume:" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    fslstats ${sub}_Lesion_inBS.nii.gz -V >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/metrics.txt
    
    
    
