function [base_db_out] = SSEPfreq(file, generalpath, baseline)
% Please note that baseline needs to be a 2*nbchans matrix

%% Import data
EEG = pop_loadset('filename',file ,'filepath',generalpath);
exp_out = zeros(2,EEG.nbchan);

%% Average epochs
EEGavg = mean(EEG.data, 3);

%% FFT transformation (Normalize by 2/N)
EEGfreq = (abs((fft(EEGavg, [], 2) .* (2.0/EEG.pnts)))).^2;
freqs = linspace(0.0, EEG.srate/2., EEG.pnts/2 + 1);

%% Export mean at FOI (1 Hz bin: 7 and 40)
exp_out(1, :) = mean(EEGfreq(:, freqs >= 6.5 & freqs <= 7.5), 2);
exp_out(2, :) = mean(EEGfreq(:, freqs >= 39.5 & freqs <= 40.5), 2);

%% Normalize using baseline (dB deviation)
base_db = 10 .* log10(exp_out(:, 1:64) ./ baseline);

%% Average channels
base_db_out = mean(base_db, 2)';

end