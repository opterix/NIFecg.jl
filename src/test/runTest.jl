function MFMTest(filename,ti,tf,sr)
	
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
	(nch,t,AECG,fetal_annot) = loadData(filename,ns,sr,ti,tf)

	#---------------------------------------- PREPROCESING
	(AECG_clean) = preProcessing(AECG,sr)

	#----------------- MOTHER SUBSTRACTION AND COMPUTATION
	(heart_rate_mother,AECGm_ica,SVDrec,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value) = motherSubstraction(AECG_clean,nch,sr,ns,ti,tf)

	#------------------ FETAL SUBSTRACTION AND COMPUTATION 
	(AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure) = fetalSubstraction(AECG_residual,heart_rate_mother,nch,sr,ti,tf)

	#---------- Grouping variables 
	(inputVar,motherVar,fetalVar)=groupVar(nch,ns,ti,tf,sr,t,fetal_annot,AECG,AECG_clean,	AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
	AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure)

	return inputVar,motherVar,fetalVar;

end




