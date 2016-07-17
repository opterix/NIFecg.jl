<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. Preprocessing</a>
<ul>
<li><a href="#sec-1-1">1.1. Artifact Canceling</a>
<ul>
<li><a href="#sec-1-1-1">1.1.1. liquid-dsp -&gt; c++ library</a></li>
<li><a href="#sec-1-1-2">1.1.2. aquila -&gt; c++ library</a></li>
<li><a href="#sec-1-1-3">1.1.3. spuc -&gt; c++ library</a></li>
<li><a href="#sec-1-1-4">1.1.4. libc, libm, fftw -&gt; c libraries</a></li>
<li><a href="#sec-1-1-5">1.1.5. Digital filters -&gt; github.com/vinniefalco/DSPFilters -&gt; c++ library</a></li>
</ul>
</li>
<li><a href="#sec-1-2">1.2. Detrending</a></li>
<li><a href="#sec-1-3">1.3. Power Line interference removal by notch filtering</a></li>
</ul>
</li>
<li><a href="#sec-2">2. mECG separation and canceling</a>
<ul>
<li><a href="#sec-2-1">2.1. Independent Component Analysis</a>
<ul>
<li><a href="#sec-2-1-1">2.1.1. LibICA</a></li>
</ul>
</li>
<li><a href="#sec-2-2">2.2. Signal Interpolation</a></li>
<li><a href="#sec-2-3">2.3. Channel selection and mother QRS detection</a></li>
<li><a href="#sec-2-4">2.4. Mother QRS cancelling</a></li>
</ul>
</li>
<li><a href="#sec-3">3. fECG extraction and fQRS detection</a>
<ul>
<li><a href="#sec-3-1">3.1. Source separation by ICA on residual signals</a></li>
<li><a href="#sec-3-2">3.2. Channel selection and Fetal QRS detection</a></li>
</ul>
</li>
<li><a href="#sec-4">4. All</a></li>
<li><a href="#sec-5">5. Evaluation code</a></li>
<li><a href="#sec-6">6. Task related with c code implementation</a></li>
</ul>
</div>
</div>
Documento para mapear todo el código de Varanini

ECG -> 60000x4 (4canales 60000 muestras) 1000Hz

# Preprocessing

## Artifact Canceling

  % -&#x2014; Artifact canceling -&#x2014;
  % X=FecgFecgImpArtCanc(ECG,fs,cName,graph,dbFlag);
  X=FecgImpArtCanc(ECG,fs,cName,0,0);
 % Impulsive artifact removal from each ECG channel,
% applying the function "ImpArtElimS" to each channel.

Median filter -> Implementation

### liquid-dsp -> c++ library

### aquila -> c++ library

### spuc -> c++ library

### libc, libm, fftw -> c libraries

### Digital filters -> github.com/vinniefalco/DSPFilters -> c++ library

## Detrending

%   ECG detrending
%
%  A baseline signal is estimated applying a low pass Butterworth filter 
%  in forward and backward direction.  The filter cut frequency is 3.17Hz. 
%  Each detrended signal is obtained as difference between the original signal 
%  and the estimated baseline. 
%  In case of residual artifacts due to fast baseline movements, median filtering is used.

## Power Line interference removal by notch filtering

  % Analize el espectro en frecuencia para determinar si aplica un notch a 50Hz o a 60 Hz. y despues lo aplica zero phase filter
% Notch filter

# mECG separation and canceling

## Independent Component Analysis

% &#x2013;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;
%   Fecg: Independent Component Analysis for mother ecg separation
%   Fixed point algorithm of Hyvarinen with deflationary ortogonalization is applied.
%   In a first attempt the hyperbolic cosine as contrast function is used because it 
%   produces more robust estimates. In case of failure of convergence the algorithm 
%   was run a second time using the kurtosis.
FastICA, Hyvarinen ()

### LibICA

## Signal Interpolation

Interpolacion de la señal usando fft

fftw-> Convertir a fft y luego conversion inversa con mas puntos.

## Channel selection and mother QRS detection

%   Fecg: "Mother" QRS detection
%  - Best mother ECG selection based on a priori information on mother ECG pseudo-periodicity.
%    A raw derivative filter signal obtained as the difference between 
%    the average values on two intervals of 7ms far off 9ms)
%  - The absolute value of the raw derivative signal was filtered by a forward backward 
%    Butterworth bandpass filter (6.3-16.Hz).
%  - mother QRS detection based on this absolute derivative
%
% Tambien QRS detector

## Mother QRS cancelling

% &#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;
% Fecg: "Mother" ECG canceling using  PQRST approximation obtained by 
% Singular Value Decomposition (SVD).
% A trapezoidal window is used to select and weight the signal around each detected mother QRS.
SVD implementacion C: Probably CLAPACK -> 
gams.nist.gov 
www.netlib.org

# fECG extraction and fQRS detection

## Source separation by ICA on residual signals

%   Fecg: Fetal ecg enhancement by ICA
%   Fixed point algorithm of Hyvarinen with deflationary ortogonalization is applied.
%   In a first attempt the hyperbolic cosine as contrast function is used because it 
%   produces more robust estimates. In case of failure of convergence the algorithm 
%   was run a second time using the kurtosis.

## Channel selection and Fetal QRS detection

# All

% -&#x2014; detrending  -&#x2014;
% Xd=FecgDetrFilt(X,fs,cName,graph,dbFlag);
Xd=FecgDetrFilt(X,fs,cName,0,0);

% -&#x2014; Power line interference removal by notch filtering -&#x2014;
% Xf=FecgNotchFilt(Xd,fs,cName,graph,dbFlag);
Xf=FecgNotchFilt(Xd,fs,cName,0,0);

% -&#x2014; Independent Component Analysis -&#x2014;
% Xm=FecgICAm(Xf,fs,cName,graph,dbFlag,saveFig);
Se=FecgICAm(Xf,fs,cName,graph,dbFlag,saveFig);

% -&#x2014; Signal interpolation
% Xi=FecgInterp(X,fs,interpFact,cName,graph);
[Se,fs]=FecgInterp(Se,fs,4,cName,0);

% -&#x2014; Channel selection and Mother QRS detection
qrsM=FecgQRSmDet(Se,fs,cName,graph,dbFlag,saveFig,qrsAf);

% -&#x2014; Mother QRS cancelling
Xr=FecgQRSmCanc(Se,qrsM,fs,cName,graph,dbFlag,saveFig,qrsAf);

% -&#x2014; Source separation by ICA on residual signals
Ser=FecgICAf(Xr,fs,cName,graph,dbFlag,saveFig);

% -&#x2014; Channel selection and Fetal QRS detection
% qrsF=FecgQRSfDniAdf(Ser,fs,cName,qrsM,graph,dbFlag,saveFig,saveFigRRf,qrsAf);
qrsF=FecgQRSfDet(Ser,fs,cName,qrsM,graph,dbFlag,saveFig,saveFigRRf,qrsAf);

    fetal<sub>QRSAnn</sub><sub>est</sub>=qrsF;
    QT<sub>Interval</sub>         = [];
%&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;&#x2014;
%   Fecg: Fetal QRS detection
%   - For each ECG channel:
%     - Fetal QRS pre-detection
%     - Identification of a good interval
%     - Fetal QRS detection in forward direction starting from the beginning
%       and in backward starting from the end of such a interval
%   - Best fetal QRS detection selection based on fetal RR variability and
%     fetal-mother QRS position coincidence

# Evaluation code

-   Implemente el codigo de evaluacion usando la función tach del wfdb toolbox. Al parecer tiene un bug, donde los dos primeros valores son casi siempre iguales, y parecen errados.

-   Ya envie un mensaje al repositorio de ellos para que lo tuvieran en cuenta.

# Task related with c code implementation

-   Implementacion en C para leer csv files. Usar libreria libcsv

-   Implementacion de filtros Notch, Wandering y cancelacion de artefactos -> Ventana de observación de 5segundos?

-   Al parecer mayoria de señales convergen para cosh ica!

-   Concentrarse en implementación preprocessing (2 semanas) -> 2h/dia.
