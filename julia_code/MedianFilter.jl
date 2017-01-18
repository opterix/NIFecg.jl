function MedianFilter(AECG_input,window,ns,nch,sr)

AECG_output=zeros(ns,nch)

for i = 1:nch
	signal = AECG_input[:,i];
	#figure(i);plot(signal);
	median_filtered_signal = [];
	window_temp = window;
  
 	# Compute a threshold from median global informaion

	difference_global = abs(signal - median(signal));
  	#figure(i);plot(difference_global);

  	median_difference_global = median(difference_global);
	println("median_difference=$(median_difference_global)");
  	s_global = difference_global / float(median_difference_global);
	#figure(i);plot(s_global);

	threshold_global = maximum(s_global);
	figure(i);plot(ones(ns)*threshold_global, color="red");

  	for ii in range(0, window_temp, ns)
	    	if ii >= ns
		      	AECG_output[:,i]=median_filtered_signal
	      	break
	    	elseif ii > ns-window_temp
		      	window_temp = ns - size(median_filtered_signal,1)
	    	end
		t_tmp=linspace(ii+1,ii+window_temp,window_temp);
		signal_temp=signal[ii+1: ii+window_temp]
		#figure(i);plot(t_tmp,signal_temp,color="black");
   		
		difference = abs(signal_temp - median(signal_temp))
		figure(i);plot(t_tmp,difference,color="blue");
		
		median_difference = median(difference)
		figure(i);plot(t_tmp,ones(window_temp)*median_difference,color="orange");
		
		s = difference / float(median_difference)
		figure(i);plot(t_tmp,s,color="green");
		
		threshold_local = maximum(s);
		figure(i);plot(t_tmp,ones(window_temp)*threshold_local,color="yellow");		
		
		mask = s .> threshold_local
		if findfirst(mask,1) != 0
			signal_temp[mask] = signal[findfirst(mask,1)];
			#threshold_global;# median(signal_temp)
		end
		median_filtered_signal = vcat(median_filtered_signal,signal_temp)
	end


end

return  AECG_output

end

#for i in 1:m
 #  max_temp=maximum(AECG_input[:,i])
  # min_temp=minimum(AECG_input[:,i])
   #println("AECG_$i:$max_temp")#maximum(AECG[:,i]))
  # println("AECG_$i:$min_temp")#minimum(AECG[:,i]))
 #end

#for i in 1:m
 # max_temp=maximum(AECG[:,i])
  #min_temp=minimum(AECG[:,i])
  #println("AECG_filtered$i:$max_temp")#maximum(AECG[:,i]))
  #println("AECG_filtered$i:$min_temp")#minimum(AECG[:,i]))
#end

