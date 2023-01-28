%% DcmToNiiforOne
% for single subject data
% for more sujects, please check DcmToNiiforSite
%%
function DcmToNiiforOne(origin_p,result_p)
    addpath('E:\DOC_BS_Stroke\code\guowei_dcm2bids\MRIcron');
    addpath('E:\DOC_BS_Stroke\code\guowei_dcm2bids\jsonlab-master');
    %origin_p = 'C:\Users\wangmiao\Desktop\QuickMoney\LIANG_YU_YI_SUB1_20220810001\VSPH_CHEN_RUN_SEN_20220810_101057_396000\';
    %result_p = 'C:\Users\wangmiao\Desktop\QuickMoney\LIANG_YU_YI_SUB1_20220810001\';
    dcm2niix = 'E:\DOC_BS_Stroke\code\guowei_dcm2bids\MRIcron\Resources\dcm2niix.exe';

    if exist(result_p)
        h=questdlg(['Are you sure to delete folder ',result_p,'?'] ,'Warning','yes','no','cancel');
        if strcmp(h,'yes')
            delete(result_p);
            mkdir(result_p);
        else
            error('stop running')
        end
    else
        mkdir(result_p);
    end

    system([dcm2niix ' -z y -m yes -i y -f %p_%t_%s_%e  -o ' result_p ' ' origin_p]);
