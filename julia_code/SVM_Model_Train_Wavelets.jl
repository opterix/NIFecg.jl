########################
# First arg = dimension
# Second arg = Cparam
# Third arg = gamma

using LIBSVM
using JLD
using Wavelets

Aux_Sig_Pos=[];
Aux_Sig_Neg=[];
Wavelets_Pos=[];
Wavelets_Neg=[];
T_Aux_Sig_Pos=[];
T_Aux_Sig_Neg=[];
Mat_To_Wavelet_Pos=[];
Mat_To_Wavelet_Neg=[];

## Generar Wavelet de Daubechies ##

xt = wavelet(WT.db7)	

if isempty(ARGS)
    dim = 32
    Cparam = 1
    gamma= 1/dim
    dwt_levels = 4
elseif size(ARGS,1) == 1
    dim = parse(Int64, ARGS[1])
    Cparam=1
    gamma=1/dim
    dwt_levels = 4
elseif size(ARGS,1) == 2
    dim = parse(Int64, ARGS[1])
    Cparam=parse(Float64, ARGS[2])
    gamma=1/dim
    dwt_levels = 4
elseif size(ARGS,1) == 3
    dim=parse(Int64, ARGS[1])
    Cparam=parse(Float64, ARGS[2])
    gamma=parse(Float64, ARGS[3])*1/dim
    dwt_levels = 4
else
    dim=parse(Int64, ARGS[1])
    Cparam=parse(Float64, ARGS[2])
    gamma=parse(Float64, ARGS[3])*1/dim
    dwt_levels = parse(Int64, ARGS[4])
end

println("Setting parameters:")
println("Feature vector dim: $(dim)")
println("C parameter: $(Cparam)")
println("gamma parameter: $(gamma)")
println("dwt_levels: $(dwt_levels)")

## Aplicar los coeficientes Wavelet a todos los casos positivos y negativos ##
data_dictio="../Dictionaries"
list_file=readdir(data_dictio)
num_files=size(list_file,1);


for i in 1:50
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
    Aux_Sig_Pos=Mat_To_Wavelet_Pos[k,:];
    T_Aux_Sig_Pos[k,:]=dwt(Aux_Sig_Pos,xt,dwt_levels);
end

(Fil,Col)=size(Mat_To_Wavelet_Neg);

for k in 1:Fil
    Aux_Sig_Neg=Mat_To_Wavelet_Neg[k,:];
    T_Aux_Sig_Neg[k,:]=dwt(Aux_Sig_Neg,xt,dwt_levels);
end

## Aplicar Support Vector Machine para clasificar 

labels = vcat(zeros(size(T_Aux_Sig_Pos,1)),ones(size(T_Aux_Sig_Neg,1)));
instances = vcat(T_Aux_Sig_Pos[1:end,1:dim],T_Aux_Sig_Neg[1:end,1:dim])

mean_instances=mean(instances,1)
std_instances=std(instances,1)

norm_instances=instances-repmat(mean_instances,size(instances,1),1)
norm_instances=norm_instances./repmat(std_instances,size(instances,1),1)


#### Clear Variables
Aux_Sig_Pos=[];
Aux_Sig_Neg=[];
Wavelets_Pos=[];
Wavelets_Neg=[];
T_Aux_Sig_Pos=[];
T_Aux_Sig_Neg=[];
Mat_To_Wavelet_Pos=[];
Mat_To_Wavelet_Neg=[];
gc()
#####################


println("\nTotal number of features vectors: $(size(norm_instances,1))")
println("Feature vector dimension: $(size(norm_instances,2))")

println("\nEntrenando Support Vector Machine")
#libsvm
#@time pmodel = svmtrain(norm_instances', labels, weights = Dict( 0. => 5., 1. => 1.), verbose=true);

@time pmodel = svmtrain(norm_instances', labels, cost=Cparam, gamma=gamma, verbose=true);
#Modelo con funcion de costo ponderada. La idea es que se penaliza las detecciones fetales falsas (Falsos positivos)

println("Predicting");
(predicted_labels, decision_v) = svmpredict(pmodel, norm_instances');

# Compute accuracy
@printf "Accuracy: %.2f%%\n" mean((predicted_labels .== labels))*100

save("../models/fetalmodelCh1_$(dim)_C$(Cparam)_gamma$(gamma)_dwt_levels$(dwt_levels).jld", "pmodel", pmodel, "mean_instances", mean_instances, "std_instances", std_instances)
