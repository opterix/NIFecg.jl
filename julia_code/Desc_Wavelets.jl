
############## LIBRARIES ##############
using MultivariateStats, Base.Test, DataFrames, PyPlot, DSP, Wavelets, JLD

############# FUNCTIONS ####################
include("process_svs.jl")
include("process_txt.jl")
include("Notch_Filter_Detrent.jl")
include("MakeICAll.jl")
include("SortICA.jl")
include("InterpSignal.jl")
include("QRSm_detector.jl")
include("QRSf_detector.jl")
include("QRSf_selector.jl")
include("MedianFilter.jl")
include("Font_Separation_SVD.jl")
include("MakeICAfeto.jl")
include("Plotting.jl")
include("pan_tomkins_detector.jl")
include("QRSf_selector.jl")

############# ALL SOURCES #######################

# function process_fetal(filename)

############# SOURCES #######################

mkdir("../Dictionaries")  # Un directorio para guardar los diccionarios generados

data_path="../data"
list_file=readdir(data_path)
num_files=size(list_file,1)
#leer todos los datos en directorio data


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

    #---------------------------------------------------------
    #----------- QRS mother detector -----------------------
    #(QRSm_pos,QRSm_value)= QRSm_detector(AECG_white,ns,sr)
    heart_rate_mother = (60*size(QRSmcell_pos[1],1))/window_size

    #------- SVD process and subtract mother signal---------

    (SVDrec,AECGm) = Font_Separation_SVD(AECG_clean,QRSm_pos,sr,nch,ns);

    pos_examples = zeros(nch*size(fetal_annot,1), fv_size);
    neg_examples = zeros(nch*size(fetal_annot,1), fv_size);

    fetal_ini=fetal_annot-(fv_size)/2;
    fetal_fin=(fetal_annot+(fv_size)/2)-1;

    if fetal_ini[1]<1;
	deleteat!(fetal_ini,1);
	deleteat!(fetal_fin,1);
	deleteat!(fetal_annot,1);

    end	

    AECGm=vcat(AECGm, zeros(128,4));


    for iannot = 1:size(fetal_annot,1)

        if iannot==1
            neg_point = fetal_annot[iannot]/2;
        else
            neg_point = (fetal_annot[iannot]+fetal_annot[iannot-1])/2;
        end

        neg_point_ini=   round(Int64, neg_point-(fv_size)/2);
        neg_point_fin=   round(Int64, neg_point+((fv_size)/2))-1;

        if neg_point_ini<=0;
            neg_point_ini=1;
            neg_point_fin=fv_size;
        end
	   
        
        pos_examples[(iannot-1)*4+1:iannot*4,:] = AECGm[Int64(fetal_ini[iannot]):Int64(fetal_fin[iannot]),:]';
        #print(iannot);
        #println(iannot);

        neg_examples[(iannot-1)*4+1:iannot*4,:] = AECGm[neg_point_ini:neg_point_fin,:]'
        
    end


    save("../Dictionaries/$(filename)_examples.jld", "pos_examples", pos_examples, "neg_examples", neg_examples)

end
