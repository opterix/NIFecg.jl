using MultivariateStats, Base.Test, DataFrames, PyPlot, MinMaxFilter
cd("/home/jarb/NI-Fecg/julia_code")

include("process_svs.jl")
include("Notch_Filter_Detrent.jl")
include("MakeICAll.jl")
include("SortICA.jl")
include("Plotting.jl")
include("InterpSignal.jl")

############# SOURCES #######################
filepath="../data/a01.csv"

############ LOAD DATA ######################
#----------- Read and fix data --------------
(t,AECG) = process_svs(filepath)
(n,m) = size(AECG) # m - number of electros, n - sample size


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
seconds=5 #seconds to plot
Plotting(AECG,AECG_white,AECG_sort)


wind=5 # seconds
threshold=0.7
#for i in 1:m
signal = AECG_white[1:5000,1]


# max_value = maximum(signal)
# min_value = minimum(signal)
#
# escale_signal = zeros(1,n)'
# point_temp = zeros(1,n)'
#
# acum=0
# for i in 1:n
# escale_signal[i,1] = (signal[i,1]-min_value)/(max_value-min_value)
# if escale_signal[i,1] <= 0.3
#   acum=acum+1
#   point_temp[acum,1] = i
# end
# end
#
# point = point_temp[1:acum,1]
# #sorting_values=sort(signal,1, rev=true)


A = convert(Array{FloatingPoint}, signal)


minval, maxval = minmax_filter(A, 1) #verbose=false)
maxval=maxval'

matching = A[1:size(maxval)[2]]
matching = matching .== maxval

peaks = maxval[matching]
#peaks = peaks[peaks .>= 0.1 * maximum(peaks)]



#call2 52 # 15 84








#
#
# sampFreq=1000
# n = length(signal)
# p = fft(signal)
#
# nUniquePts = ceil(Int, (n+1)/2)
# p = p[1:nUniquePts]
# p = abs(p)
#
# p = p / n #scale
# p = p.^2  # square it
# # odd nfft excludes Nyquist point
# if n % 2 > 0
#     p[2:length(p)] = p[2:length(p)]*2 # we've got odd number of   points fft
# else
#     p[2: (length(p) -1)] = p[2: (length(p) -1)]*2 # we've got even number of points fft
# end
#
#
# freqArray = (0:(nUniquePts-1)) * (sampFreq / n)
# plot(scatter(;x=freqArray/1000, y=10*log10(p)),
#      Layout(xaxis_title="Frequency (kHz)",
#             xaxis_zeroline=false,
#             xaxis_showline=true,
#             xaxis_mirror=true,
#             yaxis_title="Power (dB)",
#             yaxis_zeroline=false,
#             yaxis_showline=true,
#             yaxis_mirror=true))
#
#
# #end
