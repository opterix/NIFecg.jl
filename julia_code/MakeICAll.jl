function MakeICAll(signal,nch,ns)

############################################33
#ICA
#(nf,mc) = size(signal)
signal=signal'

# ------------------- Extract the mean value --------------------#
for i in 1:nch
    signal[:,i]= (signal[:,i]-mean(signal[:,i]))/std(signal[:,i]);
end

#------------------------

srand(15678)

## icagfun

f = icagfun(:tanh)
u, v = evaluate(f, 1.5)
@test_approx_eq u 0.905148253644866438242
@test_approx_eq v 0.180706638923648530597

f = icagfun(:tanh, 1.5)
u, v = evaluate(f, 1.2)
@test_approx_eq u 0.946806012846268289646
@test_approx_eq v 0.155337561057228069719

f = icagfun(:gaus)
u, v = evaluate(f, 1.5)
@test_approx_eq u 0.486978701037524594696
@test_approx_eq v -0.405815584197937162246


#-------- Mean and covarience of data -----------------#
mv = vec(mean(signal,2))
@assert size(signal) == (nch, ns)
if VERSION < v"0.5.0-dev+660"
    C = cov(signal; vardim=2)
else
    C = cov(signal, 2)
end

#-------------- FastICA --------------

M = fit(ICA, signal, nc; do_whiten=false)
@test isa(M, ICA)
@test indim(M) == nch
@test outdim(M) == nc
@test mean(M) == mv
W = M.W
@test_approx_eq transform(M, signal) W' * (signal .- mv)
@test_approx_eq W'W eye(nc)
signal_nowhite = W'*signal
signal_nowhite = signal_nowhite'

M = fit(ICA, signal, nc;do_whiten=true)#, winit=zeros(nc,nc))
@test isa(M, ICA)
@test indim(M) == nch
@test outdim(M) == nc
@test mean(M) == mv
W = M.W
@test_approx_eq W'C * W eye(nc)
signal_white = W'*signal
signal_white = signal_white'

return signal_white

end
