function MakeICAfeto(signal_orig,nc,nch)

signal_f=copy(signal_orig);

# ------------------- Extract the mean value --------------------#
for i in 1:nch
    signal_f[:,i]= (signal_f[:,i]-mean(signal_f[:,i]))/std(signal_f[:,i]);
end

signal_f=signal_f'

#figure;plot(signal_f');
M = fit(ICA, signal_f, nc;do_whiten=true, maxiter=200, tol=0.0001)#, verbose=true)
W = M.W

signal_f_white = W'*signal_f
signal_f_white = signal_f_white'

return signal_f_white

end
