function InterpSignal(AECG_white)

Fe = 1000; #Sample rate
Te = 1/Fe;
Nech = 60000; #number of samples
AECG_resample=zeros(120000,4)
signal_resmp=[]
time = ([0:Te:(Nech-1)*Te]);

Finterp = 2*Fe;
Tinterp = 1/Finterp;
t_interp = [0:Tinterp:(Nech)*Te];
t_interp=t_interp[1:120000,1]

new_size=n*fact;

for i in 1:m

signal=(AECG_white[:,i]')';


if new_size > n
    incr = 1;
else
    if new_size==0
       signal_resmp=[]
       return
    end
    incr = floor(n/new_size) + 1;
    new_size = incr*new_size;
end

 a = fft(signal,1);
 nyqst = ceil((n+1)/2);
 p1=a[1:nyqst,:]
 p2=zeros(new_size-n,1)
 p3=a[nyqst+1:n,:]
 b = [p1' p2' p3']'
 if rem(1,2) == 0
    b[nyqst,:] = b[nyqst,:]/2
    b[nyqst+new_size-n,:] = b[nyqst,:]
 end

 signal_resmp = ifft(b,1);
 if isreal(signal)
    signal_resmp = real(signal_resmp)
 end
 signal_resmp = signal_resmp * new_size / n;
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
