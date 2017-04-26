function motherSubstraction(AECG_clean,)

include("makeIcaAll.jl")
########## SOURCE SEPARATION ################
#----------------- ICA ----------------------
(AECG_white) = makeIcaAll(AECG_clean,nc)


#----------------------------------------------
#---- QRS mother detector (Pan - Tomkins) -----

(QRSmcell_pos, QRSmcell_value)=panTomkinsDetector(AECG_white, sr, nch);
QRSm_pos=QRSmcell_pos[1];
QRSm_value=QRSmcell_value[1];

#Implementar la parte de selección
    

#rr smoothing de ida
    flag=1; #bandera para aplicar segun frecuencas fetales o maternas
    (QRSmcell_pos_smooth) = smooth_RR(QRSmcell_pos, nch, sr,flag);


    SMI = smi_computation(QRSmcell_pos_smooth, nch, sr);

    auxidx=sortperm(vec(SMI)); 
    AECG_white=AECG_white[:,auxidx];
    QRSmcell_pos_smooth=QRSmcell_pos_smooth[auxidx];
    QRSmcell_pos=QRSmcell_pos[auxidx];
    QRSmcell_value=QRSmcell_value[auxidx];
    SMI=SMI[auxidx];

    QRSm_pos=QRSmcell_pos_smooth[1];
    heart_rate_mother = (60*size(QRSm_pos,1))/window_size





#------- SVD process and subtract mother signal---------

(SVDrec,AECGm) = Font_Separation_SVD(AECG_clean,QRSm_pos,sr,nch,ns);

return

end

