
function QRSm_detector(signal)

threshold=0.2

#for i in 1:m
signal = signal[1:num_sample,1]

max_value = maximum(signal)
min_value = minimum(signal)
#
escale_signal = []#zeros(num_sample,1)
point_temp = zeros(num_sample,200)
pos_temp = zeros(num_sample,200)
QRSm_pos = ones(1,200)*NaN
QRSm_value = ones(1,200)*NaN
#
acum=0
acum=0

indx=1
indx=1

for i in 1:num_sample
 escale_signal = (signal[i,1]-min_value)/(max_value-min_value)

############## MAX #############
if escale_signal >= (1-threshold)
   acum=acum+1
   point_temp[acum,indx] = signal[i,1]
   pos_temp[acum,indx] = i/1000
else
  if acum != 0
    value_temp , pos= findmax( point_temp[:,indx] )
    QRSm_pos[1,indx] = pos_temp[pos,indx]
    QRSm_value[1,indx] =  value_temp
    indx=indx+1
  end
   acum=0
end

# ############## MIN #############
# if escale_signal <= (threshold)
#    acum=acum+1
#    point_temp[acum,indx] = signal[i,1]
#    pos_temp[acum,indx] = i/1000
# else
#   if acum != 0
#     value_temp , pos= findmin( point_temp[:,indx] )
#     QRSm_pos[2,indx] = pos_temp[pos,indx]
#     QRSm_value[2,indx] =  value_temp
#     indx=indx+1
#   end
#    acum=0
# end


end


return QRSm_pos , QRSm_value

end

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