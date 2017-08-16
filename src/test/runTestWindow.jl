function MFMTestWindow(filename,ti,tf,sr,f)
	# f = number of partitions
	# ti =  time signal in seconds (Uint32)	
	# tf =  time signal in seconds (Uint32)
	# sr =  sample rate (UInt64)
	# filename = name of csv file (without csv extension, "filename") (String)
		# Notes:# - The module detects automaticly the headers.
			# - Specify the directory of data in the filename ("dir/filename")
			#   or the module searchs into the current directory.
			# - If you have annotations, put into the same directory.  
			# - The annotations and csv file must be the same name,
			#   (filename.fqrs.txt => filename.csv),
			#   otherwise the module will not detected the file.
	
	#------------------------------------ GLOBAL VARIABLES 
	ns = (tf-ti) * sr # number of samples

	#------------------------------------------- LOAD DATA
	(nsLimits)=divideSignal(AECG,ns,nch,f)
	for i = 1 : f 	
	b = nsLimits[i,1];
	f = nsLimits[i,2];
	nsd = nsLimits[i,2]-nsLimits[i,1];	
	(nch,t,AECG,fetal_annot) = loadData(filename,nsd,sr,b,f)

	#---------------------------------------- PREPROCESING
	(AECG_clean) = preProcessing(AECG,sr,nch,nsd)

	#----------------- MOTHER SUBSTRACTION AND COMPUTATION
	(heart_rate_mother,AECGm_ica,SVDrec,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value) = motherSubstraction(AECG_clean,nch,sr,nsd,b,f)

	#------------------ FETAL SUBSTRACTION AND COMPUTATION 
	(AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure) = fetalSubstraction(AECG_residual,heart_rate_mother,nch,sr,ti,tf)



	(tAcum,fetal_annotAcum,AECGAcum,AECG_cleanAcum,
AECG_icaAcum,SVDrecAcum,AECG_sortAcum,AECG_residualAcum,heart_rateAcum,QRS_valueAcum,
QRS_posAcum,AECG_sortAcum,QRS_posAcum,QRS_valueAcum,QRScell_posAcum,QRScell_valueAcum,
heart_rateAcum,QRScell_pos_smoothAcum,SMIAcum,gini_measureAcum) = initializationAcum(i,t,fetal_annot,AECG,AECG_clean,
AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth,SMI,gini_measure)


(tAcum,fetal_annotAcum,AECGAcum,AECG_cleanAcum,AECG_icaAcum,SVDrecAcum,	AECG_sortAcum,AECG_residualAcum,heart_rate_motherAcum,QRS_valueAcum,QRS_posAcum,
	AECG_sortAcum,QRS_posAcum,QRS_valueAcum,QRScell_posAcum,QRScell_valueAcum,
	heart_rate_fetoAcum,QRScell_pos_smoothAcum,SMIAcum,gini_measureAcum) = concatVar(i,t,fetal_annot,AECG,AECG_clean,
AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth,SMI,gini_measure,tAcum,fetal_annotAcum,AECGAcum,AECG_cleanAcum,
AECG_icaAcum,SVDrecAcum,AECG_sortAcum,AECG_residualAcum,heart_rateAcum,QRS_valueAcum,
QRS_posAcum,AECG_sortAcum,QRS_posAcum,QRS_valueAcum,QRScell_posAcum,QRScell_valueAcum,
heart_rateAcum,QRScell_pos_smoothAcum,SMIAcum,gini_measureAcum)

end


	#---------- Grouping variables 
	(inputVar,motherVar,fetalVar)=groupVar(nch,ns,ti,tf,sr,tAcum,fetal_annotAcum,AECGAcum,AECG_cleanAcum,	AECGm_icaAcum,AECGm_sortAcum,AECG_residualAcum,QRSm_posAcum,QRSm_valueAcum,heart_rate_motherAcum,SVDrecAcum,	AECGf_sortAcum,QRSf_posAcum,QRSf_valueAcum,QRSfcell_posAcum,QRSfcell_valueAcum,heart_rate_fetoAcum, QRSfcell_pos_smoothAcum, SMIAcum, gini_measureAcum)

	return inputVar,motherVar,fetalVar;

end




