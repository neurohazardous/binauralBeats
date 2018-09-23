
%%Generation

%Binaural Beat Theta Generation (At 80% amplitude)
cf = 432;                   % carrier frequency left (Hz)
Fs = 44100;                 % sample frequency (Hz)
d = 0.04;                    % duration (s)
n = Fs * d;                 % number of samples
x = (1:n) / Fs;             % sound data preparation
s = .8*sin(2 * pi * cf * x);       % sinusoidal modulation

cf2 =864;                   % carrier frequency right (Hz)           % sound data preparation
g = .8*sin(2 * pi * cf2 * x);      % sinusoidal modulation

cf3 =1296;                   % carrier frequency right (Hz)
h = (1:n) / Fs;             % sound data preparation
h = .8*sin(2 * pi * cf3 * x);      % sinusoidal modulation


beat = s + g + h;              % binaural beat matrix
sound(beat', Fs)            % sound presentation
filename = 'Theta_Binaural.wav';
wavwrite(beat' , Fs , filename);% create the binaural beat

%Binaural Beat Gamma Generation (At 80% amplitude)
cf = 380.0;                   % carrier frequency left (Hz)
Fs = 44100;                 % sample frequency (Hz)
d = 420.0;                    % duration (s)
n = Fs * d;                 % number of samples
s = (1:n) / Fs;             % sound data preparation
s = .8*sin(2 * pi * cf * s);       % sinusoidal modulation
cf2 =420.0;                   % carrier frequency right (Hz)
g = (1:n) / Fs;             % sound data preparation
g = .8*sin(2 * pi * cf2 * g);      % sinusoidal modulation
beat = [s ; g];              % binaural beat matrix
%sound(beat', Fs)            % sound presentation
filename = 'Gamma_Binaural.wav';
wavwrite(beat' , Fs , filename);% create the binaural beat

%Monoaural Beat Gamma Generation (At 40% amplitude)
cf = 380.0;                   % carrier frequency left (Hz)
Fs = 44100;                 % sample frequency (Hz)
d = 420.0;                    % duration (s)
n = Fs * d;                 % number of samples
s = (1:n) / Fs;             % sound data preparation
s = .4*sin(2 * pi * cf * s);       % sinusoidal modulation
cf2 =420.0;                   % carrier frequency right (Hz)
g = (1:n) / Fs;             % sound data preparation
g = .4*sin(2 * pi * cf2 * g);      % sinusoidal modulation
beat = s + g;              % binaural beat matrix
%sound(beat', Fs)            % sound presentation
filename = 'Gamma_Monoaural.wav';
wavwrite(beat' , Fs , filename);% create the monoaural beat


%Monoaural Beat Theta Generation (At 40% amplitude)
cf = 396.5;                   % carrier frequency left (Hz)
Fs = 44100;                 % sample frequency (Hz)
d = 420.0;                    % duration (s)
n = Fs * d;                 % number of samples
s = (1:n) / Fs;             % sound data preparation
s = .4*sin(2 * pi * cf * s);       % sinusoidal modulation
cf2 =403.5;                   % carrier frequency right (Hz)
g = (1:n) / Fs;             % sound data preparation
g = .4*sin(2 * pi * cf2 * g);      % sinusoidal modulation
beat = s + g;              % binaural beat matrix
%sound(beat', Fs)            % sound presentation
filename = 'Theta_Monoaural.wav';
wavwrite(beat' , Fs , filename);% create the monoaural beat


%%Analysis (FFT)

%Monoaural Beat Theta (Each step should be run separately)

excerpt = miraudio('Theta_Monoaural.wav', 'Extract', 0, 0.2857)  %Shows the first two cycles of the monoaural beat

tone = miraudio('Theta_Monoaural.wav') %Convert the .wav to a mir object for best performance

TONE = mirspectrum(tone) %FFT of stimulus

closeff = mirspectrum(tone, 'Min', 395, 'Max', 405) %Close up of the FFT in the "important" frequencies

hil = mirenvelope(tone, 'Hilbert')  %Hilbert transform of the stimuli

ffh = mirspectrum(hil, 'Min', 1) %FFT of the hilbert transform, avoid the frequency 0 because there is a problem with it

closehil = mirspectrum(hil, 'Min', 1, 'Max', 35)  %Close up of FFT of HT to show harmonics


%Monoaural Beat Gamma

excerpt = miraudio('Gamma_Monoaural.wav', 'Extract', 0, 0.05)  %Shows the first two cycles of the monoaural beat

tone = miraudio('Gamma_Monoaural.wav') %Convert the .wav to a mir object for best performance

TONE = mirspectrum(tone) %FFT of stimulus

closeff = mirspectrum(tone, 'Min', 375, 'Max', 425) %Close up of the FFT in the "important" frequencies

hil = mirenvelope(tone, 'Hilbert')  %Hilbert transform of the stimuli

ffh = mirspectrum(hil, 'Min', 1) %FFT of the hilbert transform, avoid the frequency 0 because there is a problem with it

closehil = mirspectrum(hil, 'Min', 1, 'Max', 300)  %Close up of FFT of HT to show harmonics


%Binaural Beat Theta

beat = wavread('Theta_Binaural.wav');

left = beat(:,1); %Separate Binaural Beat into left and right channels

tone_left = miraudio(left);  %Transform left channel into mir object for best performance 

excerpt = miraudio(tone_left, 'Extract', 0, .005)

TONE_left = mirspectrum(tone_left);  %Perform FFT of left channel

closeff_left = mirspectrum(tone_right, 'Min', 395, 'Max', 405)

hil_left = mirenvelope(tone_left, 'Hilbert');

ffh_left = mirspectrum(hil, 'Min', 1)

right = beat(:,2);

tone_right = miraudio(right);

excerpt = miraudio(tone_right, 'Extract', 0, .005)

TONE_right = mirspectrum(tone_right);  %Perform FFT of left channel

closeff_right = mirspectrum(tone_right, 'Min', 395, 'Max', 405)

hil_right = mirenvelope(tone_right, 'Hilbert');

ffh_right = mirspectrum(hil_right, 'Min', 1)


%Binaural Beat Theta

beat = wavread('Gamma_Binaural.wav');

left = beat(:,1); %Separate Binaural Beat into left and right channels

tone_left = miraudio(left);  %Transform left channel into mir object for best performance 

excerpt = miraudio(tone_left, 'Extract', 0, .005)

TONE_left = mirspectrum(tone_left);  %Perform FFT of left channel

closeff_left = mirspectrum(tone_left, 'Min', 375, 'Max', 420)

hil_left = mirenvelope(tone_left, 'Hilbert');

ffh_left = mirspectrum(hil_left, 'Min', 1)

right = beat(:,2);

tone_right = miraudio(right);

excerpt = miraudio(tone_right, 'Extract', 0, .005)

TONE_right = mirspectrum(tone_right);  %Perform FFT of right channel

closeff_right = mirspectrum(tone_right, 'Min', 390, 'Max', 430)

hil_right = mirenvelope(tone_right, 'Hilbert');

ffh_right = mirspectrum(hil_right, 'Min', 1)
