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

			fetal_annot = inputVar["fetal_annot"];
			fetal_annot = convert(Array{Int64,1},floor(fetal_annot));
			saveFetalAnnotation("csv",file_name,fetal_annot)			

			data = fetalVar["QRS_pos"] * sr;
			data = convert(Array{Int64,1},floor(data));
			saveFetalDetec("csv",file_name,data)
		end
	end

end

function saveFetalAnnotation(typeFile,filename,fetal_measure)

	if typeFile == "txt"
		open(filename*"Annotation.fqrs.txt", "w") do f
			for i in 1:size(fetal_measure[:,1],1)
				write(f,"$(fetal_measure[i,1])\n")
			end
		end
	else
		writecsv(filename*"_annot.csv",fetal_measure)

	end

end

function saveFetalDetec(typeFile,filename,fetal_measure)

	if typeFile == "txt"
		open(filename*"FetalResult.fqrs.txt", "w") do f
			for i in 1:size(fetal_measure[:,1],1)
				write(f,"$(fetal_measure[i,1])\n")
			end
		end
	else
		writecsv(filename*"_result.csv",fetal_measure)
	end

end
