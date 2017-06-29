
############## LIBRARIES ##############
using MultivariateStats, DSP, Wavelets, JLD, Distances

############# FUNCTIONS ####################
include("process_svs.jl")
include("process_txt.jl")
include("Notch_Filter_Detrent.jl")
include("MakeICAll.jl")
include("SortICA.jl")
include("QRSm_detector.jl")
include("QRSf_selector.jl")
include("Font_Separation_SVD.jl")
include("pan_tomkins_detector.jl")
include("gini.jl")

############# ALL SOURCES #######################

# function process_fetal(filename)

############# SOURCES #######################

mkdir("../Dictionaries")  # Un directorio para guardar los diccionarios generados

data_path="../data"
list_file=readdir(data_path)
num_files=size(list_file,1)
#leer todos los datos en directorio data

Xmult=5; #Multiply number of exampes per Xmult


for i in 1:num_files
    file_name = list_file[i]
    file_name = file_name[1:end-4]
    println("Procesando record $(file_name)")


    filename=file_name

    ############# GLOBAL VARIABLES ################

    fv_size=128;

    window_size = 60 #seconds
    sr=1000 #Sample rate
    ns = window_size * sr #number of samples

    ############ LOAD DATA ######################
    #----------- Read and fix data --------------
    (t,AECG) = process_svs(filename)
    fetal_annot = process_txt(filename,ns)

    #----------- Load data according global varaibles ----
    AECG = AECG[1:ns,:]
    t = t[1:ns,:]
    nch = size(AECG,2) # nch - number of channels

    # ########### PREPROCESING ####################
    #------- Notch Filtering and detrending ------------
    (AECG_fnotch, lowSignal) = notch_filter(AECG, sr)
    #----------- Median filter ----------------
    window = 2000 # size of window in number of samples
    AECG_clean = AECG_fnotch


    ########## SOURCE SEPARATION ################
    #----------------- ICA ----------------------
    nc = nch # number of components
    (AECG_white) = MakeICAll(AECG_clean,nch,nc)
    println(maximum(AECG_clean));

    #------------ Sort ICA results ----------------------
    #(AECG_sort)=SortICA(AECG_white)
    #----------- Resamplig signal -----------------------
    #fact=2 # factor to resample the signal
    #(t_resmp,AECG_resample) = InterpSignal(AECG_white)


    #------------ Pan - Tomkins Detector QRS------------------
    (QRSmcell_pos, QRSmcell_value)=Pan_Tomkins_Detector(AECG_white, sr,nch);
    QRSm_pos=QRSmcell_pos[1];
    QRSm_value=QRSmcell_value[1];

#rr smoothing de ida
    flag=1; #bandera para aplicar segun frecuencas fetales o maternas
    (QRSmcell_pos_smooth) = smooth_RR(QRSmcell_pos, nch, sr,flag);


    SMI = smi_computation(QRSmcell_pos_smooth, nch, sr);

    auxidx=sortperm(vec(SMI)); 
    AECG_white=AECG_white[:,auxidx];
    QRSmcell_pos_smooth=QRSmcell_pos_smooth[auxidx];
    QRSmcell_pos=QRSmcell_pos[auxidx];
    QRSmcell_value=QRSmcell_value[auxidx];
    SMI=SMI[auxidx];

    QRSm_pos=QRSmcell_pos_smooth[1];
    heart_rate_mother = (60*size(QRSm_pos,1))/window_size


    #------- SVD process and subtract mother signal---------

    (SVDrec,AECGm) = Font_Separation_SVD(AECG_clean,QRSm_pos,sr,nch,ns);

    #Normalizar AECGm
    #for i in 1:nch
    #    AECGm[:,i]= (AECGm[:,i]-mean(AECGm[:,i]))/quantile(AECGm[:,i], 0.99);
    #end


    fetal_ini=fetal_annot-(fv_size)/2;
    fetal_fin=(fetal_annot+(fv_size)/2)-1;

    if fetal_ini[1]<1;
	deleteat!(fetal_ini,1);
	deleteat!(fetal_fin,1);
	deleteat!(fetal_annot,1);
    end	

    pos_examples = zeros(nch*size(fetal_annot,1)*Xmult, fv_size);
    neg_examples = zeros(nch*size(fetal_annot,1)*Xmult, fv_size);


    AECGm=vcat(AECGm, zeros(128,4));
    total_annot = size(fetal_annot,1)

    for iannot = 1:total_annot
              

        if iannot==1
            neg_points = linspace(fv_size/2 + 1,fetal_annot[1],Xmult)
        else
            neg_points = linspace(fetal_annot[iannot-1] + fv_size, fetal_annot[iannot] - fv_size,Xmult);
        end

        neg_point_ini=   round(Int64, neg_points-(fv_size)/2);
        neg_point_fin=   round(Int64, neg_points+((fv_size)/2))-1;



        #if any(neg_point_ini.<=0);
        #    neg_point_ini[any(neg_point_ini.<=0)]=1;
        #    neg_point_fin=fv_size;
        #end
	   
        for ipoint=1:Xmult
            t0=(Xmult-1)/2
            pos_examples[((iannot-1)*4+1)+(total_annot*(ipoint-1)*4):iannot*4+total_annot*(ipoint-1)*4,:] = AECGm[Int64(fetal_ini[iannot]+(-t0+ipoint-1)*2):Int64(fetal_fin[iannot]+(-t0+ipoint-1)*2),:]';
        end
        #print(iannot);
        #println("Tamaño")
        #println(size(neg_point_ini,1));
        
        
        for ipoint in 1:size(neg_point_ini,1)
            #println()
            #print("$(((iannot-1)*4+1)+(total_annot*(ipoint-1)))..")
            neg_examples[((iannot-1)*4+1)+(total_annot*(ipoint-1)*4):iannot*4+total_annot*(ipoint-1)*4,:] = AECGm[neg_point_ini[ipoint]:neg_point_fin[ipoint],:]'
        end
        
    end


    save("../Dictionaries/$(filename)_examples.jld", "pos_examples", pos_examples, "neg_examples", neg_examples)

end
