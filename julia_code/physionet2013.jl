
ECGfiles="/home/users/daedro/materno_Info/set-a-text";

#Pkg.add("DSP");
#Pkg.add("MultivariateStats")
#Pkg.add("PyPlot")

using DSP, MultivariateStats, PyPlot

csvdata=readcsv(string(ECGfiles, "/a23.csv"));
ecgtime = csvdata[3:end,1];
signals = csvdata[3:end,2:end];

fsamp=1000;

responsetype = Lowpass(3.5, fs=fsamp);
prototype=Butterworth(8);
detrend_filter= digitalfilter(responsetype, prototype);


#--Artifact canceling--
#X=ArtifCanceling(ECG, fsamp)

#--Detrending signal


#--Notch filtering

#--maternalICA

#--signalInterpolation

#--channelSelection and mother QRS

#--mother QRS cancelling

#--fetalICA

#--channelSelection and fetal QRS



