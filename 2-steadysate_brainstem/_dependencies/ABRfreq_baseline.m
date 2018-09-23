function [baseline_freq] = ABRfreq_baseline(file_base, generalpath)
%% Import data & initialize output matrix
EEG_base = pop_loadset('filename',file_base ,'filepath',generalpath);
baseline_freq = zeros(4,EEG_base.nbchan); %mean FOI x Electrodes

%% FFT transformation (Normalize by N)
EEGfreq = (abs((fft(EEG_base.data, [], 2).* (2.0/EEG_base.pnts)))).^2;
freqs = linspace(0.0, EEG_base.srate/2., EEG_base.pnts/2 + 1);

%% Export each channel's mean at FOI (1 Hz bin: 396.5, 403.5, 380, 420)
baseline_freq(1, :) = mean(EEGfreq(:, freqs >= 396 & freqs <= 397), 2);
baseline_freq(2, :) = mean(EEGfreq(:, freqs >= 403 & freqs <= 404), 2);
baseline_freq(3, :) = mean(EEGfreq(:, freqs >= 379.5 & freqs <= 380.5), 2);
baseline_freq(4, :) = mean(EEGfreq(:, freqs >= 419.5 & freqs <= 420.5), 2);

end
