function SaveParametersForLinuxUse(~,~)
global h

global root_folder

% This parameter must be changed in Linux
GuiParameters.root_folder=root_folder;

% Load the folder with rfid and video data for segmentation
GuiParameters.Directory_Data=get(h.editLoadDirectoryChild1,'string');

 %% Choose if to analysis all the movies or only part 
 
         dataExp = get(h.popupExp,'String');
         idxExp  = get(h.popupExp,'Value');
         GuiParameters.MoviesToConsider = dataExp{idxExp};

         %% For selection to do rfid or segmentation together
         GuiParameters.SegmentationCheckBox=get(h.c(1),'Value'); %segmentation
         GuiParameters.RFIDCheckBox=get(h.c(2),'Value'); %rfid
         %% Read experiment name
         GuiParameters.ExperimentName=get(h.ExperimentName,'string');

           %% Read if to change the starting frame for the first movie to analyze
          
           GuiParameters.StartingTime =get(h.StartingTime,'string');
           
           GuiParameters.StartingTimeCheckBox=get(h.c(3),'Value');
         
       %% Load the video reference details

            GuiParameters.ReferenceFile=get(h.editLoadDirectoryChild,'string');

            GuiParameters.ReferenceFrame=get(h.editNumFrames,'string');
           
           %% Select the folder to save the parameters
           
          folder_name=uigetdir('Select the folder to save the file with gui parameters');
           timescalar=datetime('now');
           
            GuiParameters.folder_nameGuiParameters=folder_name;
           
          save(fullfile(folder_name,strcat('GUIParameters',GuiParameters.ExperimentName,'.mat')),'GuiParameters')
           
           
           
           
end