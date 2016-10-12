############## LIBRARIES ##############
using MultivariateStats, Base.Test, DataFrames, PyPlot, DSP

############# SOURCES #######################
func_path="julia_code/"
data_path="data/"

############# FUNCTIONS ####################
include("$(func_path)process_svs.jl")
include("$(func_path)Notch_Filter_Detrent.jl")
include("$(func_path)MakeICAll.jl")
include("$(func_path)SortICA.jl")
include("$(func_path)Plotting.jl")
include("$(func_path)InterpSignal.jl")
include("$(func_path)QRSm_detector.jl")
include("$(func_path)MedianFilter.jl")

############# DATA BASE ###############
list_file=readdir(data_path)



############# GLOBAL VARIABLES ################
window_size = 60 #seconds
rate_sample=1000 #Sample rate
num_sample = window_size * rate_sample #number of samples


############ LOAD DATA ######################
#----------- Read and fix data --------------
(t,AECG) = process_svs(filepath)
#----------- Load data according global varaibles ----
AECG = AECG[1:num_sample,:]
t = t[1:num_sample,:]
(n,m) = size(AECG) # m - number of electros, n - sample size


# ########### PREPROCESING ####################
# #------- Notch Filtering and detrending ------------
 (AECG_fnotch, lowSignal) = notch_filter(AECG)
 println(size(AECG_fnotch))
# #----------- Median filter ----------------
 #window = 5000 # size of window in number of samples
 #threshold = 30 # mV
#(AECG_clean) = MedianFilter(AECG_fnotch,threshold,window)
AECG_clean=AECG_fnotch


########## SOURCE SEPARATION ################
#----------------- ICA ----------------------
k = m # number of components
(AECG_white) = MakeICAll(AECG_clean)
#----------- QRS mother detector -----------------------
(QRSm_pos,QRSm_value)= QRSm_detector(AECG_white)
heart_rate_mother = size(QRSm_pos,2)


############### PLOTTING ###################
Plotting()
