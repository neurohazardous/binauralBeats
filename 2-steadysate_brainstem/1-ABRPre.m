function ABRPre()
data_path = '/Users/hectorOrozco/Desktop/Brams/0ngoing_Binaural_Beats/Data/Raw/';           %Establishes where the Raw Data is

folder_path = '/Users/hectorOrozco/Desktop/Brams/0ngoing_Binaural_Beats/Data/BrainStem/';   %General path


folders = dir(data_path);                                                                   %Pin point the folders of each participant

for n=4:length(folders)                                                                     %Skip the header of the Raw folder
    
    fold=folders(n).name;                                                                   %Folders names
    disp(fold)                                                                              %Display folder names to see where we are
    filenames=dir([data_path,fold,'/*.bdf']);                                               %Get all the .bdf files
    
    for f = 1:length(filenames)-2                                                           %Iteration for the preprocess function
        
        filename=filenames(f).name(1:end);                                                  %The name of the file
        disp(filename)                                                                      %Display the name of the file (just to see where we are)
        filepath = [data_path folders(n).name '/'];                                         %The path of said file
        disp([filepath filename])                                                           %Display the name of the path (just in case, y'know?)
        
        x = filename(1:3);
        
        if strcmp('S16',x)                                                                %I misconnected two cables when recording S16, so we are correcting that here
            fprintf('S16\n')
            ABRPreprocS16(filepath, filename, fold, folder_path)
            
        else
%             fprintf('NotS16\n')
%             ABRPreproc(filepath, filename, fold, folder_path)
            
        end
        
    end
end
end
