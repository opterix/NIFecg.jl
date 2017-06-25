using DecisionTree
using JLD
using Wavelets

if isempty(ARGS)
    testModelPath="../models/LIBSVM_fetalmodelX4_16.jld"
else   
    
    testModelPath = ARGS[1];
    lmatches=matchall(r"[0-9]+\.*[0-9]*", testModelPath)
    nch=parse(Int64, lmatches[1])
    dim=parse(Int64, lmatches[3]);
    nselFeat=parse(Int64, lmatches[4]);
    nTrees=parse(Int64, lmatches[5]);
    dwt_levels=parse(Float64, lmatches[6]);
    dwt_levels=Int64(dwt_levels);

end

Wavelets_Pos=[];
Wavelets_Neg=[];
T_Aux_Sig_Pos=[];
T_Aux_Sig_Neg=[];
Mat_To_Wavelet_Pos=[];
Mat_To_Wavelet_Neg=[];


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


#### Carga el modelo Random Forest
println("\nLoading model located at $(testModelPath)")

in_serial=open(testModelPath, "r")
fullmodel = deserialize(in_serial)

pmodel=fullmodel["pmodel"]
mean_instances=fullmodel["mean_instances"]
std_instances=fullmodel["std_instances"]

println("Processing Parameters:")
println("Number of channels: $(nch)")
println("Feature vector dim: $(dim)")
println("Number of feats per cut: $(nselFeat)")
println("Number of Trees: $(nTrees)")
println("dwt_levels: $(dwt_levels)")

## Aplicar Support Vector Machine para clasificar 

labels = vcat(zeros(size(feature_Pos,1)),ones(size(feature_Neg,1)));
instances = vcat(feature_Pos[1:end,:],feature_Neg[1:end,:])

norm_instances=instances-repmat(mean_instances,size(instances,1),1)
norm_instances=norm_instances./repmat(std_instances,size(instances,1),1)


println("Predicting");

@time predicted_labels = round(apply_forest(pmodel, norm_instances))

# Compute accuracy
@printf "Accuracy: %.2f%%\n" mean((predicted_labels .== labels))*100

#Compute Confusion Matrix

tp = (labels.==0) & (predicted_labels.==0)
tn = (labels.==1) & (predicted_labels.==1)
fp = (labels.==1) & (predicted_labels.==0)
fn = (labels.==0) & (predicted_labels.==1)

C= [sum(tp) sum(fp); sum(fn) sum(tn)]

@printf "Fscore: %.2f\n" 2*sum(tp)/(2*sum(tp)+sum(fn)+sum(fp))

println(C);

close(in_serial)
