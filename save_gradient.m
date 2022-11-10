function [] = save_gradient(script_dir,nii_file,data_dir,subname)
    ind_dir = [data_dir,subname];
    mkdir(ind_dir);    
    filename = [ind_dir,'/gradient.mat'];    
    if ~exist(filename,'file')
        M = x_gen_matrix_voxel([script_dir,'/Reslice_group_mask.nii'],nii_file);
        n = length(M);
        M_spar = M;
        tmp = sort(M);
        tmp = M - repmat(tmp(round(n*0.9),:),n,1);
        M_spar(tmp<0) = 0;
        M_spar = M_spar';

        M_cos = 1 - squareform(pdist(M_spar,'cosine'));
        M_normalized = 1 - acos(M_cos)/pi;
        [embedding,result] = x_compute_diffusion_map(M_normalized,0.5,30);     
        filename = [ind_dir,'/gradient.mat'];
        save(filename,'embedding','result');
    end
    disp('Done')
end
