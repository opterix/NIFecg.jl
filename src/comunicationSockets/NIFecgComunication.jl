using NIFecg
using PyPlot

total_time=22072;
ms=89;
num_bytes=1068;


fetalSignal=zeros(total_time,4);
motherSignal=zeros(total_time,4);
data=zeros(total_time,4);
num_ms=ms;
t=zeros(num_bytes);
_t=zeros(num_bytes);
acum_data=0;
isFullMs= true;
f1=0;
f2=0;
f3=0;
i_=0;

acumSend = 1;


p=ones(500);
p1=ones(500);
P=ones(1000);
acump=0;

for ii_=1:length(p)
    p[ii_]=200;#t[i]=i;
    p1[ii_]=50;#t1[i]=255-i;
    P[acump+1]=p[ii_];
    P[acump+2]=p1[ii_];
    acump += 2;
end
isAllData = false;

#println(P)
println("Listo para recibir y trasmitir ... esperando inicio")
#----------------------------------- Creando servidor ---------------------------
server = listen(ip"168.176.61.100",8885)

while true
    sock = accept(server)
    println("Visualizador se ha conectado\n")
    client=connect(ip"168.176.61.32",8085); 

    while true
        t_=read(client,UInt8);
        acum_data+=1;
        t[acum_data]=t_;
        f3=f2;
        f2=f1;
        f1=t_;

        if ((f1==255)&(f2==255)&(f3==255)) 
            if acum_data !=3 
                isFullMs=false;
                t=zeros(num_bytes);#t=copy(_t);
            end    
            acum_data=0;
        end 
        
        if ((acum_data==num_bytes)||(isFullMs==false))
            if isFullMs==true
                _t=copy(t);
            end    
            isFullMs=true;
            #flush(client)
            acum_data=0; #acum_data=1;
                t=convert(Array{UInt8},t) 
                println(t)
                acum=1;
                column=1;
                b=zeros(ms,4);
                for i=1:3:num_bytes
                    b1=t[i];
                    b2=t[i+1];
                    b3=t[i+2];
                    b1*=65536;
                    b2*=256;
                
                    b_=(b3|b2|b1);
                    i_+=1;
                    if i_==4
                        i_=0
                    end 
                    if b_==0xffffff
                        b_=_b;
                    end
                    _b=b_;
                    b_-=0x7fffff;
                    b[acum,column]=b_;

                    column+=1;
                    if column> 4
                    acum+=1;
                    column=1;
                    end    
                end
                println(num_ms)
                if num_ms<=total_time;
                    data[(num_ms-(ms-1)):num_ms,:]=b; 
                    num_ms+=ms;
                else
                    figure;
                    plot(data[:,1])
                    println(size(data))
                    dataScale = zeros(22000*2);
                    (dataScale)=MFMSocket(data,0,22,1000);
                    println(size(dataScale))
                    ##
#=                     dataScale = zeros(length(data[:,1]));
                    dataCopy=copy(data[:,1]);
                    minV=minimum(dataCopy);
                    maxV=maximum(dataCopy);
                    
                    for idx = 1:length(dataCopy)
                        dataScale[idx] = ((dataCopy[idx]-minV)/(maxV-minV)*255);
                    end =#
                    @async for iii=1000:1000:length(dataScale)         
                        dataToSend = convert(Array{UInt8,1},floor(dataScale[iii-999:iii,1]));
                        sleep(0.5)
                        write(sock,dataToSend);
                    end
                    
                    num_ms=ms;
                end
                i_=0;  
            end
        end
    end
end