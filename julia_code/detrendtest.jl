
ECGfiles="/home/users/daedro/materno_Info/set-a-text";

#Pkg.add("DSP");
#Pkg.add("MultivariateStats")
#Pkg.add("PyPlot")

using DSP, MultivariateStats, PyPlot

csvdata=readcsv(string(ECGfiles, "/a23.csv"));
ecgtime = csvdata[3:end,1];
signals = csvdata[3:end,2:end];

responsetype = Lowpass(3, fs=1000);
prototype=Butterworth(8);

detrend_filter= digitalfilter(responsetype, prototype);

sf=filtfilt(detrend_filter, signals[:,1])

plot(ecgtime, signals[:,1])
savefig("salida.png")

plot(ecgtime, sf);
savefig("filtered.png")

clf()

plot(ecgtime, signals[:,1]-sf);
savefig("detrended.png")