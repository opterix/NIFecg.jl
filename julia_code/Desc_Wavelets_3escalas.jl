using DSP, Wavelets, JLD, Combinatorics, DecisionTree

function extractDWTFeatures(record_id)

    include("Main.jl")
    list_file=readdir("../data")

    dimFV=dim
    

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
    #all_perms=[collect(1:4)]
    ## Generar Wavelet de Daubechies ##
    xt = wavelet(WT.db7)	

    Ns=60000; #Numero total de muestras
    ks=128;   #muestras utilizadas para aplicar wavelet


    println("Setting parameters:")
    println("Feature vector dim: $(dim) per channel")
    println("dwt_levels: $(dwt_levels)\n")

    filename="$(record_id)"
    println("Procesando Señal $(filename)")
    (nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI, giniMeasure)=process_fetal(filename)


    ## Aplicar los coeficientes Wavelet a todos los casos positivos y negativos ##

    #Normalizar AECGm
    #for i in 1:nch
    #    AECGm[:,i]= (AECGm[:,i]-mean(AECGm[:,i]))/quantile(AECGm[:,i], 0.99);
    #end

    In_Signal=AECGm[:,1:nch];
    dwt_Signal=zeros(size(In_Signal))'
    
    for kch in 1:nch
        dwt_Signal[kch,:] = dwt(vec(In_Signal[:,kch]),xt,dwt_levels)
    end

    kfinal=Int64(Ns/2^dwt_levels)


    fetal_annot = round(Int64, fetal_annot/2^dwt_levels)
    
    fetal_annot = fetal_annot[fetal_annot.<kfinal-dimFV];
    fetal_annot = fetal_annot[fetal_annot.>dimFV/2]

    aux_dwt = dwt_Signal[:,1:kfinal]
    Wavelet_Sig=zeros(size(all_perms,1)*(kfinal-dimFV), dimFV*nch);
    
    labels=ones(kfinal-dimFV)
    labels[round(Int64, fetal_annot-dimFV/2)]=0
    
    for iperm in 1:size(all_perms,1)
        for interval in 1:kfinal-dimFV
            eval_sig=aux_dwt[:,interval:interval+dimFV-1]
            eval_sig=eval_sig[all_perms[iperm],:]
            Wavelet_Sig[interval+(iperm-1)*(kfinal-dimFV),:]=eval_sig'[:]'
        end
    end

    labels=repmat(labels, size(all_perms,1))
    instances = Wavelet_Sig;

    return labels,instances
end


if isempty(ARGS)
    dim = 16
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


#########################################################
# Extraccion de los diccionarios

 mkdir("../DictionariesDWT")  # Un directorio para guardar los diccionarios generados

 for k in 1:50
    fileID = @sprintf "a%02d" k
    println("Record: $(fileID)")        
    labels, instances = extractDWTFeatures(fileID)
    save("../DictionariesDWT/$(fileID)_dwtfeats.jld", "labels", labels, "instances", instances)
 end


##########################################################
# Entrenamiento del random Forest

# data_dictio="../DictionariesDWT"
# list_file=readdir(data_dictio)
# num_files=size(list_file,1);

# all_instances=[]
# all_labels=[]

# for i in 1:10
#     file_name = list_file[i];
#     println("Procesando Dictionary $(file_name)")
#     d = load("$(data_dictio)/$(file_name)")
#     if isempty(all_instances)
#         all_instances = d["instances"];
#         all_labels = d["labels"];
#     else
#         all_instances = vcat(all_instances,d["instances"])
#         all_labels = vcat(all_labels, d["labels"])
#     end
# end

# mean_instances=mean(all_instances,1)
# std_instances=std(all_instances,1)

# norm_instances=all_instances-repmat(mean_instances,size(all_instances,1),1)
# norm_instances=norm_instances./repmat(std_instances,size(all_instances,1),1)


# println("\nTotal number of features vectors: $(size(norm_instances,1))")
# println("Feature vector dimension: $(size(norm_instances,2))")

# println("\nEntrenando Random Forest Classifier")

# @time pmodel = build_forest(all_labels, norm_instances, nselFeat, nTrees, 0.7)

# @time aux_plabels = apply_forest(pmodel, norm_instances)
#     predicted_labels=round(aux_plabels)

#     @printf "Accuracy: %.2f%%\n" mean((predicted_labels .== all_labels))*100

#     #Compute Confusion Matrix

#     tp = (all_labels.==0) & (predicted_labels.==0)
#     tn = (all_labels.==1) & (predicted_labels.==1)
#     fp = (all_labels.==1) & (predicted_labels.==0)
#     fn = (all_labels.==0) & (predicted_labels.==1)

#     C= [sum(tp) sum(fp); sum(fn) sum(tn)]

#     @printf "Fscore: %.2f\n" 2*sum(tp)/(2*sum(tp)+sum(fn)+sum(fp))

#     fullmodel1=Dict("pmodel" => pmodel, "mean_instances"=>mean_instances, 
#                     "std_instances"=>std_instances, "nch"=>4, "dim"=>dim,
#                     "nselFeat"=>nselFeat, "nTrees"=>nTrees, "dwt_levels"=>dwt_levels)


# out=open("../model/RFmodelX4_Ch1_$(dim)_randFeats$(nselFeat)_nTrees$(nTrees)_dwt_levels$(dwt_levels).jls", "w")
# fullmodel=Dict("pmodel" => pmodel, "mean_instances"=>mean_instances, "std_instances"=>std_instances, "nch"=>4, "dim"=>dim,                    "nselFeat"=>nselFeat, "nTrees"=>nTrees, "dwt_levels"=>dwt_levels)
# serialize(out, fullmodel)
# close(out)
