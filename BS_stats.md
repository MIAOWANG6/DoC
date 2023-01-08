### 脑干纤维束参数统计结果
    module load mrtrix3
    echo "sub-DOC0034" >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/tckedit.txt
    tckstats track_sub-DOC0034_BS.tck >>/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/tckedit.txt
    tckstats track_sub-DOC0034_BS.tck -histogram /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/BSStats/sub-DOC0034/hist -force

### 全脑FA和MD，必须用dwi的mask
### 方式一：
    module load fsl
    dtifit -k sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.nii.gz -o fa_fsl -m sub-DOC0034_ses-20170223171421_space-T1w_desc-brain_mask.nii.gz -r sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.bvec -b sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.bval
    fslmaths fa.nii.gz -mul sub-DOC0034_ses-20170223171421_space-T1w_desc-brain_mask.nii.gz fa_mr
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
