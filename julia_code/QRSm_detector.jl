function QRSm_detector(signal_mother)

threshold_detc=0.2

signal = signal_mother[1:num_sample,1]
max_value = maximum(signal)
min_value = minimum(signal)

init=500
 scale_signal = []#zeros(num_sample,1)

point_temp_max = zeros(num_sample,init)
pos_temp_max = zeros(num_sample,init)
point_temp_min = zeros(num_sample,init)
pos_temp_min = zeros(num_sample,init)
QRSm_pos_temp = ones(2,init)*NaN
QRSm_value_temp = ones(2,init)*NaN
 #global QRSm_pos = ones(2,2000)*NaN
 #global QRSm_value = ones(2,2000)*NaN

acum_max = 0
acum_min = 0
indx_max = 1
indx_min = 1


for i in 1:num_sample
 scale_signal = (signal[i,1]-min_value)/(max_value-min_value)
#println(i)
    #------ max peaks -------------------
    #(acum_max,indx_max)= max_points(acum_max,indx_max)
  if scale_signal >= (1-threshold_detc)
      acum_max=acum_max+1
      point_temp_max[acum_max,indx_max] = signal[i,1]
      pos_temp_max[acum_max,indx_max] = i/rate_sample
    else
     if acum_max != 0
       value_temp , pos= findmax( point_temp_max[:,indx_max] )
       QRSm_pos_temp[1,indx_max] = pos_temp_max[pos,indx_max]
       QRSm_value_temp[1,indx_max] =  value_temp
       indx_max=indx_max+1
     end
      acum_max=0
  end

    #------ min peaks -------------------
    #(acum_min,indx_min)= min_points(acum_min,indx_min)
  if scale_signal <= (threshold_detc)
       acum_min=acum_min+1
       point_temp_min[acum_min,indx_min] = signal[i,1]
       pos_temp_min[acum_min,indx_min] = i/rate_sample
    else
      if acum_min != 0
        value_temp , pos= findmin( point_temp_min[:,indx_min] )
        QRSm_pos_temp[2,indx_min] = pos_temp_min[pos,indx_min]
        QRSm_value_temp[2,indx_min] =  value_temp
        indx_min=indx_min+1
      end
       acum_min=0
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



########################################
# function max_points(acum,indx)
#   if scale_signal >= (1-threshold_detc)
#      acum=acum+1
#      point_temp_max[acum,indx] = signal[i,1]
#      pos_temp_max[acum,indx] = i/rate_sample
#   else
#     if acum != 0
#       value_temp , pos= findmax( point_temp_max[:,indx] )
#       QRSm_pos_temp[1,indx] = pos_temp_max[pos,indx]
#       QRSm_value_temp[1,indx] =  value_temp
#       indx=indx+1
#     end
#      acum=0
#   end
#   return acum, indx
# end
#
# #########################################
# function min_points(acum,indx)
#   if scale_signal <= (threshold_detc)
#       acum=acum+1
#       point_temp_min[acum,indx] = signal[i,1]
#       pos_temp_min[acum,indx] = i/rate_sample
#    else
#      if acum != 0
#        value_temp , pos= findmin( point_temp_min[:,indx] )
#        QRSm_pos_temp[2,indx] = pos_temp_min[pos,indx]
#        QRSm_value_temp[2,indx] =  value_temp
#        indx=indx+1
#      end
#       acum=0
#    end
#    return acum, indx
# end



# point = point_temp[1:acum,1]
# #sorting_values=sort(signal,1, rev=true)


#A = convert(Array{FloatingPoint}, signal)


#minval, maxval = minmax_filter(A, 1) #verbose=false)
#maxval=maxval'

#matching = A[1:size(maxval)[2]]
#matching = matching .== maxval

#peaks = maxval[matching]
#peaks = peaks[peaks .>= 0.1 * maximum(peaks)]


#
#
# sampFreq=1000
# num_sample = length(signal)
# p = fft(signal)
#
# nUniquePts = ceil(Int, (num_sample+1)/2)
# p = p[1:nUniquePts]
# p = abs(p)
#
# p = p / num_sample #scale
# p = p.^2  # square it
# # odd nfft excludes Nyquist point
# if num_sample % 2 > 0
#     p[2:length(p)] = p[2:length(p)]*2 # we've got odd number of   points fft
# else
#     p[2: (length(p) -1)] = p[2: (length(p) -1)]*2 # we've got even number of points fft
# end
#
#
# freqArray = (0:(nUniquePts-1)) * (sampFreq / num_sample)
# plot(scatter(;x=freqArray/1000, y=10*log10(p)),
#      Layout(xaxis_title="Frequency (kHz)",
#             xaxis_zeroline=false,
#             xaxis_showline=true,
#             xaxis_mirror=true,
#             yaxis_title="Power (dB)",
#             yaxis_zeroline=false,
#             yaxis_showline=true,
#             yaxis_mirror=true))
#
#
# #end
