module preProcessingModule
	
	#Libraries 
	using DSP

	# Include function files	
	include("preProcessingModule/notchFilter.jl")
	
	export preProcessing

	function preProcessing(AECG,sr)
	
		# Notch Filtering and detrending
		(AECG_clean, lowSignal) = notchFilter(AECG, sr)

		return AECG_clean

	end

end
