% DCMInfo for one subject
% 存储从DICOM导出的被试信息(性别年龄出生日期)
% for original data site, use DCMInfoOriginData.m
function DCMinfo=DCMInfoforOne(DCM_p)
DCMinfo = struct();
fileList = getAllFiles(DCM_p);
j=1;b={};
tmp = find(~cellfun('isempty',strfind(fileList,'.dcm')));
if ~isempty(tmp)
    dcminfo = dicominfo(fileList{tmp(1)});
    if ~isfield(dcminfo,'PatientAge')
        dcminfo.PatientAge='';
    end
    if ~isfield(dcminfo,'PatientBirthDate')
        dcminfo.PatientBirthDate='';
    end
    DCMinfo.gender = dcminfo.PatientSex;
    DCMinfo.age = [dcminfo.PatientAge,'\',dcminfo.PatientBirthDate];
    DCMinfo.dicomID = dcminfo.PatientID;
elseif ~isempty(find(~cellfun('isempty',strfind(fileList,'IM'))))
    tmp = find(~cellfun('isempty',strfind(fileList,'IM')));
    dcminfo = dicominfo(fileList{tmp(1)});
    DCMinfo.gender = dcminfo.PatientSex;
    if ~isfield(dcminfo,'PatientAge')
        dcminfo.PatientAge='';
    end
    if ~isfield(dcminfo,'PatientBirthDate')
        dcminfo.PatientBirthDate='';
    end
    DCMinfo.age = [dcminfo.PatientAge,'\',dcminfo.PatientBirthDate];
    DCMinfo.dicomID = dcminfo.PatientID;
elseif ~isempty(find(~cellfun('isempty',strfind(fileList,'Save.rar'))))
    tmp = find(~cellfun('isempty',strfind(fileList,'Save.rar')));
    copyfile(fileList{tmp(1)},[tempt_p,'\1.rar']);
    dos(['D:\toolbox\7-Zip\7z x ',[tempt_p,'\1.rar'], ' -o',tempt_p]);
    T1List = getAllFiles(tempt_p);
    tmp = find(~cellfun('isempty',strfind(T1List,'IM')));
    dcminfo = dicominfo(T1List{tmp(1)});
    DCMinfo.gender = dcminfo.PatientSex;
    if ~isfield(dcminfo,'PatientAge')
        dcminfo.PatientAge='';
    end
    if ~isfield(dcminfo,'PatientBirthDate')
        dcminfo.PatientBirthDate='';
    end
    DCMinfo.age = [dcminfo.PatientAge,'\',dcminfo.PatientBirthDate];
    DCMinfo.dicomID = dcminfo.PatientID;
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
        b{j}=[num2str(i),'\',fileList{tmp(1)}]; j=j+1;
        dcminfo = dicominfo(fileList{tmp(1)});
        sub_all(i).gender = dcminfo.PatientSex;
        sub_all(i).age = [dcminfo.PatientAge,'\',dcminfo.PatientBirthDate];
        sub_all(i).dicomID = dcminfo.PatientID;
    end
end
