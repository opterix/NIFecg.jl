function QRSf_selector(signal_feto,nch)

#	for i in 1:nch
#            signal_feto[:,i]= (signal_feto[:,i]-mean(signal_feto[:,i]))/maximum(abs(signal_feto[:,i]));#
#	end

    nsamples=size(signal_feto,1);
    fs=1000;

    out_aux = fft(signal_feto,1);
    out = abs(fftshift(out_aux,1))./sum(abs(fftshift(out_aux,1)));
 
    Efft= abs(out_aux).^2;

    Efft= Efft./maximum(Efft,1);


    dw_min= fs/nsamples;
    f_final= Int(round(40/dw_min));

    dw_0_4 = Int(round(0.4/dw_min));
    dw4 = Int(round(4/dw_min));

	
#    print(f_final);

    Etotal = sum(Efft[2:f_final,:],1);
#    print(Etotal);

	x=zeros(dw4-dw_0_4+1,4);

	for i in dw_0_4:dw4
	    Eparcial=sum(Efft[1:i:10*i,:],1);
	    #print(Eparcial);
	    x[i-dw_0_4+1,:]=Eparcial;
	end
	
	print(x);

	for k in 1:nch#
		x[:,k]=x[:,k]/Etotal[:,k];
	end

	maximosQindex= maximum(x,1);

	print(maximosQindex);
    
        idx=sortperm(vec(maximosQindex),rev=true);
	print(idx);
        sorted_feto = signal_feto[:,idx];
#	pause();
	



    #Variar tren de pulsos desde 0.4Hz a 4 Hz#


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

#    entr_m=zeros(size(signal_feto,2))

#    for i in 1:nch
#        entr_m[i]=entropy(out[:,i]);
#    end
#    idx=sortperm(entr_m,rev=false);
#    sorted_feto = signal_feto[:,idx];

    return sorted_feto;
end






