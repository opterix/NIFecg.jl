using MultivariateStats, Base.Test, DataFrames, PyPlot
cd("/home/jarb/NI-Fecg/julia_code")

include("process_svs.jl")
include("MakeICAll.jl")
include("SortICA.jl")
include("Plotting.jl")


############# SOURCES #######################
filepath="../data/a01.csv"
#data = readtable("set-a/set-a-text/a01.csv") # data
#t = linspace(0.0, 60.0, n) # time vector


############ LOAD DATA ######################
#----------- Read and fix data --------------
(t,AECG) = process_svs(filepath)
(n,m) = size(AECG) # m - number of electros, n - sample size


########## SOURCE SEPARATION ################
#----------------- ICA ----------------------
k = 4 # number of components
(AECG_white) = MakeICAll(AECG)
#----------------- Sort ICA results ----------------------
(AECG_sort)=SortICA(AECG_white)


############### Plotting ###################
Plotting(AECG,AECG_white,AECG_sort)
