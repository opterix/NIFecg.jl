function Font_Separation_SVD(signal)

#signal=AECG_fnotch

## SINGULAR VALUE DECOMPOSITION

## Defino la ventana a trabajar de 200 ms

(Win_Pos_Fw) = (QRSm_pos*1000) + 100 ;
(Win_Pos_Rw) = (QRSm_pos*1000) - 100 ;

## Convierto el arreglo a enteros

## Win_Pos_Rw_Int = Array(Int64, length(QRSm_pos), 1)
## Win_Pos_Fw_Int = Array(Int64, length(QRSm_pos), 1)

Win_Pos_Rw_Int = convert(Array{Int64}, round(Win_Pos_Rw));
Win_Pos_Fw_Int = convert(Array{Int64}, round(Win_Pos_Fw));


## Tomo los valores alrededor del complejo R en la ventana definida

SVD_Values=signal[Win_Pos_Rw_Int[1]:Win_Pos_Fw_Int[1]];
SVD_Values_Mot = zeros(length(SVD_Values), length(QRSm_pos));


for i = 1:length(QRSm_pos)   ##Guardo los valores de los complejos R detectados en una matriz

	SVD_Values_Mot[1:length(SVD_Values),i]=signal[Win_Pos_Rw_Int[i]:Win_Pos_Fw_Int[i]];
end

# Aplico Singular Value Decomposition a la matriz que contiene los R.


(U,S,V)=svd(SVD_Values_Mot);

Sprima=zeros(length(QRSm_pos))
Sprima[1:3]=S[1:3]
#Sprima=S;
NUrec=U*diagm(Sprima)*V'

return NUrec,SVD_Values_Mot

end

## Ventana para tomar los valores y armar la matriz 100ms



