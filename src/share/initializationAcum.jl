function	initializationAcum(nch,f,i,fetal_annot,AECG,AECG_clean,
AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth,SMI,gini_measure)
	if i == 1
		fetal_annotAcum = fetal_annot;
		AECGAcum = AECG; #
		AECG_cleanAcum = AECG_clean; #
		AECGm_icaAcum = AECGm_ica; #
		SVDrecAcum = SVDrec; #
		AECGm_sortAcum = AECGm_sort; #
		AECG_residualAcum = AECG_residual;#
		heart_rate_motherAcum = zeros(f,1); 
		heart_rate_motherAcum[i,1] = heart_rate_mother;
		QRSm_valueAcum = QRSm_value; 
		QRSm_posAcum = QRSm_pos;
		AECGf_sortAcum = AECGf_sort;#
		QRSf_posAcum = QRSf_pos;
		QRSf_valueAcum = QRSf_value;
		QRSfcell_posAcum = QRSfcell_pos;
		QRSfcell_valueAcum = QRSfcell_value; 
		heart_rate_fetoAcum = zeros(f,1);		
		heart_rate_fetoAcum[i,1] =  heart_rate_feto;
		QRSfcell_pos_smoothAcum = QRSfcell_pos_smooth;
		SMIAcum = zeros(nch,f);	SMIAcum = SMI;
		gini_measureAcum = zeros(nch,f); gini_measureAcum = gini_measure;


return fetal_annotAcum,AECGAcum,AECG_cleanAcum,	AECGm_icaAcum,SVDrecAcum,AECGm_sortAcum,AECG_residualAcum,heart_rate_motherAcum,	QRSm_valueAcum,QRSm_posAcum,AECGf_sortAcum,QRSf_posAcum,QRSf_valueAcum,QRSfcell_posAcum,
QRSfcell_valueAcum,heart_rate_fetoAcum,QRSfcell_pos_smoothAcum,SMIAcum,gini_measureAcum

end 
end
