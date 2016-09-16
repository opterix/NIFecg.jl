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

win=10000
figure(1)
AECG=AECG'
subplot(411)
title("AECG data")
 plot(t[1:win], AECG[1:win,1], color="red", linewidth=1.0, linestyle="-")
subplot(412)
 plot(t[1:win], AECG[1:win,2], color="red", linewidth=1.0, linestyle="-")
subplot(413)
 plot(t[1:win], AECG[1:win,3], color="red", linewidth=1.0, linestyle="-")
subplot(414)
 plot(t[1:win], AECG[1:win,4], color="red", linewidth=1.0, linestyle="-")

figure(2)

subplot(411)
title("ICA_white")
plot(t[1:win], AECG_white[1,1:win]', color="red", linewidth=1.0, linestyle="-")
subplot(412)
plot(t[1:win], AECG_white[2,1:win]', color="black", linewidth=1.0, linestyle="-")
subplot(413)
plot(t[1:win], AECG_white[3,1:win]', color="blue", linewidth=1.0, linestyle="-")
subplot(414)
plot(t[1:win], AECG_white[4,1:win]', color="blue", linewidth=1.0, linestyle="-")
return AECG_white#, AECG_nowhite

end
