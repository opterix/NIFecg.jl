module 	motherSubstractionModule

	#Libraries
	using MultivariateStats
	using DSP

	# Include function files
	path="motherSubstractionModule/"	
	include(path*"makeIcaMother.jl")
	include(path*"fontSeparationSVD.jl")
	path="share/"
	include(path*"panTomkinsDetector.jl")
	include(path*"smoothRR.jl")
	include(path*"smiComputation.jl")
	path="preProcessingModule/"
	include(path*"medianFilter.jl")

	export motherSubstraction

	function motherSubstraction(AECG_clean,nch,sr,ns,ti,tf)

		# Source separation - ICA 
		(AECGm_ica) = makeIcaMother(AECG_clean,nch)
		#(AECGm_ica) = medianFilter(AECGm_ica,sr,nch,ns);

		# QRS mother detector (Pan - Tomkins)
		(QRSmcell_pos, QRSmcell_value)=panTomkinsDetector(AECGm_ica, sr, nch);
		QRSm_pos=QRSmcell_pos[1];
		QRSm_value=QRSmcell_value[1];
	    
		# R-R smoothing
	    	flag = 1; #Apply with mother frequencies
		(QRSmcell_pos_smooth) = smoothRR(QRSmcell_pos, nch, sr,flag);

		# I don't now
		SMI = smiComputation(QRSmcell_pos_smooth, nch, sr);
	
		# Updating values
		auxidx=sortperm(vec(SMI)); 
		AECGm_sort=AECGm_ica[:,auxidx];
		QRSmcell_pos_smooth=QRSmcell_pos_smooth[auxidx];
		QRSmcell_pos=QRSmcell_pos[auxidx];
		QRSmcell_value=QRSmcell_value[auxidx];
		SMI=SMI[auxidx];
		QRSm_pos=QRSmcell_pos_smooth[1];
	
		#  Computation of heart rate mother
		heart_rate_mother = (60*size(QRSm_pos,1))/(tf-ti)
		# SVD process and subtract mother signal
		(SVDrec,AECG_residual) = fontSeparationSVD(AECG_clean,QRSm_pos,sr,nch,ns);
		(AECG_residual) = medianFilter(AECG_residual,sr,nch,ns);

	return heart_rate_mother,AECGm_ica,SVDrec,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value

	end
end

