function processTxt(filename,ns,sr,ti,tf)
   		
	a=readdlm(filename*".fqrs.txt")
	z(x) = x<ns
	idx=broadcast(z,a)
	a=a[idx]

	fbw(x) = x > (ti*sr);
	i_bw = broadcast(fbw,a);
	a=a[i_bw];

	ffw(x) = x < (tf*sr);
	i_fw = broadcast(ffw,a);
	a=a[i_fw];

	return a
end
