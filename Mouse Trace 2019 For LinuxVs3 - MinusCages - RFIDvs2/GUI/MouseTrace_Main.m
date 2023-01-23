function MouseTrace_Main(Path_File,NumberMovie,SegmentationCheckBox,RFIDCheckBox,varagin)

 global GuiParameters
% %%Remember the root folder could be anything
global Directory_Data
global version
global root_folder
%% This GUI enter Parameters as:
current_folder=cd;
%recover the root
root_folder=current_folder(1:length(current_folder)-3)
%% 
Directory_Data=Path_File;

%% Add path

addpath(genpath([root_folder]))
addpath(genpath([root_folder,'InitialParameters/']))
addpath(genpath([root_folder,'MouseSegmentation/']))
addpath(genpath([root_folder,'ReadTimeStamp/']))
addpath(genpath([root_folder,'RFIDIntegration/']))
addpath(genpath([root_folder,'GUI/AuxiliaryFunctions/']))

%% Read the gui parameters
version='vs. 1 2017-11-01'; %add version as global parameter
IndexAux=strfind(Path_File,'/');
GuiParameters=load(fullfile(Path_File(1:IndexAux(length(IndexAux)-1)),'Parameters','GUIParameters'));

% Read varagin
if nargin>4
   if size(varagin)==1
       NumberRFIDFolder=varagin; 
   end
else 
    NumberRFIDFolder=0;
end   

ManagerMouseTrace(NumberMovie,SegmentationCheckBox,RFIDCheckBox,NumberRFIDFolder);

     
%          uicontrol(h.FigVideoChild,'Style','text','String','1- Open the Folder with RFID and Video data- for one day','FontSize',12,'position',[60,850,500,30],'ForegroundColor','red','FontWeight','bold');
%    
%         uicontrol(h.FigVideoChild,'Style', 'pushbutton','units','pixels',.....
%         'tag','Directory',...
%         'callback',@LoadFolder,'cdata',Image2,...
%        'position',[60,800,40,60]);
%         
%          h.editLoadDirectoryChild1=uicontrol(h.FigVideoChild,'Style','edit','String',' ','position',[150,820,400,30]);  
%      
%         %% 
%          uicontrol(h.FigVideoChild,'Style','text','String','2- Look at your video','FontSize',12,'position',[60,770,400,30],'ForegroundColor','red','FontWeight','bold');
%    
%           h.editLoadDirectoryChild1=uicontrol(h.FigVideoChild,'Style','edit','String',' ','position',[150,820,400,30]);  
%         
%    
%    
% %% -------- Set the path movie ------
% 
%         Dir_handles=uicontrol(h.FigVideoChild,'Style', 'pushbutton','units','pixels',.....
%         'tag','Directory',...
%         'callback',@LoadDataForReference,'cdata',Image2,...
%        'position',[100,30,40,60]);
%     
%         uicontrol(h.FigVideoChild,'Style', 'text','units','pixels',.....
%        'string','Open the video',...
%        'position',[40,5,150,30],'FontSize',9,'ForegroundColor','blue');
% 
%        h.editLoadDirectoryChild=uicontrol(h.FigVideoChild,'Style','edit','String',' ','position',[150,50,400,30]);      
%         
%        %% ---------------Add box for the number of frame-------------------------
%         uicontrol(h.FigVideoChild,'Style','text','String','Number of Frame','FontSize',9,'position',[680,70,100,30],'ForegroundColor','blue');
%         h.editNumFrames=uicontrol(h.FigVideoChild,'Style','edit','String',' ','position',[700,50,60,30]);
%         
%           %% ----------------------------------- Create pushbutton to open a word document which explains the gui -----------------------------------------------
%             uicontrol(h.FigVideoChild,'Style', 'pushbutton','String', '','position',[1600,830,40,60],'FontSize',9,'ForegroundColor','blue','callback',@OpenWordDocument,'cdata',Image6)   
%                
%    
%    %%         %% ------------------------- Add run button ------------------
%          uicontrol(h.FigVideoChild,'Style', 'pushbutton','String', '','position',[1600,50,40,60],'FontSize',9,'ForegroundColor','blue','callback',@ManagerMouseTrace,'cdata',Image3)
%          %   uicontrol(h.FigVideoChild,'Style', 'pushbutton','String', '','position',[500,50,40,60],'FontSize',9,'ForegroundColor','blue','callback',@ManagerMouseTrace,'cdata',Image3)
%          %% Create panel for axes
%          h.hp = uipanel('Parent',h.FigVideoChild,...
%              'BackgroundColor','white',...
%              'Position',[0.50 0.1800 0.30 0.03],'Title','Reading Time Stamp','FontSize',10,'Foreground','blue');
%          
%          %% Create a wait bar in the main gui
%       h.WaitBar=axes('Parent',h.hp,'Position',[0.00001 0.00900 1 0.8])
%        %% 
%        h.WaitBar.XAxis.Visible = 'on';
%        h.WaitBar.YAxis.Visible = 'off';
%        h.WaitBar.Box='off';
%        h.WaitBar.LineWidth=1;
%        h.WaitBar.Color='w';
%        set(h.WaitBar,'xtick',[])
%        set(h.WaitBar,'xticklabel',[])
%        
%        %% Add for segmentation
%          %% Create panel for axes
%          h.hpS = uipanel('Parent',h.FigVideoChild,...
%              'BackgroundColor','white',...
%              'Position',[0.50 0.140 0.30 0.03],'Title','Segmentation','FontSize',10,'Foreground','blue');
%          
%          %% Create a wait bar in the main gui
%       h.WaitBarS=axes('Parent',h.hpS,'Position',[0.00001 0.00900 1 0.8])
%        %% 
%        h.WaitBarS.XAxis.Visible = 'on';
%        h.WaitBarS.YAxis.Visible = 'off';
%        h.WaitBarS.Box='off';
%        h.WaitBarS.LineWidth=1;
%        h.WaitBarS.Color='w';
%        set(h.WaitBarS,'xtick',[])
%        set(h.WaitBarS,'xticklabel',[])
%        
%          %% Add for saving
%          %% Create panel for axes
%          h.hpSave = uipanel('Parent',h.FigVideoChild,...
%              'BackgroundColor','white',...
%              'Position',[0.50 0.10 0.30 0.03],'Title','Saving each movie within a given interval','FontSize',10,'Foreground','blue');
%          
%          %% Create a wait bar in the main gui
%       h.WaitBarSave=axes('Parent',h.hpSave,'Position',[0.00001 0.00900 1 0.8])
%        %% 
%        h.WaitBarSave.XAxis.Visible = 'on';
%        h.WaitBarSave.YAxis.Visible = 'off';
%        h.WaitBarSave.Box='off';
%        h.WaitBarSave.LineWidth=1;
%        h.WaitBarSave.Color='w';
%        set(h.WaitBarSave,'xtick',[])
%        set(h.WaitBarSave,'xticklabel',[])
%        
%        %% Add bar for RFIs
%        
%          h.hpRFID = uipanel('Parent',h.FigVideoChild,...
%              'BackgroundColor','white',...
%              'Position',[0.50 0.050 0.30 0.03],'Title','Add RFID','FontSize',10,'Foreground','blue');
%          
%          %% Create a wait bar in the main gui
%       h.WaitBarRFID=axes('Parent',h.hpRFID,'Position',[0.00001 0.00900 1 0.8])
%        %% 
%        h.WaitBarRFID.XAxis.Visible = 'on';
%        h.WaitBarRFID.YAxis.Visible = 'off';
%        h.WaitBarRFID.Box='off';
%        h.WaitBarRFID.LineWidth=1;
%        h.WaitBarRFID.Color='w';
%        set(h.WaitBarRFID,'xtick',[])
%        set(h.WaitBarRFID,'xticklabel',[])
%        
%        %% 
%         %% Add bar for RFIs saving
%        
%          h.hpRFIDS = uipanel('Parent',h.FigVideoChild,...
%              'BackgroundColor','white',...
%              'Position',[0.50 0.010 0.30 0.03],'Title','Saving after RFID','FontSize',10,'Foreground','blue');
%          
%          %% Create a wait bar in the main gui
%       h.WaitBarRFIDS=axes('Parent',h.hpRFIDS,'Position',[0.00001 0.00900 1 0.8])
%        %% 
%        h.WaitBarRFIDS.XAxis.Visible = 'on';
%        h.WaitBarRFIDS.YAxis.Visible = 'off';
%        h.WaitBarRFIDS.Box='off';
%        h.WaitBarRFIDS.LineWidth=1;
%        h.WaitBarRFIDS.Color='w';
%        set(h.WaitBarRFIDS,'xtick',[])
%        set(h.WaitBarRFIDS,'xticklabel',[])
%        
%        
%        %% ----------------------------------- Insert droplist to choice the experiments---------------------------
%          uicontrol(h.FigVideoChild,'Style','text','String','3- Select all/one movie for analysis','FontSize',12,'position',[750,850,400,30],'ForegroundColor','red','FontWeight','bold');
%           h.popupExp = uicontrol('Style', 'popup',...
%                    'String', {'','','','','','',''},...
%                    'Position', [850,700,200,150]);
%        
%                %% ----------------------------------------------------Check box with a pushbutton for segmentation--------------------------------------------
%                 uicontrol(h.FigVideoChild,'Style','text','String','4- Select working mode','FontSize',12,'position',[750,780,400,30],'ForegroundColor','red','FontWeight','bold');
%                % Create  checkboxes
%                 h.c(1) = uicontrol(h.FigVideoChild,'style','checkbox','units','pixels',...
%                 'position',[850,770,150,15],'String','Segmentation','Value',1,'FontSize',10,'Foreground','blue');
%                %Create segmentation 
%             
%             uicontrol(h.FigVideoChild,'style','pushbutton','units','pixels',...
%                'position',[950,770,100,20],'String','Settings','Value',1,'FontSize',10,'Foreground','blue','callback',@SegmentationSettings_GUI);
%             
%              
%             
%                 h.c(2) = uicontrol(h.FigVideoChild,'style','checkbox','units','pixels',...
%                 'position',[850,740,200,15],'String','Add RFID after segmentation','FontSize',10,'Foreground','blue');  
%                
%             %% --------------------------------------Select experiment name-------------------------------------
%                uicontrol(h.FigVideoChild,'Style','text','String','5- Select experiment name','FontSize',12,'position',[1100,780,400,30],'ForegroundColor','red','FontWeight','bold');
%                 h.ExperimentName=uicontrol(h.FigVideoChild,'Style','edit','String','Exp53L','position',[1200,750,80,30]);  
%                 
%                 %% ---------------------------------Select if you prefer the first frame of the first moving in general the first day------------
%                 uicontrol(h.FigVideoChild,'Style','text','String','6- Select the starting frame','FontSize',12,'position',[1400,780,400,30],'ForegroundColor','red','FontWeight','bold');
%                % Create  checkboxes
%                 h.c(3) = uicontrol(h.FigVideoChild,'style','checkbox','units','pixels',...
%                 'position',[1480,770,200,15],'String','Select # of frame mainly for first day','Value',0,'FontSize',10,'Foreground','blue');
%                 h.StartingTime=uicontrol(h.FigVideoChild,'Style','edit','String','1','position',[1500,730,80,30]); 
%        
%                %% ----------------------------Add a panel to add the identities of the mice----------------------------
%   % Create a panel which includes the table of ID and also the coordinates
%   
%       h.PanelParameters = uipanel('Parent',h.FigVideoChild,...
%              'BackgroundColor','white',...
%              'units','pixels','Position',[900 200 800 500],'Title','7- Set Parameters for each experiment - FILL THE DATA ONLY FIRST TIME','FontSize',12,'Foreground','blue','ForegroundColor','red','FontWeight','bold');
%   
%   
%   
%        %% Create uiTable to enter mouse id
% % Create the column and row names in cell arrays 
% 
% cnames = {'Chip 1-Head','Chip 2-Ribs','Chip3-Ribs','Sex','Genotype','Idah' };
% rnames = {'Mouse 1','Mouse 2','Mouse 3','Mouse 4','Mouse 5','Mouse 6','Mouse 7','Mouse 8','Mouse 9'};
% % ChipsID=headerAll';
% 
% ChipsID=[];
% handles.data=cell(9,6); 
% handles.data={[] [] [] [] [] [];[] [] [] [] [] []; [] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] []}
% 
% t= uitable(h.PanelParameters, 'ColumnName',cnames,'RowName',rnames,'ColumnWidth',{130},'Data',handles.data,'ColumnFormat',{ChipsID ChipsID ChipsID  {'male' 'female' ' '} {'Wild type' 'knock-out' 'intruder' 'others' ' '} {'Wild mouse' 'Lab. mouse' ' '}},'ColumnEditable', [true true true true true true],'HandleVisibility','callback','Position',[10 90 780 300],'FontSize',14)
%  
% h.table=t;
% 
% %% Set arena coordinates
% %% Add panel to corroborate coordinates
% h.Coordinates=uipanel('Parent',h.PanelParameters,'Title',' Arena coordinates in pixels','FontSize',9,'ForegroundColor','magenta','Position',[0.01 0.85 0.95 0.13]);
% % uicontrol(h.Coordinates,'Style', 'pushbutton', 'String','Corroborate the arenas coordinates','position',[10,10,200,30],'foreground','red','callback',@CorroborateArenaCoord);
% % 
% % % -----------Add popup menu--------------------
% 
% h.popup6=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Left','Right'},'position',[20,1,70,25],'foreground','blue');
% uicontrol(h.Coordinates,'Style','text','String','Arena','position',[20,30,50,15]); 
% 
% h.popup1=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Set Default','Change'},'position',[110,1,70,25],'foreground','blue');
% uicontrol(h.Coordinates,'Style','text','String','Corners ','position',[110,30,50,15]); 
% 
% h.popup2=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Set Default','Change'},'position',[190,1,70,25],'foreground','blue');
% uicontrol(h.Coordinates,'Style','text','String','Eating','position',[190,30,50,15]); 
% 
% h.popup3=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Set Default','Change'},'position',[270,1,70,25],'foreground','blue');
% uicontrol(h.Coordinates,'Style','text','String','Drink loc.','position',[270,30,50,15]); 
% 
% uicontrol(h.Coordinates,'Style', 'pushbutton', 'String',' ','position',[700,5,40,30],'foreground','blue','callback',@ReadPopup,'cdata',Image5);
% 
% h.popup4=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Set Default','Change',},'position',[344,1,70,25],'foreground','blue');
% uicontrol(h.Coordinates,'Style','text','String','Bridge L.','position',[344,30,50,15]); 
% 
% h.popup5=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Set Default','Change'},'position',[415,1,70,25],'foreground','blue');
% uicontrol(h.Coordinates,'Style','text','String','Bridge N.','position',[415,30,50,15]); 
% 
% 
% h.popup7=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Set Default','Change'},'position',[500,1,70,25],'foreground','blue');
% uicontrol(h.Coordinates,'Style','text','String','Hiding Boxes','position',[500,30,80,15]); 
% 
% h.popup8=uicontrol(h.Coordinates,'Style', 'popup', 'String',{'Set Default','Change'},'position',[600,1,70,25],'foreground','blue');
% uicontrol(h.Coordinates,'Style','text','String','Out of Zone','position',[600,30,80,15]); 
% 
% %% For loading the parameters
% 
%         uicontrol(h.PanelParameters,'Style', 'pushbutton','units','pixels',.....
%         'tag','Directory',...
%         'callback',@LoadParameters,'cdata',Image2,...
%        'position',[29,30,40,60]);
%         
%       uicontrol(h.PanelParameters,'Style','text','String','Load Parameters','FontSize',9,'position',[13,10,110,20],'ForegroundColor','blue');
%    
%   %For saving the parameters    
% 
%   
%         uicontrol(h.PanelParameters,'Style', 'pushbutton','units','pixels',.....
%         'tag','Directory',...
%         'callback',@SaveTableInExcel,'cdata',Image10,...
%        'position',[500,20,40,60]);
%         
%       uicontrol(h.PanelParameters,'Style','text','String','Save Parameters','FontSize',9,'position',[480,10,110,20],'ForegroundColor','blue');
%   
%       %% For saving all the parameters for the gui into matfile
%     uicontrol(h.FigVideoChild,'Style', 'pushbutton','String', '','position',[1700,50,40,60],'FontSize',9,'ForegroundColor','blue','callback',@SaveParametersForLinuxUse,'cdata',Image10) 
%       
%       uicontrol(h.FigVideoChild,'Style','text','String','Save GUI parameters for linux','FontSize',9,'position',[1670,5,120,60],'ForegroundColor','blue');
%   
%   
% %% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end  
       