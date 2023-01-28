%% Initialization of sub_all.datalist
% datalist is a struct in a subject struct, it records all data batch and all modelity of a subject
% initial_struct is for one folder of data within same batch of a subject
% initial_cell is for one modality of the folder in processing of a subject
initial_struct = struct(); % struct for recording data info of per sub per batch, included in datalist(*)
initial_struct.date = num2str(0,'%08d'); % 20******
initial_struct.batchInfo = {''}; % batch info including machine type, scaning location,
initial_struct.BIDS = '.'; % path for BIDS files after arrangement
initial_struct.data = struct(); % dastuct recording data types
initial_struct.valid = true;

% for 5 specific modalities: T1, T2, DTI, fMRI, ASL
% each modality has six information:
% 'path', save the folder path of BIDS data files or path of non-BIDS data,depending on have done or not done BIDS transform
% 'valibility', true or false, show if the data is validate for next processing
% 'process stage', show the last step or the ongoing step in processing this data
% 'processed', a string cell show all steps has done with the data
% 'json', show the path of json file of the data, if empty, the valibility must be set as false
% 'note', record anything in addition to this data
initial_cell=[{'path',''};{'validity',false};{'process state',''};{'processed',{''}};{'json',''};{'note',''}];
initial_struct.data.T1 = initial_cell;
initial_struct.data.T2 = initial_cell;
initial_struct.data.fMRI = initial_cell;
initial_struct.data.DTI = initial_cell;
initial_struct.data.ASL = initial_cell;

save( 'F:\DATA\DOC\initial_struct.mat','initial_struct')   
