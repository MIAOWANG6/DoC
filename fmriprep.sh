#!/bin/bash
#SBATCH -J CBIC_fmriprep
#SBATCH -c 8
#SBATCH	--mem-per-cpu 8000
#SBATCH -p q_fat
module load singularity/3.7.0

#!/bin/bash
#User inputs:
site=$1
subj=$2
ses=$3
ses=${ses:4}
bids_root_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/data/$site
bids_root_dir_output_wd4singularity=/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/wd


nthreads=40

#Run fmriprep
echo ""
echo "Running fmriprep on participant: $subj${ses}"
echo ""

#Make fmriprep directory and participant directory in derivatives folder
if [ ! -d $bids_root_dir/derivatives ]; then
    mkdir $bids_root_dir/derivatives
fi
    
if [ ! -d $bids_root_dir/derivatives/fmriprep ]; then
    mkdir $bids_root_dir/derivatives/fmriprep
fi

if [ ! -d $bids_root_dir/derivatives/fmriprep/${subj}${ses} ]; then
    mkdir $bids_root_dir/derivatives/fmriprep/${subj}${ses}
fi

if [ ! -d $bids_root_dir/derivatives/fmriprep/${subj}${ses}/freesurfer ]; then
    mkdir $bids_root_dir/derivatives/fmriprep/${subj}${ses}/freesurfer
fi

if [ ! -d $bids_root_dir/derivatives/fmriprep/${subj}${ses}/freesurfer/${subj}${ses} ]; then
    mkdir $bids_root_dir/derivatives/fmriprep/${subj}${ses}/freesurfer/${subj}${ses}
fi

if [ ! -d $bids_root_dir_output_wd4singularity/derivatives ]; then
    mkdir $bids_root_dir_output_wd4singularity/derivatives
fi

if [ ! -d $bids_root_dir_output_wd4singularity/derivatives/fmriprep ]; then
    mkdir $bids_root_dir_output_wd4singularity/derivatives/fmriprep
fi

if [ ! -d $bids_root_dir_output_wd4singularity/derivatives/fmriprep/${subj}${ses} ]; then
    mkdir $bids_root_dir_output_wd4singularity/derivatives/fmriprep/${subj}${ses}
fi


cp -r /GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/data/$site/derivatives/fastcsr/${subj}ses-${ses}/* $bids_root_dir/derivatives/fmriprep/${subj}${ses}/freesurfer/${subj}${ses}/
echo $bids_root_dir
echo ${subj:4}${ses}
#Run fmriprep
export SINGULARITYENV_TEMPLATEFLOW_HOME=/GPFS/cuizaixu_lab_permanent/Public_Data/HBN/code/rsfMRI/templateflow
unset PYTHONPATH; singularity run --cleanenv -B $bids_root_dir_output_wd4singularity/derivatives/fmriprep/${subj}${ses}:/wd \
    -B $bids_root_dir/:/inputbids \
    -B $bids_root_dir/derivatives/fmriprep/${subj}${ses}:/output \
    -B /GPFS/cuizaixu_lab_permanent/wangmiao:/freesurfer_license \
    /usr/nzx-cluster/apps/fmriprep/singularity/fmriprep-20.2.1.simg \
    /inputbids /output participant \
    --participant_label ${subj:4}${ses} \
    -w /wd \
    --nthreads $nthreads \
    --omp-nthreads $nthreads \
    --mem-mb 160000 \
    --fs-license-file /freesurfer_license/license.txt \
    --output-spaces T1w MNI152NLin6Asym MNI152NLin2009cAsym  \
    --return-all-components \
    --notrack --verbose \
    --skip-bids-validation --debug all --stop-on-first-crash --use-syn-sdc --fs-no-reconall --resource-monitor
