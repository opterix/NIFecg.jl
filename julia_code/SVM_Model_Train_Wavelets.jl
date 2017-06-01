using SVR
using JLD
using Wavelets


include("Read_Dictionary.jl");
#include("LIBSVM.jl");

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

for i in 2:50
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
instances = vcat(T_Aux_Sig_Pos[1:end,1:64],T_Aux_Sig_Neg[1:end,1:64])

#instances = vcat(T_Aux_Sig_Pos[1:10000,1:64],T_Aux_Sig_Neg[1:10000,1:64])
#labels = vcat(zeros(10000),ones(10000));

#SVR.verbosity=true;

@time pmodel = SVR.train(labels,instances',verbose=true);

println("Predicting");

predicted_labels = round(SVR.predict(pmodel, instances'));
SVR.savemodel(pmodel, "SVMfetal.model")
SVR.freemodel(pmodel)



#(predicted_labels, decision_values) = svmpredict(model,test_instances);
# Compute accuracy
@printf "Accuracy: %.2f%%\n" mean((predicted_labels .== labels))*100

#save("../SVM_Model.jld","model",model)
    
