function medianFilter(AECG_input,sr,nch,ns)
close("all")
AECG_output=zeros(ns,nch);
threshold_global=15;

for i = 1:nch
	signal = AECG_input[:,i];
	#figure(i);plot(signal,color="black");
	#figure(i);plot(signal);
	median_filtered_signal = [];
  
 	# Compute a threshold from median global informaion

	difference_global = abs(signal - median(signal));
  	#figure(i);plot(difference_global);

  	median_difference_global = median(difference_global);
	println("median_difference=$(median_difference_global)");
  	s_global = difference_global / float(median_difference_global);
	#figure(i);plot(s_global);

	mask = s_global .> threshold_global
	signal[mask] = median(signal); # median_difference_global;
	#plot(signal,color="blue");

#=
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
		

		Threshold_local = maximum(s);
		figure(i);plot(t_tmp,ones(window_temp)*Threshold_local,color="yellow");			
		threshold=[];
			

		mask = s .> Threshold_local
		signal_temp[mask] = threshold;# median(signal_temp)
		median_filtered_signal = vcat(median_filtered_signal,signal_temp)
	end
=#

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

