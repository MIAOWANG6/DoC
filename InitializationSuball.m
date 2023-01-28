%% Initialization of sub_all.mat
% sub_all.mat contains structs of every subject
% initialization of sub_all.mat provides a empty struct for a new subject
% add this initialization struct to sub_all.mat and fill the information
initial_datalist=importdata('F:\DATA\DOC\initial_struct.mat');
initial_suball = struct(); 
initial_suball.id = ''; 
initial_suball.name = ''; 
initial_suball.datalist = initial_datalist; 
initial_suball.note = ''; 
initial_suball.etiology_details = '';
initial_suball.gender = '';
initial_suball.age = '';
initial_suball.duration_m = '';
initial_suball.followup_m = '';
initial_suball.std_name = '';
initial_suball.originPath = '';
initial_suball.ifPatient = '';
initial_suball.mriqc_ant1 = '';
initial_suball.mriqc_func = '';
initial_suball.mriqc_ant2 = '';
initial_suball.GOS = '';
initial_suball.diagnosis = '';
initial_suball.CRS_R_auditory = '';
initial_suball.CRS_R_visual = '';
initial_suball.CRS_R_motor = '';
initial_suball.CRS_R_oromotor = '';
initial_suball.CRS_R_communication = '';
initial_suball.CRS_R_arousal = '';
initial_suball.CRS_R_T0 = '';
initial_suball.CRS_R_T1 = '';
initial_suball.dicomPath = '';
initial_suball.dicomID = '';

save( 'F:\DATA\DOC\initial_suball.mat','initial_suball')   
