ECGfiles="/home/javier/Desarrollos/NI-Fecg";

#Pkg.add("DSP");
       #Pkg.add("MultivariateStats")
       #Pkg.add("PyPlot")

#close("all");

Frec_Mues=1000;
using DSP, MultivariateStats, PyPlot
csvdata=readcsv(string(ECGfiles, "/a03.csv"));
ecgtime = csvdata[3:end,1];
signals = csvdata[3:end,2:end];


plot(ecgtime,signals[:,1]);
title("Pure ECG")

responsetype = Lowpass(3,fs=1000);
prototype=Butterworth(8);

Notch=iirnotch(60,1,fs=1000)
EMG= digitalfilter(responsetype, prototype);
sf= filtfilt (Notch, signals [:,1])
plot(ecgtime,sf);
w=0:0.01:pi;
H=freqz(Notch,w);
figure()
plot(Frec_Mues/2*w/pi,20*log10(abs(H)));
title("ECG Filtered")


