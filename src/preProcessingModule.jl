module preProcessingModule
	
	#Libraries 
	using DSP

	# Include function files	
	include("preProcessingModule/notchFilter.jl")
	include("preProcessingModule/medianFilter.jl")
	
	export preProcessing

	function preProcessing(AECG,sr)
	
		# Notch Filtering and detrending
		(AECG_clean, lowSignal) = notchFilter(AECG, sr)
		
		# Median Filter
#		window=30
#	(AECG_clean) = medianFilter(AECG_clean,window,sr)
		
		return AECG_clean

	end

end
