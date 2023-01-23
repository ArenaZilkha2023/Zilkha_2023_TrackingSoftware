function BackgroundCreation(~,~)

% Create a background by median given frames
global h
%% Read the variables from the gui
 VideoFilename=get(h.editLoadDirectoryChildB,'string');
 FirstFrameForMedian=str2num(get(h.editNumFramesBF,'string'));
 LastFrameForMedian=str2num(get(h.editNumFramesBL,'string'));
 count=1;
 %% ---------------Auxiliary operations ---------------------
 Aux1=strfind(VideoFilename,'\');
 SaveFile=strcat(VideoFilename(1:Aux1(length(Aux1))),'BackgroundImage.mat');
 
 
 
 %% ----------------------------Read the pertinant frames---------------
v=VideoReader(VideoFilename);
hwait=waitbar(0,'Please wait');
for countFrame=FirstFrameForMedian:LastFrameForMedian
    
  FrameToMedian(:,:,count)=rgb2gray(read(v,countFrame)); 
  count=count+1;  
  waitbar(count/(LastFrameForMedian-FirstFrameForMedian));
end
% c=1.4826
% MedianGroundImage=(median(FrameToMedian,3));
% ErrorGroundImage=c*median(abs(FrameToMedian-MedianGroundImage),3);

BackGroundImage =(median( FrameToMedian,3));

% BackGroundImage=MedianGroundImage./ErrorGroundImage;

%% update the display 
axes(h.hAxisB);
imagesc(BackGroundImage)
colormap gray

%% ---------------Ask if you want to save-------------------
choice = questdlg('Do you want to save the background image?','Question')

if strcmp(choice,'Yes')==1
   SaveFile
   save(SaveFile,'BackGroundImage'); 
    
end




end