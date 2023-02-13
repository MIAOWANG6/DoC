library(bruceR)
library(patchwork)
setwd('C:/Users/wangmiao/Downloads')
trks_data<-import('trks230207.csv')
clinic_data<-import('clinic230206.xlsx')
bs_data<-import('bs230207.xlsx')
trk_mask<-import('trksmask_vol.xlsx')
merge_data<-trks_data %>% inner_join(clinic_data,by='subid') %>% inner_join(bs_data,by='subid') %>% inner_join(trk_mask,by='trk_name')

ggplot(merge_data,aes(x=reorder(trk_name,fa),y=fa,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+
  stat_summary(geom='errorbar',fun.data=mean_cl_boot)+theme_classic()
ggplot(merge_data,aes(x=reorder(trk_name,count/trk_mask_vol),y=count/trk_mask_vol,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+
  stat_summary(geom='errorbar',fun.data=mean_cl_boot)+theme_classic()
ggplot(merge_data,aes(x=reorder(trk_name,median),y=median,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+
  stat_summary(geom='errorbar',fun.data=mean_cl_boot)+theme_classic()
ggplot(merge_data,aes(x=reorder(trk_name,volume/trk_mask_vol),y=volume/trk_mask_vol,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+
  stat_summary(geom='errorbar',fun.data=mean_cl_boot)+theme_classic()

ggplot(merge_data,aes(x=reorder(trk_name,Lesion_volume.x/trk_mask_vol),y=Lesion_volume.x/trk_mask_vol,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+
  stat_summary(geom='errorbar',fun.data=mean_cl_boot)+theme_classic()

merge_data[,20:25] <- as.numeric(as.matrix(merge_data[,20:25]))

for(tract in unique(merge_data$trk_name)){
  merge_data %>% filter(trk_name==tract) %>% dplyr:: select(fa,count,Lesion_volume.x,volume,median,std,`CRS-R1`,GOS,trk_mask_vol,c(20:25)) %>%
    mutate(count_reg=count/trk_mask_vol,Lesion_volume_reg=Lesion_volume.x/trk_mask_vol,volume_reg=volume/trk_mask_vol) %>% select(fa,count_reg,Lesion_volume_reg,volume_reg,median,std,`CRS-R1`,GOS,13:18,trk_mask_vol)%>% na.omit()%>%
    Corr(method = "spearman",p.adjust = "BH",plot.file = paste0(tract,'corr.png'))
}
all_data <- data.frame()
for(tract in unique(merge_data$trk_name)){
  merge_data %>% filter(trk_name==tract) %>% dplyr:: select(fa,volume,`CRS-R1`,GOS,trk_mask_vol) %>%
    mutate(volume_reg=volume/trk_mask_vol) %>% select(fa,volume_reg,`CRS-R1`,GOS) ->tmp_data
    p<-cor.test(tmp_data$volume_reg,as.numeric(tmp_data$`CRS-R1`))
    vol_CRS <- p$estimate
    p<-cor.test(tmp_data$fa,as.numeric(tmp_data$`CRS-R1`))
    fa_CRS <- p$estimate
    p<-cor.test(tmp_data$volume_reg,as.numeric(tmp_data$GOS))
    vol_GOS <- p$estimate
    p<-cor.test(tmp_data$fa,as.numeric(tmp_data$GOS))
    fa_GOS <- p$estimate
    new_data <- data.frame(vol_CRS,fa_CRS,vol_GOS,fa_GOS,trk_name=tract)
    all_data <- rbind(all_data,new_data)
}

ggplot(all_data,aes(x=reorder(trk_name,vol_CRS),y=vol_CRS,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+theme_classic()

ggplot(all_data,aes(x=reorder(trk_name,fa_CRS),y=fa_CRS,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+theme_classic()

ggplot(all_data,aes(x=reorder(trk_name,vol_GOS),y=vol_GOS,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+theme_classic()

ggplot(all_data,aes(x=reorder(trk_name,fa_GOS),y=fa_GOS,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+theme_classic()


all_data_diff <- data.frame()
for(tract in unique(merge_data$trk_name)){
  merge_data %>% filter(trk_name==tract) %>% dplyr:: select('诊断',fa,volume,`CRS-R1`,GOS,trk_mask_vol) %>%
    mutate(volume_reg=volume/trk_mask_vol) %>% select('诊断',fa,volume_reg,`CRS-R1`,GOS) ->tmp_data
    p<-t.test(tmp_data$volume_reg~tmp_data$'诊断')
    vol_diff <- p$p.value
    p<-t.test(tmp_data$fa~tmp_data$'诊断')
    fa_diff <- p$p.value
    new_data <- data.frame(vol_diff,fa_diff,trk_name=tract)
    all_data_diff <- rbind(all_data_diff,new_data)
}

ggplot(all_data_diff,aes(x=reorder(trk_name,vol_diff),y=vol_diff,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+theme_classic()+geom_hline(yintercept = 0.05)

ggplot(all_data_diff,aes(x=reorder(trk_name,fa_diff),y=fa_diff,color=trk_name,fill=trk_name))+stat_summary(geom='col',fun=mean)+theme_classic()+geom_hline(yintercept = 0.05)
