function preProcessingModule(AECG,sr)

	include("Notch_Filter_Detrent.jl")
	
	#Notch Filtering and detrending
	(AECG_clean, lowSignal) = notch_filter(AECG, sr)

	return AECG_clean, lowSignal

end
