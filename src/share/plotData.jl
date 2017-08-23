function plotData(inputVar,motherVar,fetalVar,graph=0)

	nch = inputVar["nch"];
	sr = inputVar["sr"];
	ti = sr * inputVar["ti"]+1;
	tf = sr * inputVar["tf"];
	t = inputVar["t"];
	ns = inputVar["ns"];
	nch = inputVar["nch"];
	fetal_annot = inputVar["fetal_annot"];
	AECG = inputVar["AECG"];
	AECG_clean = inputVar["AECG_clean"]; 

	close("all")

	#-----------------------------------------------
	if findfirst(graph,1) != 0 || findfirst(graph,0) != 0
		figure(1)
		for i in 1:nch
		subplot("$(nch)1$(i)")
	    	plot(t[ti:tf], AECG[1:ns,i], color="black", linewidth=1.0, linestyle="-")
		title("Original signals")
		end
	end

	#-----------------------------------------------
	if findfirst(graph,2) != 0 || findfirst(graph,0) != 0
		figure(2)
	    
		for i in 1:nch
		subplot("$(nch)1$(i)")
		plot(t[ti:tf], AECG_clean[1:ns,i], color="black", linewidth=1.0, linestyle="-")
		title("Filtered signals")        
		end
	end

	#-----------------------------------------------
	if findfirst(graph,3) != 0 || findfirst(graph,0) != 0
		figure(3)
		for i in 1:nch
		subplot("$(nch)1$(i)")
		plot(t[ti:tf], motherVar["AECG_ica"][1:ns,i], color="black", linewidth=1.0, linestyle="-")
		plot(motherVar["QRS_pos"][:,1]',zeros(size(motherVar["QRS_pos"],1),1)', "ro")
		title("First ICA")
		end
	end

	#-----------------------------------------------
	if findfirst(graph,4) != 0 || findfirst(graph,0) != 0
		figure(4)
		for i in 1:nch
		subplot("41$(i)")    
		plot(t[ti:tf], motherVar["AECG_residual"][1:ns,i], color="black", linewidth=1.0, linestyle="-")
		if fetal_annot!= 0; plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go"); end
		title("residual signals")
		end
	end

	#-----------------------------------------------
	if findfirst(graph,5) != 0 || findfirst(graph,0) != 0
		figure(5)

		a=collect(-999.9:0.2:999.9)/2;  #Solamente funciona en ventanas de 10segundos

		for i in 1:nch
		subplot("42$(2*i-1)")    
		plot(a,abs(fftshift(fft(motherVar["AECG_residual"][1:ns,i]))), color="black", linewidth=1.0, linestyle="-")
		xlim(0, 100);

		subplot("42$(2*i)")
		plot(t[ti:tf], motherVar["AECG_residual"][1:ns,i], color="black", linewidth=1.0, linestyle="-")
		if fetal_annot != 0; plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go"); end 
		title("Residuals signals")
		end
	end

	#-----------------------------------------------
	if findfirst(graph,6) != 0 || findfirst(graph,0) != 0
		figure(6)

		for i in 1:nch
		subplot("42$(2*i-1)")
		plot(t[ti:tf], fetalVar["AECG_sort"][1:ns,i], color="black", linewidth=1.0, linestyle="-")
		if fetal_annot!= 0; plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go"); end
		plot(fetalVar["QRScell_pos_smooth"][i], zeros(size(fetalVar["QRScell_pos_smooth"][i],1),1), "ro")
		title("Sorted Second ICA signals. SMI=$(fetalVar["SMI"][i]). gini=$(fetalVar["gini_measure"][i])")

		subplot("42$(2*i)")
		plot(t[ti:tf], fetalVar["AECG_sort"][1:ns,i], color="black", linewidth=1.0, linestyle="-")
		if fetal_annot!= 0; plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go"); end
		plot(fetalVar["QRScell_pos"][i]',fetalVar["QRScell_value"][i]', "ro")
		title("Sorted Second ICA signals")
		end
	end

	#-----------------------------------------------
	if findfirst(graph,7) != 0 || findfirst(graph,0) != 0
		figure(7)
		subplot(211)
		title("Ritmo cardíaco materno = $(motherVar["heart_rate"])")
		plot(t[ti:tf], motherVar["AECG_sort"][1:ns,1], color="black", linewidth=1.0, linestyle="-")
		plot(motherVar["QRS_pos"][:,1]',zeros(size(motherVar["QRS_pos"],1),1)', "ro")

		subplot(212)
		title("Ritmo cardíaco fetal = $(fetalVar["heart_rate"])")    
		plot(t[ti:tf], fetalVar["AECG_sort"][1:ns,1], color="black", linewidth=1.0, linestyle="-")
		if fetal_annot!= 0; plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go"); end
		plot(fetalVar["QRS_pos"][:,1], zeros(size(fetalVar["QRS_pos"][:,1],1),1)+0.5, "bo")
	end

end
