**PLEASE NOTE THAT THE FILES OF P01 AND S09 WERE NOT USED (PROTOCOL WAS CHANGED AFTER THE FIRST PILOT AND FOR S09 WE HAD MAJOR TECHNICAL PROBLEMS). THIS LEFT US WITH 16 USABLE DATA SETS (P02, S01-S08, S10-S16)**


##Preprocessing 
1-ABRPre works with the function ABRPreproc (there is a function called ABRPreprocS16—  this one does a special treatment to S16 because I messed up two connections (EXG) which are corrected with this function). ARBPre points at the files and loads each file so ABRPreproc is applied to them. They do the preprocessing for the sub-cortical analysis: 

* Import .bdf file without taking off events
* Re-referencing to linked mastoids
* High pass filter @100Hz (Butterworth Order 4)
* Delete unused channels (Nose, VEOGL, HEOGL…— in total they are 11)
* Assign channel location (using Standard BESA)
* Remove and interpolate bad channels (using bad_electrodes.txt)
* Select -/+ 3s around time window of interest (First trigger-3s, Last trigger+11s)
* Epoch data into 60 events
* Name each file correctly and save the .set file
	
**IMPORTANT**: The resultant file will have 60 events, 64 channels and 60 epochs


##SSBR
2-ABR will use the function ABRfreq and ABRfreq_baseline. 2-ABR points at the files, the other two functison do all the dirty work. ABRfreq_baseline loads a baseline file, gets the FFT of each channel, gets the average power around 1Hz bins of the frequency of interest, and outputs a 4x64 matrix (FOI x channels). ABRfreq then intakes this along with the file. This function...

* Loads each file
* Average epochs
* FFT transformation (Normalize by 2/N)
* Baseline normalization (dB normalization using the baseline values)
* Average Channels
* Output FOI

After processing each subject, 2-ABR will output two csv files where we average the frequencies of interest for each beat frequency and output the data in long form (each row is a subject). 



## Stats (3-ABR_stats)
I did two 2x2 within factorial repeated measures anova in R using the csv created by the last function and also calculated partial omega squared for each main effect. 

## Figure (4-ABR_fig)
I did this figures in Python using Seaborn




