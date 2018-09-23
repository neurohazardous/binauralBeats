function import_preproc(thepath, thefile)

%%Establish the directory of EEGLAB
EEGLAB_dir='/Applications/eeglab12_0_2_1b/';


%%IMPORT BDF FILE
EEG = pop_biosig([thepath thefile]);
EEG = eeg_checkset( EEG );

%%NAME SET WITH CORRECT CONDITION AND PARTICIPANT
EEG.setname=thefile(1:end-4);
EEG = eeg_checkset( EEG );

%%CREATE BIPOLAR EOG CHANNELS
EEG = pop_eegchanoperator( EEG, {  'ch77=ch68-ch67 label HEOG',  'ch78=ch66-ch1 label VEOG'} , 'ErrorMsg', 'popup', 'Warning', 'on' ); % GUI: 08-Jun-2015 13:47:22
EEG = eeg_checkset( EEG );

%%RE-REFERENCE to linked mastoids
EEG = pop_reref( EEG, [69 70] );
EEG = eeg_checkset( EEG );

%%DELETE UNUSED CHANNELS
EEG = pop_select( EEG,'nochannel',{'EXG7' 'EXG8' 'GSR1' 'Resp' 'Left' 'Right' 'VEOGL' 'HEOGL' 'HEOGR'});
EEG = eeg_checkset( EEG );

%%EDIT CHANNEL LOCATIONS
EEG = pop_chanedit(EEG, 'lookup', [EEGLAB_dir 'plugins/dipfit2.2/standard_BESA/standard-10-5-cap385.elp']);
EEG = eeg_checkset( EEG );

%%FILTER SET FROM 1 - 100Hz
EEG  = pop_basicfilter( EEG,  1:EEG.nbchan , 'Cutoff', [ 1 100], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  2 ); % GUI: 08-Jun-2015 13:52:38
EEG = eeg_checkset( EEG );

%%Notch FILTER 60Hz (LINE NOISE)
EEG  = pop_basicfilter( EEG,  1:EEG.nbchan , 'Cutoff',  60, 'Design', 'notch', 'Filter', 'PMnotch', 'Order',  180 ); % GUI: 09-Jun-2015 16:46:03
EEG = eeg_checkset( EEG );

%%RESAMPLE SET at 512Hz
EEG = pop_resample( EEG, 512);
EEG = eeg_checkset( EEG );

%%Select +-3 secs around time-window of interest (+11 because the last
%%epoch doesn't have a last trigger; 3 + 8. The if avoids baselines because
%%they don't have triggers

x = thefile(10:end-4)
    if strcmp('Baseline',x)
        fprintf('Baseline')
    else 
        EEG = pop_select( EEG,'time',[EEG.event(1).latency/EEG.srate-3 EEG.event(end).latency/EEG.srate+11]); 
        EEG = eeg_checkset( EEG )
    end

%% SAVE FILE
EEG = pop_saveset( EEG, 'filename',[thefile(1:end-4) '_imported.set'],'filepath',thepath);
EEG = eeg_checkset( EEG );

end