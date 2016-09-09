workspace()
using MultivariateStats, Base.Test, DataFrames
using PyPlot
cd("/home/jarb/Documents/ExampleJUlia/")

include("ReadData.jl")
include("MakeICAIndep.jl")
include("MakeICAll.jl")

global AECG, AECG_nowhite, AECG_white, t, n, k, m, data

# sources
n = 60000 # numero de muestras
k = 4 # numero de componentes
m = 4 # numero de observacionhanges
data = readtable("set-a/set-a-text/a01.csv") # data

#Initializing
AECG = zeros(n,4)
AECG_nowhite = zeros(n,4)'
AECG_white = zeros(n,4)'
t = linspace(0.0, 60.0, n) # time vector

###########################
(AECG) = ReadData()

##########################
#(AECG_white, AECG_nowhite) = MakeICAIndep(AECG)
(AECG_white, AECG_nowhite) = MakeICAll(AECG)
