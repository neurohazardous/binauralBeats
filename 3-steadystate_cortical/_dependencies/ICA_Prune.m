function ICA_Prune(thepath, thefile, thename, generalpath)

%% Remove Bad Channels
%%Load .set file
EEG = pop_loadset('filename', thefile, 'filepath', thepath);
EEG = eeg_checkset( EEG );

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
EEG = pop_select( EEG,'nochannel', bad_elec_list);
EEG = eeg_checkset( EEG );

%% Remove Bad IC's
%%Load ICA weights
load([thename '_TMP.mat']);

%%Transfer ICA weights to EEG structure
EEG.icawinv = TMP.icawinv;
EEG.icasphere = TMP.icasphere;
EEG.icaweights = TMP.icaweights;
EEG.icachansind = TMP.icachansind;
clear TMP;

%%Load bad ICA list
bad_comp =[generalpath 'Script/bad_compt.txt'];
fid1 = fopen(bad_comp,'r'); %open file for reading

%To make critical
if fid1<0
    fprintf('Missing params file for subject %s \n', thename);
    return;
end

while ~feof(fid1)
    line = fgets(fid1); % read line by line
    eval(line);
end
fclose(fid1);

%Load text file and eval lines
string = ['bad_comp_list = ' thename ';'];
eval(string);


%%Remove bad individual components
EEG = pop_subcomp(EEG, bad_comp_list);
EEG = eeg_checkset( EEG );

%% Interpolate missing channels
load dummy_loc_structure.mat
EEG = eeg_interp(EEG, chanlocs );  %Default method is spherical
EEG = eeg_checkset ( EEG );

%% Re-reference to CAR
EEG = pop_reref( EEG, [],'exclude', [65:67] );
EEG = eeg_checkset( EEG );

%% Save set file as _ICA_pruned.set
EEG = pop_saveset( EEG, 'filename',[thefile(1:end-4) '_ICA_pruned.set'], 'filepath', '/Users/g0rd0/Desktop/Brams/0ngoing_Binaural_Beats/Data/ICA_Pruned/');
EEG = eeg_checkset( EEG );

%%Clear Study
EEG = pop_delset( EEG, 1);

end