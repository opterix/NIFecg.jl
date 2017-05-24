#------------------------------------------- LIBRARIES 
using MultivariateStats, Base.Test, DataFrames, PyPlot, DSP, Distances

#------------------------------------------- MODULES 
include("loadDataModule.jl")
include("preProcessingModule.jl")
include("motherSubstractionModule.jl")
include("fetalSubstractionModule.jl")
include("storageVarModule.jl")
include("plotModule.jl")

function sourceSeparationECG(filename)

#------------------------------------ GLOBAL VARIABLES 
ts = 60 # time_signal in seconds
sr = 1000 # sample rate
ns = ts * sr # number of samples

#------------------------------------------- LOAD DATA
(nch,t,AECG,fetal_annot) = loadDataModule(filename,ns)

#---------------------------------------- PREPROCESING
(AECG_clean) = preProcessingModule(AECG, sr)

#----------------- MOTHER SUBSTRACTION AND COMPUTATION
(heart_rate_mother,AECGm_ica,SVDrec,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value) = motherSubstractionModule(AECG_clean,nch,sr,ns,ts)


#------------------ FETAL SUBSTRACTION AND COMPUTATION 
(AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure) = fetalSubstractionModule(AECG_residual,heart_rate_mother,nch,sr,ts)

#------------------ Grouping variables 
(motherVar, fetalVar)=storageVarModule(AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure)


return nch,ns,t,sr,fetal_annot,AECG,AECG_clean,motherVar,fetalVar


end




