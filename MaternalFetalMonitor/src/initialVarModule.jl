module initialVarModule
	
	export initialVar
	export nch,ns,t,sr,fetal_annot,AECG,AECG_clean,motherVar,fetalVar

	function initialVar()
		#global nch=[]
		#global ns=[]
		#global t=[]
		#global sr=[]
		#global fetal_annot=[]
		#global AECG=[]
		#global AECG_clean=[]

		#global motherVar = Dict([
		#("AECGm_ica",[]),
		#("SVDrec",[]),
		#("AECGm_sort",[]),
		#("AECG_residual",[]),
		#("AECG_residual",[]),
		#("heart_rate_mother",[]),
		#("QRSm_value",[]),
		#("QRSm_pos",[])
		#])

		#global fetalVar = Dict([
		#("AECGm_ica",[]),
		#("SVDrec",[]),
		#("AECGm_sort",[]),
		#("AECG_residual",[]),
		#("AECG_residual",[]),
		#("heart_rate_mother",[]),
		#("QRSm_value",[]),
		#("QRSm_pos",[])
		#])

		 nch=[]
		 ns=[]
		 t=[]
		 sr=[]
		 fetal_annot=[]
		 AECG=[]
		 AECG_clean=[]

		 motherVar = Dict([
		("AECGm_ica",[]),
		("SVDrec",[]),
		("AECGm_sort",[]),
		("AECG_residual",[]),
		("AECG_residual",[]),
		("heart_rate_mother",[]),
		("QRSm_value",[]),
		("QRSm_pos",[])
		])

		 fetalVar = Dict([
		("AECGm_ica",[]),
		("SVDrec",[]),
		("AECGm_sort",[]),
		("AECG_residual",[]),
		("AECG_residual",[]),
		("heart_rate_mother",[]),
		("QRSm_value",[]),
		("QRSm_pos",[])
		])

		return nch,ns,t,sr,fetal_annot,AECG,AECG_clean,motherVar,fetalVar
	end

end

