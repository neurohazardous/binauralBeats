## License
This file is part of the project binauralBeat. All of binauralBeat code is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. binauralBeat is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with binauralBeat. If not, see https://www.gnu.org/licenses/.

## Status
Published paper can be found (and freely accessed) [here](https://doi.org/10.1523/ENEURO.0232-19.2020)

## Objective
Binaural beats have been the subject of much speculation during the past few years. Several companies and apps claim they regulate cognitive states and behavior. This project aims to characterize neural responses to binaural beats (as well as control conditions) throughout the auditory pathway (from brainstem responses to connectivity patterns) to determine if (1) binaural beats can entrain the brain and (2) if this entrainment modulates participants' mental state

## Visual Abstract
![visual abstract](https://github.com/neurohazardous/binauralBeats/blob/master/visual_abstract.png)

## Supervisors
[Dr Alexandre Lehmann](https://www.mcgill.ca/ent/about-us/people/faculty/dr-alexandre-lehmann) and [Dr Guillaume Dumas](https://www.extrospection.eu/)

## Dependencies
* R v3.6.1
* MATLAB 2014
* EEGLAB v13
* Python 3.6

## Contents 
### 0-experiment
* MATLAB scripts used during the actual experiment (i.e. interfacing Biosemi EEG data acquisition system with Tucker-Davis Technologies processor) and some scripts to analyze the recorded audio

### 1-analogue scales
* Includes MATLAB file used to plot results from pen and paper questionnaires
* Includes R script used to do hypothesis testing

### 2-steadystate_brainstem
* Inclues MATLAB file used to preprocess data (EEGLAB) and do Fourier analysis 
* Includes R script used to do hypothesis testing
* Includes Python script used to create violin plots

### 3-steadystate_cortical
* Inclues MATLAB file used to preprocess data (EEGLAB) and do Fourier analysis
* Includes R script used to do hypothesis testing
* Includes Python script used to create violin plots

### 4-functional_connectivity
* Please note this code was written by Dr Guillaume Dumas
* Includes MATLAB files used to do connectivity analysis (iCOH and PLV), statistical analysis, and figures
