using DecisionTree
using Wavelets
using JLD
using Combinatorics



fv_size=128;

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



#include("process_svs.jl")
#include("process_txt.jl")
include("Main.jl")
list_file=readdir("../data")
num_files=size(list_file,1);

perc_hn = 8 #Number of hard negatives as percentage of initial positives (Defined in the dictionary)

if isempty(ARGS)
    testModelPath="RFmodelX4_Ch1_16_randFeats4_nTrees10_dwt_levels5.jls"

    lmatches=matchall(r"[0-9]+\.*[0-9]*", testModelPath)
    nch=parse(Int64, lmatches[1])
    dimFV=parse(Int64, lmatches[3]);
    nselFeat=parse(Int64, lmatches[4]);
    nTrees=parse(Int64, lmatches[5]);
    dwt_levels=parse(Float64, lmatches[6]);
    dwt_levels=Int64(dwt_levels);

    #dwt_levels=4;#Numero de niveles para la descomposicion Wavelet
    #dimFV=16 #dimension del vector de caracteristicas por canal
    #nch=4;   #Numero de canales

else   
    
    testModelPath = ARGS[1];
    lmatches=matchall(r"[0-9]+\.*[0-9]*", testModelPath)
    nch=parse(Int64, lmatches[1])
    dimFV=parse(Int64, lmatches[3]);
    nselFeat=parse(Int64, lmatches[4]);
    nTrees=parse(Int64, lmatches[5]);
    dwt_levels=parse(Float64, lmatches[6]);
    dwt_levels=Int64(dwt_levels);

end

Ns=60000; #Numero total de muestras
ks=128;   #muestras utilizadas para aplicar wavelet

println("Cargando modelo $(testModelPath)")

in_serial=open(testModelPath, "r")
fullmodel = deserialize(in_serial)

pmodel=fullmodel["pmodel"]
mean_instances=fullmodel["mean_instances"]
std_instances=fullmodel["std_instances"]

## Genero un vector con los valores del caso
RF_Probe=zeros(Ns-ks+1, ks);
Wavelet_Sig=zeros(Ns, dimFV*nch);

F_Ini=hcat(1: Ns)';
F_Fin=hcat(ks:Ns+ks)';
xt = wavelet(WT.db7);

#for i in 1:num_files
for i in 1:50
    println("$i")
    file_name = list_file[i];
    file_name = file_name[1:end-4]
    filename=file_name
    
    println("Procesando Señal $(file_name)")
    (nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI, giniMeasure)=process_fetal(filename)

    AECGm=vcat(AECGm, zeros(fv_size,4));
    In_Signal=AECGm[:,1:nch];

    for interval in 1:Ns
        aux_signal=In_Signal[F_Ini[interval]:F_Fin[interval],:];
        aux_dwt=zeros(nch,ks)

        for kch in 1:nch
            aux_dwt[kch,:]=dwt(vec(aux_signal[:,kch]),xt,dwt_levels);
        end

        aux_dwt = aux_dwt[:,1:dimFV];
        Wavelet_Sig[interval,:]=aux_dwt'[:]'
    end


    #Extraer vector de caracteristicas basadas en DWT
    instances = Wavelet_Sig;

    #Aplicando normalizacion
    norm_instances=instances-repmat(mean_instances,size(instances,1),1)
    norm_instances=norm_instances./repmat(std_instances,size(instances,1),1)
    
    println("Clasificando intervalos")

    @time predicted_labels = apply_forest(pmodel, norm_instances);
    aux_plabels=vcat(predicted_labels, ones(fv_size))

# Extracción de ejemplos nuevos

    fetal_annot = process_txt(filename,ns)
    
    #shuffle!(fetal_annot)

    fetal_ini=fetal_annot-(fv_size)/2;
    fetal_fin=(fetal_annot+(fv_size)/2)-1;
    
    if fetal_ini[1]<1;
	deleteat!(fetal_ini,1);
	deleteat!(fetal_fin,1);
	deleteat!(fetal_annot,1);
    end	

    total_annot=size(fetal_annot,1)
    total_hn=round(Int64, total_annot*perc_hn)
    
    
    for iannot=1:total_annot
        aux_plabels[Int64(fetal_ini[iannot]):Int64(fetal_fin[iannot])]=1;
    end
    
    neoIdx = sortperm(aux_plabels)
    
    hn_annot = neoIdx[1:total_hn]
    hn_annot = hn_annot[hn_annot .> (fv_size/2)+1]
    AECGm=vcat(AECGm, zeros(fv_size,4));
    
    hn_examples = zeros(nch*size(hn_annot,1), fv_size);
    #extrap_examples = zeros(nch*size(hn_annot,1), fv_size);
    
    idxRand = randperm(total_annot)
    fetal_ini=fetal_ini[idxRand]
    fetal_fin=fetal_fin[idxRand]
    
    
    for iannot in 1:size(hn_annot,1)
        #delta=0;
        
        hn_examples[(iannot-1)*4+1:iannot*4,:] = AECGm[hn_annot[iannot]:hn_annot[iannot]+fv_size-1,:]'
        #extrap_examples[(iannot-1)*4+1:iannot*4,:] = AECGm[Int64(fetal_ini[iannot]+delta):Int64(fetal_fin[iannot]+delta),:]';
    end



    # Extracción de ejemplos antigüos
    println("Procesando Dictionary $(file_name)")
    d = load("../Dictionaries/$(file_name)_examples.jld")
    if isempty(Mat_To_Wavelet_Pos)
        Mat_To_Wavelet_Pos=d["pos_examples"];
        #Mat_To_Wavelet_Pos=vcat(d["pos_examples"], extrap_examples);
        Mat_To_Wavelet_Neg= vcat(d["neg_examples"], hn_examples);
        #Mat_To_Wavelet_Neg = hn_examples;

    else
        Mat_To_Wavelet_Pos=vcat(Mat_To_Wavelet_Pos,d["pos_examples"]);
        #Mat_To_Wavelet_Pos=vcat(Mat_To_Wavelet_Pos, extrap_examples);

        Mat_To_Wavelet_Neg=vcat(Mat_To_Wavelet_Neg,d["neg_examples"]);
        Mat_To_Wavelet_Neg = vcat(Mat_To_Wavelet_Neg, hn_examples);
    end
    

    #Mat_To_Wavelet_Neg = vcat(Mat_To_Wavelet_Neg, hn_examples);
    #Mat_To_Wavelet_Neg = vcat(
    
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

feature_Pos=zeros(Int64(size(Mat_To_Wavelet_Pos,1)/nch)*size(all_perms,1),dimFV*nch)
feature_Neg=zeros(Int64(size(Mat_To_Wavelet_Neg,1)/nch)*size(all_perms,1),dimFV*nch)

println("FeaturePos: $(size(feature_Pos,1))")
println("FeatureNeg: $(size(feature_Neg,1))")

(Fil,Col)=size(Mat_To_Wavelet_Pos);
iexemplar=1;
for k in 1:nch:Fil
    aux_pos=T_Aux_Sig_Pos[k:k+nch-1,1:dimFV];
    for x in all_perms
        part_Aux_Sig_Pos=aux_pos[x,:]
        
        feature_Pos[iexemplar,:] = vec(part_Aux_Sig_Pos')';
        iexemplar=iexemplar+1;
    end
    
end

(Fil,Col)=size(Mat_To_Wavelet_Neg);
iexemplar=1;
for k in 1:nch:Fil
    aux_neg=T_Aux_Sig_Neg[k:k+nch-1,1:dimFV];
    for x in all_perms
        part_Aux_Sig_Neg=aux_neg[x,:]
        
        feature_Neg[iexemplar,:] = vec(part_Aux_Sig_Neg')';
        iexemplar=iexemplar+1;
    end    
end





## Aplicar RF para clasificar 
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
pmodel=[]
gc()
#####################


println("\nTotal number of features vectors: $(size(norm_instances,1))")
println("Feature vector dimension: $(size(norm_instances,2))")

println("\nEntrenando Random Forest Classifier")

# nselFeat -> Numero de caracteristicas seleccionadas al azar en
#             cada split
# nTrees -> Numero de arboles


@time pmodel = build_forest(labels, norm_instances, nselFeat, nTrees, 1.0)

@printf "Guardando modelo\n"

out=open("../models/RFmodelX4_Ch1_$(dimFV)_randFeats$(nselFeat)_nTrees$(nTrees)_dwt_levels$(dwt_levels)_version2.jls", "w")
fullmodel=Dict("pmodel" => pmodel, "mean_instances"=>mean_instances, "std_instances"=>std_instances)
serialize(out, fullmodel)
close(out)

