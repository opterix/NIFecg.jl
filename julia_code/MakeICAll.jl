function MakeICAll(signal_orig,nch,ns,nc)

signal=copy(signal_orig')

# ------------------- Extract the mean value --------------------#
for i in 1:nch
    signal[:,i]= (signal[:,i]-mean(signal[:,i]))/std(signal[:,i]);
end

#------------------------

srand(15678)

## icagfun

#f = icagfun(:tanh)
#u, v = evaluate(f, 1.5)

#f = icagfun(:tanh, 1.5)
#u, v = evaluate(f, 1.2)

#f = icagfun(:gaus)
#u, v = evaluate(f, 1.5)

#-------------- FastICA --------------

#M = fit(ICA, signal, nc; do_whiten=false)
#W = M.W
#signal_nowhite = W'*signal
#signal_nowhite = signal_nowhite'

M = fit(ICA, signal, nc; do_whiten=true, maxiter=200, tol=0.0001)#, verbose=true)
W = M.W
signal_white = W'*signal
signal_white = signal_white'

return signal_white

end
