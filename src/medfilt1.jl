#function medfilt1(x,m)

#n=length(x);
#r=floor(Int,m/2); 
#indr=(0:m-1)'; 
#indc=1:n;
#ind=indc[ones(Int,1,m),1:n]+indr[:,ones(Int,1,n)];
#x0=x(ones(r,1))*0; 
#X=[x0'; x'; x0'];
#X=reshape(X(ind),m,n); 
#y=median(X,1);


#end





function medfilt1(x,s)
n=length(x); 
r=floor(s/2); 
indr=collect(0:s-1); 
indc=collect(1:n);
ind=indc[ones(1,s),1:n]+indr[:,ones(1,n)];
x0=x[ones(r,1)]*0; 
X=[x0'; x'; x0'];
X=reshape(X[ind],s,n); 
y=median(X,1);
end

function median_spectre(A,s)
    # Es mejor si s es impar
    filter=vec(ones(1,s)/s);
    r=floor(s/2);

    signalFFT = fft(A,1);
    absFFT = abs(signalFFT);
    unitFFT = signalFFT./absFFT
    
    out=zeros(size(A))

    #Ap=

    #for kch in 1:size(signalFFT,2)
    #    aux=conv(filter, absFFT[:,kch]);
    #    out[:,kch] = aux[Int(r):end-Int(r+1)];
    #end

    medFFT= absFFT-out;
    signalFFT[medFFT.<=0]=0;

    sig_rec = ifft(unitFFT,1);
    
    return sig_rec;
end
