
library(bruceR)
library(patchwork)
setwd('E:/DOC_BS_Stroke/BSStats/')
metrics<-import('230111.xlsx')
metrics %>% filter(Lesion_inBS_volume>20&Lesion_inBS_volume<10000) -> metrics_fil
ggplot(data=metrics_fil,aes(x=mean))+geom_histogram(bins=10)+ggtitle('追踪纤维平均长度分布图')+theme_classic()+scale_y_continuous(expand=c(0,0))->pc1
ggplot(data=metrics_fil,aes(x=Lesion_inBS_volume))+geom_histogram(bins=10)+ggtitle('病灶大小分布图')+theme_classic()+scale_y_continuous(expand=c(0,0))->pc2
ggplot(data=metrics_fil,aes(x=count))+geom_histogram(bins=10)+ggtitle('追踪纤维数量分布图')+theme_classic()+scale_y_continuous(expand=c(0,0)) -> pc3
pc1+pc2+pc3

cor.test(metrics_fil$Lesion_inBS_volume,metrics_fil$mean)
cor.test(metrics_fil$Lesion_inBS_volume,metrics_fil$count)
cor.test(metrics$FA_LS,metrics$count)
metrics %>% select(median,min,count,Lesion_inBS_volume,FA_LS,MD_LS) %>% Corr(plot.file = "sub19_6m_corr.png")

