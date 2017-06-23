########################
# First arg = dimension
# Second arg = Cparam
# Third arg = gamma

using LIBSVM
using JLD
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
    dim = 16
    Cparam = 1.0
    gamma= 1/dim
elseif size(ARGS,1) == 1
    dim = parse(Float64, ARGS[1])
    Cparam=1.0
    gamma=1/dim
elseif size(ARGS,1) == 2
    dim = parse(Float64, ARGS[1])
    Cparam=parse(Float64, ARGS[2])
    gamma=1/dim
else
    dim=parse(Int64, ARGS[1])
    Cparam=parse(Float64, ARGS[2])
    gamma=parse(Float64, ARGS[3])*1/dim
end

println("Setting parameters:")
println("Feature vector dim: $(dim)")
println("C parameter: $(Cparam)")
println("gamma parameter: $(gamma)")

if dim==32
    dwt_levels=3;
elseif dim==16
    dwt_levels=4;
else
    println("\nERROR: USE ONLY dim=32 or dim=16")
    println("Exiting...")
    exit(-1)
end

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

println("\nEntrenando Support Vector Machine")



#SVR.verbosity=true;

@time pmodel = svmtrain(norm_instances', labels, cost=Cparam, gamma=gamma, verbose=true);

println("Predicting");

(predicted_labels, decision_v) = svmpredict(pmodel, norm_instances');



# Compute accuracy
@printf "Accuracy: %.2f%%\n" mean((predicted_labels .== labels))*100

save("../models/LIBSVM_fetalmodelX4_$(dim)_C$(Cparam)_gamma$(gamma).jld", "pmodel", pmodel, "mean_instances", mean_instances, "std_instances", std_instances)
