function SetThresholdGUI(~,~)
clear all

global h
%%Remember the root folder could be anything
global Image2
global Image3
global Image4
global Image5
global Image6
global Image7
global Image8
global Image9
global Image10


%% 
[x,map]=imread('open folder.jpg');
Image2=imresize(x, [60 40]);

[x1,map]=imread('start-icon.jpg');
Image3=imresize(x1, [60 40]);

[x2,map]=imread('starting-icon.jpg');
Image4=imresize(x2, [60 40]);

[x2,map]=imread('Button-Ok-icon.png');
Image5=imresize(x2, [60 40]);

[x2,map]=imread('Microsoft-Word-2013-icon.png');
Image6=imresize(x2, [60 40]);

[x2,map]=imread('movie-icon.jpg');
Image7=imresize(x2, [60 40]);

[x4,map]=imread('back.jpg');
Image8=imresize(x4, [60 40]);
% 
[x5,map]=imread('forward.jpg');
Image9=imresize(x5, [60 40]);

[x6,map]=imread('Floppy-disk-Saving-icon.jpg');
Image10=imresize(x6, [100 200]);

%% 

% Create new figure
       
           
               h.SetThreshold.Principal = figure('numbertitle', 'off', ...
               'name', 'SetThresholdGUI', ...
               'menubar','none', ...
               'toolbar','none', ...
               'resize', 'on', ...
               'renderer','painters', ...
               'position',[50 80 1800 900]);


           %% 
 %% Create a panel for loading the raw video
       
        % Create panel
        h.SetThreshold.PanelRaw = uipanel('parent',h.SetThreshold.Principal,'Position',[0.05 0.4 0.20 0.35],'Units','Normalized');

        % Create axis
        h.SetThreshold.hAxisr = axes('position',[0 0 1 1],'Parent',h.SetThreshold.PanelRaw);
        h.SetThreshold.hAxisr.XTick = [];
        h.SetThreshold.hAxisr.YTick = [];
        h.SetThreshold.hAxisr.XColor = [1 1 1];
        h.SetThreshold.hAxisr.YColor = [1 1 1];
        
         uicontrol( h.SetThreshold.Principal ,'Style','text','String','Raw image','FontSize',12,'position',[200,680,150,30],'ForegroundColor','red','FontWeight','bold');  
  %% Create a panel for loading the data without background
       
        % Create panel
        h.SetThreshold.PanelWithoutBack = uipanel('parent',h.SetThreshold.Principal ,'Position',[0.27 0.4 0.20 0.35],'Units','Normalized');

        % Create axis
        h.SetThreshold.hAxisWB = axes('position',[0 0 1 1],'Parent',h.SetThreshold.PanelWithoutBack);
        h.SetThreshold.hAxisWB.XTick = [];
        h.SetThreshold.hAxisWB.YTick = [];
        h.SetThreshold.hAxisWB.XColor = [1 1 1];
        h.SetThreshold.hAxisWB.YColor = [1 1 1];
        
         uicontrol(h.SetThreshold.Principal,'Style','text','String','Background substracted','FontSize',12,'position',[600,680,150,50],'ForegroundColor','red','FontWeight','bold');  

         %%  %% Create a panel for binary image with threshold. 
       
        % Create panel
       h.SetThreshold.PanelT = uipanel('parent', h.SetThreshold.Principal ,'Position',[0.50 0.4 0.20 0.35],'Units','Normalized');

        % Create axis
        h.SetThreshold.hAxisT = axes('position',[0 0 1 1],'Parent', h.SetThreshold.PanelT);
        h.SetThreshold.hAxisT.XTick = [];
        h.SetThreshold.hAxisT.YTick = [];
        h.SetThreshold.hAxisT.XColor = [1 1 1];
        h.SetThreshold.hAxisT.YColor = [1 1 1];
        
         uicontrol(h.SetThreshold.Principal,'Style','text','String','Thresholded image','FontSize',12,'position',[1000,680,150,30],'ForegroundColor','red','FontWeight','bold');  
         %%   %%  %% Identified the mouse. 
       
        % Create panel
        h.SetThreshold.PanelB = uipanel('parent', h.SetThreshold.Principal ,'Position',[0.73 0.4 0.20 0.35],'Units','Normalized');

        % Create axis
        h.SetThreshold.hAxisB = axes('position',[0 0 1 1],'Parent',h.SetThreshold.PanelB);
        h.SetThreshold.hAxisB.XTick = [];
        h.SetThreshold.hAxisB.YTick = [];
        h.SetThreshold.hAxisB.XColor = [1 1 1];
        h.SetThreshold.hAxisB.YColor = [1 1 1];
        
         uicontrol(h.SetThreshold.Principal,'Style','text','String','Mouse identified','FontSize',12,'position',[1400,680,150,30],'ForegroundColor','red','FontWeight','bold');  

              
        %% 
        %% -------- Set the path movie ------

        h.SetThreshold.Dir_handles=uicontrol(h.SetThreshold.Principal,'Style', 'pushbutton','units','pixels',.....
        'tag','Directory',...
        'callback',@LoadDataForReferenceT,'cdata',Image2,...
       'position',[200,230,40,60]);
    
        uicontrol(h.SetThreshold.Principal,'Style', 'text','units','pixels',.....
       'string','Video Reference',...
       'position',[10,205,450,30],'FontSize',9,'ForegroundColor','blue');

       h.SetThreshold.editLoadDirectoryChild=uicontrol(h.SetThreshold.Principal,'Style','edit','String',' ','position',[250,250,400,30]);      
        
        %% ---------------Add box for the number of frame-------------------------
        uicontrol(h.SetThreshold.Principal,'Style','text','String','Number of Frame','FontSize',9,'position',[680,270,100,30],'ForegroundColor','blue');
        h.SetThreshold.editNumFrames=uicontrol(h.SetThreshold.Principal,'Style','edit','String',' ','position',[700,250,60,30]); 
        %% 

         % Add image without background- 
          uicontrol(h.SetThreshold.Principal,'Style','pushbutton','String','Identified the mice','FontSize',9,'position',[150,150,150,30],'ForegroundColor','magenta','callback',@IdentifiedMouse_for_settings);
          %% Change theshold area
          uicontrol(h.SetThreshold.Principal,'Style','text','String','Area to filter','FontSize',9,'position',[880,270,100,30],'ForegroundColor','blue');
          h.SetThreshold.AreaToFilter=uicontrol(h.SetThreshold.Principal,'Style','edit','String','100 ','position',[900,250,60,30]); 
          
%           %% Change theshold level
%           uicontrol(h.SetThreshold.Principal,'Style','text','String','Fix threshold if no good segmentation','FontSize',9,'position',[880,150,150,30],'ForegroundColor','blue');
%           h.SetThreshold.LevelThreshold=uicontrol(h.SetThreshold.Principal,'Style','edit','String','0.1','position',[910,120,60,30]); 
%           
%            % Actual Threshold level
%           uicontrol(h.SetThreshold.Principal,'Style','text','String','Actual threshold without condition','FontSize',9,'position',[880,220,150,30],'ForegroundColor','blue');
%           h.SetThreshold.ActualLevelThreshold=uicontrol(h.SetThreshold.Principal,'Style','edit','String','0.1','position',[910,190,60,30]);
%           
%           
%             % Fix Threshold level if the number of segmentation is larger
%             % than
%           uicontrol(h.SetThreshold.Principal,'Style','text','String','Actual threshold without condition','FontSize',9,'position',[880,220,150,30],'ForegroundColor','blue');
%           h.SetThreshold.ActualLevelThreshold=uicontrol(h.SetThreshold.Principal,'Style','edit','String','0.1','position',[910,190,60,30]);
          
          %Change elongation ratio
           uicontrol(h.SetThreshold.Principal,'Style','text','String','Minimum elongation factor to eliminate borders artifacts','FontSize',9,'position',[1080,270,150,60],'ForegroundColor','blue');
          h.SetThreshold.MinElongationFactor=uicontrol(h.SetThreshold.Principal,'Style','edit','String','8','position',[1120,250,60,30]); 
          
          % Define maximum area to be one mice
          uicontrol(h.SetThreshold.Principal,'Style','text','String','Maximum area of a mouse (pixels units)','FontSize',9,'position',[1280,270,150,60],'ForegroundColor','blue');
          h.SetThreshold.AreaMouse=uicontrol(h.SetThreshold.Principal,'Style','edit','String','650','position',[1320,250,60,30]); 
          
          %Define maximum area to be 2 clusters
          
          uicontrol(h.SetThreshold.Principal,'Style','text','String','Maximum area of a cluster of 2 mice (pixel units)','FontSize',9,'position',[1480,270,150,60],'ForegroundColor','blue');
          h.SetThreshold.Area2Mouse=uicontrol(h.SetThreshold.Principal,'Style','edit','String','1150','position',[1520,250,60,30]); 
          
          
          %% Save segmentation parameters
          
          
        h.SetThreshold.Dir_handles=uicontrol(h.SetThreshold.Principal,'Style', 'pushbutton','units','pixels',.....
        'tag','Directory',...
        'callback',@SaveSegmentationSettings,'cdata',Image2,...
       'position',[1520,100,60,30]);
   
        uicontrol(h.SetThreshold.Principal,'Style', 'text','units','pixels',.....
       'string','Save segmentation settings in a mat file to change default',...
       'position',[1450,30,200,60],'FontSize',11,'ForegroundColor','Red','FontWeight','bold');
          
end