%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Project: Binaural Beats
%% Script purpose: Analysis of brainstem responses
%% Author: Hector D Orozco Perez
%% Contact: hector.dom.orozco@gmail.com
%% License: GNU GPL v3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize EEGLAB and path
addpath(genpath('/Users/hectorOrozco/Desktop/binauralBeats/_dependencies/eeglab13_4_4b'));
addpath(genpath('/Users/hectorOrozco/Desktop/binauralBeats/analysis/2-steadysate_brainstem'));
generalpath = '/Users/hectorOrozco/Desktop/binauralBeats/output/1-SSBR/';

%% Get subject list and initialize experimental conditions
listing = dir('/Users/hectorOrozco/Desktop/binauralBeats/output/1-SSBR/*.set*');
subjects = {};
for x= 1:length(listing)
    subjects{x} = char(listing(x).name(1:3));
end
subjects = unique(subjects);
exp_conditions = {'BBG', 'BBT', 'MBG', 'MBT'};
freq_of_int = {'396.5', '403.5', '380', '420'};

%% Initialize output matrix
grandABR = zeros(length(subjects), 4, 4); % subjects x conditions x FOI

%% Get each participant
for sub = 1:length(subjects)
    fprintf('Now analyzing %s\n',subjects{sub});
    % Get baseline values
    baseline_values = ABRfreq_baseline([subjects{sub}... 
        '_Beat_Baseline_ABR_Preproc.set'], generalpath);
    
    % Get experiment-condition values
    grandABR(sub, 1, :) = ABRfreq([subjects{sub}... 
        '_Beat_BBG_ABR_Preproc.set'], generalpath, baseline_values);
    grandABR(sub, 2, :) = ABRfreq([subjects{sub}... 
        '_Beat_BBT_ABR_Preproc.set'], generalpath, baseline_values);
    grandABR(sub, 3, :) = ABRfreq([subjects{sub}... 
        '_Beat_MBG_ABR_Preproc.set'], generalpath, baseline_values);
    grandABR(sub, 4, :) = ABRfreq([subjects{sub}... 
        '_Beat_MBT_ABR_Preproc.set'], generalpath, baseline_values);
    fprintf('%s done! YAS KWEEN!\n\n\n\n\n',subjects{sub});
    
end

%% Divide the grand matrix into each frequency of interest
ABR3965 = grandABR(:, :, 1);
ABR4035 = grandABR(:, :, 2);
ABR380 = grandABR(:, :, 3);
ABR420 = grandABR(:, :, 4);

%% Average tone relevant scores together and output them as csv's
ABRtheta = (ABR3965 + ABR4035) ./ 2;
ABRgamma = (ABR380 + ABR420) ./ 2;
csvwrite('ABRtheta_relevanTones.csv',ABRtheta);
csvwrite('ABRgamma_relevanTones.csv',ABRgamma);

%% Plot just as a sanity check
figure,
boxplot(ABRtheta)
figure, 
boxplot(ABRgamma)