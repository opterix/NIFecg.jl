function processTxt(filename,ns)
   		
	a=readdlm(filename*".fqrs.txt")
	z(x) = x<ns
	idx=broadcast(z,a)
	a=a[idx]

	return a
end
