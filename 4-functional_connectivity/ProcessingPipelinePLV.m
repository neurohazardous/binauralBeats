%addpath('Teqcspec')
%addpath(genpath('fieldtrip-read-only'))
%addpath(genpath('erplab_4.0.3.1'))

addpath(('~/Dropbox/matlab/eeglab12_0_2_6b_light'))
eeglab nogui
eeglab rebuild

clear
% 2 frequencies: 7Hz and 40Hz
% ·7 Hz: 396.5 + 403.5 (Theta)
% 	·40Hz: 380 + 420 (Gamma)

freqsBeat=[7 40];
freqsStim={'T','G'};
conditions={'MB','BB'};
% 65 'Nose'
% 66 'VEOGL'
% 67 'HEOGL'
% 68 'HEOGR'
% 69 'M1'
% 70 'M2'
% 73 'GSR1'
% 74 'Resp'
% 75 'Left'
% 76 'Right'
elecNum=64;

%% Get data (correct the issue with S016) and create global synchronization matrix
folders=dir('../Data/Preproc/');
for n=1:length(folders)
    fold=folders(n).name;
    if (fold(1)~='.')&&(fold(1)~='P')
        disp(fold)
        %Create the globalSyncXP
        globalSyncXP=zeros(2,2,2,elecNum,elecNum);
        for freq=1:2
            for cond=1:2
                filename=[fold '_Beat_' conditions{cond} freqsStim{freq}];
                EEG = pop_loadset('filename',['../Data/Preproc/' fold '/' filename '_imported_ICA_pruned.set'],'filepath','.');
                
                if strcmp(folders(n).name,'S16')
                    EEG = pop_select( EEG,'nochannel',{'M1'});
                    EEG = eeg_checkset( EEG );
                end
                
                %Get all events that are not boundary
                mask=[];
                for ev=1:length(EEG.event)
                    if strcmp(EEG.event(ev).type,'boundary')
                        mask(ev)=0;
                    else
                        mask(ev)=1;
                    end
                end
                goodEvents=find(mask);
                
                % Get the average differences between events as measured by
                % samples
                InterEvent = mean(diff([EEG.event(goodEvents).latency]));
                
                
                for freqB=1:2
                    f1=freqsBeat(freqB)-1;
                    f2=freqsBeat(freqB)+1;
                    
                    Ncycle=8;
                    windowSizeF=InterEvent;%Ncycle/((f1+f2)/2)*2000;
                    stepSizeF=windowSizeF;
                    samplesNum=size(EEG.data,2);
                    
                    globalSync=zeros(elecNum,elecNum);
                    stepNormalize=0;
                    for step=goodEvents(1:end-1)%0:stepSizeF:samplesNum-windowSizeF-1
                        stepNormalize = stepNormalize + 1;
                        
                        % Hilbert transformation
                        EEG_hilbert = filter_hilbert_hanning_nonorm_2(double(EEG.data(1:elecNum,(EEG.event(step).latency):(EEG.event(step+1).latency)))',512,f1,f2,0);
                        %tic;[dist_sync,local_sync,freqind]=HBBL_iCoherence(double(EEG.data(1:elecNum,(EEG.event(1).latency):(EEG.event(length(EEG.event)).latency))),[1;48],512,2048,windowSize);toc;
                        
                        amp=abs(EEG_hilbert);
                        phase = EEG_hilbert./amp;
                        c = real(phase);
                        s = imag(phase);
                        
                        % Calculte PLI (I think)
                        dphi = c'*c + s'*s + 1i*(s'*c-c'*s);
                        syn=abs(dphi)/(size(c,1));
                        
                        %   local synchrony -- store Hilbert transform as a
                        %   local synchrony index!
                        local_sync=mean((amp.^2));
                        for m=1:elecNum
                            syn(m,m)=local_sync(m); % diagonal is the local index
                        end
                        
                        globalSync(:,:,stepNormalize)=syn;
                    end
                    globalSyncXP(freq,cond,freqB,:,:)=mean(globalSync,3); %get mean of PLV along the third dimension
                end
            end
        end
        mkdir(['../Data/Results/' fold '/'])
        save(['../Data/Results/' fold '/Hilbert_PLV_AMP_Measure'], 'globalSyncXP')
        
        clear globalSyncXP
        
        filename=[fold '_Beat_Baseline'];
        EEG = pop_loadset('filename',['../Data/Preproc/' fold '/' filename '_imported_ICA_pruned.set'],'filepath','.');

        if strcmp(folders(n).name,'S16')
            EEG = pop_select( EEG,'nochannel',{'M1'});
            EEG = eeg_checkset( EEG );
        end

        stepNormalize = 0;
        lastStep = 0;

        for freqB=1:2
            f1=freqsBeat(freqB)-1;
            f2=freqsBeat(freqB)+1;

            Ncycle=8;
            windowSizeF=InterEvent;
            stepSizeF=windowSizeF;
            samplesNum=size(EEG.data,2);

            globalSync=zeros(elecNum,elecNum);
            stepNormalize=0;
            for step=1:stepSizeF:samplesNum-windowSizeF-1
                stepNormalize = stepNormalize + 1;
                % Hilbert transformation
                EEG_hilbert = filter_hilbert_hanning_nonorm_2(double(EEG.data(1:elecNum,step:(step+windowSizeF)))',512,f1,f2,0);
                %tic;[dist_sync,local_sync,freqind]=HBBL_iCoherence(double(EEG.data(1:elecNum,(EEG.event(1).latency):(EEG.event(length(EEG.event)).latency))),[1;48],512,2048,windowSize);toc;

                amp=abs(EEG_hilbert);
                phase = EEG_hilbert./amp;
                c = real(phase);
                s = imag(phase);

                dphi = c'*c + s'*s + 1i*(s'*c-c'*s);
                syn=abs(dphi)/(size(c,1));

                %   local synchrony
                local_sync=mean((amp.^2));
                for m=1:elecNum
                    syn(m,m)=local_sync(m);
                end

                globalSync(:,:,stepNormalize)=syn;
            end
            globalSyncXP(freqB,:,:,1)=mean(globalSync,3);
            globalSyncXP(freqB,:,:,2)=std(globalSync,[],3);
        end
        save(['../Data/Results/' fold '/Hilbert_PLV_AMP_BL'], 'globalSyncXP')
        clear globalSyncXP
    end
end
labels={EEG.chanlocs.labels};

folders=dir('../Data/Results/')
globalSyncG=zeros(length(folders)-5,2,2,2,elecNum,elecNum);
bin=1;
for n=5:length(folders)
    fold=folders(n).name;
    if (fold(1)~='.') &&(fold(1)~='P')
        load(['../Data/Results/' fold '/Hilbert_PLV_AMP_Measure'], 'globalSyncXP')
        globalSyncG(bin,:,:,:,:,:)=globalSyncXP;
        %hist(globalSyncXP(:))
        %title(fold)
        %drawnow
        %pause
        bin=bin+1;
    end
end

freqAnal1 =2; freqAnal2 =2;   % 7 , 40
condition1=2; condition2=1;   % MB, BB
Stim1     =2; Stim2     =2;   % T , G

[a b c d]=ttest(squeeze(globalSyncG(:,freqAnal1,condition1,Stim1,:,:)),squeeze(globalSyncG(:,freqAnal2,condition2,Stim2,:,:)));
%BBT_Topoplot(diag(reshape(d.tstat,64,64)),2)
subplot(2,2,1)
BBT_Toposync(reshape(d.tstat,64,64))
colormap(redblue(256))
title([conditions{condition1},freqsStim{Stim1},'@',num2str(freqsBeat(freqAnal1)),' vs ',conditions{condition2},freqsStim{Stim2},'@',num2str(freqsBeat(freqAnal2))])


freqAnal1 =1; freqAnal2 =1;   % 7 , 40
condition1=2; condition2=1;   % MB, BB
Stim1     =1; Stim2     =1;   % T , G

[a b c d]=ttest(squeeze(globalSyncG(:,freqAnal1,condition1,Stim1,:,:)),squeeze(globalSyncG(:,freqAnal2,condition2,Stim2,:,:)));
%BBT_Topoplot(diag(reshape(d.tstat,64,64)),2)
subplot(2,2,2)
BBT_Toposync(reshape(d.tstat,64,64))
colormap(redblue(256))
title([conditions{condition1},freqsStim{Stim1},'@',num2str(freqsBeat(freqAnal1)),' vs ',conditions{condition2},freqsStim{Stim2},'@',num2str(freqsBeat(freqAnal2))])


freqAnal1 =2; freqAnal2 =2;   % 7 , 40
condition1=2; condition2=1;   % MB, BB
Stim1     =1; Stim2     =1;   % T , G

[a b c d]=ttest(squeeze(globalSyncG(:,freqAnal1,condition1,Stim1,:,:)),squeeze(globalSyncG(:,freqAnal2,condition2,Stim2,:,:)));
%BBT_Topoplot(diag(reshape(d.tstat,64,64)),2)
subplot(2,2,3)
BBT_Toposync(reshape(d.tstat,64,64))
colormap(redblue(256))
title([conditions{condition1},freqsStim{Stim1},'@',num2str(freqsBeat(freqAnal1)),' vs ',conditions{condition2},freqsStim{Stim2},'@',num2str(freqsBeat(freqAnal2))])


freqAnal1 =1; freqAnal2 =1;   % 7 , 40
condition1=2; condition2=1;   % MB, BB
Stim1     =2; Stim2     =2;   % T , G

[a b c d]=ttest(squeeze(globalSyncG(:,freqAnal1,condition1,Stim1,:,:)),squeeze(globalSyncG(:,freqAnal2,condition2,Stim2,:,:)));
%BBT_Topoplot(diag(reshape(d.tstat,64,64)),2)
subplot(2,2,4)
BBT_Toposync(reshape(d.tstat,64,64))
colormap(redblue(256))
title([conditions{condition1},freqsStim{Stim1},'@',num2str(freqsBeat(freqAnal1)),' vs ',conditions{condition2},freqsStim{Stim2},'@',num2str(freqsBeat(freqAnal2))])


 
% load('montage','eNames','ePositions','chcoord','maskTopo','eConn')
% addpath(genpath('/Users/kwisatz/Documents/MATLAB/toolbox/ClusteringAlgorithm/'))
% clear optionsbiv
% optionsbiv.label='matched-pair';
% optionsbiv.clustering.type='sum';
% optionsbiv.topology='bivariate';
% optionsbiv.clustering.threshold=2;%'param';
% %optionsbiv.clustering.signif=0.01;
% optionsbiv.connectivity={{eConn},{eConn}};%};
% optionsbiv.M=500;
% [results] = stat_LENA2(squeeze(globalSyncG(:,freqAnal1,condition1,Stim1,:,:)),squeeze(globalSyncG(:,freqAnal2,condition2,Stim2,:,:)),optionsbiv);
% tmps=zeros(size(results.T_orig_ori));
% PosCl=find(results.valuesPos>=results.Sth_nop_Pos(1));
% for idx=1:length(PosCl)
%     tmps(results.clustersPos{PosCl(idx)})=1;
% end
% NegCl=find(results.valuesPos<=-results.Sth_nop_Pos(1));
% for idx=1:length(NegCl)
%     tmps(results.clustersPos{NegCl(idx)})=1;
% end