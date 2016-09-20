#Pkg.add("DSP");
#Pkg.add("MultivariateStats")
#Pkg.add("PyPlot")

using DSP, MultivariateStats, PyPlot

function notch_filter(x)
    #x=ecg; #read matrix ecg
    Frec_Mues=1000;
    time=60
    #plot(ecgtime,signals[:,1]);
    nmuestras=time*Frec_Mues
    
    #title("Pure ECG")

    responsetype = Lowpass(3,fs=Frec_Mues);
    prototype=Butterworth(8);
    Notch=iirnotch(60,1,fs=Frec_Mues)
    detrend_filter= digitalfilter(responsetype, prototype);

    #sf=Array{Float64}(nmuestras, 4)

    #detrending -> No hay necesidad de hacerlo por canal, se puede pasar directamente la matriz a filtfilt
    #for i=1;i<5;i++
    #    sf = filtfilt(detrend_filter, x[:,1])
        #plot(ecgtime,sf);
    #end

    lowSignal=filtfilt(detrend_filter, x)
    sf= x - lowSignal

    sf = filtfilt(Notch, sf)

    #notchfiltering-> Tampoco hay necesidad de hacer el notch por canal
    #for i=1;i<5;i++
    #    sf = filtfilt(Notch, x[:,i])
        #plot(ecgtime,sf);
    #end
    return sf, lowSignal

end
