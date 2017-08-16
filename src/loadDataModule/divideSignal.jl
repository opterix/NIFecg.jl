function divideSignal(AECG,ns,nch,f)
	nsdFloat = (ns/f)	
	nsdInt = Int64(ceil(ns/f))
	nsAcum = 0;
	nsLimits = zeros(f,2);
	for i = 1: f
		nsLimits[i,1] = Int64(nsAcum + 1);
		nsAcum = nsdInt + nsAcum
		nsLimits[i,2] = Int64(nsAcum);
		if nsAcum > ns
			nsLimits[end,2] = Int64(ns);
		end
	end

return nsLimits

end
