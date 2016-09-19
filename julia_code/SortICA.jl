function SortICA(AECG_white)

variance = zeros(m)
for i in 1:m
  variance[i]=var(AECG_white[:,i])
end
println(variance)
variance_sort = sortperm(variance,rev=true)

AECG_sort = zeros(n,m)
for i in 1:m
  indx=variance_sort[i]
  AECG_sort[:,i]=AECG_white[:,indx]
end

return AECG_sort

end
