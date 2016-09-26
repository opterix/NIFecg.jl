using MultivariateStats, Base.Test, DataFrames, PyPlot
cd("/home/jarb/NI-Fecg/julia_code")

include("process_svs.jl")
include("Notch_Filter_Detrent.jl")
include("MakeICAll.jl")
include("SortICA.jl")
include("Plotting.jl")


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


############### PLOTTING ###################
seconds=5 #seconds to plot
Plotting(AECG,AECG_white,AECG_sort)
