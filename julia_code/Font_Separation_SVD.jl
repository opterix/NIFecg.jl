function Font_Separation_SVD(signal)

window_svd=200; #samples
signal_rec=zeros(n,m);

## SINGULAR VALUE DECOMPOSITION

## Defino la ventana a trabajar de 200 ms

(Win_Pos_Fw) = (QRSm_pos*rate_sample) + window_svd/2 ;
(Win_Pos_Rw) = (QRSm_pos*rate_sample) - window_svd/2 ;

## Convierto el arreglo a enteros

Win_Pos_Rw_Int = convert(Array{Int64}, round(Win_Pos_Rw));
Win_Pos_Fw_Int = convert(Array{Int64}, round(Win_Pos_Fw));


for i = 1:m #aplicar proceso para cada canal
	## Tomo los valores alrededor del complejo R en la ventana definida
	SVD_Values = zeros(window_svd+1, length(QRSm_pos));

	##Guardo los valores de los complejos R detectados en una matriz
	for ii = 1:length(QRSm_pos)   
		SVD_Values[1:window_svd+1,ii]=signal[Win_Pos_Rw_Int[ii]:Win_Pos_Fw_Int[ii],i];
	end

	# Aplico Singular Value Decomposition a la matriz que contiene los R.

	(U,S,V)=svd(SVD_Values);

	Sprima=zeros(length(QRSm_pos));
	Sprima[1:3]=S[1:3];
	#Sprima=S;
	NUrec=U*diagm(Sprima)*V';
	
	#Reconstruir cada canal
	for ii = 1:length(QRSm_pos)  
		signal_rec[Win_Pos_Rw_Int[ii]:Win_Pos_Fw_Int[ii],i]=NUrec[1:window_svd+1,ii];
	end
end

return signal_rec;

end
