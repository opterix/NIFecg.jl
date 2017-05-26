module 	fetalSubstractionModule

	#Libraries
	using MultivariateStats
	using DSP

	# Include function files
	path="fetalSubstractionModule/"
	include(path*"makeIcaFetal.jl")
	include(path*"qrsFetalSelector.jl")
	include(path*"giniCoefficient.jl")
	path="share/"
	include(path*"panTomkinsDetector.jl")
	include(path*"smoothRR.jl")
	include(path*"smiComputation.jl")

	export fetalSubstraction

	function fetalSubstraction(AECG_residual,heart_rate_mother,nch,sr,ts)

		# Source separation - ICA
		AECGf_ica = makeIcaFetal(AECG_residual,nch)

		# Select fetal signal
		AECGf_sort = qrsFetalSelector(AECGf_ica, nch)

		# QRS mother detector (Pan - Tomkins)
		(QRSfcell_pos,QRSfcell_value)= panTomkinsDetector(AECGf_sort, sr, nch)
		QRSf_value=QRSfcell_value[1];

		# R-R smoothing
		flag=2; #Apply with fetal frequencies
	    	(QRSfcell_pos_smooth) = smoothRR(QRSfcell_pos, nch, sr,flag);
	
		# I don't now
		SMI = smiComputation(QRSfcell_pos_smooth, nch, sr);

		# Gini process
		gini_measure = zeros(nch)
		for kch in 1:nch
		    if length(QRSfcell_pos_smooth[kch])<=10
		       gini_measure[kch] = 0
		    else
		       gini_measure[kch] = giniCoefficient(AECGf_sort[:,kch])
		    end
		end

		auxidx=sortperm(gini_measure, rev=true);
		AECGf_sort=AECGf_sort[:,auxidx];
		QRSfcell_pos_smooth=QRSfcell_pos_smooth[auxidx];
		QRSfcell_pos=QRSfcell_pos[auxidx];
		QRSfcell_value=QRSfcell_value[auxidx];
		SMI=SMI[auxidx];
		QRSf_pos=QRSfcell_pos_smooth[1];
		gini_measure=gini_measure[auxidx]

	    
		heart_rate_feto = (60*size(QRSf_pos,1))/ts
		FreqDiff = 1 - abs(heart_rate_mother-heart_rate_feto)/heart_rate_mother;

		if FreqDiff > 0.9;
			auxidx = [2,3,4,1];
			AECGf_sort=AECGf_sort[:,auxidx];
			QRSfcell_pos_smooth=QRSfcell_pos_smooth[auxidx];
			QRSfcell_pos=QRSfcell_pos[auxidx];
			QRSfcell_value=QRSfcell_value[auxidx];
			SMI = SMI[auxidx];
			gini_measure=gini_measure[auxidx]
			QRSf_pos=QRSfcell_pos_smooth[1];
			heart_rate_feto = (60*size(QRSf_pos,1))/ts
		end

	return AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure

	end

end
