using MultivariateStats, Base.Test, DataFrames, PyPlot
cd("/home/jarb/NI-Fecg/julia_code")

include("process_svs.jl")
include("MakeICAll.jl")

############# SOURCES #######################
filepath="../data/a01.csv"
#data = readtable("set-a/set-a-text/a01.csv") # data
#t = linspace(0.0, 60.0, n) # time vector

############ LOAD DATA ######################

#----------- Read and fix data --------------
(t,AECG) = process_svs(filepath)
(n,m) = size(AECG) # n - number of electros, m - sample size


########## SOURCE SEPARATION ################

#----------------- ICA ----------------------
#(AECG_white, AECG_nowhite) = MakeICAIndep(AECG)
k = 4 # number of components
PyPlot.close("all")
(AECG_white) = MakeICAll(AECG)

#----------------- FFT ----------------------
