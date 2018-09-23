%% Initialize EEGLAB and path
addpath(genpath('/Users/hectorOrozco/Desktop/binauralBeats/analysis/3-steadystate_cortical/_dependencies/eeglab13_4_4b'));
addpath(genpath('/Users/hectorOrozco/Desktop/binauralBeats/analysis/3-steadystate_cortical'));
generalpath = '/Users/hectorOrozco/Desktop/binauralBeats/output/2-SSEP/3-Epoched';
baselinepath = '/Users/hectorOrozco/Desktop/binauralBeats/output/2-SSEP/2-ICA_Pruned';

%% Just to try everything out
baseline = 'P02_Beat_Baseline_imported_ICA_pruned.set'
file = 'P02_Beat_BBG_imported_ICA_pruned_epoched.set'

%% Get subject list and initialize experimental conditions
listing = dir('/Users/hectorOrozco/Desktop/binauralBeats/output/2-SSEP/3-Epoched/*.set*');
subjects = {};
for x= 1:length(listing)
    subjects{x} = char(listing(x).name(1:3));
end
subjects = unique(subjects);
exp_conditions = {'BBG', 'BBT', 'MBG', 'MBT'};
freq_of_int = {'7', '40'};

%% Initialize output matrix
grandSSEP = zeros(length(subjects), 4, 2); % subjects x conditions x FOI

%% Get each participant
for sub = 1:length(subjects)
    fprintf('Now analyzing %s\n',subjects{sub});
    % Get baseline values
    baseline_values = SSEPfreq_baseline([subjects{sub}... 
        '_Beat_Baseline_imported_ICA_pruned.set'], baselinepath);
    
    % Get experiment-condition values
    grandSSEP(sub, 1, :) = SSEPfreq([subjects{sub}... 
        '_Beat_BBG_imported_ICA_pruned_epoched.set'], ...
        generalpath, baseline_values);
    grandSSEP(sub, 2, :) = SSEPfreq([subjects{sub}... 
        '_Beat_BBT_imported_ICA_pruned_epoched.set'], ...
        generalpath, baseline_values);
    grandSSEP(sub, 3, :) = SSEPfreq([subjects{sub}... 
        '_Beat_MBG_imported_ICA_pruned_epoched.set'], ...
        generalpath, baseline_values);
    grandSSEP(sub, 4, :) = SSEPfreq([subjects{sub}... 
        '_Beat_MBT_imported_ICA_pruned_epoched.set'], ...
        generalpath, baseline_values);
end

%% Divide the grand matrix into each frequency of interest and output csv
SSEP7 = grandSSEP(:, :, 1);
SSEP40 = grandSSEP(:, :, 2);
csvwrite('SSEP7.csv',SSEP7);
csvwrite('SSEP40.csv',SSEP40);

%% Plot just as a sanity check
figure,
boxplot(SSEP7)
figure, 
boxplot(SSEP40)