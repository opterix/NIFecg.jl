function processTxt(filepath,ns)
   
	a=readdlm("../data/Annotations/"*filepath*".fqrs.txt")
	z(x) = x<ns
	idx=broadcast(z,a)
	a=a[idx]

	return a
end
