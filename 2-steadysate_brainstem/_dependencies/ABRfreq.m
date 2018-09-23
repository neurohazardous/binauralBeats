function [base_db_out] = ABRfreq(file, generalpath, baseline)
% Please note that baseline needs to be a 4*nbchans matrix

%% Import data
EEG = pop_loadset('filename',file ,'filepath',generalpath);
exp_out = zeros(4,EEG.nbchan);

%% Average epochs
EEGavg = mean(EEG.data, 3);

%% FFT transformation (Normalize by 2/N)
EEGfreq = (abs((fft(EEGavg, [], 2) .* (2.0/EEG.pnts)))).^2;
freqs = linspace(0.0, EEG.srate/2., EEG.pnts/2 + 1);

%% Export mean at FOI (1 Hz bin: 396.5, 403.5, 380, 420)
exp_out(1, :) = mean(EEGfreq(:, freqs >= 396 & freqs <= 397), 2);
exp_out(2, :) = mean(EEGfreq(:, freqs >= 403 & freqs <= 404), 2);
exp_out(3, :) = mean(EEGfreq(:, freqs >= 379.5 & freqs <= 380.5), 2);
exp_out(4, :) = mean(EEGfreq(:, freqs >= 419.5 & freqs <= 420.5), 2);

%% Normalize using baseline (dB deviation)
base_db = 10 .* log10(exp_out ./ baseline);

%% Average channels
base_db_out = mean(base_db, 2)';

end