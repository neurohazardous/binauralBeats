%%% bgeneration Final Version. Created by Hector O. with Alexandre L. %%%
%%% help (Lots of help from him, actually). Last modified: 23/04/2015 %%%

function [Freq1, Freq2, name, Dur, Amp, Sel] = bgeneration(n)


switch n
    
    
    case 1
        
        %Binaural Beat Theta Generation 
        name = 'Binaural Beat Theta';
        Freq1 = 396.5;                   % carrier frequency left (Hz)
        Dur = 480.0;                     % duration (s)
        Freq2 =403.5;                    % carrier frequency right (Hz)
        Amp = 1;
        Sel = 1;
        
    case 2
        %Binaural Beat Gamma Generation 
        name = 'Binaural Beat Gamma';
        Freq1 = 380.0;                   % carrier frequency left (Hz)
        Dur = 480.0;                     % duration (s)
        Freq2 =420.0;                    % carrier frequency right (Hz)
        Amp = 1; 
        Sel = 1;
        
    case 3
        %Monoaural Beat Gamma Generation 
        name = 'Monoaural Beat Gamma';
        Freq1 = 380.0;                   % carrier frequency left (Hz)
        Dur = 480.0;                     % duration (s)
        Freq2 =420.0;                    % carrier frequency right (Hz)
        Amp = .6;
        Sel = 0;
        
    case 4
        %Monoaural Beat Theta Generation 
        name = 'Monoaural Beat Theta'; 
        Freq1 = 396.5;                   % carrier frequency left (Hz)
        Dur = 480.0;                     % duration (s)
        Freq2 =403.5;                    % carrier frequency right (Hz)
        Amp = .6;
        Sel = 0;
    otherwise
        fprintf('Wrong input. Try again\n'),
        
end