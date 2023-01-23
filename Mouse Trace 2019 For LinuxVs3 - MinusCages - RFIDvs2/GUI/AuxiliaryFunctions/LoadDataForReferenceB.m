 function LoadDataForReferenceB(~,~)
 
  global h
  global v
  global numFrames
  
  [FileName,PathName]=uigetfile('*.avi','Open the file with the Video for selecting a reference frame');

  set(h.editLoadDirectoryChildB,'string', fullfile(PathName,FileName));
  
  %% ------------------- In addition add the video -----------------------
  
  v=VideoReader(fullfile(PathName,FileName));
   numFrames = v.NumberOfFrames;

  
  FirstFrame=read(v,1);
  
  image(FirstFrame,'Parent', h.hAxis);
 
   %% 
        %-------------------------------------Add a slider to the-------
            sliderMin = 1;
             sliderMax = numFrames; % this is variable
             sliderStep = [1/(numFrames-1), 0.1]; % major and minor steps of 1
       
        h.sliderChild=uicontrol(h.SetBackground,'Style', 'slider',.....
       'position',[90,120,720,20],'FontSize',9,'ForegroundColor','blue','Min',1,'Max', numFrames,'Value',1,'SliderStep', sliderStep,'callback',@MoveFramesB);
          
        %% ---------------------Set the number of frame-----------------
        
        set(h.editNumFramesB,'string',num2str(1));
        

  end  
  
  
  

