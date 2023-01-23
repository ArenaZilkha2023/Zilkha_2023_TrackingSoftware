function SetBackgroundGUI(~,~)
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
       
           
               h.SetBackground = figure('numbertitle', 'off', ...
               'name', 'SetBackgroundGUI', ...
               'menubar','none', ...
               'toolbar','none', ...
               'resize', 'on', ...
               'renderer','painters', ...
               'position',[50 80 1800 900]);

           %% 
 %% Create a panel for loading the video
       
        % Create panel
        h.hPanelOriginal = uipanel('parent',h.SetBackground,'Position',[0.05 0.15 0.40 0.70],'Units','Normalized');

        % Create axis
        h.hAxis = axes('position',[0 0 1 1],'Parent',h.hPanelOriginal);
        h.hAxis.XTick = [];
        h.hAxis.YTick = [];
        h.hAxis.XColor = [1 1 1];
        h.hAxis.YColor = [1 1 1];
        
         uicontrol(h.SetBackground,'Style','text','String','Original','FontSize',12,'position',[300,770,150,30],'ForegroundColor','red','FontWeight','bold');  

   %% Create a second panel  to see the background
       
        % Create panel
        h.hPanelBackground = uipanel('parent',h.SetBackground,'Position',[0.55 0.15 0.40 0.70],'Units','Normalized');

        % Create axis
        h.hAxisB = axes('position',[0 0 1 1],'Parent',h.hPanelBackground);
        h.hAxisB.XTick = [];
        h.hAxisB.YTick = [];
        h.hAxisB.XColor = [1 1 1];
        h.hAxisB.YColor = [1 1 1];      
        
        uicontrol(h.SetBackground,'Style','text','String','Background','FontSize',12,'position',[1300,770,150,30],'ForegroundColor','red','FontWeight','bold');  
        
        %% 
        %% -------- Set the path movie ------

        Dir_handlesB=uicontrol(h.SetBackground,'Style', 'pushbutton','units','pixels',.....
        'tag','Directory',...
        'callback',@LoadDataForReferenceB,'cdata',Image2,...
       'position',[100,30,40,60]);
    
        uicontrol(h.SetBackground,'Style', 'text','units','pixels',.....
       'string','Video Reference',...
       'position',[40,5,150,30],'FontSize',9,'ForegroundColor','blue');

       h.editLoadDirectoryChildB=uicontrol(h.SetBackground,'Style','edit','String',' ','position',[150,50,400,30]);      
        
        %% ---------------Add box for the number of frame-------------------------
        uicontrol(h.SetBackground,'Style','text','String','Number of Frame','FontSize',9,'position',[680,70,100,30],'ForegroundColor','blue');
        h.editNumFramesB=uicontrol(h.SetBackground,'Style','edit','String',' ','position',[700,50,60,30]); 

        %% Settings for the background
        % Create panel
        
         h.panelSettings = uipanel('Parent',h.SetBackground,...
             'BackgroundColor','white',...
             'Position',[0.55 0.0200 0.3 0.13],'Title','Setting to create a background','FontSize',10,'Foreground','blue');
          
        uicontrol(h.panelSettings,'Style','text','String','First Frame for median background ','FontSize',9,'position',[10,60,100,30],'ForegroundColor','blue');
        h.editNumFramesBF=uicontrol(h.panelSettings,'Style','edit','String',' ','position',[200,60,80,20]); %first frame
        
        uicontrol(h.panelSettings,'Style','text','String','Last frame for median background','FontSize',9,'position',[10,10,150,30],'ForegroundColor','blue');
        h.editNumFramesBL=uicontrol(h.panelSettings,'Style','edit','String',' ','position',[200,10,80,20]); %last frame
        
          %start calcutlate background
          uicontrol(h.panelSettings,'Style','pushbutton','String','Start to create background','FontSize',9,'position',[300,60,150,30],'ForegroundColor','magenta','callback',@BackgroundCreation);
          % save the background
          % uicontrol(h.panelSettings,'Style','pushbutton','String','Save the background','FontSize',9,'position',[300,20,150,30],'ForegroundColor','red');
          
        %% 
        
        




end