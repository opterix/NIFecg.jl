function MFMTestDB(ti,tf,sr)

	# ti =  time signal in seconds (Uint32)	
	# tf =  time signal in seconds (Uint32)
	# sr =  sample rate (UInt64)
	# Notes: the module search in the current directory csv files

	list_file=readdir(pwd())
	num_files=size(list_file,1)

	for i in 1:num_files
		file_name = list_file[i]
		if file_name[end-2:end] == "csv"
			file_name = file_name[1:end-4]
			println("Procesando record $(file_name)")
			(inputVar,motherVar,fetalVar)=MFMTest(file_name,ti,tf,sr)
			saveFetalDetecTxt(file_name,fetalVar["QRS_pos"])
		end
	end

end

function saveFetalDetecTxt(filename,fetal_measure)

	open(filename*"_fet_result.fqrs.txt", "w") do f
		for i in 1:size(fetal_measure[:,1],1)
			write(f,"$(fetal_measure[i,1])\n")
		end
	end

end
