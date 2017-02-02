function Font_Separation_SVD(signal,QRSm_pos,sr,nch,ns)

window_svd=200; #samples
numSVD=3; # number of single values take into account for reconstruction

## SINGULAR VALUE DECOMPOSITION

## Defino la ventana a trabajar de 200 ms

(Win_Pos_Fw) = (QRSm_pos*sr) + window_svd/2 ;
(Win_Pos_Rw) = (QRSm_pos*sr) - window_svd/2 ;

#if Win_Pos_Fw[end] >60
#   Win_Pos_Fw=Win_Pos_Fw[1:end-1];
#end

#if Win_Pos_Rw[1] <0
#   Win_Pos_Rw=Win_Pos_Rw[2:end];
#end


## Pesos de la ventana (Tukey)
alpha=0.5; #constante 0(rectangular) - 1(gausiana)
win_weight=tukey(window_svd+1, alpha)*0.8+0.2;

## Convierto el arreglo a enteros

Win_Pos_Rw_Int = convert(Array{Int64}, round(Win_Pos_Rw));
Win_Pos_Fw_Int = convert(Array{Int64}, round(Win_Pos_Fw));

if Win_Pos_Fw_Int[end] > ns
  QRSm_pos_tmp=QRSm_pos[1:end-1]
else
  QRSm_pos_tmp=QRSm_pos
end  


if Win_Pos_Rw_Int[1] < 0
  QRSm_pos_tmp=QRSm_pos_tmp[2:end]
  Win_Pos_Rw_Int=Win_Pos_Rw_Int[2:end]
  Win_Pos_Fw_Int=Win_Pos_Fw_Int[2:end]	
end



## Inicializando variables
signal_rec=zeros(ns,nch);

for i = 1:nch #aplicar proceso para cada canal
	## Tomo los valores alrededor del complejo R en la ventana definida
	SVD_Values = zeros(window_svd+1, length(QRSm_pos_tmp));

	##Guardo los valores de los complejos R detectados en una matriz
	for ii = 1:length(QRSm_pos_tmp)   

	SVD_Values[1:window_svd+1,ii]=(signal[Win_Pos_Rw_Int[ii]:Win_Pos_Fw_Int[ii],i]).*win_weight;	
	end
	
	# Aplico Singular Value Decomposition a la matriz que contiene los R.

	(U,S,V)=svd(SVD_Values);

	Sprima=zeros(length(QRSm_pos_tmp));
	Sprima[1:numSVD]=S[1:numSVD];
	#Sprima=S;
	NUrec=U*diagm(Sprima)*V';
	
	#Reconstruir cada canal 
	for ii = 1:length(QRSm_pos_tmp)  
		signal_rec[Win_Pos_Rw_Int[ii]:Win_Pos_Fw_Int[ii],i]=NUrec[1:window_svd+1,ii];
	end
end

# Restar con la original
signal_subtract=signal-signal_rec;

#=
responsetype = Lowpass(90;fs=sr)
designmethod = Butterworth(4)# FIRWindow(hanning(64))

signal_subtract[:,1]=filt(digitalfilter(responsetype, designmethod), signal_subtract[:,1])
signal_subtract[:,2]=filt(digitalfilter(responsetype, designmethod), signal_subtract[:,2])
signal_subtract[:,3]=filt(digitalfilter(responsetype, designmethod), signal_subtract[:,3])
signal_subtract[:,4]=filt(digitalfilter(responsetype, designmethod), signal_subtract[:,4])
println("r")
=#


return signal_rec, signal_subtract;

end
