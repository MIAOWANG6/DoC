%% DcmToNiiforSite
% for a site of subjects data in a site folder
% for single sujects, please check DcmToNiiforOne

%%
addpath('E:\DOC_BS_Stroke\code\guowei_dcm2bids\MRIcron');
addpath('E:\DOC_BS_Stroke\code\guowei_dcm2bids\jsonlab-master');
origin_p = 'E:\DOC_BS_Stroke\NewDataDCM230120\';
result_p = 'E:\DOC_BS_Stroke\NewDataBIDS230120\';
dcm2niix = 'E:\DOC_BS_Stroke\code\guowei_dcm2bids\MRIcron\Resources\dcm2niix.exe';

sub_all = dir([origin_p,'*']);
sub_all(1:2)=[];

for sub=1:numel(sub_all)   
    %% find possible MRI data folder
    % if sub_in folder has other branches besides the one contains DCM data
    % need to go into until reach the folder only has one branch to DCM data
    %% 
    sub_in = [origin_p, sub_all(sub).name];
    sub_out = [result_p, sub_all(sub).name];
    if exist(sub_out)
        delete(sub_out);
        mkdir(sub_out);
    else
        mkdir(sub_out);
    end
    %% dicome to nii
    system([dcm2niix ' -z y -m yes -i y -f %p_%t_%s_%e  -o ' sub_out ' ' sub_in]);

    %% exclude the useless nii files
    file_out = dir([sub_out '\*.json']);
    file_out = {file_out.name};
    exclude_type = {'localizer';'localizer2';'ADC';'FA';'TRACEW';'ColFA'};
    for file = 1:size(file_out,2)
        data = loadjson([sub_out filesep file_out{file}]);
        if isfield(data,'SeriesDescription')
            SeriesDescription = data.SeriesDescription;
            SeriesDescription = strsplit(SeriesDescription,'_');
            [path name ext] = fileparts([sub_out filesep file_out{file}]); 
            disp(SeriesDescription{end});
            if cellfind(exclude_type,SeriesDescription{end})
               delete([path filesep name '.*']);
            end
        else
            strcat('bad data', sub_in)
        end           
    end
    clear file_out
end
