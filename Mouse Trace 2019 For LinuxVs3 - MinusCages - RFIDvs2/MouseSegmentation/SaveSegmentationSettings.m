function SaveSegmentationSettings(~,~)

global h

%% Read the variables from the gui
 VideoFilename=get(h.SetThreshold.editLoadDirectoryChild,'string')
 Aux1=strfind(VideoFilename,'\');

 mkdir(VideoFilename(1:Aux1(length(Aux1)-1)),'Parameters\'); 
 SaveFile=strcat(VideoFilename(1:Aux1(length(Aux1)-1)),'Parameters\','SegmentationSettings.mat');
 
 % Read parameters
 
 SegmentationParameters.AreaToFilter=str2num(get(h.SetThreshold.AreaToFilter,'string'));
 SegmentationParameters.ElongationParams=str2num(get(h.SetThreshold.MinElongationFactor,'string'));
 SegmentationParameters.AreaMouse=str2num(get( h.SetThreshold.AreaMouse,'string'));
 SegmentationParameters.Area2Mouse=str2num(get( h.SetThreshold.Area2Mouse,'string'));


 
save(SaveFile,'SegmentationParameters')

msgbox('The data was saved')







end