function MakeICAll(AECG)

############################################33
#ICA
#(nf,mc) = size(AECG)
AECG=AECG'

# ------------------- Extract the mean value --------------------#
for i in 1:m
    AECG[:,i]= (AECG[:,i]-mean(AECG[:,i]))/std(AECG[:,i]);
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
mv = vec(mean(AECG,2))
@assert size(AECG) == (m, n)
if VERSION < v"0.5.0-dev+660"
    C = cov(AECG; vardim=2)
else
    C = cov(AECG, 2)
end

#-------------- FastICA --------------

M = fit(ICA, AECG, k; do_whiten=false)
@test isa(M, ICA)
@test indim(M) == m
@test outdim(M) == k
@test mean(M) == mv
W = M.W
@test_approx_eq transform(M, AECG) W' * (AECG .- mv)
@test_approx_eq W'W eye(k)
AECG_nowhite = W'*AECG
AECG_nowhite = AECG_nowhite'

M = fit(ICA, AECG, k;do_whiten=true)#, winit=zeros(k,k))
@test isa(M, ICA)
@test indim(M) == m
@test outdim(M) == k
@test mean(M) == mv
W = M.W
@test_approx_eq W'C * W eye(k)
AECG_white = W'*AECG
AECG_white = AECG_white'

return AECG_white

end
