########################
# First arg = dimension
# Second arg = nselFeat
# Third arg = gamma

using DecisionTree
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
    nselFeat = 1
    nTrees= 1/dim
    dwt_levels = 4
elseif size(ARGS,1) == 1
    dim = parse(Int64, ARGS[1])
    nselFeat=1
    nTrees=1/dim
    dwt_levels = 4
elseif size(ARGS,1) == 2
    dim = parse(Int64, ARGS[1])
    nselFeat=parse(Int64, ARGS[2])
    nTrees=5
    dwt_levels = 4
elseif size(ARGS,1) == 3
    dim=parse(Int64, ARGS[1])
    nselFeat=parse(Int64, ARGS[2])
    nTrees=parse(Int64, ARGS[3])
    dwt_levels = 4
else
    dim=parse(Int64, ARGS[1])
    nselFeat=parse(Int64, ARGS[2])
    nTrees=parse(Int64, ARGS[3])
    dwt_levels = parse(Int64, ARGS[4])
end

println("Setting parameters:")
println("Feature vector dim: $(dim)")
println("Number of feats per cut: $(nselFeat)")
println("Number of Trees: $(nTrees)")
println("dwt_levels: $(dwt_levels)\n")

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

println("\nEntrenando Random Forest Classifier")

# nselFeat -> Numero de caracteristicas seleccionadas al azar en
#             cada split
# nTrees -> Numero de arboles


@time pmodel = build_forest(labels, norm_instances, nselFeat, nTrees, 1.0)

println("Predicting");
# Compute accuracy 5fold validation
#accuracy=nfoldCV_forest(labels, norm_instances, nselFeat, nTrees, 3, 1.0)


#@printf "Accuracy: %.2f%%\n" mean(accuracy)*100
@printf "Guardando modelo\n"

save("../models/RFmodel_Ch1_$(dim)_randFeats$(nselFeat)_nTrees$(nTrees)_dwt_levels$(dwt_levels).jld", "pmodel", pmodel, "mean_instances", mean_instances, "std_instances", std_instances)
