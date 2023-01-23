function  Initial_Parameters=Parameters(~,~)
%Create structure of initial parameters

%% Variables
global Directory_Data
global GuiParameters
global root_folder
%% Load the folder with rfid and video data for segmentation

%          Directory_Data=get(h.editLoadDirectoryChild1,'string');
         
         Aux=strfind(Directory_Data,'/');%Before the folder of dates 
         LoadFile=strcat(strrep(Directory_Data(1:Aux(length(Aux))),'RawData/','Parameters/'),'SegmentationSettings.mat');
         BackFile=strcat(Directory_Data,'/','BackgroundImage.mat');

 %% Creation of structure
         Initial_Parameters.DataDirectory=Directory_Data;


 %% Choose if to analysis all the movies or only part 
 
%          dataExp = get(h.popupExp,'String');
%          idxExp  = get(h.popupExp,'Value');
%          Initial_Parameters.MoviesToConsider = dataExp{idxExp};
 %          Initial_Parameters.MoviesToConsider =GuiParameters.GuiParameters.MoviesToConsider; 
          Initial_Parameters.MoviesToConsider ='All';

         %% Add the checkbox
%          Initial_Parameters.SegmentationCheckBox=get(h.c(1),'Value');
%          Initial_Parameters.RFIDCheckBox=get(h.c(2),'Value');
           %Initial_Parameters.SegmentationCheckBox=GuiParameters.GuiParameters.SegmentationCheckBox;
           %Initial_Parameters.RFIDCheckBox=GuiParameters.GuiParameters.RFIDCheckBox;
           %Initial_Parameters.SegmentationCheckBox=1;
           %Initial_Parameters.RFIDCheckBox=0;

         %% Read experiment name
%          Initial_Parameters.ExperimentName=get(h.ExperimentName,'string');
            Initial_Parameters.ExperimentName=GuiParameters.GuiParameters.ExperimentName;
         
         %% Read if to change the starting frame for the first movie to analyze
          
%            Initial_Parameters.StartingTime =get(h.StartingTime,'string');
%            
%            Initial_Parameters.StartingTimeCheckBox=get(h.c(3),'Value');

             Initial_Parameters.StartingTime =GuiParameters.GuiParameters.StartingTime;
             Initial_Parameters.StartingTimeCheckBox=GuiParameters.GuiParameters.StartingTimeCheckBox;
             
             
 %% Parameters for reading the stamp time

% Dimension of the rectangle to crop all the title
Initial_Parameters.CropTimeStamp=[ 265.5100  557.5100  176.9800   18.9800]; %to crop all the title

%Directory with the fonts

Initial_Parameters.FontsFile=[root_folder,'ReadTimeStamp/','LibraryPicturesOfNumbers'];
%Initial_Parameters.FontsFile=[root_folder,'/','LibraryPicturesOfNumbers'];

% %% Load the video reference details
% Initial_Parameters.ReferenceFile=get(h.editLoadDirectoryChild,'string');
% 
% Initial_Parameters.ReferenceFrame=get(h.editNumFrames,'string');
%% Frame rate assignment

Initial_Parameters.FrameRate=12.8;


%% Parameters Related with segmentation
   %% Parameters Associated with the elimination of the borders,which appear in the segmentation (they are very dark)
%        Initial_Parameters.AreaToFilter=290;
%        Initial_Parameters.MajorAxis=40;
%        
%       
%     %% Parameters for the speration of 2 or 3 mice
%        Initial_Parameters.LimitArea1To2=700; %pixels units
%        Initial_Parameters.LimitArea2To3=1150; %pixels units
%        Initial_Parameters.erodePixels=6;
%        Initial_Parameters.erodeAreasToRemove=10;

%% 
if exist(LoadFile)==0
  
    %msgbox('Use default segmentations values')
    Initial_Parameters.AreaToFilter=100;
    Initial_Parameters.MajorAxis=8;
    Initial_Parameters.LimitArea1To2=650;
    Initial_Parameters.LimitArea2To3=1150;
    Initial_Parameters.CheckboxAdditionalBack=0;
    Initial_Parameters.CheckboxAdditionalCirc=0;
    Initial_Parameters.CheckboxAdditionalArea=0;
    
else
    
    load(LoadFile);

 Initial_Parameters.AreaToFilter=SegmentationParameters.AreaToFilter;
 Initial_Parameters.MajorAxis=SegmentationParameters.ElongationParams;
 Initial_Parameters.LimitArea1To2=SegmentationParameters.AreaMouse;
 Initial_Parameters.LimitArea2To3=SegmentationParameters.Area2Mouse;
 if isfield(SegmentationParameters,'CheckboxAdditionalBack')  %In the case the user use old data
    Initial_Parameters.CheckboxAdditionalBack=SegmentationParameters.CheckboxAdditionalBack;
    Initial_Parameters.BackgroundFactor=SegmentationParameters.BackgroundFactor;
 end
 if isfield(SegmentationParameters,'CheckboxAdditionalCirc') 
    Initial_Parameters.CheckboxAdditionalCirc=SegmentationParameters.CheckboxAdditionalCirc;
    Initial_Parameters.Circularity=SegmentationParameters.Circularity;
 end
 if isfield(SegmentationParameters,'CheckboxAdditionalArea') 
    Initial_Parameters.CheckboxAdditionalArea=SegmentationParameters.CheckboxAdditionalArea;
    Initial_Parameters.Area=SegmentationParameters.Area;
end
 if isfield(SegmentationParameters,'CheckboxContourArena') 
    Initial_Parameters.CheckboxContourArena=SegmentationParameters.CheckboxContourArena;
end

%% Insert the background
if exist(BackFile)==0
    
    errordlg('No background image exists- Go to settings and determined the background');
    return
else
    
  load(BackFile);
  Initial_Parameters.BackgroundImage=BackGroundImage;

end   








end

