clear;clc;close all

freqsBeat=[1,5, 9,13,32,6,39;
           4,8,12,30,48,8,41];

conditions={'MB','BB'};
freqsStim={'T','G'};
freqAnal={'Delta','Theta','Alpha','Beta','Gamma','Theta-Beat','Gamma-Beat'};

%% PLV Z-score
clear B C Z
bin=0;
folders=dir('../Data/Preproc/');
for n=1:length(folders)
    fold=folders(n).name;
    if (fold(1)~='.')&&(fold(1)~='P')
        bin=bin+1;
        load(['../Data/Results/' fold '/PLV_FULL'], 'globalSyncXP')
        M=globalSyncXP;
        load(['../Data/Results/' fold '/PLV_FULL_BL'], 'globalSyncXP')
        BL=globalSyncXP;
        for freqStim=1:2
            for cond=1:2
                for freqAnalyse=1:size(freqsBeat,2)
                    B(bin,cond,freqStim,freqAnalyse,:,:)=squeeze(BL(freqAnalyse,:,:,1));
                    C(bin,cond,freqStim,freqAnalyse,:,:)=squeeze(M(freqStim,cond,freqAnalyse,:,:));
                    Z(bin,cond,freqStim,freqAnalyse,:,:)=(squeeze(M(freqStim,cond,freqAnalyse,:,:))-squeeze(BL(freqAnalyse,:,:,1)))./squeeze(BL(freqAnalyse,:,:,2));
                end
            end
        end
    end
end

%% Visualization
for stim=1:2 % T , G
    figure(stim)
    bin=1;
    for freqA=1:size(freqsBeat,2)
        cond1=2; cond2=1;   % MB, BB
        
        subplot(size(freqsBeat,2),3,bin)
        [a b c d]=ttest(mdiag(squeeze(Z(:,cond1,stim,freqA,:,:))),zeros(size(mdiag(squeeze(B(:,cond1,stim,freqA,:,:))))));
        BBT_Toposync(diag(d.tstat),0,1:64,1:64,3)
        colormap(redblue(256))
        title([conditions{cond1},freqsStim{stim},' vs BL ? ',freqAnal{freqA}])
        bin=bin+1;
        
        subplot(size(freqsBeat,2),3,bin)
        [a b c d]=ttest(mdiag(squeeze(Z(:,cond2,stim,freqA,:,:))),zeros(size(mdiag(squeeze(B(:,cond2,stim,freqA,:,:))))));
        BBT_Toposync(diag(d.tstat),0,1:64,1:64,3)
        colormap(redblue(256))
        title([conditions{cond2},freqsStim{stim},' vs BL ? ',freqAnal{freqA}])
        bin=bin+1;
        
        subplot(size(freqsBeat,2),3,bin)
        [a b c d]=ttest(mdiag(squeeze(Z(:,cond1,stim,freqA,:,:))),mdiag(squeeze(Z(:,cond2,stim,freqA,:,:))));
        BBT_Toposync(diag(d.tstat),0,1:64,1:64,3)
        colormap(redblue(256))
        title([conditions{cond1},freqsStim{stim},' vs ',conditions{cond2},freqsStim{stim},' ? ',freqAnal{freqA}])
        bin=bin+1;
    end
end

%% Clustering statistics
load('montage','eNames','ePositions','chcoord','maskTopo','eConn')
addpath(genpath('/Users/kwisatz/Documents/MATLAB/toolbox/ClusteringAlgorithm/'))
clear optionsuniv
optionsuniv.label='matched-pair';
optionsuniv.clustering.type='sum';
optionsuniv.topology='univariate';
optionsuniv.clustering.threshold=3;%'param';
%optionsuniv.clustering.signif=0.05;
optionsuniv.connectivity={{eConn}};%};
optionsuniv.M=1000;

cond1=2; cond2=1;   % MB, BB

for stim = 1:2
    for freqA = 1:7
        display(' ')
        display(' ')
        display(['PLV ',conditions{cond1},' vs. ',conditions{cond2},' Stim=',freqsStim{stim},' Freq=',freqAnal{freqA}])

        [results] = stat_LENA2(mdiag(squeeze(Z(:,cond1,stim,freqA,:,:))),mdiag(squeeze(Z(:,cond2,stim,freqA,:,:))),optionsuniv);
        
        PosCl=find(results.valuesPos>=results.Sth_nop_Pos(1));
        if length(PosCl)>0
            disp(['Pos:',mat2str(PosCl)])
            disp(sprintf('Positive threshold = %f',results.Sth_nop_Pos(1)))
            for idx=1:length(PosCl)
                tmps=zeros(size(results.T_orig_ori));
                tmps(results.clustersPos{PosCl(idx)})=1;
                disp(sprintf('CS = %f',results.valuesPos(PosCl(idx))))
                indx = find(results.S_nop_sort_Pos<results.valuesPos(PosCl(idx)));
                disp(sprintf('p = %f', 1-indx(end)/optionsuniv.M))

                figure()
                BBT_Toposync(diag(results.T_orig_ori),5,1:64,tmps==1,1)
                colormap(redblue(256))
                title(['PLV ','Positive Cluster ?',conditions{cond1},' vs. ',conditions{cond2},' Stim=',freqsStim{stim},' Freq=',freqAnal{freqA}])
            end
        end
        
        NegCl=find(results.valuesNeg<=-results.Sth_nop_Neg(1));
        if length(NegCl)>0
            disp(['Neg:',mat2str(NegCl)])
            disp(sprintf('Negative threshold = %f',results.Sth_nop_Neg(1)))
            for idx=1:length(NegCl)
                tmps=zeros(size(results.T_orig_ori));
                tmps(results.clustersNeg{NegCl(idx)})=-1;
                disp(sprintf('CS = %f',results.valuesNeg(NegCl(idx))))
                indx = find(results.S_nop_sort_Neg<-results.valuesNeg(NegCl(idx)));
                disp(sprintf('p = %f', 1-indx(end)/optionsuniv.M))

                figure()
                BBT_Toposync(diag(results.T_orig_ori),5,1:64,tmps==-1,1)
                colormap(redblue(256))
                title(['PLV ','Negative Cluster ?',conditions{cond1},' vs. ',conditions{cond2},' Stim=',freqsStim{stim},' Freq=',freqAnal{freqA}])
            end
        end
        
        display(' ')
        display(['PLV ',conditions{cond1},' vs. BL Stim=',freqsStim{stim},' Freq=',freqAnal{freqA}])

        [results] = stat_LENA2(mdiag(squeeze(Z(:,cond1,stim,freqA,:,:))),zeros(15,64),optionsuniv);

        PosCl=find(results.valuesPos>=results.Sth_nop_Pos(1));
        if length(PosCl)>0
            disp(['Pos:',mat2str(PosCl)])
            disp(sprintf('Positive threshold = %f',results.Sth_nop_Pos(1)))
            for idx=1:length(PosCl)
                tmps=zeros(size(results.T_orig_ori));
                tmps(results.clustersPos{PosCl(idx)})=1;
                disp(sprintf('CS = %f',results.valuesPos(PosCl(idx))))
                indx = find(results.S_nop_sort_Pos<results.valuesPos(PosCl(idx)));
                disp(sprintf('p = %f', 1-indx(end)/optionsuniv.M))

                figure()
                BBT_Toposync(diag(results.T_orig_ori),5,1:64,tmps==1,1)
                colormap(redblue(256))
                title(['PLV ','Positive Cluster ?',conditions{cond1},' vs. BL Stim=',freqsStim{stim},' Freq=',freqAnal{freqA}])
            end
        end
        
        NegCl=find(results.valuesNeg<=-results.Sth_nop_Neg(1));
        if length(NegCl)>0
            disp(['Neg:',mat2str(NegCl)])
            disp(sprintf('Negative threshold = %f',results.Sth_nop_Neg(1)))
            for idx=1:length(NegCl)
                tmps=zeros(size(results.T_orig_ori));
                tmps(results.clustersNeg{NegCl(idx)})=-1;
                disp(sprintf('CS = %f',results.valuesNeg(NegCl(idx))))
                indx = find(results.S_nop_sort_Neg<-results.valuesNeg(NegCl(idx)));
                disp(sprintf('p = %f', 1-indx(end)/optionsuniv.M))

                figure()
                BBT_Toposync(diag(results.T_orig_ori),5,1:64,tmps==-1,1)
                colormap(redblue(256))
                title(['PLV ','Negative Cluster ?',conditions{cond1},' vs. BL Stim=',freqsStim{stim},' Freq=',freqAnal{freqA}])
            end
        end
        
        display(' ')
        display(['PLV ',conditions{cond2},' vs. BL Stim=',freqsStim{stim},' Freq=',freqAnal{freqA}])

        [results] = stat_LENA2(mdiag(squeeze(Z(:,cond2,stim,freqA,:,:))),zeros(15,64),optionsuniv);

        PosCl=find(results.valuesPos>=results.Sth_nop_Pos(1));
        if length(PosCl)>0
            disp(['Pos:',mat2str(PosCl)])
            disp(sprintf('Positive threshold = %f',results.Sth_nop_Pos(1)))
            for idx=1:length(PosCl)
                tmps=zeros(size(results.T_orig_ori));
                tmps(results.clustersPos{PosCl(idx)})=1;
                disp(sprintf('CS = %f',results.valuesPos(PosCl(idx))))
                indx = find(results.S_nop_sort_Pos<results.valuesPos(PosCl(idx)));
                disp(sprintf('p = %f', 1-indx(end)/optionsuniv.M))

                figure()
                BBT_Toposync(diag(results.T_orig_ori),5,1:64,tmps==1,1)
                colormap(redblue(256))
                title(['PLV ','Positive Cluster ?',conditions{cond2},' vs. BL Stim=',freqsStim{stim},' Freq=',freqAnal{freqA}])
            end
        end
        
        NegCl=find(results.valuesNeg<=-results.Sth_nop_Neg(1));
        if length(NegCl)>0
            disp(['Neg:',mat2str(NegCl)])
            disp(sprintf('Negative threshold = %f',results.Sth_nop_Neg(1)))
            for idx=1:length(NegCl)
                tmps=zeros(size(results.T_orig_ori));
                tmps(results.clustersNeg{NegCl(idx)})=-1;
                disp(sprintf('CS = %f',results.valuesNeg(NegCl(idx))))
                indx = find(results.S_nop_sort_Neg<-results.valuesNeg(NegCl(idx)));
                disp(sprintf('p = %f', 1-indx(end)/optionsuniv.M))

                figure()
                BBT_Toposync(diag(results.T_orig_ori),5,1:64,tmps==-1,1)
                colormap(redblue(256))
                title(['PLV ','Negative Cluster ?',conditions{cond2},' vs. BL Stim=',freqsStim{stim},' Freq=',freqAnal{freqA}])
            end
        end
    end
end