using RDatasets, SVR
using Wavelets
using SVR
using MLBase
using JLD


include("process_svs.jl")
include("process_txt.jl")
include("Main.jl")
list_file=readdir("../data")
num_files=size(list_file,1);

SVM_FET=SVR.loadmodel("SVMfetal.model")   ##Cargo el modelo del SVM

## Genero un vector con los valores del caso


SVM_Probe=zeros(9873,128);
Wavelet_Sig=zeros(9873,128);


F_Ini=hcat(1:(10000-127))';
F_Fin=hcat(128:10000)';

xt = wavelet(WT.db7);


for i in 1:num_files
      file_name = list_file[i];
      file_name = file_name[1:end-4]
      filename=file_name
      println("Procesando Señal $(file_name)")
(nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI, giniMeasure)=process_fetal(filename)

 In_Signal=AECGm[:,1];


  for kch in 1:(10000-128)
      SVM_Probe[kch,:]=In_Signal[F_Ini[kch]:F_Fin[kch]];
      Wavelet_Sig[kch,:]=dwt(SVM_Probe[kch,:],xt,3);
  end


Instances = Wavelet_Sig[1:end,1:64];


predicted_labels = round(SVR.predict(SVM_FET, Instances'));

figure(i)
hold(true)
plot(predicted_labels,color="black")
#plot(In_Signal,color="green")
#plot(Wavelet_Sig[:,1],color="blue")
plot(fetal_annot,zeros(size(fetal_annot,1)),"ro") 
title("Classification Wavelet")
manager = get_current_fig_manager()
manager[:window][:attributes]("-zoomed", 1)
sleep(1)
manager[:window][:attributes]("-zoomed", 2)
savefig("../Test_Images_Wavelets/$(file_name)_.png") 

end
