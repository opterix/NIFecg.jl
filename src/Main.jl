############## LIBRARIES ##############
using MultivariateStats, Base.Test, DataFrames, PyPlot, DSP, Distances

############# FUNCTIONS ####################
include("loadDataModule.jl")
include("preProcessingModule.jl")

include("makeIcaAll.jl")

include("QRSm_detector.jl")
include("QRSf_detector.jl")
include("QRSf_selector.jl")
include("MedianFilter.jl")
include("Font_Separation_SVD.jl")
include("MakeICAfeto.jl")
include("Plotting.jl")
include("panTomkinsDetector.jl")
include("QRSf_selector.jl")
include("gini.jl")

############# ALL SOURCES #######################

function process_fetal(filename)

############# GLOBAL VARIABLES ################
window_size = 20 #seconds
sr=1000 #Sample rate
ns = window_size * sr #number of samples

############ LOAD DATA ######################
(nch,t,AECG,fetal_annot) = loadDataModule(filename,ns)

########### PREPROCESING ####################
(AECG_clean, lowSignal) = preProcessingModule(AECG, sr)


########## MOTHER SUBSTRACTION ################



########## SOURCE SEPARATION ################
#----------------- ICA ----------------------
(AECG_white) = makeIcaAll(AECG_clean,nch)


#----------------------------------------------
#---- QRS mother detector (Pan - Tomkins) -----

(QRSmcell_pos, QRSmcell_value)=panTomkinsDetector(AECG_white, sr, nch);
QRSm_pos=QRSmcell_pos[1];
QRSm_value=QRSmcell_value[1];

#Implementar la parte de selección
    

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
AECGf = MakeICAfeto(AECGm,nch,nch)
    (AECGf2, frecQ, Qfactor) = QRSf_selector(AECGf, nch)



(QRSfcell_pos,QRSfcell_value)= Pan_Tomkins_Detector(AECGf2, sr, nch)

    QRSf_value=QRSfcell_value[1];
#    maxSeg=size(AECGm,1)/sr;

    #rr smoothing de ida
    flag=2; #bandera para aplicar segun frecuencas fetales o maternas
    (QRSfcell_pos_smooth) = smooth_RR(QRSfcell_pos, nch, sr,flag);

    SMI = smi_computation(QRSfcell_pos_smooth, nch, sr);

    giniMeasure = zeros(nch)
    for kch in 1:nch
        if length(QRSfcell_pos_smooth[kch])<=10
            giniMeasure[kch] = 0
        else
            giniMeasure[kch] = gini(AECGf2[:,kch])
        end
    end
    #idx_new=sortperm(giniMeasure, rev=true);
    #AECGf2=AECGf2[:,idx_new];


    #auxidx=sortperm(vec(SMI));
    auxidx=sortperm(giniMeasure, rev=true);
    AECGf2=AECGf2[:,auxidx];
    QRSfcell_pos_smooth=QRSfcell_pos_smooth[auxidx];
    QRSfcell_pos=QRSfcell_pos[auxidx];
    QRSfcell_value=QRSfcell_value[auxidx];
    SMI=SMI[auxidx];
    QRSf_pos=QRSfcell_pos_smooth[1];
    giniMeasure=giniMeasure[auxidx]

    
    heart_rate_feto = (60*size(QRSf_pos,1))/window_size
    FreqDiff = 1 - abs(heart_rate_mother-heart_rate_feto)/heart_rate_mother;

    if FreqDiff > 0.9;
        auxidx = [2,3,4,1];
        AECGf2=AECGf2[:,auxidx];
        QRSfcell_pos_smooth=QRSfcell_pos_smooth[auxidx];
        QRSfcell_pos=QRSfcell_pos[auxidx];
        QRSfcell_value=QRSfcell_value[auxidx];
        SMI = SMI[auxidx];
        giniMeasure=giniMeasure[auxidx]
        QRSf_pos=QRSfcell_pos_smooth[1];
        heart_rate_feto = (60*size(QRSf_pos,1))/window_size
    end




return nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI, giniMeasure;

end
