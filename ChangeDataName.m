subs = importdata('/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/Subs&Patho_for_Gradient.txt');
gra_p = '/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/data/';

for i = 1:numel(subs)
    site_sub_ses = strsplit(subs{i},'/');
    sub_p = [gra_p,site_sub_ses{1},'/',site_sub_ses{2},site_sub_ses{3}];
    if isfolder([sub_p,'/anat/'])
        files = dir([sub_p,'/anat/']);
        files(1:2) = [];
        for j = 1:numel(files)
            if ~isempty(strfind(files(j).name,'json'))
                system(['mv ',files(j).folder,'/',files(j).name,' ',files(j).folder,'/',site_sub_ses{2},site_sub_ses{3},'_T1w.json']);
            end
            if ~isempty(strfind(files(j).name,'nii'))
                system(['mv ',files(j).folder,'/',files(j).name,' ',files(j).folder,'/',site_sub_ses{2},site_sub_ses{3},'_T1w.nii.gz']);
            end
        end                
    end
    
    if isfolder([sub_p,'/func/'])
        files = dir([sub_p,'/func/']);
        files(1:2) = [];
        for j = 1:numel(files)
            if ~isempty(strfind(files(j).name,'json'))
                system(['mv ',files(j).folder,'/',files(j).name,' ',files(j).folder,'/',site_sub_ses{2},site_sub_ses{3},'_task-rest_bold.json']);
            end
            if ~isempty(strfind(files(j).name,'nii'))
                system(['mv ',files(j).folder,'/',files(j).name,' ',files(j).folder,'/',site_sub_ses{2},site_sub_ses{3},'_task-rest_bold.nii.gz']);
            end
        end                
    end
    
    if isfolder([sub_p,'/dwi/'])
        files = dir([sub_p,'/dwi/']);
        files(1:2) = [];
        for j = 1:numel(files)
            if ~isempty(strfind(files(j).name,'json')) & isempty(strfind(files(j).name,'dki'))
                system(['mv ',files(j).folder,'/',files(j).name,' ',files(j).folder,'/',site_sub_ses{2},site_sub_ses{3},'_dwi.json']);
            end
            if ~isempty(strfind(files(j).name,'nii')) & isempty(strfind(files(j).name,'dki'))
                system(['mv ',files(j).folder,'/',files(j).name,' ',files(j).folder,'/',site_sub_ses{2},site_sub_ses{3},'_dwi.nii.gz']);
            end
            if ~isempty(strfind(files(j).name,'bval')) & isempty(strfind(files(j).name,'dki'))
                system(['mv ',files(j).folder,'/',files(j).name,' ',files(j).folder,'/',site_sub_ses{2},site_sub_ses{3},'_dwi.bval']);
            end
            if ~isempty(strfind(files(j).name,'bvec')) & isempty(strfind(files(j).name,'dki'))
                system(['mv ',files(j).folder,'/',files(j).name,' ',files(j).folder,'/',site_sub_ses{2},site_sub_ses{3},'_dwi.bvec']);
            end
        end                
    end
    




end
