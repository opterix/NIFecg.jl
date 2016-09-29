using MultivariateStats, Base.Test, DataFrames, PyPlot, Multirate
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
# N=9;
#
# srand(0);
#  #a = @data([1.5, NA, NA, NA, NA, NA, 10.5]);
#  a = ([1.5, 3, 6, 10.5]);
#   b = linspace(1, 100, 10);
# f=rand(N);
# t = linspace(0.0, 1, N) # time vector
#
#
# ########### BSPLINE ############################
#
# x = interpolate(b,BSpline(Linear()), OnGrid())
# B=zeros(length(b)*2)
# for i in 0:length(b)-1
#   tmpidxs = i+1.5
#   B[i*2+1] = b[i+1]
#   B[i*2+2] = x[tmpidxs]
# end
#
# v1 = x[0.6]
# v2 = x[3.6]
#
# ########## FOURIER ###########################3
#
# # compute FFT (the factor of N is just a normalization)
# tildef=fft(f)/N;
#
# # define the trigonometric interpolant defined by the equation above
# Sum=0.0 + 0.0im;
# for nu=0:N-1
# Sum+=tildef[nu+1]*exp(2*pi*im*nu*t/N);
# end
# Sum
# println(Sum)
#
# recover=real(ifft(Sum))
#  #####################
#

#  a = @data([1.5, NA, NA, NA, NA, NA, 10.5]);
#  b=collect(linspace(a[1],a[end],sum(isna(a))))
#
# idxs = find(~isna(a))
# for i in 1:length(idxs)-1
#   tmpidxs = idxs[i]:idxs[i+1]
#   a[idxs[i]+1:idxs[i+1]-1] = linspace(a[idxs[i]],a[idxs[i+1]],length(tmpidxs))[2:end-1]
# end


###############################################################33
Fe = 1000; #Sample rate
Te = 1/Fe;
Nech = 1000; #number of samples
j =0 + 1im

time = ([0:Te:(Nech-1)*Te]);
timeDiscrete = ([0:1:Nech-1]')';
frequency = (timeDiscrete/Nech)*Fe;

signal = AECG_white[1:Nech,1]#linspace(1, 100, Nech);
spectrum =  signal*exp(-2*pi*j*timeDiscrete'*timeDiscrete/Nech);
fspec = [0:Nech-1]*Fe/Nech;
reconstruction = spectrum*exp(2*pi*j*timeDiscrete'*timeDiscrete/Nech)/Nech;

figure(4)
subplot(311)
title("Signal")
plot(time,signal)
subplot(312)
plot(time,real(reconstruction),color="red")

# **** interpolation ****

Finterp = 2*Fe;
Tinterp = 1/Finterp;
TimeInterp = [0:Tinterp:(Nech-1)*Te];
NechInterp = length(TimeInterp);
TimeInterpDiscrete = ([0:NechInterp-1]')';

#Compute original signal value without any interpolation
#signalResampled = cos(2*pi*F1*(TimeInterp))+cos(2*pi*F2*(TimeInterp))+cos(2*pi*FMax*(TimeInterp));

#Compute original signal interpolation by padding the fft and performing inverse fft on the result
Nz = NechInterp-Nech;
p1=zeros(1,convert(Int64,floor(Nz/2)))
p2=fftshift(spectrum)
p3=zeros(1,convert(Int64,floor(Nz/2))+rem(Nz,2))

padded_spectrum0 = ifftshift([p1 p2' p3]);
fspecPadded = [0:NechInterp-1]*Finterp/NechInterp;

padded_reconstruction = padded_spectrum0*exp(2*pi*j*TimeInterpDiscrete*TimeInterpDiscrete'/NechInterp)/(1*Nech);
#spectrumresampled = signalResampled*exp(-2*pi*j*TimeInterpDiscrete'*TimeInterpDiscrete/NechInterp);
#fresampled = [0:NechInterp-1]*Fe/NechInterp;
subplot(313)
plot(time,real(reconstruction),color="black")
