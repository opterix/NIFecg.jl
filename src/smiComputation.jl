function smiComputation(FQRSdetections, nch, fs)

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

