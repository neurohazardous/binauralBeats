%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Project: Binaural Beats
%% Script purpose: Processing for cortical steady state response
%% Author: Hector D Orozco Perez
%% Contact: hector.dom.orozco@gmail.com
%% License: GNU GPL v3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function BBPre2()

data_path = '/Users/g0rd0/Desktop/Brams/0ngoing_Binaural_Beats/Data/PreprocessingICA/'; %Establishes where the Inputted Data is

folders = dir(data_path);                                                               %Pin point the folders of each participant

for n=4:length(folders)-1                                                              %Skip the header of the PreprocessingICA folder
    fold=folders(n).name;                                                               %Folders names
    disp(fold)                                                                          %Display folder names to see where we are
    filenames=dir([data_path,fold,'/*.set']);                                           %Get all the .set files to merge them
    
    for f = 1:5                                                                         %Iteration for the preprocess function
        
        filename=filenames(f).name(1:end);                                              %The name of the file
        disp(filename)                                                                  %Display the name of the file (just to see where we are)
        filepath = [data_path folders(n).name '/'];                                     %The path of said file
        disp([filepath filename])                                                       %Display the name of the path (just in case, y'know?)
        setname(f) = {filename};
    end
    fprintf('\n')
    
    %ICA_preproc(filepath, setname, fold, data_path);                                    %Funtion that runs the pre-processing pipeline for the ICA weights
    
end


end