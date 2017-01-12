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
include("Plotting.jl")

############# SOURCES #######################
filename="a03"

############# GLOBAL VARIABLES ################
window_size = 60 #seconds
sr=1000 #Sample rate
ns = window_size * sr #number of samples

############ LOAD DATA ######################
#----------- Read and fix data --------------
(t,AECG) = process_svs(filename)
fetal_annot = process_txt(filename,ns)

#----------- Load data according global varaibles ----
AECG = AECG[1:ns,:]
t = t[1:ns,:]
nch = size(AECG,2) # nch - number of channels


# ########### PREPROCESING ####################
#------- Notch Filtering and detrending ------------

(AECG_fnotch, lowSignal) = notch_filter(AECG, sr)

#------- Low Pass Filter ------------
















