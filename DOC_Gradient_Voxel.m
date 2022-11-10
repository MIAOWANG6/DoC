%% process pipeline
%% define work dir
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
%mkdir(out_path);
for group=1
    %group_all_sub = dir([path_dir sub_cate{group} '\sub-*']);
    for sub=1:numel(sub_all)
       sub_data = [path_dir,sub_all{sub}];
       sub_etc = strsplit(sub_data,'func/');
       sub_etc = sub_etc{2};
       sub_etc = strsplit(sub_etc,'.');
       if exist(sub_data,'file')           
           gunzip(sub_data,out_path);
       end
       [out_path,sub_etc{1},'.nii']
       x_reslice([script_dir,'Reslice_group_mask.nii'],[out_path,sub_etc{1},'.nii'],4);
    end
end

%% Generate connectivity matrix and calculate gradients
cd(out_path);
file_reslice = dir([out_path,'*.nii']);

for i = 1:numel(file_reslice)
    M = x_gen_matrix_voxel([script_dir,'Reslice_group_mask.nii'],file_reslice(i).name);
    n = length(M);
    M_spar = M;
    tmp = sort(M);
    tmp = M - repmat(tmp(round(n*0.9),:),n,1);
    M_spar(tmp<0) = 0;
    M_spar = M_spar';
    
    M_cos = 1 - squareform(pdist(M_spar,'cosine'));
    M_normalized = 1 - acos(M_cos)/pi;
    [embedding,result] = x_compute_diffusion_map(M_normalized,0.5,30);
    
    ind_dir = [gradient_dir,strrep(file_reslice(i).name,'_task-rest_space-MNI152NLin6Asym_desc-residual_smooth_bold.nii','')];
    mkdir(ind_dir);
    filename = [ind_dir,'/gradient.mat'];
    save(filename,'embedding','result');
end


%% arrange emb
cd(gradient_dir);
file_gradient = dir([gradient_dir,'rsub*']);
emb_all = cell(numel(file_gradient),1);
res_all = cell(numel(file_gradient),1);
for i = 1:numel(file_gradient)
    cd([gradient_dir,file_gradient(i).name]);
    if isfile('gradient.mat')
    load('gradient.mat');
    emb_all{i} = embedding;
    res_all{i} = result; 
    else 
        file_gradient(i).name
    end
end
% aligned across subjects
[realigned, xfms] = mica_iterativeAlignment(emb_all,100);
realigned = real(realigned);
xfms = cellfun(@real,xfms,'UniformOutput',false);
gradient_emb = cell(30,1);
for i = 1:30
    gradient_emb{i} = squeeze(realigned(:,i,:));
end
%calculate order sequence
seq = zeros(numel(file_gradient),30);
for i = 1:numel(file_gradient)
    tmp = abs(xfms{i});
    [~,I] = sort(tmp,'descend');
    seq_tmp = zeros(5,1);
    seq_tmp(1) = I(1);
    for j = 2:30
        for k = 1:30
            if isempty(find(seq_tmp == I(k,j), 1))
                seq_tmp(j) = I(k,j);
                break;
            end
        end
    end
    seq(i,:) = seq_tmp;
end

%calculate explaination rate
exprate = zeros(numel(file_gradient),30);
for i = 1:numel(file_gradient)
    tmp = res_all{i}.lambdas./sum(res_all{i}.lambdas);
    exprate(i,:) = tmp(seq(i,:));
end


% reorder gradient according to explaination ratio
exprate_mean = mean(exprate);
[~,I] = sort(exprate_mean,'descend');
gradient_emb_reordered = cell(30,1);
for i = 1:30
    gradient_emb_reordered{i} = gradient_emb{I(i)};
end

exprate_reordered = exprate(:,I);
save([out_path 'exprate_reordered.mat'],'exprate_reordered')

% visual check mean gradient
%load('E:\youyi_fucha\exprate_reordered.mat')
hdr_mask = spm_vol([script_dir,'Reslice_group_mask.nii']);
vol_mask = spm_read_vols(hdr_mask);
hdr = hdr_mask;
hdr.dt(1) = 64;
ind = find(vol_mask);
cd(out_path);
for i = 1:3
    vol = zeros(hdr.dim);
    vol(ind) = mean(gradient_emb_reordered{i},2);
    hdr.fname = ['mean_g_',num2str(i),'.nii'];    
    spm_write_vol(hdr,vol);
end

for i = 1:3
    gradient_emb_reordered{i} = -gradient_emb_reordered{i};
end
save([out_path,'gradient_emb_correct(1-3).mat'],'gradient_emb_reordered');

% generate mean map for both groups
hdr_mask = spm_vol([script_dir,'Reslice_group_mask.nii']);
vol_mask = spm_read_vols(hdr_mask);
hdr = hdr_mask;
hdr.dt(1) = 64;
ind = find(vol_mask);
cd(out_path);
sub_info = [repmat(1,50,1) ;repmat(2,54,1)];
for i = 1:3
    vol = zeros(hdr.dim);
    vol(ind) = mean(gradient_emb_reordered{i},2);
    hdr.fname = ['mean_g_',num2str(i),'_DOC.nii'];    
    spm_write_vol(hdr,vol);
end

% calculate mean ratio
mean(exprate_reordered(:,1))
std(exprate_reordered(:,1))

mean(exprate_reordered(:,2))
std(exprate_reordered(:,2))

mean(exprate_reordered(:,3))
std(exprate_reordered(:,3))

% draw explaination ratio
close all

%%
close all

cum_exprate_DOC = cumsum(exprate_mean);

ph = plot(1.2:1:30.2,cum_exprate_DOC,'.-','color','blue','linewidth',0.5);
ph.MarkerSize = 10;
pm.MarkerSize = 10;
l = legend;
l.String = {'DOC'};
l.Location = 'northeast';
xlabel('Component of diffusion embedding');
ylabel('Cumulative explained ratio');
set(gca,'LineWidth',0.5);
set(gca,'FontName','Arial','FontSize',6);
set(gca,'YLim',[0,1],'YTick',0:0.25:1);
set(gca,'XLim',[0,31]);
box off
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'Paperposition',[1 1 8.9 8]);
print(gcf,[gradient_dir,'CompCum.tif'],'-dtiff','-r1000');

%%
% calculate gradient range
emb_range = zeros(numel(file_gradient),3);
for i = 1:3
    for j = 1:numel(file_gradient)
        emb_range(j,i) = max(gradient_emb_reordered{i}(:,j)) - min(gradient_emb_reordered{i}(:,j));
    end
end
save([out_path,'emb_range.mat'],'emb_range');

% calculate variation
emb_std = zeros(numel(file_gradient),3);
for i = 1:3
    for j = 1:numel(file_gradient)
        emb_std(j,i) = std(gradient_emb_reordered{i}(:,j));
    end
end
save([out_path,'emb_std.mat'],'emb_std');
