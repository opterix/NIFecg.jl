function MFMTestDBPlot(ts,sr)
	# Run the maternal-fetal monitor in database and save images of plot

	# ts =  time signal in seconds (Uint32)
	# sr =  sample rate (UInt64)
	# Notes: the module search in the current directory csv files

	list_file=readdir(pwd())
	num_files=size(list_file,1)

	for i in 1:num_files
		file_name = list_file[i]
		if file_name[end-2:end] == "csv"
			file_name = file_name[1:end-4]
			println("Procesando record $(file_name)")
			(inputVar,motherVar,fetalVar)=MFMTest(file_name,ts,sr)
			plotSavePlot(inputVar,motherVar,fetalVar)
		end
	end
end


function plotSavePlot(inputVar,motherVar,fetalVar)

	plotData(inputVar,motherVar,fetalVar,[1])
	manager = get_current_fig_manager()
	manager[:window][:attributes]("-zoomed", 1)
	sleep(1)
	manager[:window][:attributes]("-zoomed", 2)
	savefig(file_name*"_plot$(1).png")

	plotData(inputVar,motherVar,fetalVar,[2])
	manager = get_current_fig_manager()
	manager[:window][:attributes]("-zoomed", 1)
	sleep(1)
	manager[:window][:attributes]("-zoomed", 2)
	savefig(file_name*"_plot$(2).png")

	plotData(inputVar,motherVar,fetalVar,[3])
	manager = get_current_fig_manager()
	manager[:window][:attributes]("-zoomed", 1)
	sleep(1)
	manager[:window][:attributes]("-zoomed", 2)
	savefig(file_name*"_plot$(3).png")

	plotData(inputVar,motherVar,fetalVar,[4])
	manager = get_current_fig_manager()
	manager[:window][:attributes]("-zoomed", 1)
	sleep(1)
	manager[:window][:attributes]("-zoomed", 2)
	savefig(file_name*"_plot$(4).png")
	    
	plotData(inputVar,motherVar,fetalVar,[6])
	manager = get_current_fig_manager()
	manager[:window][:attributes]("-zoomed", 1)
	sleep(1)
	manager[:window][:attributes]("-zoomed", 2)
	savefig(file_name*"_plot$(6).png")  

	plotData(inputVar,motherVar,fetalVar,[7])
	manager = get_current_fig_manager()
	manager[:window][:attributes]("-zoomed", 1)
	sleep(1)
	manager[:window][:attributes]("-zoomed", 2)
	savefig(file_name*"_plot$(7).png")

	close("all")

end



