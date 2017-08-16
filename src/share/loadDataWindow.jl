function loadDataWindow(AECG,sr,ti,tf)
	
	# Load data according global varaibles
	AECG = AECG[ti*sr+1:tf*sr,:];

return AECG

end
