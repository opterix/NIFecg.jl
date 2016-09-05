
medianfilter1(v,ws) = [median(v[i:(i+ws-1)]) for i=1:(length(v)-ws+1)]

medianfilter(v) = medianfilter1(vcat(0,v,0),3)
