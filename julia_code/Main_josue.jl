############## LIBRARIES ##############
using MultivariateStats, Base.Test, DataFrames, PyPlot, DSP

############# FUNCTIONS ####################
include("process_svs.jl")
include("Notch_Filter_Detrent.jl")
include("MakeICAll.jl")
include("SortICA.jl")
include("Plotting.jl")
include("InterpSignal.jl")
include("QRSm_detector.jl")

############# SOURCES #######################
cd("/home/jarb/NI-Fecg/julia_code")
filepath="../data/a03.csv"


############ LOAD DATA ######################
#----------- Read and fix data --------------
(t,AECG) = process_svs(filepath)
(n,m) = size(AECG) # m - number of electros, n - sample size


############# GLOBAL VARIABLES ################
window_size = 10 #seconds
rate_sample=1000 #Sample rate
num_sample = window_size * rate_sample #number of samples


########### PREPROCESING ####################
#------- Notch Filtering and detrending ------------
(AECG, lowSignal) = notch_filter(AECG);


########## SOURCE SEPARATION ################
#----------------- ICA ----------------------
k = 4 # number of components
(AECG_white) = MakeICAll(AECG)
#------------ Sort ICA results ----------------------
(AECG_sort)=SortICA(AECG_white)
#----------- Resamplig signal -----------------------
#fact=2 # factor to resample the signal
#(t_resmp,AECG_resample) = InterpSignal(AECG_white)
#----------- QRS mother detector -----------------------
(QRSm_pos,QRSm_value)= QRSm_detector(AECG_white)


############### PLOTTING ###################
Plotting()
