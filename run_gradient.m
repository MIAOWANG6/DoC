clear;clc;
addpath('/GPFS/cuizaixu_lab_permanent/wangmiao/ABCD_dMRI_Result/ABCD_code/spm12');
sub_all = importdata('/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/code/voxel_gradient/subfiles.txt');
path_dir = '/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/data/';
%sub_cate = {'CONtrol';'SUB'};
script_dir = '/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/code/voxel_gradient/';
gradient_dir = '/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/code/voxel_gradient/gradient_221109/';
%mkdir(figure_dir)
%% Downsample preprocessed images
out_path='/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/voxel_out/';
%% Generate connectivity matrix and calculate gradients
cd(out_path);
file_reslice = dir([out_path,'r*.nii']);
cd(script_dir)
for i = 1:length(file_reslice)
    subname = strrep(file_reslice(i).name,'_task-rest_space-MNI152NLin6Asym_desc-residual_smooth_bold.nii','');
    ind_dir = [gradient_dir,subname]; 
    if ~exist(ind_dir,'dir')
        cmd{1} = ['out_path=''/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/code/voxel_gradient'''];
        cmd{2} = 'addpath(genpath(''/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/code/''))';
        cmd{3} = 'addpath(''/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/spm12'')';
        cmd{4} = 'cd(out_path)';
        cmd{5} = ['subname = ''' subname ''''];
        cmd{6} = ['nii_file = ''', out_path, file_reslice(i).name ''''];
        cmd{7} = ['save_gradient(''' script_dir ''',nii_file,''' gradient_dir ''',subname)'];
        fid = fopen(['/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/code/voxel_gradient/single_parcel_' num2str(i) '.m'],'wt');
        fprintf(fid,'%s\n',cmd{:});
        fclose(fid);
        pause(2)
        system(['sbatch '  'run_single_parcel.slurm ' 'single_parcel_' num2str(i)]);
    end
    i
end
