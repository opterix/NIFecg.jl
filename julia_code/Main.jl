############## LIBRARIES ##############
@time using MultivariateStats, Base.Test, DataFrames, PyPlot, DSP

############# FUNCTIONS ####################
include("process_svs.jl")
include("Notch_Filter_Detrent.jl")
include("MakeICAll.jl")
include("SortICA.jl")
include("Plotting.jl")
include("InterpSignal.jl")
include("QRSm_detector.jl")
include("MedianFilter.jl")


############# SOURCES #######################
# cd("/Desarrollos/NI-Fecg/julia_code")
filepath="../data/a03.csv"


############# GLOBAL VARIABLES ################
window_size = 60 #seconds
rate_sample=1000 #Sample rate
num_sample = window_size * rate_sample #number of samples


############ LOAD DATA ######################
#----------- Read and fix data --------------
@time (t,AECG) = process_svs(filepath)
#----------- Load data according global varaibles ----
AECG = AECG[1:num_sample,:]
t = t[1:num_sample,:]
(n,m) = size(AECG) # m - number of electros, n - sample size


# ########### PREPROCESING ####################
#------- Notch Filtering and detrending ------------
@time (AECG_fnotch, lowSignal) = notch_filter(AECG)
#----------- Median filter ----------------
window = 2000 # size of window in number of samples
threshold = 30 # mV
#(AECG_clean) = MedianFilter(AECG_fnotch,threshold,window)
AECG_clean = AECG_fnotch

########## SOURCE SEPARATION ################ndims(A)
#----------------- ICA ----------------------
k = m # number of components
@time (AECG_white) = MakeICAll(AECG_clean)

#------------ Sort ICA results ----------------------
#(AECG_sort)=SortICA(AECG_white)
#----------- Resamplig signal -----------------------
#fact=2 # factor to resample the signal
#(t_resmp,AECG_resample) = InterpSignal(AECG_white)
#----------- QRS mother detector -----------------------
@time (QRSm_pos,QRSm_value)= QRSm_detector(AECG_white)
heart_rate_mother = size(QRSm_pos,2)

@time include("Font_Separation_SVD.jl")


############### PLOTTING ###################
Plotting()
