using LIBSVM
using JLD
using Wavelets


Wavelets_Pos=[];
Wavelets_Neg=[];
T_Aux_Sig_Pos=[];
T_Aux_Sig_Neg=[];
Mat_To_Wavelet_Pos=[];
Mat_To_Wavelet_Neg=[];

dwt_levels=4;
nch=4;

dim=16;

## Generar Wavelet de Daubechies ##

xt = wavelet(WT.db7)	

## Aplicar los coeficientes Wavelet a todos los casos positivos y negativos ##

data_dictio="../Dictionaries"
list_file=readdir(data_dictio)
num_files=size(list_file,1);


for i in 51:num_files
    file_name = list_file[i];
    println("Procesando Dictionary $(file_name)")
    d = load("$(data_dictio)/$(file_name)")

    if isempty(Mat_To_Wavelet_Pos)
        Mat_To_Wavelet_Pos=d["pos_examples"];
        Mat_To_Wavelet_Neg=d["neg_examples"];
    else
        Mat_To_Wavelet_Pos=vcat(Mat_To_Wavelet_Pos,d["pos_examples"]);
        Mat_To_Wavelet_Neg=vcat(Mat_To_Wavelet_Neg,d["neg_examples"]);

    end

end

T_Aux_Sig_Pos=zeros(size(Mat_To_Wavelet_Pos));
T_Aux_Sig_Neg=zeros(size(Mat_To_Wavelet_Neg));
(Fil,Col)=size(Mat_To_Wavelet_Pos);

for k in 1:Fil
    T_Aux_Sig_Pos[k,:]=dwt(Mat_To_Wavelet_Pos[k,:],xt,dwt_levels);
    T_Aux_Sig_Neg[k,:]=dwt(Mat_To_Wavelet_Neg[k,:],xt,dwt_levels);
end

feature_Pos=zeros(Int64(size(Mat_To_Wavelet_Pos,1)/nch),dim*nch)
feature_Neg=zeros(Int64(size(Mat_To_Wavelet_Neg,1)/nch),dim*nch)
iexemplar=1;

for k in 1:nch:Fil
    aux_pos=T_Aux_Sig_Pos[k:k+nch-1,1:dim];
    aux_neg=T_Aux_Sig_Neg[k:k+nch-1,1:dim];

    feature_Pos[iexemplar,:] = vec(aux_pos')';
    feature_Neg[iexemplar,:] = vec(aux_neg')';
    iexemplar=iexemplar+1;
end




#### Carga el modelo del SVM

println("Cargando Modelo SVM")

pmodel=load("../models/LIBSVM_fetalmodelX4_$(dim).jld", "pmodel")
mean_instances=load("../models/LIBSVM_fetalmodelX4_$(dim).jld", "mean_instances")
std_instances=load("../models/LIBSVM_fetalmodelX4_$(dim).jld", "std_instances")


## Aplicar Support Vector Machine para clasificar 

labels = vcat(zeros(size(feature_Pos,1)),ones(size(feature_Neg,1)));
instances = vcat(feature_Pos[1:end,:],feature_Neg[1:end,:])

norm_instances=instances-repmat(mean_instances,size(instances,1),1)
norm_instances=norm_instances./repmat(std_instances,size(instances,1),1)


println("Predicting");

@time (predicted_labels, decision_v) = svmpredict(pmodel, norm_instances');


# Compute accuracy
@printf "Accuracy: %.2f%%\n" mean((predicted_labels .== labels))*100

#Compute Confusion Matrix

tp = (labels.==0) & (predicted_labels.==0)
tn = (labels.==1) & (predicted_labels.==1)
fp = (labels.==1) & (predicted_labels.==0)
fn = (labels.==0) & (predicted_labels.==1)

C= [sum(tp) sum(fp); sum(fn) sum(tn)]

println(C);
