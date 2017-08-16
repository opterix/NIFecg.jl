function concatVar(
i,t,fetal_annot,AECG,AECG_clean,
AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth,SMI,gini_measure,tAcum,fetal_annotAcum,AECGAcum,AECG_cleanAcum,
AECG_icaAcum,SVDrecAcum,AECG_sortAcum,AECG_residualAcum,heart_rate_motherAcum,QRS_valueAcum,
QRS_posAcum,AECG_sortAcum,QRS_posAcum,QRS_valueAcum,QRScell_posAcum,QRScell_valueAcum,
heart_rate_fetoAcum,QRScell_pos_smoothAcum,SMIAcum,gini_measureAcum)
	
if i > 1
	tAcum =  vcat(t,tAcum);  #
	fetal_annotAcum =  vcat(fetal_annot,fetal_annotAcum);
	AECGAcum =  vcat(AECG,AECGAcum); #
	AECG_cleanAcum =  vcat(AECG_clean,AECG_cleanAcum); #
	AECG_icaAcum =  vcat(AECGm_ica,AECG_icaAcum); #
	SVDrecAcum =  vcat(SVDrec,SVDrecAcum); #
	AECGm_sortAcum =  vcat(AECGm_sort,AECGm_sortAcum); #
	AECG_residualAcum =  vcat(AECG_residual,AECG_residualAcum);#
	heart_rate_motherAcum[i,1] =  vcat(heart_rate_mother,heart_rate_motherAcum[i,1]);#
	QRS_valueAcum =  vcat(QRSm_value,QRS_valueAcum); #
	QRSm_posAcum =  vcat(QRSm_pos,QRSm_posAcum);#
	AECGf_sortAcum =  vcat(AECGf_sort,AECGf_sortAcum);#
	QRSf_posAcum =  vcat(QRSf_pos,QRSf_posAcum);#
	QRS_valueAcum =  vcat(QRSf_value,QRS_valueAcum);#
	QRScell_posAcum =  vcat(QRSfcell_pos,QRScell_posAcum);#
	QRScell_valueAcum =  vcat(QRSfcell_value,QRScell_valueAcum);# 
	heart_rate_fetoAcum[i,1] =  vcat(heart_rate_feto,heart_rate_fetoAcum[i,1]);#
	QRScell_pos_smoothAcum =  vcat(QRSfcell_pos_smooth,QRScell_pos_smoothAcum);
	SMIAcum[:,i] =  hcat(SMI,SMIAcum[:,i]);
	gini_measureAcum[:,i] =  hcat(gini_measure,gini_measureAcum[:,i]);

if i == f
heart_rate_motherAcum = mean(heart_rate_motherAcum,1)
heart_rate_fetoAcum = mean(heart_rate_fetoAcum,1)
gini_measureAcum = mean(gini_measureAcum,2)
SMIAcum = mean(SMIAcum,2)
end


	return tAcum,fetal_annotAcum,AECGAcum,AECG_cleanAcum,AECG_icaAcum,SVDrecAcum,	AECG_sortAcum,AECG_residualAcum,heart_rate_motherAcum,QRS_valueAcum,QRS_posAcum,
	AECG_sortAcum,QRS_posAcum,QRS_valueAcum,QRScell_posAcum,QRScell_valueAcum,
	heart_rate_fetoAcum,QRScell_pos_smoothAcum,SMIAcum,gini_measureAcum
end
end
