module loadDataModule
	
	# Include function files
	path="loadDataModule/"	
	include(path*"processSvs.jl")
	include(path*"processTxt.jl")

	export loadData

	function loadData(filename,ns)
	
		# Read and fix data
		(t,AECG) = processSvs(filename)
		fetal_annot = processTxt(filename,ns)

		# Load data according global varaibles
		AECG = AECG[1:ns,:]
		t = t[1:ns,:]
		nch = size(AECG,2) # nch - number of channels

		return nch,t,AECG,fetal_annot

	end
end
