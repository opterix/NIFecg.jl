using SVR
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
    T_Aux_Sig_Pos[k,:]=dwt(Mat_To_Wavelet_Pos[k,:],xt,3);
    T_Aux_Sig_Neg[k,:]=dwt(Mat_To_Wavelet_Neg[k,:],xt,3);
end

feature_Pos=zeros(Int64(size(Mat_To_Wavelet_Pos,1)/nch)*size(all_perms,1),64*nch)
feature_Neg=zeros(Int64(size(Mat_To_Wavelet_Neg,1)/nch)*size(all_perms,1),64*nch)
iexemplar=1;

for k in 1:nch:Fil
    aux_pos=T_Aux_Sig_Pos[k:k+nch-1,1:64];
    aux_neg=T_Aux_Sig_Neg[k:k+nch-1,1:64];
    for x in all_perms
        part_Aux_Sig_Pos=aux_pos[x,:]
        part_Aux_Sig_Neg=aux_neg[x,:]
        
        feature_Pos[iexemplar,:] = vec(part_Aux_Sig_Pos')';
        feature_Neg[iexemplar,:] = vec(part_Aux_Sig_Neg')';
        iexemplar=iexemplar+1;
    end
    
end


println("Entrenando Support Vector Machine")

## Aplicar Support Vector Machine para clasificar 

labels = vcat(zeros(size(feature_Pos,1)),ones(size(feature_Neg,1)));
instances = vcat(feature_Pos[1:end,:],feature_Neg[1:end,:])


#SVR.verbosity=true;

@time pmodel = SVR.train(labels,instances',verbose=true);

println("Predicting");

predicted_labels = round(SVR.predict(pmodel, instances'));
SVR.savemodel(pmodel, "SVMfetalX4.model")
SVR.freemodel(pmodel)

# Compute accuracy
@printf "Accuracy: %.2f%%\n" mean((predicted_labels .== labels))*100
