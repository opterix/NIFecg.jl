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
nch=4

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

#------- Normalization  ------------

signal=copy(AECG_fnotch);

for i in 1:nch
    signal[:,i]= (signal[:,i]-mean(signal[:,i]))/maximum(abs(signal[:,i]));
end

#------- Passband Filter > 5Hz-15Hz

responsetypeLP = Lowpass(15,fs=sr);
prototypeLP=Butterworth(4);

responsetypeHP = Highpass(5,fs=sr);
prototypeHP = Butterworth(4);

filtroLP=digitalfilter(responsetypeLP, prototypeLP);
filtroHP=digitalfilter(responsetypeHP, prototypeHP);

signal=filtfilt(filtroLP, signal);
signal=filtfilt(filtroHP, signal);

#------- Derivative Filter

#B=vcat(ones(nu,1), zeros(nz,1), -1*ones(nu,1))
#delay=convert(Int64, floor(length(B)/2));
B=[-1, -2, 0 , 2, 1]/8;
salida=conv(signal[:,1],B);
salida=salida[3:end-2];
salida= salida/maximum(abs(salida));
salida=salida.^2;

