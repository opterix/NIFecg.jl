############## LIBRARIES ##############
using MultivariateStats, Base.Test, DataFrames, PyPlot, DSP, Distances

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

function process_fetal(filename)

############# SOURCES #######################
#filename="a12"

############# GLOBAL VARIABLES ################
    window_size = 20#seconds
    sr=1000 #Sample rate
    ns = window_size * sr #number of samples

    flag_Anot=true;
    ecg_nativos=false;

############ LOAD DATA ######################
#----------- Read and fix data --------------
    (t,AECG) = process_svs(filename)
    if flag_Anot
        fetal_annot = process_txt(filename,ns)
    else
        fetal_annot=0;
    end

    if ecg_nativos
        AECG = AECG*22350;
    end

#----------- Load data according global varaibles ----
AECG = AECG[1:ns,:]
t = t[1:ns,:]
nch = size(AECG,2) # nch - number of channels

# ########### PREPROCESING ####################
#------- Notch Filtering and detrending ------------
(AECG_fnotch, lowSignal) = notch_filter(AECG, sr)
#----------- Median filter ----------------
window = 2000 # size of window in number of samples
#(AECG_clean) = MedianFilter(AECG_fnotch,window,ns,nch,sr)
AECG_clean = AECG_fnotch


########## SOURCE SEPARATION ################
#----------------- ICA ----------------------
nc = nch # number of components
(AECG_white) = MakeICAll(AECG_clean,nch,nc)


#------------ Sort ICA results ----------------------
#(AECG_sort)=SortICA(AECG_white)
#----------- Resamplig signal -----------------------
#fact=2 # factor to resample the signal
#(t_resmp,AECG_resample) = InterpSignal(AECG_white)
#------------ Pan - Tomkins Detector QRS------------------
(QRSmcell_pos, QRSmcell_value)=Pan_Tomkins_Detector(AECG_white, sr, nch);
#Implementar la parte de selección
    
    
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




#-------------------------------------------------------
#----------- QRS mother detector -----------------------
#(QRSm_pos,QRSm_value)= QRSm_detector(AECG_white,ns,sr)

#heart_rate_mother = (60*size(QRSmcell_pos[1],1))/window_size



#------- SVD process and subtract mother signal---------

(SVDrec,AECGm) = Font_Separation_SVD(AECG_clean,QRSm_pos,sr,nch,ns);
AECGf = MakeICAfeto(AECGm,nc,nch)
(AECGf2, frecQ, Qfactor) = QRSf_selector(AECGf, nc)
    #@time (QRSf_pos,QRSf_value)= QRSf_detector(AECGf,ns,sr)

    #Aplicar transformada de Hilbert?
    #fftHilbert= -j*sign(AECGf2).*fft(AECGf2)
    
    

(QRSfcell_pos,QRSfcell_value)= Pan_Tomkins_Detector(AECGf2, sr, nch)

    QRSf_value=QRSfcell_value[1];
#    maxSeg=size(AECGm,1)/sr;

    #rr smoothing de ida
    flag=2; #bandera para aplicar segun frecuencas fetales o maternas
    (QRSfcell_pos_smooth) = smooth_RR(QRSfcell_pos, nch, sr,flag);

#    for kch in 1:nch
#        QRSfcell_pos_smooth[kch]=flipdim(maxSeg - QRSfcell_pos_smooth[kch], 1)
#    end

    #rr smoothing de vuelta
#    (QRSfcell_pos_smooth) = smooth_RR(QRSfcell_pos, nch, sr);

    #Vuelta a orden original
#    for kch in 1:nch
#        QRSfcell_pos_smooth[kch]=flipdim(maxSeg - QRSfcell_pos_smooth[kch], 1)
#    end


    SMI = smi_computation(QRSfcell_pos_smooth, nch, sr);

    auxidx=sortperm(vec(SMI));
    AECGf2=AECGf2[:,auxidx];
    QRSfcell_pos_smooth=QRSfcell_pos_smooth[auxidx];
    QRSfcell_pos=QRSfcell_pos[auxidx];
    QRSfcell_value=QRSfcell_value[auxidx];
    SMI=SMI[auxidx];

    QRSf_pos=QRSfcell_pos_smooth[1];
    heart_rate_feto = (60*size(QRSf_pos,1))/window_size

    FreqDiff = 1 - abs(heart_rate_mother-heart_rate_feto)/heart_rate_mother;

#    println(FreqDiff)
    
    if FreqDiff > 0.9;
        auxidx = [2,3,4,1];
        AECGf2=AECGf2[:,auxidx];
        QRSfcell_pos_smooth=QRSfcell_pos_smooth[auxidx];
        QRSfcell_pos=QRSfcell_pos[auxidx];
        QRSfcell_value=QRSfcell_value[auxidx];
        SMI = SMI[auxidx];

        QRSf_pos=QRSfcell_pos_smooth[2];
        heart_rate_feto = (60*size(QRSf_pos,1))/window_size

    end

return nch,AECG,ns,t,sr,AECG_clean,QRSm_pos,QRSm_value,QRSf_pos,QRSf_value,AECG_white,fetal_annot,AECGf2,QRSfcell_pos,QRSfcell_value,heart_rate_mother,heart_rate_feto,AECGm, SVDrec, frecQ, Qfactor, QRSfcell_pos_smooth, SMI;

#-------Channel Selection after ICA---------
#FETO=QRSf_selector(AECGf,nch);
#Feto_Det=FETO[:,4];

## Detector ECG feto con filtro derivativo
#nu=convert(Int64, ceil(0.005*sr));
#nz=convert(Int64, floor(0.003*sr/2)*2+1);
#B=vcat(ones(nu,1), zeros(nz,1), -1*ones(nu,1))
#delay=convert(Int64, floor(length(B)/2));

#ecgfx=vcat(repmat(AECGf2[1,:],1,delay)', AECGf, repmat(AECGf2[end,:],1,delay)')
#der=PolynomialRatio(vec(B),[1])
#ecg_der=filt(der,ecgfx);
#ecg_der=ecg_der[2*delay+1:end,:]

#responseType=Bandpass(0.7,8;fs=sr)
#designMethod=Butterworth(10);
#salida = filtfilt(digitalfilter(responseType, designMethod), ecg_der);
end
