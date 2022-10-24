#!/bin/bash
#SBATCH -J QSIPREP
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem-per-cpu 8000
#SBATCH -p q_cn

module load singularity/3.7.0
module load freesurfer
module load fastcsr/fastcsr_cpu
module load fsl


#User inputs:
subj=$1
ses=$2
bids_root_dir=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p #site
bids_root_dir_output=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p #site
bids_root_dir_output_wd4singularity=/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p_WK 
SUBJECTS_DIR=$bids_root_dir_output/derivatives/fastcsr/
subses_dir=$bids_root_dir_output/derivatives/fastcsr/$subj$ses
nthreads=8


cd /GPFS/cuizaixu_lab_permanent/wangmiao/Fastcsr/

if [ -d $subses_dir ]; then
    python3 fastcsr_model_infer.py --fastcsr_subjects_dir $SUBJECTS_DIR --subj $subj$ses --hemi lh --suffix orig.nofix
    python3 fastcsr_model_infer.py --fastcsr_subjects_dir $SUBJECTS_DIR --subj $subj$ses --hemi rh --suffix orig.nofix

    python3 levelset2surf.py --fastcsr_subjects_dir $bids_root_dir/derivatives/fastcsr/ --subj $subj$ses --hemi lh --suffix orig.nofix
    python3 levelset2surf.py --fastcsr_subjects_dir $bids_root_dir/derivatives/fastcsr/ --subj $subj$ses --hemi rh --suffix orig.nofix


    mris_smooth -nw $subses_dir/surf/lh.orig.nofix $subses_dir/surf/lh.smoothwm.nofix
    mris_smooth -nw $subses_dir/surf/rh.orig.nofix $subses_dir/surf/rh.smoothwm.nofix
    mris_inflate -no-save-sulc $subses_dir/surf/lh.smoothwm.nofix $subses_dir/surf/lh.inflated.nofix
    mris_inflate -no-save-sulc $subses_dir/surf/rh.smoothwm.nofix $subses_dir/surf/rh.inflated.nofix
    mris_sphere -q $subses_dir/surf/lh.inflated.nofix $subses_dir/surf/lh.qsphere.nofix
    mris_sphere -q $subses_dir/surf/rh.inflated.nofix $subses_dir/surf/rh.qsphere.nofix

    cp $subses_dir/surf/lh.inflated.nofix $subses_dir/surf/lh.inflated
    cp $subses_dir/surf/rh.inflated.nofix $subses_dir/surf/rh.inflated

    mris_fix_topology -mgz -sphere $subses_dir/surf/qsphere.nofix -ga $subj$ses lh
    mris_fix_topology -mgz -sphere $subses_dir/surf/qsphere.nofix -ga $subj$ses rh

    mris_euler_number $subses_dir/surf/lh.orig
    mris_euler_number $subses_dir/surf/rh.orig
    mris_remove_intersection $subses_dir/surf/lh.orig $subses_dir/surf/lh.orig
    mris_remove_intersection $subses_dir/surf/rh.orig $subses_dir/surf/rh.orig

    rm $subses_dir/surf/lh.inflated
    rm $subses_dir/surf/rh.inflated

    mris_make_surfaces -aseg $subses_dir/mri/aseg.presurf -whiteonly -noaparc -mgz -T1 $subses_dir/mri/brain.finalsurfs $subj$ses lh
    mris_make_surfaces -aseg $subses_dir/mri/aseg.presurf -whiteonly -noaparc -mgz -T1 $subses_dir/mri/brain.finalsurfs $subj$ses rh

    mris_smooth -n 3 -nw $subses_dir/surf/lh.white $subses_dir/surf/lh.smoothwm
    mris_smooth -n 3 -nw $subses_dir/surf/rh.white $subses_dir/surf/rh.smoothwm

    mris_inflate $subses_dir/surf/lh.smoothwm $subses_dir/surf/lh.inflated
    mris_inflate $subses_dir/surf/rh.smoothwm $subses_dir/surf/rh.inflated

    mris_curvature -w $subses_dir/surf/lh.white
    mris_curvature -w $subses_dir/surf/rh.white

    mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 $subses_dir/surf/lh.inflated
    mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 $subses_dir/surf/rh.inflated

    mris_curvature_stats -m --writeCurvatureFiles -G -o $subses_dir/stats/lh.curv.stats -F smoothwm $subj$ses lh curv sulc
    mris_curvature_stats -m --writeCurvatureFiles -G -o $subses_dir/stats/rh.curv.stats -F smoothwm $subj$ses rh curv sulc

    recon-all -autorecon3 -subjid $subj$ses



fi
