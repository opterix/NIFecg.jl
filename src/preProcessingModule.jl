module preProcessingModule
	
	#Libraries 
	using DSP

	# Include function files	
	include("preProcessingModule/notchFilter.jl")
	include("preProcessingModule/medianFilter.jl")

	export preProcessing

	function preProcessing(AECG,sr,nch,ns)
	
		# Notch Filtering and detrending
		(AECG_clean, lowSignal) = notchFilter(AECG, sr);
		
		# Median Filter
		#(AECG_clean) = medianFilter(AECG_clean,sr,nch,ns);
		
		return AECG_clean

	end

end
