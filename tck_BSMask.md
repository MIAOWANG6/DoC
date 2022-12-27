## 1.将ch2bet模板中画出的BS_MNI2009的模板转换到个体空间

### module load ants

### antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input `BS_Mask_MNI_ch2bet` --interpolation Linear --output `mask_indv.nii.gz` --reference-image `preproc_T1w.nii.gz` --transform `xfm.h5`


{
    "tck": "/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/sub-DOC0034_YANGYI/sub-DOC0034_YangYi_Lesion_tracks.tck",
    "dwi": "/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/sub-DOC0034_YANGYI/sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.nii.gz"
}


mrconvert sub-DOC0034_YangYi_Lesion.nii.gz sub-DOC0034_YangYi_Lesion.mif


tckedit sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_space-T1w_desc-tracks_ifod2.tck sub-DOC0034_YangYi_Lesion_tracks.tck -include sub-DOC0034_YangYi_Lesion.mif
