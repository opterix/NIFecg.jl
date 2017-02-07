function QRSf_selector(signal_feto,nch)

	for i in 1:nch
            signal_feto[:,i]= (signal_feto[:,i]-mean(signal_feto[:,i]))/maximum(abs(signal_feto[:,i]));
	end

    out_aux = fft(signal_feto,1);
    out = abs(fftshift(out_aux,1))./sum(abs(fftshift(out_aux,1)));

    Efft= abs(out_aux).^2;

    #lfrec=40*size(fft,1)/1000;

    #Etotal40=Efft[1:lfrec];

    #Seedw=collect(0.4:0.1:4);

    #for seedw in 0.4:0.1:4
    #    Q
    #end


##Método por maximos vs promedio-No funciona
#    maximos = maximum(out,1);
#    avAbsPower = mean(out,1);
#    quality = maximos./avAbsPower;
#    idx = sortperm(vec(quality), rev=true);

##Método por entropia:

    entr_m=zeros(size(signal_feto,2))

    for i in 1:nch
        entr_m[i]=entropy(out[:,i]);
    end
    idx=sortperm(entr_m,rev=false);
    sorted_feto = signal_feto[:,idx];

    return sorted_feto;
end






