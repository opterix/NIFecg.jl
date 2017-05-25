function qrsFetalSelector(signal_feto,nch)

	for i in 1:nch
            signal_feto[:,i]= (signal_feto[:,i]-mean(signal_feto[:,i]))/(std(signal_feto[:,i]));#
	end

    nsamples=size(signal_feto,1);
    fs=1000;

    out_aux = fft(signal_feto,1);
    #out = abs(fftshift(out_aux,1))./sum(abs(fftshift(out_aux,1)));
    Efft= abs(out_aux).^2;
    #Efft= Efft./maximum(Efft,1);

    dw_min= fs/nsamples;
    f_final= Int(round(40/dw_min));

    dw_ini = Int(round(0.8/dw_min)); #Iniciar buscando en 1.3Hz: 77 pulsos por min
    dw_fin = Int(round(3.8/dw_min));
	
#    print(f_final);
    Etotal = sum(Efft[1:f_final,:],1);
    #    print(Etotal);
    points=collect(dw_ini:0.1:dw_fin);
    x=zeros(size(points,1),nch);

    kpoint=1;
    
    for i in points
	Eparcial=median(Efft[round(Int64, 1:i:10*i)+1,:],1);
        #O usar sum o average?
	#print(Eparcial);
	x[kpoint,:]=Eparcial;
        kpoint += 1;
    end
	
	#print(x);
	for k in 1:nch#
		x[:,k]=x[:,k]/Etotal[:,k];
	end

    maximosQindex= maximum(x,1);
    #(maxval,indQ)=findmax(Qfactor,1);
    
    print(maximosQindex);
    idx=sortperm(vec(maximosQindex),rev=true);
    print(idx);
    sorted_feto = signal_feto[:,idx];
    
    return sorted_feto
end


function smooth_RR(FQRSdetections, nch, fs, flag)

if flag == 1 # mother
    max_frr = 1*fs;
    min_frr = 0.55*fs;
elseif flag == 2 #fetal 
 max_frr = 0.55*fs;
    min_frr = 0.35*fs;

end
    smooth_FQRS=cell(nch);

    for i in 1:nch

        medSamples=5
        conteo=medSamples

        auxFQRSdet = copy(FQRSdetections[i])*fs;
        while conteo<size(auxFQRSdet,1)-1
            med=median(diff(auxFQRSdet[conteo-medSamples+1:conteo]));
            #println(med);

            if med>min_frr && med<max_frr
                dTplus = auxFQRSdet[conteo+1]-auxFQRSdet[conteo]; #rr siguiente
                dTminus = auxFQRSdet[conteo]-auxFQRSdet[conteo-1]; #rr anterior

                if dTplus<0.7*med && dTminus<1.2*med
                    #Extra detection
                    #Eliminar detección
                    deleteat!(auxFQRSdet, conteo+1);
                    #println("QRS eliminado");
                elseif dTplus>1.75*med && dTminus>0.7*med
                    #Pulso no detectado
                    #usar la mediana del RR para insertar pulso no detectado
                    missedFQRS= round(auxFQRSdet[conteo] + med);
                    insert!(auxFQRSdet, conteo+1, missedFQRS);
                    #println("QRS insertado");
                else
                    #Detección normal
                    conteo=conteo+1;
                end
            else
                #rr out of physiological range
                conteo = conteo+1;
            end
        end

        smooth_FQRS[i]=auxFQRSdet/fs;
        
    end

    return smooth_FQRS;
end


function smi_computation(FQRSdetections, nch, fs)

    CI=0.98;
    SMI = zeros(nch,1);
    BCM = zeros(nch,1);

    t_comp = 50e-3; #comparison window 50mseg

    tc_samp = t_comp*fs
    
       
    for i in 1:nch
        #QRS=zeros(window_time*fs,1);
        #QRS[round(Int64, FQRSdetections[i]*fs)]=1;
        QRS = FQRSdetections[i];
        hrate= 60./(diff(QRS));

        hrate_var = sort(vec(diff(hrate)));
        Nhrate_var = size(hrate_var,1);

        superior=ceil(Int64, Nhrate_var*(CI+(1-CI)/2));
        inferior=ceil(Int64, Nhrate_var*(1-CI)/2);
        if (superior!=0) && (inferior != 0) && (Nhrate_var > 10)
            hrate_var_robust=hrate_var[inferior:superior];
            SMI[i] = size(find((hrate_var_robust.>30) | (hrate_var_robust.<-30)),1);
            #SMI[i] = sum(abs(hrate_var_robust));
        else
            SMI[i] = 1000;
        end

        #compare peaks with maternal
        #dist_all = pairwise(Euclidean(), reshape(QRSm_pos, 1, length(QRSm_pos)), reshape(FQRSdetections[i], 1, length(FQRSdetections[i])));

        
        #BCM[i]=sum(any(dist_all.<350e-3,2))/size(dist_all,2);

        #if BCM[i]>0.4
        #    SMI[i]=1000;
        #end
        
    end

    println(BCM);
    
    return SMI;
end

