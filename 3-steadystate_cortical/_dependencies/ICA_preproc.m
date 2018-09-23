function ICA_preproc(thepath, thefile, thename, generalpath)

%% Create Dummy data set (MEGA_EEG) to compute the ICA

%%Merge 5 files into single file
for n =1:5
    
    EEG_set(n) = pop_loadset('filename', thefile(n), 'filepath', thepath) 
    
end

MEGA_EEG = pop_mergeset(EEG_set, [1 2 3 4 5], 0);
MEGA_EEG = eeg_checkset( MEGA_EEG );

%%Bandpass filter 1 - 80Hz
MEGA_EEG  = pop_basicfilter( MEGA_EEG,  1:MEGA_EEG.nbchan , 'Cutoff', [ 1 80], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  2 ); % GUI: 08-Jun-2015 13:52:38
MEGA_EEG = eeg_checkset( MEGA_EEG );

%%Downsample to 256Hz
MEGA_EEG = pop_resample( MEGA_EEG, 256);
MEGA_EEG = eeg_checkset( MEGA_EEG );


%%Save MEGA_EEG
MEGA_EEG = pop_saveset( MEGA_EEG, 'filename', [thename '_MEGA_EEG.set']  ,'filepath',thepath);
MEGA_EEG = eeg_checkset( MEGA_EEG );


%% Remove bad electrodes (keep bad_chan list)

%%Load Bad Electrode File
bad_electrode =[generalpath 'Script/bad_electrodes.txt'];%Add path of bad electrode.txt
fid1 = fopen(bad_electrode,'r'); %open file for reading

%To make critical
if fid1<0
    fprintf('Missing params file for subject %s \n', thename);
    return;
end

while ~feof(fid1)
    line = fgets(fid1); % Evaluate line by line of bad_electrode.txt
    eval(line);
end
fclose(fid1);


%%Create the bad_electrode variable
string = ['bad_elec_list = ' thename ';'];
eval(string);


%%Remove bad electrodes
MEGA_EEG = pop_select( MEGA_EEG,'nochannel', bad_elec_list);
MEGA_EEG = eeg_checkset( MEGA_EEG );


%%Save file with no electrodes
MEGA_EEG = pop_saveset( MEGA_EEG, 'filename', [thename '_MEGA_EEG_ChannelOff.set']  ,'filepath',thepath);
MEGA_EEG = eeg_checkset( MEGA_EEG );


%% Run ICA
MEGA_EEG = pop_runica(MEGA_EEG, 'extended',1,'interupt','on');
MEGA_EEG = eeg_checkset( MEGA_EEG );


%%Save ICA file
MEGA_EEG = pop_saveset( MEGA_EEG, 'filename', [thename '_MEGA_EEG_ICA.set']  ,'filepath',thepath);
MEGA_EEG = eeg_checkset( MEGA_EEG );

%%Save ICA weights matrix
TMP.icawinv = MEGA_EEG.icawinv;
TMP.icasphere = MEGA_EEG.icasphere;
TMP.icaweights = MEGA_EEG.icaweights;
TMP.icachansind = MEGA_EEG.icachansind;
save([thename '_TMP.mat'], 'TMP' );

%%Clear Study
MEGA_EEG = pop_delset( MEGA_EEG, 1);
end
