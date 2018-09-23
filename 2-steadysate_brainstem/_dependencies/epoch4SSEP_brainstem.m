%%epoch4SSEP
Nevents=60;
event_length=8; %s
Ngroup=5;

thepath='/Users/hectorOrozco/Desktop/';
subjects={ 'S02' 'S01' 'S03' 'S04' 'S05' 'S06' 'S07' 'S08' 'S10' 'S11' 'S12' 'S13' 'S14' 'S15' 'S16'};

conds={'BBG_BS_imported' 'BBT_imported_ICA_pruned' 'MBG_imported_ICA_pruned' 'MBT_imported_ICA_pruned'};

for s=1:length(subjects)
    
    current_s=subjects{s};
    current_path=[thepath current_s filesep];
    
    for c=1:length(conds)
        eeglab nogui;
        current_c=conds{c};
        disp(['now working on: ' current_s '_' current_c '.set']);
        
        %% load file
        EEG = pop_loadset('filename',[current_s '_' current_c '.set'], 'filepath', current_path);
        EEG = eeg_checkset( EEG );
        %% Insert events
        %Create new events to end up with Nevents/Ngroup epochs of length
        %Ngroup * event_length
        counter=0;
        for i=1:length([EEG.event])
            %If event is not boundary
            if sum(strcmp(EEG.event(i).type,{  '1' '2' '3' '4'  }))
                counter=counter+1;
                %If event is start of a block
                if not(mod(counter-1,Ngroup))
                    EEG.event(end+1)=EEG.event(i);
                    EEG.event(end).type='9';
                end
            end
        end
        EEG = eeg_checkset( EEG );
            %% save
            EEG = pop_saveset( EEG, 'filename',[current_s '_' current_c(1:3) '_newtrig.set'],'filepath',current_path);
            EEG = eeg_checkset( EEG );
            
            %% epoch
            EEG = pop_epoch( EEG, {   '1' '2' '3' '4'   }, [-0.2  40], 'newname', [current_s '_' current_c(1:3) 'epoched'], 'epochinfo', 'yes');
            EEG = eeg_checkset( EEG );
            %% remove baseline
            EEG = pop_rmbase( EEG, [-190  0]);
            EEG = eeg_checkset( EEG );
            %% save
            EEG = pop_saveset( EEG, 'filename',[current_s '_' current_c(1:3) '_epoched.set'],'filepath',current_path);
            EEG = eeg_checkset( EEG );
            %% clear EEG
            clear EEG;
        end
    end