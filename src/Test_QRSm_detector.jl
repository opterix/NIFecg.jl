############## LIBRARIES ##############
using MultivariateStats, Base.Test, DataFrames, PyPlot, DSP


############# FUNCTIONS ####################
include("process_svs.jl")
include("Notch_Filter_Detrent.jl")
include("MakeICAll.jl")
include("QRSm_detector.jl")
include("PlotTestQRSmDetector.jl")

############# DATA BASE ###############
data_path="/home/jarb/NI-Fecg/data/"
test_path="/home/jarb/NI-Fecg/test_image/"
list_file=readdir(data_path)
num_files=size(list_file,1)

############# GLOBAL VARIABLES ################
window_size = 60 #seconds
rate_sample=1000 #Sample rate
num_sample = window_size * rate_sample #number of samples
global m,n,k


#---------- Initialize varibles
heart_rate_mother = zeros(num_files)


###########
for i in 1:num_files

file_name = list_file[i]
############ LOAD DATA ######################
#----------- Read and fix data --------------
(t,AECG) = process_svs(joinpath(data_path,file_name))
#----------- Load data according global varaibles ----
AECG = AECG[1:num_sample,:]
t = t[1:num_sample,:]
(n,m) = size(AECG) # m - number of electros, n - sample size


# ########### PREPROCESING ####################
# #------- Notch Filtering and detrending ------------
 (AECG_fnotch, lowSignal) = notch_filter(AECG)
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

#QRSm[i].pos = QRSm_pos
#QRSm[i].value = QRSm_value
heart_rate_mother[i] = size(QRSm_pos,2)

############### PLOTTING ###################
PlotTestQRSmDetector(test_path,file_name,QRSm_pos,QRSm_value,t,AECG_white)
end
