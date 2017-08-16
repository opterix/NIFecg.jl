function	initializationAcum(i,t,fetal_annot,AECG,AECG_clean,
AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth,SMI,gini_measure)
	if i == 1
		fetal_annotAcum = fetal_annot;
		AECGAcum = AECG; #
		AECG_cleanAcum = AECG_clean; #
		AECG_icaAcum = AECGm_ica; #
		SVDrecAcum = SVDrec; #
		AECGm_sortAcum = AECGm_sort; #
		AECG_residualAcum = AECG_residual;#
		heart_rate_motherAcum[i,1] = heart_rate_mother;
		QRS_valueAcum = QRSm_value; 
		QRS_posAcum = QRSm_pos;
		AECGf_sortAcum = AECGf_sort;#
		QRS_posAcum = QRSf_pos;
		QRS_valueAcum = QRSf_value;
		QRScell_posAcum = QRSfcell_pos;
		QRScell_valueAcum = QRSfcell_value; 
		heart_rate_fetoAcum[i,1] =  heart_rate_feto;
		QRScell_pos_smoothAcum = QRSfcell_pos_smooth;
		SMIAcum = SMI;
		gini_measureAcum = gini_measure;


return tAcum,fetal_annotAcum,AECGAcum,AECG_cleanAcum,
AECG_icaAcum,SVDrecAcum,AECG_sortAcum,AECG_residualAcum,heart_rate_motherAcum,QRS_valueAcum,
QRS_posAcum,AECG_sortAcum,QRS_posAcum,QRS_valueAcum,QRScell_posAcum,QRScell_valueAcum,
heart_rate_fetoAcum,QRScell_pos_smoothAcum,SMIAcum,gini_measureAcum

end 
end
