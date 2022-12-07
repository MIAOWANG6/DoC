## Transform NII from MNI to individual space or vice versa with ANTS command

### `antsApplyTransforms --default-value 0 --dimensionality 3 --float 0` command and parameters

### `--input` nii file need to be transformed

### `--interpolation Linear` way of transformation

### `--output` nii output file name

### `--reference-image` preproc_T1w.nii.gz T1 file

### `--transform` Transform Matrix from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5

`antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input  --interpolation Linear --output  --reference-image  --transform `

## Example

`antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/code/convert_MNI_to_T1/brain_stem.nii --interpolation Linear --output /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/code/convert_MNI_to_T1/output.nii.gz --reference-image /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p/derivatives/qsiprep/sub-DOC0049/qsiprep/sub-DOC0049/anat/sub-DOC0049_desc-preproc_T1w.nii.gz --transform /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p/derivatives/qsiprep/sub-DOC0049/qsiprep/sub-DOC0049/anat/sub-DOC0049_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5`
