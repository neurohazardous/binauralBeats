function [baseline_freq] = ABRfreq_baseline(file_base, baselinepath)
%% Import data & initialize output matrix
EEG_base = pop_loadset('filename',file_base ,'filepath',baselinepath);
baseline_freq = zeros(2,EEG_base.nbchan); %mean FOI x Electrodes

%% FFT transformation (Normalize by N)
EEGfreq = (abs((fft(EEG_base.data, [], 2).* (2.0/EEG_base.pnts)))).^2;
freqs = linspace(0.0, EEG_base.srate/2., EEG_base.pnts/2 + 1);

%% Export each channel's mean at FOI (1 Hz bin: 7 and 40)
baseline_freq(1, :) = mean(EEGfreq(:, freqs >= 6.5 & freqs <= 7.5), 2);
baseline_freq(2, :) = mean(EEGfreq(:, freqs >= 39.5 & freqs <= 40.5), 2);

%% Export only the channels of interest
baseline_freq = baseline_freq(:, 1:64);

end
