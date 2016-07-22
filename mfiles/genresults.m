% MATLAB script for processing a Challenge 2013 data set with a Challenge entry
% Version 1.0  (13 February 2013)
%
% A script similar to this one will be used as part of the evaluation of
% Challenge entries written in m-code. We have provided these scripts so
% that Challenge participants can test their entries to verify that they
% run properly in the environment that will be used to test them.
%
% This script supplies a complete set of records, one at a time, to an
% entry, and collects its output for each record (a vector of  QRS
% annotations and an estimate of QT interval).
%
% If your entry is written in m-code, it must be in the form of a function
% named physionet2013, with this signature:
%         [fetal_QRSAnn_est,QT_Interval]=physionet2013(tm,ecgs)
%
% See the sample entry at http://physionet.org/challenge/2013/physionet2013.m
% for descriptions of the input and output variables.
%
% To use this script to obtain an unofficial score for your entry on set A:
%  1. Download these files from http://www.physionet.org/challenge/2013/ and
%     save them in your MATLAB working directory:
%	genresults.m		 (this file)
%       set-a-text.zip
%         or
%       set-a-text.tar.gz        (zip archive or tarball of set A CSV files)
%
%  2. Unzip set-a-text.zip (or unpack set-a.tar-text.gz), creating a
%     subdirectory within your working directory called 'set-a-text'.  When
%     you have completed this step, the set-a-text directory should contain
%     the individual signal files files (*.csv) as well as the reference
%     annotation files (*.fqrs.txt).
%
%  3. Save a copy of your entry (which should be named physionet2013.m) in
%     your working directory.  You can test this procedure using the sample
%     'physionet2013.m' we have provided, or you can use your own version.
%
%  4. The next few lines are MATLAB code that clears any previously set
%     variables, and sets the name of the directory containing the input
%     data, the name for the annotation/QT output files, and the name of
%     the files containing the known QRS intervals (*.fqrs).  Change them
%     if necessary.
%
% Note that if you run a test on a set more than once, this code will
% overwrite your output files!!

%Written by Ikaro Silva, 2013
%Last Modified: June, 14, 2013

clear all;close all;clc

% Suffix for binary WFDB fetal QRS annotation files produced by your entry
annotation_suffix='entry1';

% Suffix for reference binary WFDB fetal QRS annotation files supplied by PhysioNet
annotation_answer_suffix='fqrs';

% set_name is the name of the working directory containing the input
% CSV files.  Your entry's output annotation files will be written into
% this directory.  When you unpacked set A, the reference annotation
% files were also written in this working directory.  The reference
% annotation files will be inaccessible to your code while it is being
% evaluated using set B or set C.  The challenge is (in part) to produce
% annotation files that are as similar to the hidden reference annotation
% files as possible.
set_name='set-a'; % (change this to use other datasets)

rec_ext='dat'; % (using the WFDB binary dataset)

%QT Interval file: example of how to set the suffix in order to generate
% files for the QT interval (stored in the same location as the annotation
% files).
% NOTE that for this to work you will have to comment out or delete the
% qt_suffix=''; line right below.

qt_suffix='qt1';

%NOTE: set qt_suffix to empty (as below) if you do not wisth to compete in this event
%this will stop the script from generating QT files int the same directory
qt_suffix='';


%Set 'show' to true to display the waveforms and their annotations
show=0;
clr={'k-','k-','k-','k-','b-'}; %Used for plotting only
records=dir(['*.' rec_ext]);
I=length(records);
display(['Processing ' num2str(I) ' records ...'])


% Each Challenge .csv file (record) contains ECG data for one patient,
% in 5 columns (the timestamp and four abdominal_ecgs).  During each
% iteration of the loop below, the contents of a single record are
% loaded into arrays named tm and abdominal_ecgs. Your physionet2013.m
% then generates a set of annotations, fetal_QRSAnn_est, and an
% estimated QT interval that will be stored in files with the same
% record name but with suffixes defined by the values you have chosen
% above for 'annotation_sufix' and 'qt_suffix'. The output files are all
% kept in the same directory as the data (i.e., 'set-a-text' for set a).

score_cache=dir(['*rr_*']);
if(~isempty(score_cache))
   warning(['Your directory containes unremoved score cache files. Results may not be accurate.'...
       'Please remove any file in the format aXX.rr_* : ' score_cache(:).name]);
end

SCORES=zeros(I,2)+NaN;
unscored=0;
for i=1:I
    
    record_id=records(i).name(1:3);
    fname=[record_id '.' rec_ext];
    fname_ann_out=[record_id annotation_suffix];
    fname_qt_out=[record_id qt_suffix];
    answers=[record_id annotation_answer_suffix];
    
    [tm,ecgs]=rdsamp(record_id);
    
    % The contents of one input file are now ready to be given to your
    % physionet2013 function for analysis in the next line:
    
    %Get answers if the annotations are available
    ecgs_aux=ecgs;
    ecgs_aux(isnan(ecgs))=-32768;
    QRSAnn=rdann(record_id, annotation_answer_suffix); %Extraer anotación
    
    %Get the answers for this record file
    [fetal_QRSAnn_est,QT_Interval]=physionet2013(tm,ecgs_aux);
    
    if size(fetal_QRSAnn_est,1)==1
        fetal_QRSAnn_est=fetal_QRSAnn_est';
    end
    
    aux=pdist2(fetal_QRSAnn_est,tm);
    [minimo, QRSAnn_est]=min(aux,[],2);
                
    
    try
        %Save annotations as binary WFDB files
        %wrann(record_id,annotation_suffix,fetal_QRSAnn_est);
        wrann(record_id,annotation_suffix,QRSAnn_est);
    catch exception
        warning(['Could write file: ' record_id '.' annotation_suffix])
        if(isempty(fetal_QRSAnn_est))
            warning(['No annotations estimated. '])
        end
    end
    if(~isempty(qt_suffix))
        try
            %Save QT estimates as normal txt files
            csvwrite(fname_qt_out,QT_Interval);
        catch exception
            warning(['Could not write file: ' fname_qt_out])
            throw(exception)
        end
    end
    if(strcmp(set_name,'set-a'))
        try
    %        %Provide answers to set A
            %[s1,s2]=score2013(record_id,annotation_answer_suffix,annotation_suffix);
            %SCORES(i,:)=[s1,s2];
            
            sal=tach(record_id,annotation_answer_suffix,[],[],12);
            sal2=tach(record_id, annotation_suffix, [], [], 12);
            
            
            sal(1:2,:)=[];
            sal2(1:2,:)=[];

            %usar esta o mxm??
            s1=mean((sal2-sal).^2);
            s2=s1;
            
            SCORES(i,:)=[s1,s2];
            
            display([record_id ' ( ' num2str(i) '/' num2str(I) '): score1= '...
                num2str(s1) ' score2= ' num2str(s2) ])
        catch
            warning(['!!Could not score record: ' record_id])
            unscored=unscored+1;
    %        %Unscored entries are assigned a very high value
            SCORES(i,:)=[8000 200];
        end
    end
    
    % If 'show' was set to true above, display results for individual records
    if(show)
        [N,M]=size(ecgs);
        figure
        for m=1:M
            sig=ecgs(:,m);
            if(nansum(sig))
                
                
                
                
                sig=(sig-nanmean(sig))./(nanmax(sig)-nanmean(sig));
                plot(sig + (m-1)*2,clr{m});hold on;grid on
                plot(QRSAnn_est,sig(QRSAnn_est)+(m-1)*2,...
                    'o','MarkerSize',7,'MarkerEdgeColor','r','LineWidth',2)
                if(~isempty(QRSAnn))
                    plot(QRSAnn,sig(QRSAnn)+(m-1)*2,'x','MarkerSize',7,...
                        'MarkerEdgeColor','g','LineWidth',2)
                    lgd={'ECG','FQRS Estimate','FQRS Answer'};
                else
                    lgd={'ECG','FQRS Estimate'};
                end
                
            end
        end
        title(['Record id: ' record_id])
        xlabel('Time (ms)')
        legend(lgd)
        
        %pause();
    end
    
    if(~mod(i,5))
        display(['Processed: ' num2str(i) ' records out of ' num2str(I)])
    end
end

display(['Finished!!'])
SCORES2=nanmean(SCORES);
fprintf(['Average scores are:\n\tEvent 1/4=%.2d\n\tEvent 2/5=%.2d\n'],SCORES2(1),SCORES2(2))
display(['Total unscored records: ' num2str(unscored)])
