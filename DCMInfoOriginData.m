% DCMInfo for origin data in F:\DATA\DOC\Origin data from YiYang\MR3\核磁数据\
% 存储从DICOM导出的被试信息(性别年龄出生日期)
sub_all = importdata('F:\DATA\DOC\sub_all_updated.mat');
%%
site_p = 'F:\DATA\DOC\Origin data from YiYang\MR3\核磁数据\核磁数据_北大国际';
subs = dir(site_p);
subs(1:2) = [];
tempt_p = 'F:\DATA\test';
j=1;b={};
for i = 474:474
    sub_name = sub_all(i).name;
    index = find(~cellfun('isempty',strfind({subs.name},sub_name)));
    if ~isempty(index)
        dicom_p = [subs(index).folder,'\',subs(index).name];
        sub_all(i).dicomPath = dicom_p;
        fileList = getAllFiles(dicom_p);
        tmp = find(~cellfun('isempty',strfind(fileList,'IM0')));
        if ~isempty(tmp)
            dcminfo = dicominfo(fileList{tmp(1)});
            sub_all(i).gender = dcminfo.PatientSex;
            sub_all(i).age = [dcminfo.PatientAge,'\',dcminfo.PatientBirthDate];
            sub_all(i).dicomID = dcminfo.PatientID;
        elseif ~isempty(find(~cellfun('isempty',strfind(fileList,'IM'))))
            tmp = find(~cellfun('isempty',strfind(fileList,'IM')));
            dcminfo = dicominfo(fileList{tmp(1)});
            sub_all(i).gender = dcminfo.PatientSex;
            if ~isfield(dcminfo,'PatientAge')
                dcminfo.PatientAge='';
            end
            if ~isfield(dcminfo,'PatientBirthDate')
                dcminfo.PatientBirthDate='';
            end
            sub_all(i).age = [dcminfo.PatientAge,'\',dcminfo.PatientBirthDate];
            sub_all(i).dicomID = dcminfo.PatientID;
        elseif ~isempty(find(~cellfun('isempty',strfind(fileList,'Save.rar'))))
            tmp = find(~cellfun('isempty',strfind(fileList,'Save.rar')));
            copyfile(fileList{tmp(1)},[tempt_p,'\1.rar']);
            dos(['D:\toolbox\7-Zip\7z x ',[tempt_p,'\1.rar'], ' -o',tempt_p]);
            T1List = getAllFiles(tempt_p);
            tmp = find(~cellfun('isempty',strfind(T1List,'IM')));
            dcminfo = dicominfo(T1List{tmp(1)});
            sub_all(i).gender = dcminfo.PatientSex;
            if ~isfield(dcminfo,'PatientAge')
                dcminfo.PatientAge='';
            end
            if ~isfield(dcminfo,'PatientBirthDate')
                dcminfo.PatientBirthDate='';
            end
            sub_all(i).age = [dcminfo.PatientAge,'\',dcminfo.PatientBirthDate];
            sub_all(i).dicomID = dcminfo.PatientID;
            rmdir('F:\DATA\test','s');
            mkdir('F:\DATA\test');
        else
            tmp = find(cellfun('isempty',strfind(fileList,'.nii'))...
                & cellfun('isempty',strfind(fileList,'DIR'))...
                & cellfun('isempty',strfind(fileList,'inf'))...
                & cellfun('isempty',strfind(fileList,'exe'))...
                & cellfun('isempty',strfind(fileList,'info'))...
                & cellfun('isempty',strfind(fileList,'bval'))...
                & cellfun('isempty',strfind(fileList,'bvec')));
            if ~isempty(tmp)
                b{j}=[num2str(i),'\',fileList{tmp(1)}];j=j+1;
                dcminfo = dicominfo(fileList{tmp(1)});
                sub_all(i).gender = dcminfo.PatientSex;
                sub_all(i).age = [dcminfo.PatientAge,'\',dcminfo.PatientBirthDate];
                sub_all(i).dicomID = dcminfo.PatientID;
            end
        end
    else
        sub_name
    end


end
save('F:\DATA\DOC\sub_all_updated.mat','sub_all');
