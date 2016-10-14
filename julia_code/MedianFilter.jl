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
 
#responsetype = Lowpass(100;fs=rate_sample)
#designmethod = FIRWindow(hanning(64))
#AECG_output[:,i]=filt(digitalfilter(responsetype, designmethod), signal)

#designmethod = Butterworth(24)
#AECG_output[:,i]=filt(digitalfilter(responsetype, designmethod), signal)

  difference = abs(signal - median(signal))
  median_difference = median(difference)
  s = difference / float(median_difference)  
  threshold = maximum(s)*0.95
  println(threshold)

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
    s = difference / float(median_difference)
    mask = s .> threshold
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
