function processSvs(filename)

	a=readcsv(filename*".csv") #read file

	#Detección de los headers del archivo csv	
	f(x) = typeof(x) == Float64 || typeof(x) == Int64 
	bool_string = broadcast(f,a[:,1])
	indx=findfirst(bool_string)

	#Extraer la información del archivo
	t=a[indx:end, 1]
	b=a[indx:end, 2:end] 

	#Busca y convierte los valores NaN en 0
	bool_floats = broadcast(f,b)
	bool_floats=convert(Array{Bool,2}, bool_floats)	
	b[~bool_floats] = 0 #Convert all non-number strings to NaN
	b=convert(Array{Float64,2}, b) #Convert to Float array

	return t, b
end
