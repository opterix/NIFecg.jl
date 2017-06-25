########################
# First arg = dimension
# Second arg = nselFeat
# Third arg = nTree
# Fourth arg = dwt levels


using JLD
using DecisionTree
using Wavelets
using Combinatorics

Aux_Sig_Pos=[];
Aux_Sig_Neg=[];
Wavelets_Pos=[];
Wavelets_Neg=[];
T_Aux_Sig_Pos=[];
T_Aux_Sig_Neg=[];
Mat_To_Wavelet_Pos=[];
Mat_To_Wavelet_Neg=[];

nch=4;

all_perms=collect(permutations(collect(1:nch)))

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

#Solo en portatil- En servidor comentar estas dos lineas
#Mat_To_Wavelet_Pos=Mat_To_Wavelet_Pos[1:20:end,:];
#Mat_To_Wavelet_Neg=Mat_To_Wavelet_Neg[1:20:end,:];


T_Aux_Sig_Pos=zeros(size(Mat_To_Wavelet_Pos));
T_Aux_Sig_Neg=zeros(size(Mat_To_Wavelet_Neg));

(Fil,Col)=size(Mat_To_Wavelet_Pos);

for k in 1:Fil
    T_Aux_Sig_Pos[k,:]=dwt(Mat_To_Wavelet_Pos[k,:],xt,dwt_levels);
    T_Aux_Sig_Neg[k,:]=dwt(Mat_To_Wavelet_Neg[k,:],xt,dwt_levels);
end

feature_Pos=zeros(Int64(size(Mat_To_Wavelet_Pos,1)/nch)*size(all_perms,1),dim*nch)
feature_Neg=zeros(Int64(size(Mat_To_Wavelet_Neg,1)/nch)*size(all_perms,1),dim*nch)
iexemplar=1;

for k in 1:nch:Fil
    aux_pos=T_Aux_Sig_Pos[k:k+nch-1,1:dim];
    aux_neg=T_Aux_Sig_Neg[k:k+nch-1,1:dim];
    for x in all_perms
        part_Aux_Sig_Pos=aux_pos[x,:]
        part_Aux_Sig_Neg=aux_neg[x,:]
        
        feature_Pos[iexemplar,:] = vec(part_Aux_Sig_Pos')';
        feature_Neg[iexemplar,:] = vec(part_Aux_Sig_Neg')';
        iexemplar=iexemplar+1;
    end
    
end


## Aplicar Support Vector Machine para clasificar 

labels = vcat(zeros(size(feature_Pos,1)),ones(size(feature_Neg,1)));
instances = vcat(feature_Pos[1:end,:],feature_Neg[1:end,:])

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
feature_Pos=[]
feature_Neg=[]

gc()
#####################


println("\nTotal number of features vectors: $(size(norm_instances,1))")
println("Feature vector dimension: $(size(norm_instances,2))")

println("\nEntrenando Random Forest Classifier")

@time pmodel = build_forest(labels, norm_instances, nselFeat, nTrees, 1.0)


println("Predicting");
accuracy=nfoldCV_forest(labels, norm_instances, nselFeat, nTrees, 3, 1.0)

@printf "Guardando modelo\n"

out=open("../models/RFmodelX4_Ch1_$(dim)_randFeats$(nselFeat)_nTrees$(nTrees)_dwt_levels$(dwt_levels).jls", "w")
fullmodel=Dict("pmodel" => pmodel, "mean_instances"=>mean_instances, "std_instances"=>std_instances)
serialize(out, fullmodel)
close(out)
