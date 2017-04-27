function loadDataModule(filename,ns)
	
	# Include function files	
	include("processSvs.jl")
	include("processTxt.jl")

	# Read and fix data
	(t,AECG) = processSvs(filename)
	fetal_annot = processTxt(filename,ns)

	# Load data according global varaibles
	AECG = AECG[1:ns,:]
	t = t[1:ns,:]
	nch = size(AECG,2) # nch - number of channels

	return nch,t,AECG,fetal_annot

end
