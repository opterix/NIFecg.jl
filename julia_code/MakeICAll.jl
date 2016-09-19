function MakeICAll(AECG)

############################################33
#ICA
#(nf,mc) = size(AECG)
AECG=AECG'

# ------------------- Extract the mean value --------------------#
for is in 1:m
    AECG[:,is]= (AECG[:,is]-mean(AECG[:,is]))/std(AECG[:,is]);
end

#-------- Mean and covarience of data -----------------#
mv = vec(mean(AECG,2))
@assert size(AECG) == (m, n)
if VERSION < v"0.5.0-dev+660"
    C = cov(AECG; vardim=2)
else
    C = cov(AECG, 2)
end

#-------------- FastICA --------------

M = fit(ICA, AECG, k;do_whiten=true)#, winit=zeros(k,k))
@test isa(M, ICA)
@test indim(M) == m
@test outdim(M) == k
@test mean(M) == mv
W = M.W
@test_approx_eq W'C * W eye(k)
AECG_white = W'*AECG
AECG_white = AECG_white'

return AECG_white#, AECG_nowhite

end
