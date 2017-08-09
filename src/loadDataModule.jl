module loadDataModule
	
	# Include function files
	path="loadDataModule/"	
	include(path*"processSvs.jl")
	include(path*"processTxt.jl")

	export loadData

	function loadData(T4filename,ns,sr,ti,tf)
	
		# Read and fix data
		(t,AECG) = processSvs(filename)

		# Load data according global varaibles
		AECG = AECG[ti*sr+2:tf*sr+1,:]
		t = t[ti*sr+2:tf*sr+1,1]
		nch = size(AECG,2) # nch - number of channels

		#Read txt annotations if it exist		
		annot_search = filter(x->contains(x,(filename*".fqrs")), readdir(pwd()))
		if length(annot_search) != 0
			fetal_annot = processTxt(filename,ns)
		else
			fetal_annot = 0
		end

		return nch,t,AECG,fetal_annot

	end
end
