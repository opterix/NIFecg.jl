############## LIBRARIES ##############
using MultivariateStats, Base.Test, DataFrames, PyPlot, DSP

############# FUNCTIONS ####################
include("process_svs.jl")
include("process_txt.jl")
include("Notch_Filter_Detrent.jl")
include("MakeICAll.jl")
include("SortICA.jl")
include("InterpSignal.jl")
include("QRSm_detector.jl")
include("QRSf_detector.jl")
include("QRSf_selector.jl")
include("MedianFilter.jl")
include("Font_Separation_SVD.jl")
include("MakeICAfeto.jl")
include("PlottingTest.jl")

############# GLOBAL VARIABLES ################
window_size = 10 #seconds
rate_sample=1000 #Sample rate
num_sample = window_size * rate_sample #number of samples

for num_signal=21:25
println(num_signal)
############# SOURCES #######################
files=readdir("../data/")
filename=files[num_signal];

############ LOAD DATA ######################
#----------- Read and fix data --------------
(t,AECG) = process_svs(filename[1:end-4])
(fetal_annot) = process_txt(filename[1:end-4])

#----------- Load data according global varaibles ----
AECG = AECG[1:num_sample,:]
t = t[1:num_sample,:]
(n,m) = size(AECG) # m - number of electros, n - sample size


# ########### PREPROCESING ####################
#------- Notch Filtering and detrending ------------
@time (AECG_fnotch, lowSignal) = notch_filter(AECG, rate_sample)
#----------- Median filter ----------------
window = 2000 # size of window in number of samples
threshold = 30 # mV
#(AECG_clean) = MedianFilter(AECG_fnotch,threshold,window)
AECG_clean = AECG_fnotch

########## SOURCE SEPARATION ################
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
heart_rate_mother = (60*size(QRSm_pos,1))/window_size
#------- SVD process and subtract mother signal---------
@time (SVDrec,AECGm) = Font_Separation_SVD(AECG_clean, QRSm_pos, rate_sample);
AECGf = MakeICAfeto(AECGm)
AECGf2 = QRSf_selector(AECGf)
@time (QRSf_pos,QRSf_value)= QRSf_detector(AECGf)
heart_rate_feto = (60*size(QRSf_pos,1))/window_size

PlottingTest([2 5 6])
end
