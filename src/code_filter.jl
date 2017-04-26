include("medfilt1.jl")

function medfilt1mit(x,m,nit)

if(size(x,2)>size(x,1)) 
x=x';
colV=bool(0);
else
colV=bool(1); 
end
n=length(x);
m2=floor(Int,m/2);
xi=median(x[1:min(n,m)]);
xf=median(x[end-min(n,m)+1:end]);
xt=[xi+zeros(m2,1); x; xf+zeros(m2,1)];

for it=1:nit
    xx=xt;
    xt=medfilt1(xx,m);
    if(all((xt-xx)==0))
    break 
   end
end
if(colV==true)
xmf=xt[m2+1:end-m2] 
else 
xmf=xt[m2+1:end-m2]' 
end


end






