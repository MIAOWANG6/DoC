subs = importdata('/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/Subs&Patho_for_Gradient.txt');
orig_p = '/GPFS/cuizaixu_lab_permanent/wangmiao/DoC/bids_updated/';
gra_p = '/GPFS/cuizaixu_lab_permanent/wangmiao/Gradient/data/';
for i = 1:numel(subs)
    site_sub_ses = strsplit(subs{i},'/');
    dataorig_p = [orig_p, site_sub_ses{1}, '/', site_sub_ses{2}, '/', site_sub_ses{3},'/'];
    datagra_p = [gra_p, site_sub_ses{1}, '/', site_sub_ses{2}, site_sub_ses{3},'/'];
    csrorig_p = [orig_p,site_sub_ses{1}, '/derivatives/fastcsr/', site_sub_ses{2}, site_sub_ses{3},'/'];
    csrgra_p = [gra_p,site_sub_ses{1}, '/derivatives/fastcsr/', site_sub_ses{2}, site_sub_ses{3}];
    mriqct1orig_p = [orig_p,site_sub_ses{1}, '/derivatives/', site_sub_ses{2}, '_', site_sub_ses{3}, '_T1w.html'];
    mriqct1gra_p = [gra_p,site_sub_ses{1}, '/derivatives/', site_sub_ses{2}, '_', site_sub_ses{3}, '_T1w.html'];
    mriqcforig_p = [orig_p,site_sub_ses{1}, '/derivatives/', site_sub_ses{2}, '_', site_sub_ses{3}, '_bold.html'];
    mriqcfgra_p = [gra_p,site_sub_ses{1}, '/derivatives/', site_sub_ses{2}, '_', site_sub_ses{3}, '_bold.html'];
    qsiorig_p = [orig_p, site_sub_ses{1}, '/derivatives/qsiprep/', site_sub_ses{2}, '/qsiprep'];
    qsigra_p = [gra_p, site_sub_ses{1}, '/derivatives/qsiprep/', site_sub_ses{2}, '/qsiprep'];
    
    cd([gra_p,'/',site_sub_ses{1}]);        
    system(['mkdir ',datagra_p]);
    cd(dataorig_p)
    system(['cp -r ./* ',datagra_p]);
    cd([gra_p,'/',site_sub_ses{1}]);
    if ~isfolder('derivatives')
        mkdir('derivatives');
    end
    cd 'derivatives'
    if ~isfolder('fastcsr')
        mkdir('fastcsr');
    end
    cd 'fastcsr'
    system(['mkdir ',csrgra_p]);
    cd(csrorig_p)
    system(['cp -r ./* ' ,csrgra_p]);
    
    cd([orig_p,site_sub_ses{1},'/derivatives/'])
    system(['cp ',mriqct1orig_p,' ',mriqct1gra_p]);
    system(['cp ',mriqcforig_p,' ',mriqcfgra_p]);
    cd([gra_p, site_sub_ses{1},'/derivatives/'])
    if ~isfolder('qsiprep')
        mkdir('qsiprep');
    end
    cd qsiprep
    mkdir(site_sub_ses{2})
    cd([orig_p, site_sub_ses{1}, '/derivatives/qsiprep/', site_sub_ses{2}]);
    system(['cp -r ',qsiorig_p,' ',qsigra_p]);
end
