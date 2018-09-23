%%% beats_bimo Final Version. Created by Hector O. with Alexandre L.  %%%
%%% help (Lots of help from him, actually). Last modified: 23/04/2015 %%%

function beats_bimo()

%%Initial Parameters
pseudo_rand=randperm(4);                    %Generate the random order for the experimental blocks
npts= 2.34375e+007;                         %Number of samples the TDT will actively play the sound = 8 minutes worth of samples
fprintf(1,'Beat experiment will start.\n');
fprintf(1,'Conditions %i \n',pseudo_rand);  %Display the order of conditions
fprintf('Ready to start ');
if ~continuer();
    disp('Done.');
    return;
end

%%Start RP2
fprintf(1,'\nCreating TDT ActiveX interface...\n') %Wake up the TDT
HActX = figure('position',[5 673 462 73],...
    'menubar','none',...
    'numbertitle','off',...
    'name','TDT ActiveX',...
    'Tag','TDT ActiveX window',...
    'DeleteFcn','global RP2, delete(RP2)');
RP2 = actxcontrol('RPco.x',[0 0 200 200],HActX);
invoke(RP2,'ConnectRX6','GB',1);
chain = 'hector_tone.rcx';                         %Use this patch for the TDT
invoke(RP2,'ClearCOF');
invoke(RP2,'LoadCOF',chain);
invoke(RP2,'Run');
Status = uint32(invoke(RP2,'GetStatus'));          %Check everything is ok with the TDT - First wake it up, then feed the patch and finally run it

if bitget(Status,1)==0;
    error('Error connecting to RX6')
end
if bitget(Status,2)==0;
    error('Error loading circuit')
end
if bitget(Status,3)==0;
    error('Error running circuit')
else
    fprintf(1,'RX6 ready!\n\n')
end

%%Generate the Beat Parameters and Pass them to the TDT
for j=1:4;
    [Freq1, Freq2, name, Dur, Amp, Sel] = bgeneration(pseudo_rand(j)); %Generates the Beat parameters using the bgeneration function
    fprintf(1,'This block will take 8 minutes using %s \n', name);
    fprintf('Use these parameters ');
    if ~continuer();
        disp('Done.');
        return;
    end

    %Init TDT PARAMS
    invoke(RP2,'SetTagVal','Freq1',Freq1);
    invoke(RP2,'SetTagVal','Freq2',Freq2);
    invoke(RP2,'SetTagVal','Amp',Amp);     %Amplitude, this one is important to have the same amplitude in binaural vs monoaural
    invoke(RP2,'SetTagVal','Sel',Sel);     %This will do the selection in the multiplexing process in the patch
    invoke(RP2,'SetTagVal','BufLen',npts);
    invoke(RP2,'SetTagVal','TrigCode',pseudo_rand(j));

    fprintf('Condition: %i \nType: %s \n', pseudo_rand(j), name);
    input('Press ENTER to continue \n');
    pause(1);
    invoke(RP2,'SoftTrg',1);                           %Invoke Softtrig to start everything in the patch
    pause(5);                                          %Wait for sound to start

    while double(invoke(RP2,'GetTagVal','Play'))>0;    %The TDT is sending us Play to know when it has stopped playing so we can continue
        pause(0.01);
    end

    %The sound has stopped playing, clear variables to start iteration again

    clear Freq1
    clear Freq2
    clear name
    clear Amp
    clear Dur
    clear Sel


end

%%Stop patch and finish protocol
invoke(RP2,'Halt');
delete(HActX);
fprintf(1,'\nDone.\n\n');
end





