function ABRPreproc(thepath, thefile, thename, generalpath)

%% Establish the directory of EEGLAB
EEGLAB_dir='/Users/hectorOrozco/Documents/programSpecific/MATLAB/eeglab13_5_4b/';

%% IMPORT BDF FILE
EEG = pop_readbdf([thepath thefile], [], 77, [], ['off']);
EEG = eeg_checkset( EEG );

%% RE-REFERENCE TO LINKED MASTOIDS
EEG = pop_reref( EEG, [69 70] );
EEG = eeg_checkset( EEG );

%% HIGH-PASS FILTER (100HZ)
EEG  = pop_basicfilter( EEG,  1:64 , 'Boundary', 'boundary', 'Cutoff',  100, 'Design', 'butter', 'Filter', 'highpass', 'Order',  4 ); 
EEG = eeg_checkset( EEG );

%% DELETE UNUSED CHANNELS
EEG = pop_select( EEG,'nochannel', {'Nose' 'VEOGL' 'HEOGL' 'HEOGR' 'EXG7' 'EXG8' 'GSR1' 'Resp' 'Left' 'Right' 'Status'});
EEG = eeg_checkset( EEG );

%% ASSIGN CHANNEL LOCATION
EEG=pop_chanedit(EEG, 'lookup','/Users/hectorOrozco/Documents/MATLAB/eeglab13_5_4b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
EEG = eeg_checkset( EEG );

%% INTERPOLATE BAD CHANNELS
%%Load Bad Electrode File
bad_electrode =[generalpath 'bad_electrodes.txt'];%Add path of bad electrode.txt
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

%%Interpolate bad electrodes
bad_elec_indices = std_chaninds(EEG, bad_elec_list);   %This one is tricky; when directly interpolating electrodes, you need the indices, not the names. chaninds makes that change.
EEG = pop_interp(EEG, bad_elec_indices, 'spherical');
EEG = eeg_checkset( EEG );

%% SELECT+-3 S AROUND TIME-WINDOW OF INTEREST + EPOCH DATA INTO 60 EVENTS + REMOVE BASELINE

x = thefile(10:end-4);

if strcmp('Baseline',x)     %Avoid baselines because they don't have triggers
    fprintf('Baseline')
    
else
    
    EEG = pop_select( EEG,'time',[EEG.event(1).latency/EEG.srate-3 EEG.event(end).latency/EEG.srate+11]);  %+11 because the last epoch does'nt have a trigger (3+8)
    EEG = eeg_checkset( EEG )
    
    EEG = pop_epoch( EEG, {   '1' '2' '3' '4'   }, [-0.1  7.9],  'epochinfo', 'yes');
    EEG = eeg_checkset( EEG );
    
%     EEG = pop_rmbase( EEG, [-99  0]);
%     EEG = eeg_checkset( EEG );

end

%% NAME SET WITH CORRECT CONDITION AND PARTICIPANT
EEG.setname=thefile(1:end-4);
EEG = eeg_checkset( EEG );


%% SAVE FILE
EEG = pop_saveset( EEG, 'filename', 'Test1','filepath', '/Users/hectorOrozco/Desktop');
EEG = eeg_checkset( EEG );

end
