function MakeICAfeto(signal_orig)

k=4

signal_f=copy(signal_orig);

# ------------------- Extract the mean value --------------------#
for i in 1:size(signal_f,2)
    signal_f[:,i]= (signal_f[:,i]-mean(signal_f[:,i]))/std(signal_f[:,i]);
end

signal_f=signal_f'

#figure();plot(signal_f');



srand(15678)

M = fit(ICA, signal_f, k;do_whiten=true, maxiter=200, tol=0.0001, verbose=true)#, winit=zeros(k,k))
W = M.W

signal_f_white = W'*signal_f
signal_f_white = signal_f_white'

return signal_f_white

end
