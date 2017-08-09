function groupVar(
nch,ns,ti,tf,sr,t,fetal_annot,AECG,AECG_clean,
AECGm_ica,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value,heart_rate_mother,SVDrec,
AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure)

	inputVar = Dict([
	("nch",nch),
	("ns",ns),
	("ti",ti),
	("tf",tf),
	("sr",sr),
	("t",t),
	("fetal_annot",fetal_annot),
	("AECG",AECG),
	("AECG_clean",AECG_clean)
	]) 

	motherVar = Dict([
	("AECG_ica",AECGm_ica),
	("SVDrec",SVDrec),
	("AECG_sort",AECGm_sort),
	("AECG_residual",AECG_residual),
	("heart_rate",heart_rate_mother),
	("QRS_value",QRSm_value),
	("QRS_pos",QRSm_pos)
	])

	fetalVar = Dict([
	("AECG_sort",AECGf_sort),
	("QRS_pos",QRSf_pos),
	("QRS_value",QRSf_value),
	("QRScell_pos",QRSfcell_pos),
	("QRScell_value",QRSfcell_value),
	("heart_rate",heart_rate_feto),
	("QRScell_pos_smooth",QRSfcell_pos_smooth),
	("SMI",SMI),
	("gini_measure",gini_measure)
	])


	return inputVar,motherVar,fetalVar
end
