function QRSf_detector(signal_feto,ns,sr)

num_channel=1;

threshold_detc=0.2# threshold in relation of maximum and minumim values
threshold_avoidnoise=200#constraint to avoid the estimation of several peaks by noise in small window.

signal = signal_feto[1:ns,num_channel] # suppose that the signal mother is the first independent component
max_value = maximum(signal)
min_value = minimum(signal)


# initialization matrices
init=1000 # variable to initialize matrices
scale_signal = []
point_temp_max = zeros(ns,init)
pos_temp_max = zeros(ns,init)
point_temp_min = zeros(ns,init)
pos_temp_min = zeros(ns,init)
QRSf_pos_temp = ones(2,init)*NaN
QRSf_value_temp = ones(2,init)*NaN

acum_noise_max = threshold_avoidnoise
acum_noise_min = threshold_avoidnoise
acum_max = 0; acum_min = 0;
indx_max = 1; indx_min = 1;


for i=1:ns
 # normalize signal 0-1 
 scale_signal = (signal[i,1]-min_value)/(max_value-min_value)

    #------ max peaks -------------------
#only take into account the values under 0.7 values and no continue values among 200ms
  if scale_signal >= (1-threshold_detc) && acum_noise_max >= threshold_avoidnoise
      acum_max=acum_max+1 # number os samples under 0.7
      point_temp_max[acum_max,indx_max] = signal[i,1] #storage the values since exceeds the threshold until fall behind this.  
      pos_temp_max[acum_max,indx_max] = i/sr #position of these values 
    else
     if acum_max  !=0
       value_temp , pos= findmax( point_temp_max[:,indx_max] ) # find the higher peak
       QRSf_pos_temp[1,indx_max] = pos_temp_max[pos,indx_max] # storage in the final variabñes
       QRSf_value_temp[1,indx_max] =  value_temp
       indx_max=indx_max+1 # restart the indx
       acum_max=0
       acum_noise_max=0
     end
 # allows to search other peaks near of last peak founded
     if acum_noise_max <=10 && QRSf_value_temp[1,end] < signal[i,1]
	QRSf_value_temp[1,end] = signal[i,1]
        QRSf_pos_temp[1,end] = i
     end
     acum_noise_max=acum_noise_max+1
  end

    #------ min peaks -------------------
  if scale_signal <= (threshold_detc) && acum_noise_min >= threshold_avoidnoise
       acum_min=acum_min+1
       point_temp_min[acum_min,indx_min] = signal[i,1]
       pos_temp_min[acum_min,indx_min] = i/sr
    else
      if acum_min !=0
        value_temp , pos= findmin( point_temp_min[:,indx_min] )
        QRSf_pos_temp[2,indx_min] = pos_temp_min[pos,indx_min]
        QRSf_value_temp[2,indx_min] =  value_temp
        indx_min=indx_min+1
        acum_min=0
        acum_noise_min = 0
      end
     if acum_noise_max <=10 && QRSf_value_temp[2,end] < signal[i,1]
	QRSf_value_temp[2,end] = signal[i,1]
        QRSf_pos_temp[2,end] = i
     end
      acum_noise_min=acum_noise_min+1
  end

end

# assign the minimum number of peaks founded between min and max peaks
if indx_min > indx_max
   QRSf_pos = QRSf_pos_temp[1,1:indx_max-1]
   QRSf_value = QRSf_value_temp[1,1:indx_max-1]
else
  QRSf_pos = QRSf_pos_temp[2,1:indx_min-1]
  QRSf_value = QRSf_value_temp[2,1:indx_min-1]
end

return QRSf_pos , QRSf_value

end
