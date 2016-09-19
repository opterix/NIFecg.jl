function SortICA(AECG_white)

variance = zeros(m)
for i in 1:m
  variance[i]=var(AECG_white[:,i])
end

variance_sort = sortperm(variance,rev=true)

AECG_sort = zeros(n,m)
for i in 1:m
  indx=variance_sort[i]
  AECG_sort[:,i]=AECG_white[:,indx]
end

#AECG_sort= AECG_sort'


return AECG_sort

end
