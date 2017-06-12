module loadDataModule
	
	# Include function files
	path="loadDataModule/"	
	include(path*"processSvs.jl")
	include(path*"processTxt.jl")

	export loadData

	function loadData(filename,ns)
	
		# Read and fix data
		(t,AECG) = processSvs(filename)

		# Load data according global varaibles
		AECG = AECG[1:ns,:]
		t = t[1:ns,:]
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
