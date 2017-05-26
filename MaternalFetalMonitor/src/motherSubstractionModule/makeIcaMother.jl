function makeIcaMother(signal_orig,nch)

signal=copy(signal_orig)

# Extract the mean value
for i in 1:nch
    signal[:,i]= (signal[:,i]-mean(signal[:,i]))/std(signal[:,i]);
end


signal=signal'

srand(15678)

# FastICA

M = fit(ICA, signal, nch; do_whiten=false)
W = M.W
signal_nowhite = W'*signal
signal_nowhite = signal_nowhite'

M = fit(ICA, signal, nch; do_whiten=true, maxiter=200, tol=0.0001)
W = M.W
signal_white = W'*signal
signal_white = signal_white'

return signal_white

end
