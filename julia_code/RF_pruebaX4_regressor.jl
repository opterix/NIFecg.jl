########################
# First arg = dimension
# Second arg = nselFeat
# Third arg = nTree
# Fourth arg = dwt levels


using JLD
using Wavelets
using Combinatorics
using PyPlot
using DecisionTree
using Interpolations


function train_RF_regressor(record_id)

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

    #record_id
    #record_id="a03";

    #all_perms=collect(permutations(collect(1:nch)))
    all_perms=[collect(1:4)]
    ## Generar Wavelet de Daubechies ##
    xt = wavelet(WT.db7)	

    Ns=60000; #Numero total de muestras
    ks=128;   #muestras utilizadas para aplicar wavelet


    println("Setting parameters:")
    println("Feature vector dim: $(dim)")
    println("Number of feats per cut: $(nselFeat)")
    println("Number of Trees: $(nTrees)")
    println("dwt_levels: $(dwt_levels)\n")

    filename="$(record_id)"
    println("Procesando Señal $(filename)")
    (nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI, giniMeasure)=process_fetal(filename)


    ## Aplicar los coeficientes Wavelet a todos los casos positivos y negativos ##

    In_Signal=AECGm[:,1:nch];
    dwt_Signal=zeros(size(In_Signal))'
    
    for kch in 1:nch
        dwt_Signal[kch,:] = dwt(vec(In_Signal[:,kch]),xt,dwt_levels)
    end

    kfinal=Int64(Ns/2^dwt_levels)

    fetal_annot = fetal_annot[fetal_annot.<=Ns];
    fetal_annot = round(Int64, fetal_annot/2^dwt_levels)

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
    
    #Extraer vector de caracteristicas basadas en DWT
    instances = Wavelet_Sig;
    mean_instances=mean(instances,1)
    std_instances=std(instances,1)

    norm_instances=instances-repmat(mean_instances,size(instances,1),1)
    norm_instances=norm_instances./repmat(std_instances,size(instances,1),1)
    ## Normalizar features
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


    #@time pmodel = build_balanced_forest(labels, norm_instances, nselFeat, nTrees, 1.0)

    @time pmodel = build_forest(labels, norm_instances, nselFeat, nTrees, 0.7)

    @time aux_plabels = apply_forest(pmodel, norm_instances)
    predicted_labels=round(aux_plabels)

    @printf "Accuracy: %.2f%%\n" mean((predicted_labels .== labels))*100

    #Compute Confusion Matrix

    tp = (labels.==0) & (predicted_labels.==0)
    tn = (labels.==1) & (predicted_labels.==1)
    fp = (labels.==1) & (predicted_labels.==0)
    fn = (labels.==0) & (predicted_labels.==1)

    C= [sum(tp) sum(fp); sum(fn) sum(tn)]

    @printf "Fscore: %.2f\n" 2*sum(tp)/(2*sum(tp)+sum(fn)+sum(fp))

    tp = (labels.==0) & (predicted_labels.==0)
    tn = (labels.==1) & (predicted_labels.==1)
    fp = (labels.==1) & (predicted_labels.==0)
    fn = (labels.==0) & (predicted_labels.==1)

    C= [sum(tp) sum(fp); sum(fn) sum(tn)]

    fullmodel1=Dict("pmodel" => pmodel, "mean_instances"=>mean_instances, 
                    "std_instances"=>std_instances, "name"=>"Optimized_4ch_Nocombinatorics_TR$(record_id)", "nch"=>nch, "dim"=>dim,
                    "nselFeat"=>nselFeat, "nTrees"=>nTrees, "dwt_levels"=>dwt_levels, "record_id"=>record_id)

    return fullmodel1
end




function classify_opt(fullmodel)
    include("Main.jl")
    list_file=readdir("../data")
    
    num_files=size(list_file,1);
    
    nch=fullmodel["nch"]
    dimFV=fullmodel["dim"]
    nselFeat=fullmodel["nselFeat"]
    nTrees=fullmodel["nTrees"]
    dwt_levels=fullmodel["dwt_levels"]
    test_id = fullmodel["record_id"]
    
    Ns=10000; #Numero total de muestras
    ks=128;   #muestras utilizadas para aplicar wavelet
    
    pmodel=fullmodel["pmodel"]
    mean_instances=fullmodel["mean_instances"]
    std_instances=fullmodel["std_instances"]
    name=fullmodel["name"]
    
    RF_Probe=zeros(Ns-ks+1, ks);
    

    F_Ini=hcat(1: Ns-ks+1)';
    F_Fin=hcat(ks:Ns)';
    xt = wavelet(WT.db7);

    filename="$(test_id)"
    println("Procesando Señal $(filename)")
    (nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI, giniMeasure)=process_fetal(filename)
        
    In_Signal=circshift(AECGm[:,1:nch],[3,0]);
    dwt_Signal=zeros(size(In_Signal))'

    for kch in 1:nch
        dwt_Signal[kch,:] = dwt(vec(In_Signal[:,kch]),xt,dwt_levels)
    end

    #kfinal=Int64(size(dwt_Signal,2)/2^dwt_levels)
    kfinal=Int64(Ns/2^dwt_levels)
    aux_dwt = dwt_Signal[:,1:kfinal]

    println("Size aux_dwt")
    println(size(aux_dwt))

    Wavelet_Sig=zeros(kfinal-dimFV, dimFV*nch);
        

    for interval in 1:kfinal-dimFV
        eval_sig=aux_dwt[:,interval:interval+dimFV-1]
        Wavelet_Sig[interval,:]=eval_sig'[:]'
    end

    

    #Extraer vector de caracteristicas basadas en DWT
    instances = Wavelet_Sig;

    #Aplicando normalizacion
    norm_instances=instances-repmat(mean_instances,size(instances,1),1)
    norm_instances=norm_instances./repmat(std_instances,size(instances,1),1)
    
    println("Clasificando intervalos")

    @time predicted_labels = apply_forest(pmodel, norm_instances);

    itp=interpolate(predicted_labels, BSpline(Linear()),OnGrid())
    predicted_labels = itp[linspace(1, kfinal-dimFV, kfinal*2^dwt_levels)]
    
    

    fetal_annot = fetal_annot[fetal_annot.<=Ns];
        
    figure()
        #hold(true)
    plot(predicted_labels,color="black")
    plot(fetal_annot,zeros(size(fetal_annot,1)),"ro") 
    title("Classification Wavelet")
    #manager = get_current_fig_manager()
    #manager[:window][:attributes]("-zoomed", 1)
    #sleep(1)
    #manager[:window][:attributes]("-zoomed", 2)
    savefig("$(name)_TEST$(test_id)_$(dimFV)_$(nselFeat)_$(nTrees)_$(dwt_levels).png") 
    close("all")
end


function classify(fullmodel)
    include("Main.jl")
    list_file=readdir("../data")
    
    num_files=size(list_file,1);
    
    nch=fullmodel["nch"]
    dimFV=fullmodel["dim"]
    nselFeat=fullmodel["nselFeat"]
    nTrees=fullmodel["nTrees"]
    dwt_levels=fullmodel["dwt_levels"]
    test_id = fullmodel["record_id"]
    
    Ns=10000; #Numero total de muestras
    ks=128;   #muestras utilizadas para aplicar wavelet
    
    pmodel=fullmodel["pmodel"]
    mean_instances=fullmodel["mean_instances"]
    std_instances=fullmodel["std_instances"]
    name=fullmodel["name"]
    
    RF_Probe=zeros(Ns-ks+1, ks);
    Wavelet_Sig=zeros(Ns-ks+1, dimFV*nch);

    F_Ini=hcat(1: Ns-ks+1)';
    F_Fin=hcat(ks:Ns)';
    xt = wavelet(WT.db7);

    filename="$(test_id)"
    println("Procesando Señal $(filename)")
    (nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI, giniMeasure)=process_fetal(filename)
        
    In_Signal=AECGm[:,1:nch];
        
    for interval in 1:(Ns-ks)
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
    
    println("Clasificando intervalos NO opt")

    @time predicted_labels = apply_forest(pmodel, norm_instances);
    

    fetal_annot = fetal_annot[fetal_annot.<=Ns];
        
    figure()
        #hold(true)
    plot(predicted_labels,color="black")
    plot(fetal_annot,zeros(size(fetal_annot,1)),"ro") 
    title("Classification Wavelet")
    #manager = get_current_fig_manager()
    #manager[:window][:attributes]("-zoomed", 1)
    #sleep(1)
    #manager[:window][:attributes]("-zoomed", 2)
    savefig("$(name)_TEST$(test_id)_$(dimFV)_$(nselFeat)_$(nTrees)_$(dwt_levels).png") 
    close("all")
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


for k in 1:10
    fileID = @sprintf "a%02d" k
    println("Record: $(fileID)")        
    fullRF=train_RF_regressor(fileID)
    for j in k:k
        testID = @sprintf "a%02d" j
        fullRF["record_id"] = testID
        classify(fullRF)
    end
end
