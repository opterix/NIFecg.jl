using ExtremelyRandomizedTrees
using Wavelets
using JLD

include("medfilt1.jl")
include("Main.jl")
include("QRSf_selector.jl")

list_file=readdir("../data")
num_files=size(list_file,1);

if isempty(ARGS)
    testModelPath="ETmodelX4_Ch1_16_randFeats4_nTrees10_dwt_levels5.jls"

    lmatches=matchall(r"[0-9]+\.*[0-9]*", testModelPath)
    nch=parse(Int64, lmatches[1])
    dimFV=parse(Int64, lmatches[3]);
    nselFeat=parse(Int64, lmatches[4]);
    nTrees=parse(Int64, lmatches[5]);
    dwt_levels=parse(Float64, lmatches[6]);
    dwt_levels=Int64(dwt_levels);

    #dwt_levels=4;#Numero de niveles para la descomposicion Wavelet
    #dimFV=16 #dimension del vector de caracteristicas por canal
    #nch=4;   #Numero de canales

else   
    
    testModelPath = ARGS[1];
    lmatches=matchall(r"[0-9]+\.*[0-9]*", testModelPath)
    nch=parse(Int64, lmatches[1])
    dimFV=parse(Int64, lmatches[3]);
    nselFeat=parse(Int64, lmatches[4]);
    nTrees=parse(Int64, lmatches[5]);
    dwt_levels=parse(Float64, lmatches[6]);
    dwt_levels=Int64(dwt_levels);

end

Ns=60000; #Numero total de muestras
ks=128;   #muestras utilizadas para aplicar wavelet

println("Cargando modelo $(testModelPath)")

in_serial=open(testModelPath, "r")
fullmodel = deserialize(in_serial)

pmodel=fullmodel["pmodel"]
mean_instances=fullmodel["mean_instances"]
std_instances=fullmodel["std_instances"]

## Genero un vector con los valores del caso
RF_Probe=zeros(Ns-ks+1, ks);
Wavelet_Sig=zeros(Ns-ks+1, dimFV*nch);

F_Ini=hcat(1: Ns-ks+1)';
F_Fin=hcat(ks:Ns)';
xt = wavelet(WT.db7);

predicted_labels=[]
votes=[]

for i in 1:num_files
#for i in 1:10
    file_name = list_file[i];
    file_name = file_name[1:end-4]
    filename=file_name
    println("Procesando Señal $(file_name)")
    (nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI, giniMeasure)=process_fetal(filename)

 #Normalizar AECGm
    #for i in 1:nch
        #AECGm[:,i]= (AECGm[:,i]-mean(AECGm[:,i]))/std(AECGm[:,i]);
        #AECGm[:,i]= (AECGm[:,i]-mean(AECGm[:,i]))/quantile(AECGm[:,i], 0.99);
    #end

    #for i in 1:nch
    #    AECGm[:,i]= (AECGm[:,i]-mean(AECGm[:,i]))/quantile(AECGm[:,i], 0.99);
    #end

    
    In_Signal=AECGm[:,1:nch];

    for interval in 1:(Ns-ks)
        aux_signal=In_Signal[F_Ini[interval]:F_Fin[interval],:];
        aux_dwt=zeros(nch,ks)

        for kch in 1:nch
            aux_dwt[kch,:]=dwt(vec(aux_signal[:,kch]),xt,dwt_levels);
        end

        aux_dwt = aux_dwt[:,1:dimFV];
        Wavelet_Sig[interval,:]=aux_dwt'[:]'
    end


    #Extraer vector de caracteristicas basadas en DWT
    instances = Wavelet_Sig;

    #Aplicando normalizacion
    norm_instances=instances-repmat(mean_instances,size(instances,1),1)
    norm_instances=norm_instances./repmat(std_instances,size(instances,1),1)
    
    println("Clasificando intervalos")

    #@time predicted_labels = apply_forest(pmodel, norm_instances);
    
    @time predicted_labels, votes = ExtremelyRandomizedTrees.predict(pmodel, norm_instances', returnvotes=true)
    
    fetal_annot = fetal_annot[fetal_annot.<=Ns];

    #threshold = vec(medfilt1(vec(votes[1,:]),101))
    threshold = vec(quantile_filt1(vec(votes[1,:]),1001,0.95))+0.18
    
    figure(i)
    #hold(true)
    #plot(vec(round(predicted_labels-1)),color="black")

    fQRS_ini = round(Int64, find(votes[1,:].>threshold))
    fQRS_aux = zeros(Ns,1)
    fQRS_aux[fQRS_ini]=1
    fQRS_diff = round(Int64, diff(fQRS_aux))
    fQRS_est = (find(fQRS_diff.==1)+find(fQRS_diff.==-1))/2
    fQRS_est = round(Int64, fQRS_est)
    fQRS_est = smooth_RR(fQRS_est, 1, 1000, 2)

    plot(votes[1,:].>threshold, color="black")
    plot(votes[1,:],color="green")
    plot(threshold, color="blue")
    plot(fetal_annot,zeros(size(fetal_annot,1)),"r.") 
    title("ET Classification Wavelet")
    
    savefig("../Test_Images_WaveletsX4/$(file_name)_X4_ET.png", format="png", dpi=300)     
    writecsv("../Test_Images_WaveletsX4/$(file_name)_estimation.csv", fQRS_est)

    close("all")
    
end
