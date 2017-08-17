function concatVar(
i,fetal_annot,AECG,AECG_clean,
AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth,SMI,gini_measure,fetal_annotAcum,AECGAcum,AECG_cleanAcum,	AECGm_icaAcum,SVDrecAcum,AECGm_sortAcum,AECG_residualAcum,heart_rate_motherAcum,	QRSm_valueAcum,QRSm_posAcum,AECGf_sortAcum,QRSf_posAcum,QRSf_valueAcum,QRSfcell_posAcum,
QRSfcell_valueAcum,heart_rate_fetoAcum,QRSfcell_pos_smoothAcum,SMIAcum,gini_measureAcum)
	
if i > 1
	fetal_annotAcum =  vcat(fetal_annot,fetal_annotAcum);
	AECGAcum =  vcat(AECG,AECGAcum); #
	AECG_cleanAcum =  vcat(AECG_clean,AECG_cleanAcum); #
	AECGm_icaAcum =  vcat(AECGm_ica,AECGm_icaAcum); #
	SVDrecAcum =  vcat(SVDrec,SVDrecAcum); #
	AECGm_sortAcum =  vcat(AECGm_sort,AECGm_sortAcum); #
	AECG_residualAcum =  vcat(AECG_residual,AECG_residualAcum);#
	heart_rate_motherAcum[i,1] =  vcat(heart_rate_mother,heart_rate_motherAcum[i,1]);#
	QRSm_valueAcum =  vcat(QRSm_value,QRSm_valueAcum); #
	QRSm_posAcum =  vcat(QRSm_pos,QRSm_posAcum);#
	AECGf_sortAcum =  vcat(AECGf_sort,AECGf_sortAcum);#
	QRSf_posAcum =  vcat(QRSf_pos,QRSf_posAcum);#
	QRSf_valueAcum =  vcat(QRSf_value,QRSf_valueAcum);#
	QRSfcell_posAcum =  vcat(QRSfcell_pos,QRSfcell_posAcum);#
	QRSfcell_valueAcum =  vcat(QRSfcell_value,QRSfcell_valueAcum);# 
	heart_rate_fetoAcum[i,1] =  vcat(heart_rate_feto,heart_rate_fetoAcum[i,1]);#
	QRSfcell_pos_smoothAcum =  vcat(QRSfcell_pos_smooth,QRSfcell_pos_smoothAcum);
	SMIAcum[:,i] =  hcat(SMI,SMIAcum[:,i]);
	gini_measureAcum[:,i] =  hcat(gini_measure,gini_measureAcum[:,i]);

if i == f
heart_rate_motherAcum = mean(heart_rate_motherAcum,1)
heart_rate_fetoAcum = mean(heart_rate_fetoAcum,1)
gini_measureAcum = mean(gini_measureAcum,2)
SMIAcum = mean(SMIAcum,2)
end


	return fetal_annotAcum,AECGAcum,AECG_cleanAcum,	AECGm_icaAcum,SVDrecAcum,AECGm_sortAcum,AECG_residualAcum,heart_rate_motherAcum,	QRSm_valueAcum,QRSm_posAcum,AECGf_sortAcum,QRSf_posAcum,QRSf_valueAcum,QRSfcell_posAcum,
QRSfcell_valueAcum,heart_rate_fetoAcum,QRSfcell_pos_smoothAcum,SMIAcum,gini_measureAcum
end
end
