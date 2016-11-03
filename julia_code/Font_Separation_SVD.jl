## SINGULAR VALUE DECOMPOSITION

## Defino la ventana a trabajar de 200 ms

(Win_Pos_Fw) = (QRSm_pos*1000) + 100 ;
(Win_Pos_Rw) = (QRSm_pos*1000) - 100 ;

## Convierto el arreglo a enteros

Win_Pos_Rw_Int = Array(Int64, length(QRSm_pos), 1)
Win_Pos_Fw_Int = Array(Int64, length(QRSm_pos), 1)

for i = 1:length(QRSm_pos)
		
	Win_Pos_Rw_Int[i]= convert(Int64,Win_Pos_Rw[i])
	Win_Pos_Fw_Int[i]= convert(Int64,Win_Pos_Fw[i])
end


## Tomo los valores alrededor del complejo R en la ventana definida

SVD_Values=AECG_white[Win_Pos_Rw_Int[1]:Win_Pos_Fw_Int[1]];
SVD_Values_Mot = zeros(length(SVD_Values), length(QRSm_pos));


for i = 1:length(QRSm_pos)   ##Guardo los valores de los complejos R detectados en una matriz

	SVD_Values_Mot[1:length(SVD_Values),i]=AECG_white[Win_Pos_Rw_Int[i]:Win_Pos_Fw_Int[i]];
end

# Aplico Singular Value Decomposition a la matriz que contiene los R.


(U,S,V)=svd(SVD_Values_Mot);

return U,S,V






## Ventana para tomar los valores y armar la matriz 100ms



