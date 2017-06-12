using LIBSVM
using Wavelets
using MLBase
using JLD

include("process_svs.jl")
include("process_txt.jl")
include("Main.jl")
list_file=readdir("../data")
num_files=size(list_file,1);

dimFV=32 #dimension del vector de caracteristicas


Ns=10000; #Numero total de muestras
ks=128;   #muestras utilizadas para aplicar wavelet

## Modulo SVM cargado
SVM_FET=load("../models/LIBSVM_fetalmodel.jld", "pmodel")
mean_instances=load("../models/LIBSVM_fetalmodel.jld", "mean_instances")
std_instances=load("../models/LIBSVM_fetalmodel.jld", "std_instances")

## Genero un vector con los valores del caso
SVM_Probe=zeros(Ns-ks+1, ks);
Wavelet_Sig=zeros(Ns-ks+1, ks);


F_Ini=hcat(1: Ns-ks+1)';
F_Fin=hcat(ks:Ns)';

xt = wavelet(WT.db7);


for i in 1:num_files
    file_name = list_file[i];
    file_name = file_name[1:end-4]
    filename=file_name
    println("Procesando Señal $(file_name)")
    (nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI, giniMeasure)=process_fetal(filename)
    
    In_Signal=AECGm[:,1];


    for interval in 1:(Ns-ks)
        SVM_Probe[interval,:]=In_Signal[F_Ini[interval]:F_Fin[interval]];
        Wavelet_Sig[interval,:]=dwt(SVM_Probe[interval,:],xt,3);
    end


    #Extraer vector de caracteristicas basadas en DWT
    instances = Wavelet_Sig[1:end,1:dimFV];

    #Aplicando normalizacion
    norm_instances=instances-repmat(mean_instances,size(instances,1),1)
    norm_instances=norm_instances./repmat(std_instances,size(instances,1),1)
    
    @time (predicted_labels, decision_v) = svmpredict(SVM_FET, norm_instances');
    
    figure(i)
    hold(true)
    plot(predicted_labels,color="black")
    plot(fetal_annot,zeros(size(fetal_annot,1)),"ro") 
    title("Classification Wavelet")
    #manager = get_current_fig_manager()
    #manager[:window][:attributes]("-zoomed", 1)
    #sleep(1)
    #manager[:window][:attributes]("-zoomed", 2)
    savefig("../Test_Images_Wavelets/$(file_name)_.png") 
    close("all")
    
end
