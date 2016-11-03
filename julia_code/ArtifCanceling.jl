
medianfilter1(v,ws) = [median(v[i:(i+ws-m)]) for i=1:(length(v)-ws+m)]

medianfilter(v) = medianfilter1(vcat(0,v,0),8)
