function Subcortical_import(path,filename, eeglab_folder)

eeglab;

%Import bdf file
EEG = pop_biosig([path filename]);
EEG.setname= filename;
EEG = eeg_checkset( EEG );

%Filter
EEG  = pop_basicfilter( EEG,  1:5 , 'Cutoff',  100, 'Design', 'butter', 'Filter', 'highpass', 'Order',  2 );
EEG = eeg_checkset( EEG );
EEG  = pop_basicfilter( EEG,  1:5 , 'Cutoff',  2000, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );
EEG = eeg_checkset( EEG );

%Edit locations
EEG=pop_chanedit(EEG,'changefield',{1 'labels' 'Fpz'},'changefield',{2 'labels' 'C7'},'changefield',{3 'labels' 'Cz'},'changefield',{4 'labels' 'M1'},'changefield',{5 'labels' 'M2'}, 'lookup',[eeglab_folder 'standard-10-5-cap385.elp']);
EEG = eeg_checkset( EEG );

%Select 2 relevant channels
EEG = pop_select( EEG,'channel',{'Fpz' 'C7'});
EEG = eeg_checkset( EEG );

%Re-ref to C7
EEG = pop_reref( EEG, 2 );
EEG = eeg_checkset( EEG );


%Save file
EEG = pop_saveset( EEG, 'filename',[filename(1:end-4) '_Brainstem_imported.set'],'filepath',path);
EEG = eeg_checkset( EEG );

end