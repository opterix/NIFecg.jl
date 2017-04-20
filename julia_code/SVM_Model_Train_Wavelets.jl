#### Leo los diccionarios generados, para la descomposición Wavelet ###


include("Read_Dictionary.jl");
include("LIBSVM.jl");
using LIBSVM

## Variables ##


Aux_Sig_Pos=[];
Aux_Sig_Neg=[];
Wavelets_Pos=[];
Wavelets_Neg=[];
T_Aux_Sig_Pos=zeros(size(Mat_To_Wavelet_Pos));
T_Aux_Sig_Neg=zeros(size(Mat_To_Wavelet_Neg));
Mat_To_Wavelet_Pos=B["pos_examples"];
Mat_To_Wavelet_Neg=B["neg_examples"];

## Generar Wavelet de Daubechies ##

xt = wavelet(WT.db7)	

## Aplicar los coeficientes Wavelet a todos los casos positivos y negativos ##

for i in 2:num_files
    file_name = list_file[i];
    println("Procesando Dictionary $(file_name)")
    d = load("$(data_dictio)/$(file_name)")
    Mat_To_Wavelet_Pos=vcat(Mat_To_Wavelet_Pos,d["pos_examples"]);
    Mat_To_Wavelet_Neg=vcat(Mat_To_Wavelet_Neg,d["neg_examples"]);
    (Fil,Col)=size(Mat_To_Wavelet_Pos);

    for k in 1:Fil
      Aux_Sig_Pos=Mat_To_Wavelet_Pos[k,:];
      T_Aux_Sig_Pos[k,:]=dwt(Aux_Sig_Pos,xt,3);
      Aux_Sig_Neg=Mat_To_Wavelet_Neg[k,:];
      T_Aux_Sig_Neg[k,:]=dwt(Aux_Sig_Neg,xt,3);
    end
end

println("Entrenando Support Vector Machine")

## Aplicar Support Vector Machine para clasificar 

labels = vcat(zeros(size(T_Aux_Sig_Neg,1)),ones(size(T_Aux_Sig_Pos,1)));
instances = vcat(T_Aux_Sig_Pos[:,1:64],T_Aux_Sig_Neg[:,1:64])'
model = svmtrain(labels,instances,verbose=true);

(predicted_labels, decision_values) = svmpredict(model,instances);

# Compute accuracy
@printf "Accuracy: %.2f%%\n" mean((predicted_labels .== labels))*100

save("../SVM_Model.jld","model",model)
    
