% Neurophenomenology analyses
clear;clc;close all

%% Extract scores for all subjects
% MR : Mental Relaxation 
% AD : Absorption Depth
% Header : Participant, Baseline, MBG, BBT, BBG, MBT
MRfile = '/Users/kwisatz/Dropbox/science/EMC/BinauralBeat/BB_ESAS_AD.csv';
fileID = fopen(MRfile,'r');
MR = cell2mat(textscan(fileID,'%f%f%f%f%f%f','Delimiter',',','HeaderLines',1));
fclose(fileID);

ADfile = '/Users/kwisatz/Dropbox/science/EMC/BinauralBeat/BB_ESAS_MR.csv';
fileID = fopen(ADfile,'r');
AD = cell2mat(textscan(fileID,'%f%f%f%f%f%f','Delimiter',',','HeaderLines',1));
fclose(fileID);

%% Neurophenomenological contrasts
conditions = {'MBG', 'BBT', 'BBG', 'MBT'};
% conditions={'MB','BB'};
% freqsStim={'T','G'};
conds2cond = [1,2,2,1];
conds2stim = [2,1,2,1];

freqsBeat=[1,5, 9,13,32,6,39;
           4,8,12,30,48,8,41];

 
disp('MR-max vs. MR-min') 
bin=0;
for subj = [1:8 10:16]
    bin=bin+1;
    mrs = MR(subj,3:end);
    mrmax = find(mrs==max(mrs));
    mrmin = find(mrs==min(mrs));
    [values, index] = sort(mrs);
    disp([num2str(subj),': Max=', conditions{mrmax(1)},' Min=',conditions{mrmin(1)}])
    fold = ['S' sprintf('%02i',subj)];
    load(['../Data/Results/' fold '/PLV_FULL'], 'globalSyncXP')
    M=globalSyncXP;
    load(['../Data/Results/' fold '/PLV_FULL_BL'], 'globalSyncXP')
    BL=globalSyncXP;
    for freqAnalyse=1:size(freqsBeat,2)
        B(bin,1,freqAnalyse,:,:)=squeeze(BL(freqAnalyse,:,:,1));
        %C(bin,1,freqAnalyse,:,:)=squeeze(M(conds2stim(mrmax(1)),conds2cond(mrmax(1)),freqAnalyse,:,:));
        C(bin,1,freqAnalyse,:,:)=mean(cat(3,squeeze(M(conds2stim(index(3)),conds2cond(index(3)),freqAnalyse,:,:)),squeeze(M(conds2stim(index(4)),conds2cond(index(4)),freqAnalyse,:,:))),3);
        %ZMR(bin,1,freqAnalyse,:,:)=(squeeze(M(conds2stim(mrmax(1)),conds2cond(mrmax(1)),freqAnalyse,:,:))-squeeze(BL(freqAnalyse,:,:,1)))./squeeze(BL(freqAnalyse,:,:,2));
        ZMR(bin,1,freqAnalyse,:,:)=(mean(cat(3,squeeze(M(conds2stim(index(3)),conds2cond(index(3)),freqAnalyse,:,:)),squeeze(M(conds2stim(index(4)),conds2cond(index(4)),freqAnalyse,:,:))),3)-squeeze(BL(freqAnalyse,:,:,1)))./squeeze(BL(freqAnalyse,:,:,2));
    end
    for freqAnalyse=1:size(freqsBeat,2)
        B(bin,2,freqAnalyse,:,:)=squeeze(BL(freqAnalyse,:,:,1));
        %C(bin,2,freqAnalyse,:,:)=squeeze(M(conds2stim(mrmin(1)),conds2cond(mrmin(1)),freqAnalyse,:,:));
        C(bin,2,freqAnalyse,:,:)=mean(cat(3,squeeze(M(conds2stim(index(2)),conds2cond(index(2)),freqAnalyse,:,:)),squeeze(M(conds2stim(index(1)),conds2cond(index(1)),freqAnalyse,:,:))),3);
        %ZMR(bin,2,freqAnalyse,:,:)=(squeeze(M(conds2stim(mrmin(1)),conds2cond(mrmin(1)),freqAnalyse,:,:))-squeeze(BL(freqAnalyse,:,:,1)))./squeeze(BL(freqAnalyse,:,:,2));
        ZMR(bin,2,freqAnalyse,:,:)=(mean(cat(3,squeeze(M(conds2stim(index(2)),conds2cond(index(2)),freqAnalyse,:,:)),squeeze(M(conds2stim(index(1)),conds2cond(index(1)),freqAnalyse,:,:))),3)-squeeze(BL(freqAnalyse,:,:,1)))./squeeze(BL(freqAnalyse,:,:,2));
    end
end

disp('AD-max - AD-min')
bin=0;
for subj = [1:8 10:16]
    bin = bin+1;
    ads = AD(subj,3:end);
    admax = find(ads==max(ads));
    admin = find(ads==min(ads));
    [values, index] = sort(ads);
    disp([num2str(subj),': Max=', conditions{admax(1)},' Min=',conditions{admin(1)}])
    fold = ['S' sprintf('%02i',subj)];
    load(['../Data/Results/' fold '/PLV_FULL'], 'globalSyncXP')
    M=globalSyncXP;
    load(['../Data/Results/' fold '/PLV_FULL_BL'], 'globalSyncXP')
    BL=globalSyncXP;

    for freqAnalyse=1:size(freqsBeat,2)
        B(bin,1,freqAnalyse,:,:)=squeeze(BL(freqAnalyse,:,:,1));
        %C(bin,1,freqAnalyse,:,:)=squeeze(M(conds2stim(admax(1)),conds2cond(admax(1)),freqAnalyse,:,:));
        C(bin,1,freqAnalyse,:,:)=mean(cat(3,squeeze(M(conds2stim(index(3)),conds2cond(index(3)),freqAnalyse,:,:)),squeeze(M(conds2stim(index(4)),conds2cond(index(4)),freqAnalyse,:,:))),3);
        %ZMR(bin,1,freqAnalyse,:,:)=(squeeze(M(conds2stim(admax(1)),conds2cond(admax(1)),freqAnalyse,:,:))-squeeze(BL(freqAnalyse,:,:,1)))./squeeze(BL(freqAnalyse,:,:,2));
        ZMR(bin,1,freqAnalyse,:,:)=(mean(cat(3,squeeze(M(conds2stim(index(3)),conds2cond(index(3)),freqAnalyse,:,:)),squeeze(M(conds2stim(index(4)),conds2cond(index(4)),freqAnalyse,:,:))),3)-squeeze(BL(freqAnalyse,:,:,1)))./squeeze(BL(freqAnalyse,:,:,2));
    end
    for freqAnalyse=1:size(freqsBeat,2)
        B(bin,2,freqAnalyse,:,:)=squeeze(BL(freqAnalyse,:,:,1));
        %C(bin,2,freqAnalyse,:,:)=squeeze(M(conds2stim(admin(1)),conds2cond(admin(1)),freqAnalyse,:,:));
        C(bin,2,freqAnalyse,:,:)=mean(cat(3,squeeze(M(conds2stim(index(2)),conds2cond(index(2)),freqAnalyse,:,:)),squeeze(M(conds2stim(index(1)),conds2cond(index(1)),freqAnalyse,:,:))),3);
        %ZAD(bin,2,freqAnalyse,:,:)=(squeeze(M(conds2stim(admin(1)),conds2cond(admin(1)),freqAnalyse,:,:))-squeeze(BL(freqAnalyse,:,:,1)))./squeeze(BL(freqAnalyse,:,:,2));
        ZAD(bin,2,freqAnalyse,:,:)=(mean(cat(3,squeeze(M(conds2stim(index(2)),conds2cond(index(2)),freqAnalyse,:,:)),squeeze(M(conds2stim(index(1)),conds2cond(index(1)),freqAnalyse,:,:))),3)-squeeze(BL(freqAnalyse,:,:,1)))./squeeze(BL(freqAnalyse,:,:,2));
    end
end

%% Visualization
freqAnal={'Delta','Theta','Alpha','Beta','Gamma','Theta-Beat','Gamma-Beat'};

figure()
bin=1;
for freqA=1:size(freqsBeat,2)
    cond1=2; cond2=1;   % MB, BB

    subplot(size(freqsBeat,2),2,bin)
    [a b c d]=ttest(squeeze(ZMR(:,1,freqA,:,:)),squeeze(ZMR(:,2,freqA,:,:)));
    BBT_Toposync(reshape(d.tstat,64,64),0,1:64,1:64,3)
    colormap(redblue(256))
    title([freqAnal{freqA},'- MR'])

    bin=bin+1;
    
    subplot(size(freqsBeat,2),2,bin)
    [a b c d]=ttest(squeeze(ZAD(:,1,freqA,:,:)),squeeze(ZAD(:,2,freqA,:,:)));
    BBT_Toposync(reshape(d.tstat,64,64),0,1:64,1:64,3)
    colormap(redblue(256))
    title([freqAnal{freqA},'- AD'])
    
    bin=bin+1;
end

%% Clustering statistics - Power
disp('Clustering statistics - Power')

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

disp('Mental Relaxation')
for freqA = 1:7
    display(' ')
    display(['MR - Freq=',freqAnal{freqA}])

    [results] = stat_LENA2(mdiag(squeeze(ZMR(:,1,freqA,:,:))),mdiag(squeeze(ZMR(:,2,freqA,:,:))),optionsuniv);
    
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
            title(['PLV ','Positive Cluster ? MR Freq=',freqAnal{freqA}])
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
            title(['PLV ','Negative Cluster ? MR Freq=',freqAnal{freqA}])
        end
    end
end

display(' ')

disp('Absorption Depth')
for freqA = 1:7
    display(' ')

    display(['AD - Freq=',freqAnal{freqA}])

    [results] = stat_LENA2(mdiag(squeeze(ZAD(:,1,freqA,:,:))),mdiag(squeeze(ZAD(:,2,freqA,:,:))),optionsuniv);
        
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
            title(['PLV ','Positive Cluster ? AD Freq=',freqAnal{freqA}])
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
            title(['PLV ','Negative Cluster ? AD Freq=',freqAnal{freqA}])
        end
    end
end
        


%% Clustering statistics - Connectivity
disp('Clustering statistics - Connectivity')

clear optionsbiv
optionsbiv.label='matched-pair';
optionsbiv.clustering.type='sum';
optionsbiv.topology='bivariate';
optionsbiv.clustering.threshold=3;%'param';
%optionsbiv.clustering.signif=0.05;
optionsbiv.connectivity={{eConn},{eConn}};%};
optionsbiv.M=1000;

cond1=2; cond2=1;   % MB, BB
freqAnal={'Delta','Theta','Alpha','Beta','Gamma','Theta-Beat','Gamma-Beat'};

disp('Mental Relaxation')
for freqA = 1:7
    display(' ')
    display(['MR - Freq=',freqAnal{freqA}])

    [results] = stat_LENA2(rmdiag(squeeze(ZMR(:,1,freqA,:,:))),rmdiag(squeeze(ZMR(:,2,freqA,:,:))),optionsbiv);

    PosCl=find(results.valuesPos>=results.Sth_nop_Pos(1));
    if length(PosCl)>0
        disp(['Pos:',mat2str(PosCl)])
        disp(sprintf('Positive threshold = %f',results.Sth_nop_Pos(1)))
        for idx=1:length(PosCl)
            tmps=zeros(size(results.T_orig_ori));
            tmps(results.clustersPos{PosCl(idx)})=1;
            disp(sprintf('CS = %f',results.valuesPos(PosCl(idx))))
            indx = find(results.S_nop_sort_Pos<results.valuesPos(PosCl(idx)));
            disp(sprintf('p = %f', 1-indx(end)/optionsbiv.M))

            figure()
            BBT_Toposync(reshape(tmps,64,64),5,1:64,sum(reshape(tmps,64,64)+reshape(tmps,64,64)')>0,0.5)
            title(['PLV Positive Cluster ? MR Freq=',freqAnal{freqA}])
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
            disp(sprintf('p = %f', 1-indx(end)/optionsbiv.M))

            figure()
            BBT_Toposync(reshape(tmps,64,64),5,1:64,sum(reshape(tmps,64,64)+reshape(tmps,64,64)')<0,0.5)
            title(['PLV Negative Cluster ? MR Freq=',freqAnal{freqA}])
        end
    end
end

display(' ')
disp('Absorption Depth')
for freqA = 1:7
    display(' ')
    display(['AD - Freq=',freqAnal{freqA}])

    [results] = stat_LENA2(rmdiag(squeeze(ZAD(:,1,freqA,:,:))),rmdiag(squeeze(ZAD(:,2,freqA,:,:))),optionsbiv);

    PosCl=find(results.valuesPos>=results.Sth_nop_Pos(1));
    if length(PosCl)>0
        disp(['Pos:',mat2str(PosCl)])
        disp(sprintf('Positive threshold = %f',results.Sth_nop_Pos(1)))
        for idx=1:length(PosCl)
            tmps=zeros(size(results.T_orig_ori));
            tmps(results.clustersPos{PosCl(idx)})=1;
            disp(sprintf('CS = %f',results.valuesPos(PosCl(idx))))
            indx = find(results.S_nop_sort_Pos<results.valuesPos(PosCl(idx)));
            disp(sprintf('p = %f', 1-indx(end)/optionsbiv.M))

            figure()
            BBT_Toposync(reshape(tmps,64,64),5,1:64,sum(reshape(tmps,64,64)+reshape(tmps,64,64)')>0,0.5)
            title(['PLV Positive Cluster ? AD Freq=',freqAnal{freqA}])
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
            disp(sprintf('p = %f', 1-indx(end)/optionsbiv.M))

            figure()
            BBT_Toposync(reshape(tmps,64,64),5,1:64,sum(reshape(tmps,64,64)+reshape(tmps,64,64)')<0,0.5)
            title(['PLV Negative Cluster ? AD Freq=',freqAnal{freqA}])
        end
    end
end