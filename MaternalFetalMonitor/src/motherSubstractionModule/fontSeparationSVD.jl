function fontSeparationSVD(signal,QRSm_pos,sr,nch,ns)

	
    window_svd=Int64(floor(sr*0.7)); #samples
    window_init= Int64(floor(window_svd*0.4));
    window_fin= Int64(ceil(window_svd*0.6));
    
    numSVD=3; # number of single values take into account for reconstruction



## SINGULAR VALUE DECOMPOSITION
    ## Defino la ventana a trabajar de 200 ms

    maximind_all = max_per_channel(signal,QRSm_pos,sr,nch,ns);

    Win_Pos_Fw=zeros(size(maximind_all));
    Win_Pos_Rw=zeros(size(maximind_all));

    for kch in 1:nch
        #(Win_Pos_Fw[:,kch]) = (maximind_all[:,kch]*sr) + window_svd/2 ;
        #(Win_Pos_Rw[:,kch]) = (maximind_all[:,kch]*sr) - window_svd/2 ;

        Win_Pos_Fw[:,kch] = maximind_all[:,kch] + window_fin ;
        Win_Pos_Rw[:,kch] = maximind_all[:,kch] - window_init ;

    end

#if Win_Pos_Fw[end] >60
#   Win_Pos_Fw=Win_Pos_Fw[1:end-1];
#end

#if Win_Pos_Rw[1] <0
#   Win_Pos_Rw=Win_Pos_Rw[2:end];
#end


## Pesos de la ventana (Tukey)
    alpha=0.5; #constante 0(rectangular) - 1(gausiana)
    #win_weight=tukey(window_svd+1, alpha)*0.8+0.2;

    win_weight=tukey(round(Int64, window_svd*4/5) + 1, 0.5)*0.8+0.2;
    win_weight=vcat(win_weight, ones(round(Int64, window_svd/5),1)*0.2);

## Convierto el arreglo a enteros

Win_Pos_Rw_Int = convert(Array{Int64}, round(Win_Pos_Rw));
    Win_Pos_Fw_Int = convert(Array{Int64}, round(Win_Pos_Fw));

#        QRSm_pos_tmp=maximind_all;

    #for kch in 1:nch

    QRSm_pos_tmp=maximind_all

#    
#        QRSm_pos_tmp=maximind_all[1:end-1, :]
#    else
#        QRSm_pos_tmp=maximind_all
#    end  
#
    if any(Win_Pos_Rw_Int[1,:] .< 0)
        QRSm_pos_tmp=QRSm_pos_tmp[2:end,:]
        Win_Pos_Rw_Int=Win_Pos_Rw_Int[2:end,:]
        Win_Pos_Fw_Int=Win_Pos_Fw_Int[2:end,:]	
    end
#end



## Inicializando variables
signal_rec=zeros(ns,nch);

for i = 1:nch #aplicar proceso para cada canal
    ## Tomo los valores alrededor del complejo R en la ventana definida
    SVD_Values = zeros(window_svd+1, size(QRSm_pos_tmp,1));

    ##Guardo los valores de los complejos R detectados en una matriz
    for ii = 1:size(QRSm_pos_tmp,1)
        if Win_Pos_Fw_Int[ii,i] > ns
            SVD_Values[1:window_svd+1,ii]=vcat(signal[Win_Pos_Rw_Int[ii, i]:end,i], zeros(Win_Pos_Fw_Int[ii,i]-ns,1)).*win_weight;
        elseif Win_Pos_Rw_Int[ii,i] <= 0
            SVD_Values[1:window_svd+1,ii]=vcat(zeros(-(Win_Pos_Rw_Int[ii,i])+1,1), signal[1:Win_Pos_Fw_Int[ii,i],i]).*win_weight;
        else
	    SVD_Values[1:window_svd+1,ii]=(signal[Win_Pos_Rw_Int[ii, i]:Win_Pos_Fw_Int[ii,i],i]).*win_weight;
        end
    end
    
    # Aplico Singular Value Decomposition a la matriz que contiene los R.
    
    (U,S,V)=svd(SVD_Values);
    
    Sprima=zeros(size(QRSm_pos_tmp,1));
    Sprima[1:numSVD]=S[1:numSVD];
	#Sprima=S;
    NUrec=U*diagm(Sprima)*V';
    
    #Reconstruir cada canal

    min_Rw = min(Win_Pos_Rw_Int[1,i],0);
    max_Fw = max(Win_Pos_Fw_Int[end,i], ns);

    range_RFw=max_Fw - min_Rw + 1

    signal_rec_aux=zeros(range_RFw,1);
    
    for ii = 1:size(QRSm_pos_tmp,1)
    	signal_rec_aux[Win_Pos_Rw_Int[ii,i]-min_Rw+1:Win_Pos_Fw_Int[ii,i]-min_Rw+1,1]=NUrec[1:window_svd+1,ii];
    end

    signal_rec[:,i]=signal_rec_aux[1-min_Rw+1:ns-min_Rw+1,1];
   
end

# Restar con la original
signal_subtract=signal-signal_rec;

#=
responsetype = Lowpass(90;fs=sr)
designmethod = Butterworth(4)# FIRWindow(hanning(64))

signal_subtract[:,1]=filt(digitalfilter(responsetype, designmethod), signal_subtract[:,1])
signal_subtract[:,2]=filt(digitalfilter(responsetype, designmethod), signal_subtract[:,2])
if sr > 1000/4
	signal_subtract[:,3]=filt(digitalfilter(responsetype, designmethod), signal_subtract[:,3])
	signal_subtract[:,4]=filt(digitalfilter(responsetype, designmethod), signal_subtract[:,4])
end
println("r")
=#


return signal_rec, signal_subtract;

end


function max_per_channel(signal,QRSm_pos,sr,nch,ns)
    window_maxsearch=Int64(floor(sr*0.2));


    detections=zeros(1,ns);
    detections[round(Int64, floor(QRSm_pos*sr))]=1;

    filtones=ones(1,Int(floor(window_maxsearch/2)));

    mask = conv(vec(detections), vec(filtones));
    mask = mask[Int(floor(window_maxsearch/4)):Int(floor(window_maxsearch/4)+ns)];
    mask[1]=0;
    mask[end]=0;
    cambios = diff(mask);
    initp = find(cambios.>0.5);
    endingp = find(cambios.<-0.5);

    maximind_all=zeros(length(initp), nch);

    for l in 1:length(initp)
        trimsignal=signal[initp[l]:endingp[l],:];
        (maximo,maximind) = findmax(trimsignal,1);
        maximind_all[l,:] = mod(maximind-1,size(trimsignal,1))+1+initp[l];
    end

    return maximind_all;
       
end
