## 1-1.制作MNI空间脑干mask

    str_bs_mask_MNI  = spm_vol('E:\DOC_BS_Stroke\BSMask\BS_Mask_MNI_icbm15209c.nii.gz'); %用MNI_icbm15209c全脑模板在ITKSNAP里制作的MNI脑干模板
    bs_mask_MNI  = spm_read_vols(str_bs_mask_MNI ); %读取图像数据
    bs_mask_MNI=round(bs_mask_MNI); %取整
    
![image](https://user-images.githubusercontent.com/52966164/209779461-d27c5bd0-0bb9-47f1-9e16-ef24dcefac63.png)

## 1-2.制作MNI空间无脑干全脑mask

    str_brain_mask_MNI = spm_vol('E:\DOC_BS_Stroke\BSMask\Brain_Mask_MNI_icbm15209c.nii'); %导入MNI_icbm15209c全脑模板
    brain_mask_MNI  = spm_read_vols(str_brain_mask_MNI );
    brain_mask_MNI =round(brain_mask_MNI );
    brain_bs_mask_diff_MNI =brain_mask_MNI-bs_mask_MNI; %MNI全脑mask减去MNI-BS-Mask
    str_brain_bs_mask_diff_MNI=str_brain_mask_MNI;
    str_brain_bs_mask_diff_MNI.fname = 'E:\DOC_BS_Stroke\BSMask\Brain_BS_Mask_diff_MNI.nii'; %改名字
    spm_write_vol(str_brain_bs_mask_diff_MNI,brain_bs_mask_diff_MNI); %save差异模板
    
![image](https://user-images.githubusercontent.com/52966164/209780530-155511e5-2937-4084-859b-3e592d948eaa.png)

### 用INKSNAP将差异模板多余的膜去掉，去掉的mask存成BS-nodiff-mask

![image](https://user-images.githubusercontent.com/52966164/209783207-afe9b280-1db2-4a49-9923-7e8c868d130f.png)

### 如果不这样，转换成surface的时候会出现以下状况：

![image](https://user-images.githubusercontent.com/52966164/209781750-0069c0c0-c5f7-48f0-8823-2c302c247076.png)

## 1-3.制作MNI空间全脑&脑干多值mask

    str_bs_mask_nodiff_MNI = spm_vol('E:\DOC_BS_Stroke\BSMask\BS_Mask_nodiff_MNI.nii'); %读取BS-nodiff-mask
    bs_mask_nodiff_MNI= spm_read_vols(str_bs_mask_nodiff_MNI );
    bs_mask_nodiff_MNI=round(bs_mask_nodiff_MNI);
    brain_bs_mask_nodiff_MNI=brain_bs_mask_diff_MNI-bs_mask_nodiff_MNI; %全脑差异mask减去BS-nodiff-mask
    brain_bs_mask_nodiff_MNI(find(brain_bs_mask_nodiff_MNI<0))=0; %让小于0的部分归零
    str_brain_bs_mask_nodiff_MNI=str_bs_mask_nodiff_MNI;
    str_brain_bs_mask_nodiff_MNI.fname= 'E:\DOC_BS_Stroke\BSMask\Brain_BS_Mask_nodiff_MNI.nii'; 
    spm_write_vol(str_brain_bs_mask_nodiff_MNI,brain_bs_mask_nodiff_MNI); %存储全脑无脑干的nodiff-mask

![image](https://user-images.githubusercontent.com/52966164/209782296-1e3c47b6-258d-4734-b144-301bbb58ec44.png)

    bs_mask_MNI(find(bs_mask_MNI==1))=20; %赋值脑干值为20
    brain_bs_mask_nodiff_MNI(find(brain_bs_mask_nodiff_MNI==1))=200; %赋值大脑其他部位值为200
    final_mask_MNI=brain_bs_mask_nodiff_MNI+bs_mask_MNI;
    str_final_mask_MNI=str_bs_mask_nodiff_MNI;
    str_final_mask_MNI.fname= 'E:\DOC_BS_Stroke\BSMask\Final_BS_Mask_MNI.nii'; 
    spm_write_vol(str_final_mask_MNI,final_mask_MNI); %存储MNI空间的多值mask
    
![image](https://user-images.githubusercontent.com/52966164/209786930-94a3dc46-fb35-4dea-b055-9b2fafba7d4b.png)
    
## 1-4.将MNI空间转换为个体空间全脑&脑干多值mask  

### module load ants
### antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input `final_mask_MNI` --interpolation Linear --output `final_mask_MNI_indv.nii.gz` --reference-image `preproc_T1w.nii.gz` --transform `xfm.h5`

### 例
    antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input Final_BS_Mask_MNI.nii --interpolation NearestNeighbor --output sub-DOC0034_Final_BS_Mask_MNI.nii --reference-image sub-DOC0034_desc-preproc_T1w.nii.gz --transform sub-DOC0034_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5
### 注：必须是NearestNeighbor插值不然会有小数
### 注：有的时候会加载gcc/5.5.0，这个有问题，要unload这个module
### 注：用matlab提交不行！

![image](https://user-images.githubusercontent.com/52966164/209655397-d9d26c7a-d8db-4f08-96c9-a8c71e6257c5.png)

## 2.将被试的tck文件提取穿过ROI的纤维束
    antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input BS_Mask_MNI_icbm15209c.nii.gz --interpolation NearestNeighbor --output sub-DOC0034_BS_Mask_MNI.nii --reference-image sub-DOC0034_desc-preproc_T1w.nii.gz --transform sub-DOC0034_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5
    
    module load mrtrix3
    mrconvert sub-DOC0034_BS_Mask_MNI.nii sub-DOC0034_BS_Mask_MNI.mif
    module unload gcc/5.5.0
    tckedit sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_space-T1w_desc-tracks_ifod2.tck track_sub-DOC0034_BS_minl245.tck -include sub-DOC0034_BS_Mask_MNI.mif -minlength 245
    tckedit sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_space-T1w_desc-tracks_ifod2.tck track_sub-DOC0034_BS_num200.tck -include sub-DOC0034_BS_Mask_MNI.mif -number 200

## 3-1.parallel.m
    site_dir = '/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow';
    cd(site_dir);
    sub_site = dir([site_dir, '/sub-*' ]);
    num=0;
    for sub = 4:numel(sub_site)
        folder_name = sub_site(sub).name;
        sub_name = folder_name(1:11);
        copyfile('./antsTrans.sh' ,[sub_site(sub).folder,'/',folder_name]);
        copyfile('./Final_BS_Mask_MNI.nii' ,[sub_site(sub).folder,'/',folder_name]);
        copyfile('./BS_Mask_MNI_icbm15209c.nii' ,[sub_site(sub).folder,'/',folder_name]);
        cd([sub_site(sub).folder,'/',folder_name]);
    end
    
## 3-2.parallel.sh
    #!/bin/bash
    #SBATCH -J ANTS
    #SBATCH --nodes=1
    #SBATCH --ntasks=1
    #SBATCH --ntasks-per-node=2
    #SBATCH --mem-per-cpu 16000
    #SBATCH -p q_fat_c
    module load ants
    module unload gcc/5.5.0

    antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input Final_BS_Mask_MNI.nii --interpolation NearestNeighbor --output ${1}_Final_BS_Mask_MNI.nii --reference-image ${1}_desc-preproc_T1w.nii.gz --transform ${1}_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5

    antsApplyTransforms --default-value 0 --dimensionality 3 --float 0 --input BS_Mask_MNI_icbm15209c.nii --interpolation NearestNeighbor --output ${1}_BS_Mask_MNI.nii --reference-image ${1}_desc-preproc_T1w.nii.gz --transform ${1}_from-MNI152NLin2009cAsym_to-T1w_mode-image_xfm.h5

    module load mrtrix3

    mrconvert ${1}_BS_Mask_MNI.nii ${1}_BS_Mask_MNI.mif
   
## 3-3.run .sh
    cd /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/sub-DOC0034_YANGYI/
    srun sh antsTrans.sh sub-DOC0034

## 4.将tck转为trk文件（可不操作）
## 4-1.修改app-convert-tck-to-trk/config.json
    {
        "tck": "/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/sub-DOC0034_YANGYI/sub-DOC0034_YangYi_Lesion_tracks.tck",
        "dwi": "/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/sub-DOC0034_YANGYI/sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_dwi.nii.gz"
    }

## 4-2.run python tck2trk脚本
    cd /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/app-convert-tck-to-trk/
    conda activate tck2trk    
    srun -p q_fat_c -c 4 python convert_tck_to_trk.py
    cp track_sub-001.trk /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/sub-DOC0034_YANGYI/track_sub-DOC0034_BS_220.trk
    rm track_sub-001.trk

## 5.下载track_ROI并显示与Overlay
## 5-1. 制作个体被试的两种穿过BS的纤维束
    cd /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/Brain_Stem_Connectivity/LesionShow/sub-DOC0034_YANGYI/
    tckedit /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p/derivatives/qsiprep/sub-DOC0034/qsirecon/sub-DOC0034/ses-20170223171421/dwi/sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_space-T1w_desc-tracks_ifod2.tck track_sub-DOC0034_BS_num200.tck -include sub-DOC0034_BS_Mask_MNI.mif -number 200
    tckedit /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p/derivatives/qsiprep/sub-DOC0034/qsirecon/sub-DOC0034/ses-20170223171421/dwi/sub-DOC0034_ses-20170223171421_space-T1w_desc-preproc_space-T1w_desc-tracks_ifod2.tck track_sub-DOC0034_BS_minl245.tck -include sub-DOC0034_BS_Mask_MNI.mif -minlength 245
    
## 5-2.将BrainBS、BS、Lesion的mask都转换为mz3格式
    nii_nii2atlas('E:\DOC_BS_Stroke\LesionShow\sub-DOC0034_Final_BS_Mask_MNI.nii');
    nii_nii2atlas('E:\DOC_BS_Stroke\LesionShow\sub-DOC0034_BS_Mask_MNI.nii');
    nii_nii2atlas('E:\DOC_BS_Stroke\LesionShow\DOC0034-SEG.nii.gz');
    







