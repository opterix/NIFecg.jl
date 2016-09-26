using Interpolations
N=9;

srand(0);
f=rand(N);
t = linspace(0.0, 1, N) # time vector


########### BSPLINE ############################

x = interpolate(f,BSpline(Constant()), OnCell())

A = rand(20)
A_x = collect(1.0:2.0:40.0)
knots = (A_x,)
itp = interpolate(knots, A, Gridded(Linear()))
println(itp)
itp[1.0]
itp[2.0]
itp[3.0]
itp[4.0]

########## FOURIER ###########################3

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
# recover=ifftshift(Sum)
