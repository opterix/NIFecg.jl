function saveResults(filename,fetal_measure)

open("../data/Results/"*filename*"FetalResult.fqrs.txt", "w") do f
	for i in 1:size(fetal_measure[:,1],1)
		write(f," $(fetal_measure[i,1]) \n")
	end
end

end
