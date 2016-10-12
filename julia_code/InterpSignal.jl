function InterpSignal(AECG_white)

new_size=num_sample*fact;

Te = 1/rate_sample;
AECG_resample=zeros(new_size,m)
signal_resmp=[]
#time = ([0:Te:(num_sample-1)*Te]);

Finterp = fact*rate_sample;
Tinterp = 1/Finterp;
t_interp = [0:Tinterp:(num_sample)*Te];
t_interp = t_interp[1:new_size,1]

for i in 1:m

signal=(AECG_white[:,i]')';


if new_size > num_sample
    incr = 1;
else
    if new_size==0
       signal_resmp=[]
       return
    end
    incr = floor(num_sample/new_size) + 1;
    new_size = incr*new_size;
end

 a = fft(signal,1);
 nyqst = ceil((num_sample+1)/2);
 p1=a[1:nyqst,:]
 p2=zeros(new_size-num_sample,1)
 p3=a[nyqst+1:num_sample,:]
 b = [p1' p2' p3']'
 if rem(1,2) == 0
    b[nyqst,:] = b[nyqst,:]/2
    b[nyqst+new_size-num_sample,:] = b[nyqst,:]
 end

 signal_resmp = ifft(b,1);
 if isreal(signal)
    signal_resmp = real(signal_resmp)
 end
 signal_resmp = signal_resmp * new_size / num_sample;
 signal_resmp = signal_resmp[1:incr:new_size,:]  #% Skip over extra points when oldny <= 1.
size(signal_resmp)

AECG_resample[:,i] = signal_resmp



# if i== 1
#   PyPlot.close("all")
# end
# figure("$(i)")
#   subplot(211)
#   title("Signal")
#   plot(time,signal)
#   subplot(212)
#   plot(t_interp,(AECG_resample[:,i]),color="red")

end

return t_interp, AECG_resample

end
