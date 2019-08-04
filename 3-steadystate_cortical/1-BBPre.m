%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Project: Binaural Beats
%% Script purpose: Processing for cortical steady state response
%% Author: Hector D Orozco Perez
%% Contact: hector.dom.orozco@gmail.com
%% License: GNU GPL v3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function BBPre()

data_path = '/Users/g0rd0/Desktop/Brams/0ngoing_Binaural_Beats/Data/Raw/'; %Establishes where the Raw Data is

folders = dir(data_path);                                                                   %Pin point the folders of each participant

for n=4:length(folders)                                                                     %Skip the header of the Raw folder
    
    fold=folders(n).name;                                                                   %Folders names
    disp(fold)                                                                              %Display folder names to see where we are
    filenames=dir([data_path,fold,'/*.bdf']);                                               %Get all the .bdf files
    
    for f = 1:length(filenames)-2                                                       %Iteration for the preprocess function
        
        filename=filenames(f).name(1:end);                                              %The name of the file
        disp(filename)                                                                  %Display the name of the file (just to see where we are)
        filepath = [data_path folders(n).name '/'];                                         %The path of said file
        disp([filepath filename])                                                       %Display the name of the path (just in case, y'know?)
     
        
%         x = filename(1:3);
%         
%         if strcmp('S16',x)
%             fprintf('S16\n')
%             %import_preproc_S16(filepath, filename)
%             
%         else
%             fprintf('NotS16\n')
%             %import_preproc(filepath, filename)
%             
%         end
    end
end


end

