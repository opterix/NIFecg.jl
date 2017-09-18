function convertResultsCsv2Binary()
	
	list_file=dir(pwd);
	num_files = size(list_file,1);

	for i = 3 : num_files
		file_name = list_file(i).name;
		if strcmp(file_name(end-2:end),'csv')
			disp(['Procesando record ',file_name])
			result = int64(csvread(file_name));
            wrann(file_name(1:3),'entry1',result);

        end
	end
end
