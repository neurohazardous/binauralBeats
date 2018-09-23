## Preprocessing
**PLEASE NOTE THAT THE FILES OF P01 AND S09 WERE NOT USED (PROTOCOL WAS CHANGED AFTER THE FIRST PILOT AND FOR S09 WE HAD MAJOR TECHNICAL PROBLEMS). THIS LEFT US WITH 16 USABLE DATA SETS (P02, S01-S08, S10-S16)**

1-BBPre works with the function import_preproc. They do the first part of the pre-processing pipeline:

  1. Import BDF File
  2. Name it according to condition and participant
  3. Create the bipolar EOG channels
  4. Re-reference to linked mastoids
  5. Delete the unused channels ('EXG7' 'EXG8' 'GSR1' 'Resp' 'Left' 'Right' 'VEOGL' 'HEOGL' 'HEOGR')
  6. Edit channel locations
  7. Filter from 1 - 100Hz
  8. Notch filter at 60Hz
  9. Resample at 512Hz
  10. Select +-3 secs around time-window of interest 
  11. Save file as "_imported.set"

2-BBPre2 works with the function ICA_preproc. This function does the next processes:   
  1. Create Dummy data set (MEGA_EEG) to compute the ICA    
        1.1 Merge all 5 files into a single file (4 conditions + baseline)  
        1.2 Filter between 1 and 80Hz  
        1.3 Downsample to 256Hz  
        1.4 Save SXX_MEGA_EEG.set  
  2. Remove bad electrodes (keep bad_chan list)   
  3. Run ICA  
  4. Save ICA weights matrix  
  5. Save ICA file "_MEGA_EEG_ICA.set"  

 
The next steps were done manually, where ICs were inspected and a bad component list (bad_comp.txt) was made for the second half of the pre-processing. 

3-BBPre3 works with ICA_Prune. They do the last part of the pre-processing pipeline. To interpolate missing channels, the file P02_Beat_BBT was used (for it had all of the channels). the syntax used was as follows:
 
save('dummy_loc_structure.mat', '-struct', 'EEG', 'chanlocs')

The last part of the pre-processing pipe-line is as follows:
  1. Remove Bad Channels
  2. Remove Bad IC's
  3. Interpolate missing channels
  4. Re-reference to CAR
  5. Save set file as _ICA_pruned.set
  
## SSEP
4-SSEP will use the function SSEPfreq and SSEPfreq_baseline. 4-SSEP points at the files, the other two functison do all the dirty work. SSEPfreq_baseline loads a baseline file, gets the FFT of each channel, gets the average power around 1Hz bins of the frequency of interest, and outputs a 2x64 matrix (FOI x channels). ABRfreq then intakes this along with the file. This function...

* Loads each file
* Average epochs
* FFT transformation (Normalize by 2/N)
* Baseline normalization (dB normalization using the baseline values)
* Average Channels
* Output FOI

After processing each subject, 4-SSEP will output two csv files for the activity at each beat frequency (7 and 40 Hz) and output the data in long form (each row is a subject, each column an experimental condition and the values are the activity at either 7 or 40 Hz). 

  


