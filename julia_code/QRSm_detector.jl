function QRSm_detector(signal_mother)

threshold_detc=0.3
threshold_avoidnoise=200
signal = signal_mother[1:num_sample,1]
max_value = maximum(signal)
min_value = minimum(signal)

init=1000
 scale_signal = []#zeros(num_sample,1)

point_temp_max = zeros(num_sample,init)
pos_temp_max = zeros(num_sample,init)
point_temp_min = zeros(num_sample,init)
pos_temp_min = zeros(num_sample,init)
QRSm_pos_temp = ones(2,init)*NaN
QRSm_value_temp = ones(2,init)*NaN

acum_noise_max = threshold_avoidnoise
acum_noise_min = threshold_avoidnoise
acum_max = 0
acum_min = 0
indx_max = 1
indx_min = 1


for i in 1:num_sample
 scale_signal = (signal[i,1]-min_value)/(max_value-min_value)
#println(i)
    #------ max peaks -------------------
    #(acum_max,indx_max)= max_points(acum_max,indx_max)
  if scale_signal >= (1-threshold_detc) && acum_noise_max >= threshold_avoidnoise
      acum_max=acum_max+1
      point_temp_max[acum_max,indx_max] = signal[i,1]
      pos_temp_max[acum_max,indx_max] = i/rate_sample
    else
     if acum_max != 0
       value_temp , pos= findmax( point_temp_max[:,indx_max] )
       QRSm_pos_temp[1,indx_max] = pos_temp_max[pos,indx_max]
       QRSm_value_temp[1,indx_max] =  value_temp
       indx_max=indx_max+1
       acum_max=0
       acum_noise_max=0
     end
     acum_noise_max=acum_noise_max+1
  end

    #------ min peaks -------------------
    #(acum_min,indx_min)= min_points(acum_min,indx_min)
  if scale_signal <= (threshold_detc) && acum_noise_min >= threshold_avoidnoise
       acum_min=acum_min+1
       point_temp_min[acum_min,indx_min] = signal[i,1]
       pos_temp_min[acum_min,indx_min] = i/rate_sample
    else
      if acum_min != 0
        value_temp , pos= findmin( point_temp_min[:,indx_min] )
        QRSm_pos_temp[2,indx_min] = pos_temp_min[pos,indx_min]
        QRSm_value_temp[2,indx_min] =  value_temp
        indx_min=indx_min+1
        acum_min=0
        acum_noise_min = 0
      end
      acum_noise_min=acum_noise_min+1
  end

end

if indx_min > indx_max
   QRSm_pos = QRSm_pos_temp[1,1:indx_max-1]
   QRSm_value = QRSm_value_temp[1,1:indx_max-1]
else
  QRSm_pos = QRSm_pos_temp[2,1:indx_min-1]
  QRSm_value = QRSm_value_temp[2,1:indx_min-1]
end

return QRSm_pos , QRSm_value

end
