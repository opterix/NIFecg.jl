function qrsFetalSelector(signal_feto,nch,fs)

	for i in 1:nch
            signal_feto[:,i]= (signal_feto[:,i]-mean(signal_feto[:,i]))/(std(signal_feto[:,i]));#
	end

    nsamples=size(signal_feto,1);

    out_aux = fft(signal_feto,1);
    #out = abs(fftshift(out_aux,1))./sum(abs(fftshift(out_aux,1)));
    Efft= abs(out_aux).^2;
    #Efft= Efft./maximum(Efft,1);

    dw_min= fs/nsamples;
    f_final= Int(round(40/dw_min));

    dw_ini = Int(round(0.8/dw_min)); #Iniciar buscando en 1.3Hz: 77 pulsos por min
    dw_fin = Int(round(3.8/dw_min));
	

    Etotal = sum(Efft[1:f_final,:],1);
    points=collect(dw_ini:0.1:dw_fin);
    x=zeros(size(points,1),nch);

    kpoint=1;
    
    for i in points
	Eparcial=median(Efft[round(Int64, 1:i:10*i)+1,:],1);
        #O usar sum o average?
	x[kpoint,:]=Eparcial;
        kpoint += 1;
    end
	
	for k in 1:nch#
		x[:,k]=x[:,k]/Etotal[:,k];
	end

    maximosQindex= maximum(x,1);
    #(maxval,indQ)=findmax(Qfactor,1);
    
    idx=sortperm(vec(maximosQindex),rev=true);
    sorted_feto = signal_feto[:,idx];
    
    return sorted_feto
end
