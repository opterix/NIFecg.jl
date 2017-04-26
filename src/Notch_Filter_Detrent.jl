function notch_filter(x, rate_sample)
    #x=ecg; #read matrix ecg

    #time=60
    #plot(ecgtime,signals[:,1]);
    #nmuestras=time*rate_sample

    #title("Pure ECG")
    frec_Notch=60;
    frec_Notch2=50

    responsetype = Lowpass(5,fs=rate_sample);
    prototype=Butterworth(4);

    Notch=iirnotch(frec_Notch,1,fs=rate_sample)
    Notch2=iirnotch(frec_Notch*2,1,fs=rate_sample)
    Notch3=iirnotch(frec_Notch*3,1,fs=rate_sample)
    Notch4=iirnotch(frec_Notch2,1,fs=rate_sample)
    Notch5=iirnotch(frec_Notch2*2,1,fs=rate_sample)

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
    sf = filtfilt(Notch2, sf)
    sf = filtfilt(Notch3, sf)
    sf = filtfilt(Notch4, sf)
    sf = filtfilt(Notch5, sf)

    #notchfiltering-> Tampoco hay necesidad de hacer el notch por canal
    #for i=1;i<5;i++
    #    sf = filtfilt(Notch, x[:,i])
        #plot(ecgtime,sf);
    #end
    return sf, lowSignal

end
