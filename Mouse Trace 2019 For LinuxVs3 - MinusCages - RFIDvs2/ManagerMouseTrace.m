function ManagerMouseTrace(NumberMovie,SegmentationCheckBox,RFIDCheckBox,NumberRFIDFolder)
%Manager of the mouse Trace
%Doing analysis for one day
global Directory_Data
global version
global root_folder
global UpperCage
global DownCage
global First_HidingCoordinates
global Second_HidingCoordinates
global Third_HidingCoordinates
global Four_HidingCoordinates

global Corn



%% %%%%%%%%%%%%%%%%%%% Read initial parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Initial_Parameters=Parameters();
%global h
%% Read the names of the file movies

Movies_file=dir(fullfile(Initial_Parameters.DataDirectory,'*.avi'));

%Frame Rate
FrameRate=Initial_Parameters.FrameRate;

%Decide if to analysis all the movies or only par
MoviesToConsider= Initial_Parameters.MoviesToConsider; %information from the gui
%Range=FindRangeReadMovies(MoviesToConsider,Movies_file); %number of movie to be analyzed
Range=NumberMovie;
% Create names for the temporal movies
Iformovie=strfind(Initial_Parameters.DataDirectory,'/');
temp1=strcat('temp1',Initial_Parameters.DataDirectory(Iformovie(length(Iformovie))+1:end),'.avi'); %distinguish between left and right
temp2=strcat('temp2',Initial_Parameters.DataDirectory(Iformovie(length(Iformovie))+1:end),'.avi');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
DateExpI=strfind(Initial_Parameters.DataDirectory,'/');
DateDay=dir(Initial_Parameters.DataDirectory(1:DateExpI(length(DateExpI))));
Initial_Parameters.SegmentationCheckBox=SegmentationCheckBox;
Initial_Parameters.RFIDCheckBox=RFIDCheckBox;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sort the days to begin with the correct day
DateDayAux1={DateDay(3:end).name}';
DateDayAux2=datetime(DateDayAux1,'InputFormat','dd.MM.yyyy')
x=(1:size(DateDayAux2,1))';
t=table(DateDayAux2,x);
[t,indext]=sortrows(t,'DateDayAux2');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Begin reading time stamp and segmentation%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Initial_Parameters.SegmentationCheckBox==1
%% ------------------------1)- find the contour of the arena by using the background -----------------------------------------
    [PixelsArenaContour]=ThresholdingBackgroundFrame(Initial_Parameters.BackgroundImage);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---------------------------Treat movies-----------------------

        %% Loop over each movie
      for countMovie=Range
             %for countMovie=3
      %% %%%%%%%%%%%%%%%% Initialization and parameters %%%%%%%%%%%%%%%%%%%%%%%%
          v = VideoReader(fullfile(Initial_Parameters.DataDirectory,Movies_file(countMovie).name));%Load /read movie
          numFrames= ceil(FrameRate*v.Duration);%it is approximate
          % add information of the camera
          if ~isempty(strfind(Movies_file(countMovie).name,'Camera-2'))
              Side='L';
          else
              Side='R';
          end
          
          % Create object to write the cutted video and the cutted video with segmentation
          Iletter=strfind(Directory_Data,'/');
          mkdir(strcat(Directory_Data(1:Iletter(length(Iletter)-1)),'Temporary'));
          temp1=strcat(num2str(countMovie),Side,temp1);
          temp1=strcat(strcat(Directory_Data(1:Iletter(length(Iletter)-1)),'Temporary'),'/',temp1);
           writer1=VideoWriter(temp1);
           writer1.FrameRate = FrameRate;
           
           temp2=strcat(num2str(countMovie),Side,temp2);
           temp2=strcat(strcat(Directory_Data(1:Iletter(length(Iletter)-1)),'Temporary'),'/',temp2);
           writer2=VideoWriter(temp2);
           writer2.FrameRate = FrameRate;
                 
           open(writer1);
           open(writer2);
                
         % When to begin if  with the first or later frames- the first frames are using to input the mice
         %then begin later the movies only for first movie
             if countMovie==1
                 if ~isempty(strfind(Movies_file(1).name,DateDay(indext(1)+2).name)) %first movie
                    if   Initial_Parameters.StartingTimeCheckBox==1          %the checkbox is on
                       v.CurrentTime=str2num(Initial_Parameters.StartingTime)/FrameRate; %starting time in seconds
                    end
                 end 
             end
                
         % Initialize variables for segmentation
               clear Locomotion
                Coordinates=[];
                NumberOfFrame=[];
                CoordinatesR=[];
                NumberOfFrameR=[]; 
                SegmentationData=[];
                SegmentationDataR=[];
                MajorAxisLength=[];
                MinorAxisLength=[];
                areaTotal=[];
                BoundingBoxCoord=[];
                MousePixelsCoord=[];
                Orientation=[];
                RepetitionCoord=[];
                MarkCluster=[];
                 MarkClusterR=[];
                TimeExp={};
                
         % Define variables
                countFrame=1;
                clear mov;
                Origin=1;
                CountWaitBar=1;
                
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3- Looping over each frame- Read the time stamp - and do segmentation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                 
               while hasFrame(v) %the first slide is without time -we don't consider
                     clear Iaux
        %%%%%%%%%%%%%%%%%%%%%%%%%%     Begin Analysis of one Frame %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        
                     if countFrame==1
                                    s(countFrame).cdata=readFrame(v,'native');
                                    Iaux=s(countFrame).cdata;
                
                     else
                                    s(countFrame).cdata=readFrame(v,'native');
                                    Iaux=s(countFrame).cdata;
              %% Get time stamp for the movie and create a movie with an adequate fps
              % similar to the real one-ADD A CONTROL OF THE TIME
                                    
                                  %  set( h.WaitBar,'Position',[0.00001 0.00900 (CountWaitBar/numFrames) 0.8]);
                                   % h.WaitBar.Color='m';
                                    %pause(0.01) %wait bar for time stamp
                                 
                                    ExpTime=ManagerReadTimeStamp(Iaux,Initial_Parameters.CropTimeStamp,Initial_Parameters.FontsFile);
                                    TimeExp(countFrame-1,1)={ExpTime};
                                    
          %% %% %%%%%%%%%%%%%%%%%%%%%%%%    Cut the movie  where is  bridge of time          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                   if countFrame~=2
                      ElapseTime=MeasureTimeDifference(TimeExp(countFrame-1,1), TimeExp(countFrame-2,1));
                      TotalElapseTime=MeasureTimeDifference(TimeExp(countFrame-1,1), TimeExp(Origin,1));
                       if (ElapseTime>600) | (TotalElapseTime > 3600) %if the time is larger than 10 min then save all the information in the respective folder or the total time is larger than 1 hour
                          %  Save in a structure important variables and movies
                           clear Locomotion
                            %set( h.WaitBarSave,'Position',[0.00001 0.00900 (CountWaitBar/numFrames) 0.8]);
                             %       h.WaitBarSave.Color='g';
                              %      pause(0.01) %control bar of saving
                            %Save Parameters
                            Locomotion.ExperimentTime=TimeExp(Origin:countFrame-2,:);
                            DateExp=FindDate(Movies_file(countMovie).name);
                            DateExp=repmat(DateExp,size(TimeExp(Origin:countFrame-2,:)));
                            Locomotion.ExperimentDate=DateExp;
                            Locomotion.Coordinates=SegmentationData;%Save coordinates
                            Locomotion.CoordinatesWithRepeats=SegmentationDataR;
                            Locomotion.SegmentationDetails.MajorAxisLength=MajorAxisLength; %save other segmentation parameters
                            Locomotion.SegmentationDetails.MinorAxisLength=MinorAxisLength;
                            Locomotion.SegmentationDetails.areaTotal=areaTotal;
                            Locomotion.SegmentationDetails.BoundingBoxCoord=BoundingBoxCoord;
                            Locomotion.SegmentationDetails.MousePixelsCoord=MousePixelsCoord;
                            
                            Locomotion.SegmentationDetails.Orientation=Orientation;
                            Locomotion.SegmentationDetails.RepetitionCoord=RepetitionCoord;
                            Locomotion.SegmentationDetails.MarkCluster=MarkCluster;
                            Locomotion.SegmentationDetails.MarkClusterR=MarkClusterR;
                            
                            close(writer1);
                            close(writer2);
                            SaveMovie_Parameters(Initial_Parameters.DataDirectory,Locomotion,Movies_file(countMovie).name,TimeExp(Origin,1),TimeExp(countFrame-2,1),FrameRate,temp1,temp2);
                                              
                    % CLear variables once it is saved the counter return to the beggining
                          countFrame=2;
                          Origin=1;
                          clear Locomotion;
                          clear TimeExp;
                          clear DateExp;
                          clear SegmentationData;
                          clear MajorAxisLength;
                          clear MinorAxisLength;
                          clear areaTotal;
                          clear BoundingBoxCoord;
                          clear MousePixelsCoord;
                          clear Orientation;
                          clear RepetitionCoord;
                          clear SegmentationDataR;
                          clear NumberOfFrame;
                          clear NumberOfFrameR;
                          TimeExp(1,1)={ExpTime};
                          
                    % Initialize variables for segmentation
                         Coordinates=[];
                        NumberOfFrame=[];
                        CoordinatesR=[];
                        NumberOfFrameR=[]; 
                       SegmentationData=[];
                       SegmentationDataR=[];
                       MajorAxisLength=[];
                       MinorAxisLength=[];
                       areaTotal=[];
                       BoundingBoxCoord=[];
                       MousePixelsCoord=[];
                       Orientation=[];
                       RepetitionCoord=[];
                       MarkCluster=[];
                       MarkClusterR=[];

                     % Open again the videos for writing
                          open(writer1);
                          open(writer2);  
                       end
                   end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Finish cutting process      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                    
                                  
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get segmentation for each frame %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
                   % set( h.WaitBarS,'Position',[0.00001 0.00900 (CountWaitBar/numFrames) 0.8]);
                    %     h.WaitBarS.Color='b';
                     %     pause(0.01) % control bar of segmentation
                     [IndicationClusterWithRepeats,IndicationClusterWithoutRepeats,CoordinatesPixelR,CoordinatesPixel,Frame,MajorAxisLengthAll,OrientationTotal,RepetitionAll,...
    MinorAxisLengthAll,areaTotalAll,BoundingBoxAll,...
    MousePixels]=ManagerSegmentation(Iaux,Initial_Parameters.BackgroundImage,PixelsArenaContour,Initial_Parameters.AreaToFilter,...
                                                      Initial_Parameters.MajorAxis,Initial_Parameters.LimitArea1To2,Initial_Parameters.LimitArea2To3,...
                                                      Initial_Parameters.CheckboxAdditionalBack,Initial_Parameters.CheckboxAdditionalCirc,Initial_Parameters.CheckboxAdditionalArea,...
                                                      Initial_Parameters.BackgroundFactor,Initial_Parameters.Circularity,Initial_Parameters.Area,Initial_Parameters.CheckboxContourArena) ;    
                                                  
                   NumberOfFrame= repmat(countFrame,size(CoordinatesPixel,1),1);
                   SegmentationData=[SegmentationData;[NumberOfFrame,CoordinatesPixel]];
                   MajorAxisLength=[MajorAxisLength;[NumberOfFrame,MajorAxisLengthAll]];  
                   Orientation=[Orientation;[NumberOfFrame,OrientationTotal]];
                   RepetitionCoord=[RepetitionCoord;[NumberOfFrame,RepetitionAll]];
                   NumberOfFrameR=repmat(countFrame,size(CoordinatesPixelR,1),1);
                   SegmentationDataR=[SegmentationDataR;[NumberOfFrameR,CoordinatesPixelR]];
                   MarkCluster=[MarkCluster;[NumberOfFrame,IndicationClusterWithoutRepeats]];
                   MarkClusterR=[MarkClusterR;[NumberOfFrameR,IndicationClusterWithRepeats]];
                   
                   MinorAxisLength=[MinorAxisLength;[NumberOfFrame,MinorAxisLengthAll]];
                   areaTotal=[areaTotal;[NumberOfFrame,areaTotalAll]];
                   BoundingBoxCoord=[BoundingBoxCoord;[NumberOfFrame,BoundingBoxAll]];
                   MousePixelsCoord=[MousePixelsCoord;[num2cell(NumberOfFrame),MousePixels]];               
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Finish segmentation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                       
                                  %% ---------------------Create a movie save each time a different frame--------------                                 
                                 writeVideo(writer1,im2frame(s(countFrame).cdata));
                                 writeVideo(writer2,im2frame(Frame));
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        
                     end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Finish analysis of one frame %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
                     
                     
                        countFrame=countFrame+1
                        CountWaitBar=CountWaitBar+1; %for the wait bar
                 end
                 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Finish for a given movie      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
                 
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Save the data remain        
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
      % Not consider information which last less than 9.59 minutes- that is
      % the taill of the movie
       ElapseTime=MeasureTimeDifference(TimeExp(end,1), TimeExp(Origin,1));
                 %% Save in a structure important variables
                 %Save experimental time
               if  ElapseTime >= 599 % 9 minutes and 59 seconds
                  Locomotion.ExperimentTime=TimeExp(Origin:end);
                  DateExp=FindDate(Movies_file(countMovie).name);
                  DateExp=repmat(DateExp,size(TimeExp(Origin:end)));
                  Locomotion.ExperimentDate=DateExp;
                  Locomotion.Coordinates=SegmentationData;
                  Locomotion.CoordinatesWithRepeats=SegmentationDataR; %Save coordinates with repetitions 
                  Locomotion.SegmentationDetails.MajorAxisLength=MajorAxisLength;
                  Locomotion.SegmentationDetails.MinorAxisLength=MinorAxisLength;
                  Locomotion.SegmentationDetails.areaTotal=areaTotal;
                  Locomotion.SegmentationDetails.BoundingBoxCoord=BoundingBoxCoord;
                  Locomotion.SegmentationDetails.MousePixelsCoord=MousePixelsCoord;
                  
                  Locomotion.SegmentationDetails.Orientation=Orientation;
                  Locomotion.SegmentationDetails.RepetitionCoord=RepetitionCoord;
                  Locomotion.SegmentationDetails.MarkCluster=MarkCluster;
                  Locomotion.SegmentationDetails.MarkClusterR=MarkClusterR;
                  close(writer1);
                  close(writer2);
                 % Save the movie without segmentation and the data
                   [NameToSaveD,NameToSave]=Rename_Save_Directory(Movies_file(countMovie).name,TimeExp(1,1),TimeExp(size(TimeExp,1),1));
                    A=strcat(Initial_Parameters.DataDirectory,'/',NameToSaveD)
                    mkdir(char(A));
                    B=strcat(Initial_Parameters.DataDirectory,'/',NameToSaveD,'/',NameToSaveD,'.avi');
                    D=strcat(Initial_Parameters.DataDirectory,'/',NameToSaveD,'/',NameToSaveD,'WithSegmentation.avi');
                    C=strcat(Initial_Parameters.DataDirectory,'/',NameToSaveD,'/',NameToSaveD,'.mat');
                    movefile(temp1,char(B));
                    movefile(temp2,char(D));
                    save(char(C),'Locomotion');
               else
                   delete(temp1,temp2);
             end    
        end
        %%%%%%%%%%%%%%%%%%%%%% Finish all movies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Finish reading time stamp and segmentation%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
 %%       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Add RFID according to a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%checkbox%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif Initial_Parameters.RFIDCheckBox==1
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Loop over each folder%%%%%%%%%%
    %% %%%%%%%%%%%%%%% Read the directories inside the given folder %%%%%%%%%%%%%%%%%%%%%%%%%%
         List_Directories= dir(Initial_Parameters.DataDirectory);
         List_Directories= List_Directories([List_Directories.isdir]);
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Read the initial parameters about mice information and coordinates the same for every file--And also read the date%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       IndexAux=strfind(Initial_Parameters.DataDirectory,'/');
       Date=Initial_Parameters.DataDirectory(IndexAux(end)+1:end);
       Date=strrep(Date,'.','/');
       sheet=char(Initial_Parameters.ExperimentName);
       % %%%%%%%%%%%%%%%%%%%%%% Read the mice list%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       [num,txt,raw]=xlsread(strrep(Initial_Parameters.DataDirectory(1:IndexAux(end)),'RawData/',strcat(Initial_Parameters.ExperimentName,'/Parameters/','MiceID.xlsx')),sheet);% Read the excel sheet
        miceList=raw(2:end,2);
        miceList=strrep(miceList,'''',''); %for removing double quotes
        miceList=miceList(~strcmp(miceList,'')); %remove empty places
        % chip on the ribs
        miceListRibs=raw(2:end,3);
        miceListRibs=strrep(miceListRibs,'''','');
        miceListRibs=miceListRibs(~strcmp(miceListRibs,''));
       %in the case of a third chip
        miceListRibsSide=raw(2:end,4);
        miceListRibsSide=strrep(miceListRibsSide,'''','');
        miceListRibsSide=miceListRibsSide(~strcmp(miceListRibsSide,''));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Add The corners of the arena%%%%%%%%%%%%%%
        load(strrep(Initial_Parameters.DataDirectory(1:IndexAux(end)),'RawData/',strcat(Initial_Parameters.ExperimentName,'/Parameters/','MovingParametersInArena.mat')),'Corners_PixelCoordinates');% load mat files with the parameters
        Corn=Corners_PixelCoordinates;
           % When there are cages
         load(strrep(Initial_Parameters.DataDirectory(1:IndexAux(end)),'RawData/',strcat(Initial_Parameters.ExperimentName,'/Parameters/','MovingParametersInArena.mat')),'UpperCage_PixelCoordinates');% load mat files with the parameters
        UpperCage=UpperCage_PixelCoordinates; %coord of upper cage
        load(strrep(Initial_Parameters.DataDirectory(1:IndexAux(end)),'RawData/',strcat(Initial_Parameters.ExperimentName,'/Parameters/','MovingParametersInArena.mat')),'DownCage_PixelCoordinates');% load mat files with the parameters
        DownCage=DownCage_PixelCoordinates; %coord of down cage
        % Load hiding boxes
         load(strrep(Initial_Parameters.DataDirectory(1:IndexAux(end)),'RawData/',strcat(Initial_Parameters.ExperimentName,'/Parameters/','MovingParametersInArena.mat')),'First_HidingCoordinates',...
              'Second_HidingCoordinates','Third_HidingCoordinates','Four_HidingCoordinates');
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    %% %%%%%%%%%%%%%%%% Loop over each folder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for countD=2+NumberRFIDFolder
 %for countD=3:length(List_Directories) %at the beggining aren't files
 %for countD=6:length(List_Directories)
 % for countD=14
       
       
     %for countD=length(List_Directories)
   
     %%%%%%%%%%%%%%%%Load matlab files from the segmentation%%%%%%%%%
       MatFile=dir(fullfile(Initial_Parameters.DataDirectory,List_Directories(countD).name,'*.mat'))
       load(fullfile(Initial_Parameters.DataDirectory,List_Directories(countD).name,MatFile.name));
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load avi files and select only the one without segmentation
        AviFileS=dir(fullfile(Initial_Parameters.DataDirectory,List_Directories(countD).name,'*WithSegmentation.avi'));
        AviFile=dir(fullfile(Initial_Parameters.DataDirectory,List_Directories(countD).name,'*.avi'));
        IwithoutS=find(strcmp(AviFile,AviFileS)==0);
        v1=VideoReader(fullfile(Initial_Parameters.DataDirectory,List_Directories(countD).name,AviFile(IwithoutS).name));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
       %% --------------------Save Variables-------------------------
       
       TimeExp=Locomotion.ExperimentTime; 
       Position=Locomotion.CoordinatesWithRepeats; 
       
       %% Create locomotion matrix in order to inverse
%         LocomotionInverse.ExperimentTime=flipud(Locomotion.ExperimentTime);
%         LocomotionInverse.ExperimentDate=flipud(Locomotion.ExperimentDate);
%         LocomotionInverse.Coordinates=flipud(Locomotion.Coordinates);
       %% 
        
  % [AntennaForMiceT,CoordinatesFinalMiceMM,CoordinatesFinalMice,FidelityMatrix,FidelityVelocity,FidelityForNonCoord,IsSleeping,TotalVelocity]=ManagerRFIDCoupling(Corn,TimeExp,Position,miceList,miceListRibs,miceListRibsSide,Initial_Parameters.DataDirectory,Date);
     Locomotion=ManagerRFIDCoupling(Initial_Parameters.DataDirectory,Date,TimeExp,miceList,miceListRibs,miceListRibsSide,Locomotion,Corn);
     Locomotion.AssigRFID.miceList=miceList;
     
%      Locomotion=ManagerRFIDCouplingInverse(Initial_Parameters.DataDirectory,Date,TimeExp,miceList,miceListRibs,miceListRibsSide,Locomotion,Corn);
%      Locomotion.AssigRFIDInverse.miceList=miceList;
     %% Do the inverse 
     
     %save mat data
   
%                load(fullfile(Initial_Parameters.DataDirectory,List_Directories(countD).name,MatFile.name),'Locomotion');
%                
%                 %% Order variables for later saving
%                 Locomotion.ExperimentDate=cellstr(Locomotion.ExperimentDate);
%                 Locomotion.IsSleeping=num2cell(IsSleeping);
%                 Locomotion.TotalVelocity=num2cell(TotalVelocity);
%                 Locomotion.FidelityVelocity=num2cell(FidelityVelocity);
%                  Locomotion.CoordinatesFinalMiceMM=CoordinatesFinalMiceMM;
%                 Locomotion.CoordinatesFinalMicePixel=CoordinatesFinalMice;
%                 Locomotion.AntennaInformation=AntennaForMiceT;
%%  Arrange the coordinates into an interleave
                 XauxC=(Locomotion.AssigRFID.XcoordMM)';
                 YauxC=(Locomotion.AssigRFID.YcoordMM)';
                 CoordinatesFinalMiceMM= reshape([XauxC(:) YauxC(:)]',2*size(XauxC,1), [])'; %all coordinates x and y together
                 
  %% %%%%%%%%%%%%%%%INVERSE- Arrange the coordinates of the inverse running into an interleave
%                   XauxCInverse=(Locomotion.AssigRFIDInverse.XcoordMM)';
%                  YauxCInverse=(Locomotion.AssigRFIDInverse.YcoordMM)';
%                  CoordinatesFinalMiceMMInverse= reshape([XauxCInverse(:) YauxCInverse(:)]',2*size(XauxCInverse,1), [])'; %all coordinates x and y together 
%                  
                 
   %% Save the variables
   
              Matrix_RFID_MM=Arrange_In_Matrix_RFIDData(TimeExp,Locomotion.ExperimentDate,strcat('''',miceList,''''),CoordinatesFinalMiceMM,Locomotion.AssigRFID.VelocityMouse);
               MovieNameRFID=FindNameMovieChange(AviFile(IwithoutS).name);
%              hhaux=msgbox('Wait...........');
            SaveAsCsvCell(strcat(Initial_Parameters.DataDirectory,'/',List_Directories(countD).name,'/',MovieNameRFID,'.csv.csv'),Matrix_RFID_MM);
           AuxMV=num2cell(double(Locomotion.AssigRFID.FinalIndicationVelocityWithoutNonDefined));
            
           SaveAsCsvCell(strcat(Initial_Parameters.DataDirectory,'/',List_Directories(countD).name,'/',MovieNameRFID,'ControlVelocity.csv.csv'),AuxMV);    
%% %%%%%%%%%%%%%%%%%%%%%%%%INVERSE- Save the coordinates from the inverse process
              
%               Matrix_RFID_MMInverse=Arrange_In_Matrix_RFIDData(TimeExp,Locomotion.ExperimentDate,strcat('''',miceList,''''),CoordinatesFinalMiceMMInverse,Locomotion.AssigRFIDInverse.VelocityMouse);
%                MovieNameRFID=FindNameMovieChange(AviFile(IwithoutS).name);
% %              hhaux=msgbox('Wait...........');
%             SaveAsCsvCell(strcat(Initial_Parameters.DataDirectory,'/',List_Directories(countD).name,'/',MovieNameRFID,'.Inversecsv.csv'),Matrix_RFID_MMInverse);
%               




%% 
              
            % dlmwrite(strcat(Initial_Parameters.DataDirectory,'/',List_Directories(countD).name,'/',MovieNameRFID,'.csv'),Matrix_RFID,'delimiter','/t');
              %dlmwrite(strcat(Initial_Parameters.DataDirectory,'/',List_Directories(countD).name,'/',MovieNameRFID,'WithRFIDPixel.csv'),CoordinatesFinalMice,'delimiter','/t');
              %save to mat file again locomotion
             save(fullfile(Initial_Parameters.DataDirectory,List_Directories(countD).name,MatFile.name),'Locomotion');
    
            %close(hhaux); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              
 %% --------------Show the frames---------------------------
 % create writer object for video
  writeRFID=VideoWriter(strcat(Initial_Parameters.DataDirectory,'/',List_Directories(countD).name,'/',MovieNameRFID,'WithRFID.avi'));
  writeRFID.FrameRate = 12.8;
  open(writeRFID)
 
 t=1;
for countFrames=1:size(Locomotion.AssigRFID.XcoordPixel,1)
%for countFrames=1:5000
     % set(  h.WaitBarRFIDS,'Position',[0.00001 0.00900 (countFrames/size(Locomotion.AssigRFID.XcoordPixel,1)) 0.8]);
      %h.WaitBarRFIDS.Color='g';
      %pause(0.01) 
    
     countFrames
     Frame=read(v1,countFrames); %Read each frame of the movie
     C={'red','cyan','green','yellow','magenta','blue','black'};   
     counter=1;
     counter1=1;
    for m=1:length(miceList)
        auxp=[];
        position2=[];
        position=[Locomotion.AssigRFID.XcoordPixel(countFrames,m),Locomotion.AssigRFID.YcoordPixel(countFrames,m),4]; 
        if position(:,1)~=1e6 & Locomotion.AssigRFID.IsSleeping(countFrames,m)==0 & Locomotion.AssigRFID.IsHidingTracking(countFrames,m)==0
           Frame=insertShape(Frame,'FilledCircle',position,'LineWidth',2,'Color',C{m}); 
        end   
        if countFrames >5 & Locomotion.AssigRFID.IsSleeping(countFrames,m)==0 & Locomotion.AssigRFID.IsHidingTracking(countFrames,m)==0 %then add to each mouse 10 frames of trajectory
           %if Locomotion.AssigRFID.XcoordPixel(countFrames-3,m)~=1e6 & Locomotion.AssigRFID.XcoordPixel(countFrames-2,m)~=1e6 & Locomotion.AssigRFID.XcoordPixel(countFrames-1,m)~=1e6 & Locomotion.AssigRFID.XcoordPixel(countFrames,m)~=1e6
            %  if Locomotion.AssigRFID.XcoordPixel(countFrames-3,m)~=0 & Locomotion.AssigRFID.XcoordPixel(countFrames-2,m)~=0 & Locomotion.AssigRFID.XcoordPixel(countFrames-1,m)~=0 & Locomotion.AssigRFID.XcoordPixel(countFrames,m)~=0
              position2=[Locomotion.AssigRFID.XcoordPixel(countFrames-3:countFrames,m),Locomotion.AssigRFID.YcoordPixel(countFrames-3:countFrames,m)];
            if ~isempty(find(position2(:,1)==1e6))
               position2=position2(find(position2(:,1)~=1e6),:);
            end    
            %position2=[CoordinatesFinalMice(1:countFrames,2*m-1),CoordinatesFinalMice(1:countFrames,2*m)];
            auxp=position2';
            position2=reshape(auxp,[1,2*size(auxp,2)]);
            if size(position2,2)>2
               Frame=insertShape(Frame,'Line',position2,'LineWidth',2,'Color',C{m});  
            elseif or(size(position2,2)==1,size(position2,2)==2) 
                position3=[position2,repmat(4,size(position2,1),1)];
                 Frame=insertShape(Frame,'FilledCircle',position3,'LineWidth',2,'Color',C{m}); 
            end
             % end
           %end
            
        end    
        
        if Locomotion.AssigRFID.IsSleeping(countFrames,m)==1
             if counter==1  
                  position1=[Locomotion.AssigRFID.XcoordPixel(countFrames,m),Locomotion.AssigRFID.YcoordPixel(countFrames,m)];
             else
                 position1=[Locomotion.AssigRFID.XcoordPixel(countFrames,m)+(counter-1)*5,Locomotion.AssigRFID.YcoordPixel(countFrames,m)]; %move the marker
             end
                 
                  Frame=insertMarker(Frame,position1,'*','size',6,'Color',C{m}); %add a marker when it is sleeping
                  counter=counter+1;
        end
        
         if Locomotion.AssigRFID.IsHidingTracking(countFrames,m)==1
            if counter1==1  
              position11=[Locomotion.AssigRFID.XcoordPixel(countFrames,m),Locomotion.AssigRFID.YcoordPixel(countFrames,m)]; 
            else
                 position11=[Locomotion.AssigRFID.XcoordPixel(countFrames,m)+(counter1-1)*5,Locomotion.AssigRFID.YcoordPixel(countFrames,m)]; 
            end
              Frame=insertMarker(Frame,position11,'s','size', 6,'Color',C{m}); %add a marker when it is sleeping
              counter1=counter1+1;
        end
        
        %% Add text and name of the mouse on the side
        Frame=insertShape(Frame,'FilledCircle',[20,10+m*40,4],'LineWidth',2,'Color',C{m});
        AuxNameM=miceList{m};
        Frame=insertText(Frame,[35,10+m*40],AuxNameM(4:end));
        
      
  end


     writeVideo(writeRFID,Frame);

 
 
 end
 
 
   w=cd;  %current directory

% 
close( writeRFID)  
              
              
              
              
              
              
    end
end
        
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%End%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ------------------------- Auxiliary function----------------------------------------------

% Create name of save folder and save directary
function   [NameToSaveD,NameToSave]=Rename_Save_Directory(MovieFile,InitialTime,FinalTime)

InitialTime=strrep(InitialTime,'''','');
FinalTime=strrep(FinalTime,'''','');

MovieFile=char(MovieFile);
indexLetter=strfind(MovieFile,'.avi');

InitialTime1=strrep(InitialTime,':','_');
FinalTime1=strrep(FinalTime,':','_');

NameToSaveD=strcat(MovieFile(1:indexLetter-1),'[',InitialTime1,'-',FinalTime1,']');

NameToSave=strcat(MovieFile(1:indexLetter-1),'[',InitialTime,'-',FinalTime,']');

end
%% Find the date

function DateExp=FindDate(MovieName)

Index=strfind(char(MovieName),'-');

DateExp=MovieName(1:Index-1);

DateExp=strrep(DateExp,'.','/');
DateExp=strcat('''',DateExp,'''');

end
%% Time difference between frames

function ElapseTime=MeasureTimeDifference(TimeAfter, TimeBefore)

TimeAfter=RemoveDoubleString(TimeAfter);
TimeBefore=RemoveDoubleString(TimeBefore);

%translate TimeExp to vector

TimeVectorAfter=datevec(TimeAfter,'HH:MM:SS.FFF');
TimeVectorBefore=datevec(TimeBefore,'HH:MM:SS.FFF');

ElapseTime=abs(etime(TimeVectorAfter,TimeVectorBefore));% this is given in second

end
%% Remove double string from the time

function TimeExp=RemoveDoubleString(TimeExp)

    for count=1:size(TimeExp,1)
       TimeExp(count,1)=strrep(TimeExp(count,1),'''','');
    end

end
%% Function to decide reading all the movies or only one movie
function Range=FindRangeReadMovies(MoviesToConsider,Movies_file)

if strcmp(MoviesToConsider,'All') 
    Range=1:size(Movies_file,1); 
else
    for i=1:size(Movies_file,1)

        if strcmp(Movies_file(i).name,MoviesToConsider)==1
            
             Range=i;
          
        end

    end
end

end

%% Save the data

function SaveMovie_Parameters(Initial_Directory,Locomotion,MovieName,OriginTimeOfMovie,FinalTimeOfMovie,FrameRate,temp1,temp2)

%% Create the folders and the names of the files to save the data

  [NameToSaveD,NameToSave]=Rename_Save_Directory(MovieName,OriginTimeOfMovie,FinalTimeOfMovie);
                    A=strcat(Initial_Directory,'/',NameToSaveD);
                       
                    mkdir(char(A));
                    B=strcat(Initial_Directory,'/',NameToSaveD,'/',NameToSaveD,'.avi');
                    D=strcat(Initial_Directory,'/',NameToSaveD,'/',NameToSaveD,'WithSegmentation.avi');
                    C=strcat(Initial_Directory,'/',NameToSaveD,'/',NameToSaveD,'.mat');


%% Save video
                 
                    movefile(temp1,char(B));
                    movefile(temp2,char(D));
                   
 
                    %% Save the data in a structure
    
                 save(char(C),'Locomotion');
 
                 %% 
                 



end
%% 

function  MovieNameRFID=FindNameMovieChange(Name)

I=strfind(Name,'.avi')
MovieNameRFID=Name(1:I-1);

%change [ in the name by (

% MovieNameRFID=strrep(MovieNameRFID,'[','(');
% MovieNameRFID=strrep(MovieNameRFID,']',')');

end


%% function for arranging data into matrix
function  raw=Arrange_In_Matrix_RFIDData(time,date,micelist,coordinates,velocity)

%headers
raw(1,1)={'Date'};
raw(1,2)={'Time'};



%% 

for count=1:length(micelist)
    %% REMOVE NOT REAL VELOCITIES 
    Indexaux=find(velocity(1:end,count)>500000);
    velocity(Indexaux,count)=NaN;
    
   raw(1,3*count+1)=(micelist(count)); 
   raw(2,3*count)={'x(mm)'};
   raw(2,3*count+1)={'y(mm)'}; 
   raw(2,3*count+2)={'velocity (cm/sec)'}; 
  
   
   raw(3:size(coordinates,1)+2,3*count:3*count+1)=num2cell(coordinates(1:end,2*count-1:2*count)); 
   raw(3:size(coordinates,1)+2,3*count+2)=num2cell(velocity(1:end,count));  
end

%data

raw(3:size(coordinates,1)+2,1)=cellstr(date(1:size(coordinates,1),:));
raw(3:size(coordinates,1)+2,2)=cellstr(time(1:size(coordinates,1),:));

% Add a column with number of frames
 raw(2,3*length(micelist)+5)={'Number of frame'}; 
 raw(3:size(coordinates,1)+2,3*length(micelist)+5)=num2cell([1:size(coordinates,1)]');

end

%% Save cell array as csv
function SaveAsCsvCell(filename,Cell_Array)


cellwrite(filename,Cell_Array);

end

