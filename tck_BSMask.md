## 1.将ch2bet模板中画出的BS_MNI2009的模板转换到个体空间

### module load ants
### antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input `BS_Mask_MNI_ch2bet` --interpolation Linear --output `mask_indv.nii.gz` --reference-image `preproc_T1w.nii.gz` --transform `xfm.h5`

### 例
### `antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input BS_Mask_MNI_icbm15209c.nii.gz --interpolation Linear --output sub-DOC0034_BS_Mask_MNI_icmb15209c.nii.gz --reference-image sub-DOC0034_desc-preproc_T1w.nii.gz --transform sub-DOC0034_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5`

## 2.将被试的tck文件提取穿过ROI的纤维束

### module load mrtrix3
### `mrconvert sub-DOC0034_BS_Mask_MNI_icmb15209c.nii.gz sub-DOC0034_BS_Mask_MNI_icmb15209c.mif`
### `tckedit sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_space-T1w_desc-tracks_ifod2.tck track_sub-DOC0034_YangYi_BS.tck -include sub-DOC0034_BS_Mask_MNI_icmb15209c.mif`

## 3.制作preproc_T1w与Indv_BS_Mask_MNI_icmb15209c合并的Multi-tissue Mask


## 4.下载track_ROI并显示与Overlay

`{
    "tck": "/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/sub-DOC0034_YANGYI/sub-DOC0034_YangYi_Lesion_tracks.tck",
    "dwi": "/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/sub-DOC0034_YANGYI/sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.nii.gz"
}`



