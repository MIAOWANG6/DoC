 %% NiiToBIDS FOR SINGLE SUBJECT

function NiiToBIDS(input_dir,output_dir,sub_id,all_data_info)

%% convert name to bids style
    json_p = dir([input_dir , '\*.json' ]);
    file_p = dir([input_dir, '\*.nii.gz' ]);
    data_out_p = [output_dir '\sub-' sub_id]; % bids files output path for a sub
    if isfolder(data_out_p)
        rmdir(data_out_p, 's');
        mkdir(data_out_p)
    else
        mkdir(data_out_p)
    end
    %% T1
    if ~isempty(all_data_info.T1)
        for n_run = 1:size(all_data_info.T1,1)
            file_p = dir([input_dir filesep all_data_info.T1{n_run,2} '.nii.gz']);
            file_size = file_p.bytes; 
            % save bids file     
            if file_size > 1000000 % 10 MB
                ses_info = ['ses-' all_data_info.T1{n_run,1}];
                fileout = [data_out_p filesep ses_info '\anat'];
                mkdir(fileout)
                final_json_name = all_data_info.T1{n_run,2};
                copyfile([json_p(1).folder '\' final_json_name '.nii.gz'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_T1w.nii.gz']);
                copyfile([json_p(1).folder '\' final_json_name '.json'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_T1w.json']);
            end
        end
    end
    %% T2
     if ~isempty(all_data_info.T2)
        for n_run = 1:size(all_data_info.T2,1)
            file_p = dir([input_dir filesep all_data_info.T2{n_run,2} '.nii.gz']);
            file_size = file_p.bytes; 
            % save bids file     
            if file_size > 1000000 % 10 MB
                ses_info = ['ses-' all_data_info.T2{n_run,1}];
                fileout = [data_out_p filesep ses_info '\anat'];
                final_json_name = all_data_info.T2{n_run,2};
                mkdir(fileout)
                copyfile([json_p(1).folder '\' final_json_name '.nii.gz'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_T2w.nii.gz']);
                copyfile([json_p(1).folder '\' final_json_name '.json'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_T2w.json']);
            end
        end
     end
    %% fMRI
  if ~isempty(all_data_info.rest)
        for n_run = 1:size(all_data_info.rest,1)
            file_p = dir([input_dir filesep all_data_info.rest{n_run,2} '.nii.gz']);
            file_size = file_p.bytes; 
            % save bids file     
            if file_size > 1000000 % 10 MB
                ses_info = ['ses-' all_data_info.rest{n_run,1}];
                fileout = [data_out_p filesep ses_info '\func'];
                final_json_name = all_data_info.rest{n_run,2};
                mkdir(fileout)
                copyfile([json_p(1).folder '\' final_json_name '.nii.gz'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_bold.nii.gz']);
                copyfile([json_p(1).folder '\' final_json_name '.json'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_bold.json']);
            end
        end
  end
    
    %% DTI
 if ~isempty(all_data_info.DTI)
        for n_run = 1:size(all_data_info.DTI,1)
            file_p = dir([input_dir filesep all_data_info.DTI{n_run,2} '.nii.gz']);
            file_size = file_p.bytes; 
            % save bids file     
            if file_size > 1000000 % 10 MB
                ses_info = ['ses-' all_data_info.DTI{n_run,1}];
                fileout = [data_out_p filesep ses_info '\dwi'];
                final_json_name = all_data_info.DTI{n_run,2};
                mkdir(fileout)
                copyfile([json_p(1).folder '\' final_json_name '.nii.gz'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_dwi.nii.gz']);
                copyfile([json_p(1).folder '\' final_json_name '.json'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_dwi.json']);
                copyfile([json_p(1).folder '\' final_json_name '.bval'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_dwi.bval']);
                copyfile([json_p(1).folder '\' final_json_name '.bvec'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_dwi.bvec']);
            end
        end
  end
    
    %% DKI
   if ~isempty(all_data_info.dki)
        for n_run = 1:size(all_data_info.dki,1)
            file_p = dir([input_dir filesep all_data_info.dki{n_run,2} '.nii.gz']);
            file_size = file_p.bytes; 
            % save bids file     
            if file_size > 1000000 % 10 MB
                ses_info = ['ses-' all_data_info.dki{n_run,1}];
                fileout = [data_out_p filesep ses_info '\dwi'];
                final_json_name = all_data_info.dki{n_run,2};
                mkdir(fileout)
                copyfile([json_p(1).folder '\' final_json_name '.nii.gz'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_run-dki_dwi.nii.gz']);
                copyfile([json_p(1).folder '\' final_json_name '.json'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_run-dki_dwi.json']);
                copyfile([json_p(1).folder '\' final_json_name '.bval'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_run-dki_dwi.bval']);
                copyfile([json_p(1).folder '\' final_json_name '.bvec'],[fileout '\' 'sub-',sub_id,'_',ses_info,'_run-dki_dwi.bvec']);
            end
        end
  end
    
    
    %% ASL
 end
