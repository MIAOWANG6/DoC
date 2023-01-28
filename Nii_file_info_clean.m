%% Nii files cleaning infomation
function all_data = Nii_file_info_clean(input_dir)
%% get all json file
    json_p = dir([input_dir , '\*.json' ]);
    file_p = dir([input_dir, '\*.nii.gz' ]);
    %% T1
    json_index = [];
    date_info = [];
    for t1 = 1:numel(json_p)
        if [(contains(json_p(t1).name, 't1') || contains(json_p(t1).name, 'T1') && contains(json_p(t1).name, '3D'))]
            json_index = [json_index t1];
        end
    end
    if ~isempty(json_index) % if have the data of this modality
        n_date = 1;
        for i=1:length(json_index)           
            [path name ext] = fileparts([json_p(json_index(i)).folder '\' json_p(json_index(i)).name]);
            if ~contains(name,'ASL')
                name_info = strsplit(name,'_');
                for n=1:length(name_info)
                    if str2num(name_info{n})>10000
                        data_index = n;
                    end
                end
                if data_index
                    date_info{n_date,1} = num2str(name_info{data_index});
                    date_info{n_date,2} = name; % save the name of T1 data with max size
                    n_date = n_date+1;
                end
            end
        end
    end
    all_data.T1 = date_info;
    %% T2
    json_index = [];
    date_info = [];
    for t2 = 1:numel(json_p)
        if [(contains(json_p(t2).name, 't2') || contains(json_p(t2).name, 'T2'))]
            json_index = [json_index t2];
        end
    end
    if ~isempty(json_index) % if have the data of this modality
        n_date=1;
        for i=1:length(json_index)           
            [path name ext] = fileparts([json_p(json_index(i)).folder '\' json_p(json_index(i)).name]);
            json_info = loadjson([json_p(json_index(i)).folder '\' json_p(json_index(i)).name]);
            if isfield(json_info,'SpacingBetweenSlices')
                SliceThickness = json_info.SpacingBetweenSlices;
            elseif isfield(json_info,'SliceThickness')
                SliceThickness = json_info.SliceThickness;
            else
                SliceThickness = 0;
            end
            if SliceThickness<3
                if contains(name, 'tse') || contains(name, 'TSE')
                   name_info = strsplit(name,'_');
                    for n=1:length(name_info)
                        if str2num(name_info{n})>10000
                            data_index = n;
                        end
                    end
                    if data_index
                        date_info{n_date,1} = num2str(name_info{data_index});
                        date_info{n_date,2} = name; % save the name of T1 data with max size
                        n_date = n_date+1;
                    end             
                elseif contains(name, 'spc') || contains(name, 'spc')
                    name_info = strsplit(name,'_');
                    for n=1:length(name_info)
                        if str2num(name_info{n})>10000
                            data_index = n;
                        end
                    end
                    if data_index
                        date_info{n_date,1} = num2str(name_info{data_index});
                        date_info{n_date,2} = name; % save the name of T1 data with max size
                        n_date = n_date+1;
                    end
                else
                    name_info = strsplit(name,'_');
                    for n=1:length(name_info)
                        if str2num(name_info{n})>10000
                            data_index = n;
                        end
                    end
                    if data_index
                        date_info{n_date,1} = num2str(name_info{data_index});
                        date_info{n_date,2} = name; % save the name of T1 data with max size
                        n_date = n_date+1;
                    end 
                end
             end
        end
    end
    all_data.T2=date_info;
    %% fMRI
    json_index = [];
    date_info = [];
    for fmri = 1:numel(json_p)
        if contains(json_p(fmri).name, 'bold') || contains(json_p(fmri).name, 'BOLD') || contains(json_p(fmri).name, 'rest') || contains(json_p(fmri).name, 'Rest') && ~contains(json_p(fmri).name, 'MoCo')
            json_index = [json_index fmri];
        end
    end
    if ~isempty(json_index) % if have the data of this modality 
        n_date=1;
        for i=1:length(json_index)           
            [path name ext] = fileparts([json_p(json_index(i)).folder '\' json_p(json_index(i)).name]);     
            name_info = strsplit(name,'_');
            for n=1:length(name_info)
                if str2num(name_info{n})>10000
                    data_index = n;
                end
            end
            if data_index
                date_info{n_date,1} = num2str(name_info{data_index});
                date_info{n_date,2} = name; % save the name of T1 data with max size
                n_date = n_date+1;
            end
        end 
    end
    all_data.rest = date_info;
    %% DTI
    json_index = [];
    date_info = [];
    json_index = find(~cellfun('isempty',strfind({json_p.name},'DTI')));

    for dti = 1:numel(json_p)
        if [(contains(json_p(dti).name, 'DTI') || contains(json_p(dti).name, 'DWI'))]
            json_index = [json_index dti];
        end
    end
    
    if ~isempty(json_index) % if have the data of this modality 
        n_date=1;
        for i=1:length(json_index)           
            [path name ext] = fileparts([json_p(json_index(i)).folder '\' json_p(json_index(i)).name]);
             name_info = strsplit(name,'_');
            for n=1:length(name_info)
                if str2num(name_info{n})>10000
                    data_index = n;
                end
            end
            if data_index
                date_info{n_date,1} = num2str(name_info{data_index});
                date_info{n_date,2} = name; % save the name of T1 data with max size
                n_date = n_date+1;
            end
        end
    end
    all_data.DTI = date_info;
    %% DKI
    json_index = [];
    date_info = [];
    for dki = 1:numel(json_p)
        if [(contains(json_p(dki).name, 'DKI') || contains(json_p(dki).name, 'dki'))]
            json_index = [json_index dki];
        end
    end

    if ~isempty(json_index) % if have the data of this modality 
        n_date=1;
        for i=1:length(json_index)           
            [path name ext] = fileparts([json_p(json_index(i)).folder '\' json_p(json_index(i)).name]);
             name_info = strsplit(name,'_');
            for n=1:length(name_info)
                if str2num(name_info{n})>10000
                    data_index = n;
                end
            end
            if data_index
                date_info{n_date,1} = num2str(name_info{data_index});
                date_info{n_date,2} = name; % save the name of T1 data with max size
                n_date = n_date+1;
            end
        end
    end
    all_data.dki = date_info;
 end
    

