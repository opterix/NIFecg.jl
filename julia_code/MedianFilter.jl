function MedianFilter(AECG_input,threshold,window)

AECG_output=zeros(n,m)

 for i in 1:m
   max_temp=maximum(AECG_input[:,i])
   min_temp=minimum(AECG_input[:,i])
   println("AECG_$i:$max_temp")#maximum(AECG[:,i]))
   println("AECG_$i:$min_temp")#minimum(AECG[:,i]))
 end


for i in 1:m
  signal = AECG_input[:,i]
  median_filtered_signal = []
  window_temp = window

  for ii in range(0, window_temp, n)

    if ii >= n
      AECG_output[:,i]=median_filtered_signal
      break
    elseif ii > n-window_temp
      window_temp = n - size(median_filtered_signal,1)
    end

    signal_temp=signal[ii+1: ii+window_temp]
    difference = abs(signal_temp - median(signal_temp))
    median_difference = median(difference)

    if median_difference == 0
       s = zeros(size(signal_temp))
    else
      s = difference / float(median_difference)
    end
    mask = s .> threshold
    #println(var(signal_temp))
    #println(median(signal_temp))
    signal_temp[mask] = median(signal_temp)
    median_filtered_signal = vcat(median_filtered_signal,signal_temp)
  end

end

for i in 1:m
  max_temp=maximum(AECG[:,i])
  min_temp=minimum(AECG[:,i])
  println("AECG_filtered$i:$max_temp")#maximum(AECG[:,i]))
  println("AECG_filtered$i:$min_temp")#minimum(AECG[:,i]))
end

return  AECG_output

end
