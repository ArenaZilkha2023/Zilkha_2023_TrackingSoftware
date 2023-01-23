function SegmentationSettings_GUI(~,~)
% Create a new gui

% Create new figure
       
           
               h.FigSegmentation = figure('numbertitle', 'off', ...
               'name', 'Segmentation Settings', ...
               'menubar','none', ...
               'toolbar','none', ...
               'resize', 'on', ...
               'renderer','painters', ...
               'position',[50 80 200 300]);

 %% ----------------------------------- Create pushbutton for each settings -----------------------------------------------
            uicontrol(h.FigSegmentation,'Style', 'pushbutton','String', 'Set Background','position',[20,230,100,30],'FontSize',9,'ForegroundColor','blue','callback',@SetBackgroundGUI)   
               
             uicontrol(h.FigSegmentation,'Style', 'pushbutton','String', 'Set Threshold','position',[20,150,100,30],'FontSize',9,'ForegroundColor','blue','callback',@SetThresholdGUI)   


end