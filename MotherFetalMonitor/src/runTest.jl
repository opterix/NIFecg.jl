function sourceSeparationTest(filename,ts,sr)

#------------------------------------ GLOBAL VARIABLES 
initialVar()
global nch,ns,t,fetal_annot,AECG,AECG_clean,motherVar,fetalVar
# ts = 60 # time_signal in seconds
# sr = 1000 # sample rate
ns = ts * sr # number of samples

#------------------------------------------- LOAD DATA
(nch,t,AECG,fetal_annot) = loadData(filename,ns)

#---------------------------------------- PREPROCESING
(AECG_clean) = preProcessing(AECG, sr)

#----------------- MOTHER SUBSTRACTION AND COMPUTATION
(heart_rate_mother,AECGm_ica,SVDrec,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value) = motherSubstraction(AECG_clean,nch,sr,ns,ts)

#------------------ FETAL SUBSTRACTION AND COMPUTATION 
(AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure) = fetalSubstraction(AECG_residual,heart_rate_mother,nch,sr,ts)

#---------- Grouping variables 
(motherVar, fetalVar)=storageVar(AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure)

return nch,ns,t,sr,fetal_annot,AECG,AECG_clean,motherVar,fetalVar


end




