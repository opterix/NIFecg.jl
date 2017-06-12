using LIBSVM
using Wavelets
using JLD

include("process_svs.jl")
include("process_txt.jl")
include("Main.jl")
list_file=readdir("../data")
num_files=size(list_file,1);

dimFV=32 #dimension del vector de caracteristicas por canal
nch=4;   #Numero de canales

Ns=10000; #Numero total de muestras
ks=128;   #muestras utilizadas para aplicar wavelet

## Modulo SVM cargado
SVM_FET=load("../models/LIBSVM_fetalmodelX4_32.jld", "pmodel")
mean_instances=load("../models/LIBSVM_fetalmodelX4_32.jld", "mean_instances")
std_instances=load("../models/LIBSVM_fetalmodelX4_32.jld", "std_instances")

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
    
    In_Signal=AECGm[:,1:nch];




    for interval in 1:(Ns-ks)
        aux_signal=In_Signal[F_Ini[interval]:F_Fin[interval],:];
        aux_dwt=zeros(nch,ks)

        for kch in 1:nch
            aux_dwt[kch,:]=dwt(vec(aux_signal[:,kch]),xt,3);
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
    (predicted_labels, decision_v) = svmpredict(SVM_FET, norm_instances');
    
    figure(i)
    #hold(true)
    plot(predicted_labels,color="black")
    plot(fetal_annot,zeros(size(fetal_annot,1)),"ro") 
    title("Classification Wavelet")
    #manager = get_current_fig_manager()
    #manager[:window][:attributes]("-zoomed", 1)
    #sleep(1)
    #manager[:window][:attributes]("-zoomed", 2)
    savefig("../Test_Images_WaveletsX4/$(file_name)_X4.png") 
    close("all")
    
end
