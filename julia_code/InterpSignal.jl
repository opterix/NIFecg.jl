using Interpolations, DataFrames, ArrayFire
N=9;

srand(0);
 #a = @data([1.5, NA, NA, NA, NA, NA, 10.5]);
 a = ([1.5, 3, 6, 10.5]);
  b = linspace(1, 100, 10);
f=rand(N);
t = linspace(0.0, 1, N) # time vector


########### BSPLINE ############################

x = interpolate(b,BSpline(Linear()), OnGrid())
B=zeros(length(b)*2)
for i in 0:length(b)-1
  tmpidxs = i+1.5
  B[i*2+1] = b[i+1]
  B[i*2+2] = x[tmpidxs]
end

v1 = x[0.6]
v2 = x[3.6]
#
# ########## FOURIER ###########################3
#
# # compute FFT (the factor of N is just a normalization)
# tildef=fft(f)/N;
#
# # define the trigonometric interpolant defined by the equation above
# Sum=0.0 + 0.0im;
# for nu=0:N-1
# Sum+=tildef[nu+1]*exp(2*pi*im*nu*t/N);
# end
# Sum
# println(Sum)
#
# recover=real(ifft(Sum))
#  #####################
#

#  a = @data([1.5, NA, NA, NA, NA, NA, 10.5]);
#  b=collect(linspace(a[1],a[end],sum(isna(a))))
#
# idxs = find(~isna(a))
# for i in 1:length(idxs)-1
#   tmpidxs = idxs[i]:idxs[i+1]
#   a[idxs[i]+1:idxs[i+1]-1] = linspace(a[idxs[i]],a[idxs[i+1]],length(tmpidxs))[2:end-1]
# end
