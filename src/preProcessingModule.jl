function preProcessingModule(AECG,sr)

	# Include function files	
	include("notchFilter.jl")
	
	# Notch Filtering and detrending
	(AECG_clean, lowSignal) = notchFilter(AECG, sr)

	return AECG_clean

end
