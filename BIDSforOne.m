%% BIDSforOne
% Rearrange transformed nii data to BIDS
% Used for one sub
% For all subjects, please check BIDSforAll.m
%% use when needed
% clear;clc;
% load('F:\DATA\DOC\sub_all.mat');
% sub_dir = 'F:\DATA\DOC\Preprocessed\201608_before_199p\天津武警\';
% bids_dir = 'F:\DATA\DOC\bids_updated\201608_before_199p\';
% sub_name = '天津武警';
%%
function BIDSforOne(sub_dir,bids_dir,sub_all,sub_name)
all_data = Nii_file_info_clean(sub_dir);
sub_index = find(~cellfun('isempty',strfind({sub_all.name},sub_name))); % sub's index in sub_all
sub_id = sub_all(sub_index).id; % sub's id
NiiToBIDS(sub_dir,bids_dir,sub_id,all_data);
