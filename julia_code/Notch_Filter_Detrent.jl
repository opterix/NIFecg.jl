#Pkg.add("DSP");
#Pkg.add("MultivariateStats")
#Pkg.add("PyPlot")

using DSP, MultivariateStats, PyPlot

function notch_filter(x)
x=ecg; #read matrix ecg
Frec_Mues=1000;

plot(ecgtime,signals[:,1]);
title("Pure ECG")

responsetype = Lowpass(3,fs=1000);
prototype=Butterworth(8);

Notch=iirnotch(60,1,fs=1000)
EMG= digitalfilter(responsetype, prototype);
for i=0;i<4;i++
sf= filtfilt (Notch, x [:,i])
plot(ecgtime,sf);
end

#    return ecg, Notch

end


