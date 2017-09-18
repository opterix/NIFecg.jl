function convertResultsCsv2Txt(sr,ti,tf)
	
	list_file=readdir(pwd())
	num_files=size(list_file,1)

	for i in 1:num_files
		file_name = list_file[i]
		if file_name[end-2:end] == "csv"
			println("Procesando record $(file_name)")
			fileStat = stat(file_name)
			if fileStat.size > 0
				file_name = file_name[1:end-4]
				result=readcsv(file_name*".csv")

				fbw(x) = x > (ti*sr);
				i_bw = broadcast(fbw,result);
				result=result[i_bw];

				ffw(x) = x < (tf*sr);
				i_fw = broadcast(ffw,result);
				result=result[i_fw];
				result = round(Int64,result)
				println("$(file_name[1:3]).entry1")
				open("$(file_name[1:3]).entry1", "w") do f
					for ii in 1:size(result,1)
						write(f,"$(result[ii])\n")
					end
				end
			else
				println("El archivo esta vacio")
				open("$(file_name[1:3]).entry1", "w") do f
				end
			end

		end
	end
end
