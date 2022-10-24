
% set path of data
site_dir = '/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/201608_after_75p';
sub_site = dir([site_dir, '/sub-*' ]);
for sub = 4:numel(sub_site)
    sub_name = sub_site(sub).name;
    ses_sub = dir([sub_site(sub).folder '/' sub_site(sub).name '/' 'ses-*']);
    for ses = 1:numel(ses_sub)
        cd /GPFS/cuizaixu_lab_permanent/wangmiao/DoC/DoCMatlab_code/
        ses_name = ses_sub(ses).name;
        system(['sbatch -e ',sub_name,ses_name,'.error -o ',sub_name,ses_name,'.out freesurfer.sh ',...
            sub_name,' ',ses_name]);             
    end     
end

