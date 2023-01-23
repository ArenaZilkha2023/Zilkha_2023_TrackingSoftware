function Locomotion=ManagerRFIDCouplingInverse(DataDirectory,Date,TimeExp,miceList,miceListRibs,miceListRibsSide,Locomotion,Corn)
% Fix Variables
MaxRFIDDistance=57; %mm  units diameter antenna, before 57 mm;
DeltaFrame=80; %There are not detection for the antennas to larger times the units are in ms-it was 80
VelocityThreshold=150; %No possible velocity larger than this value in cm/sec was 200
FactorAcceleration=305; %Acceleration 150 cm/sec^2
MinimumAngleTolerance=55; % Angle of tolerance-angle larger than this assume a swap in the identification
MaxDistanceToleranceRFID=300;%tOLERANCE DISTANCE TO BE CONSIDERED NO REAL was 400
VelocityThresholForCorrection=190; % in cm/sec
DistanceToSwapIdentity=80; % in mm this is the distance maximum to swap identities because of wrong segmentation

Locomotion.AssigRFIDInverse.XcoordPixel=[];
Locomotion.AssigRFIDInverse.YcoordPixel=[];
Locomotion.AssigRFIDInverse.XcoordMM=[];
Locomotion.AssigRFIDInverse.YcoordMM=[];
Locomotion.AssigRFIDInverse.NoSureSignal=[];
Locomotion.AssigRFIDInverse.MouseOrientation=[];
Locomotion.AssigRFIDInverse.VelocityMouse=[];
MouseArray=[];
%% %%%%%%%%%%%%%%%%%%%% Variables and initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
IsSleeping=zeros(20000,length(miceList)); %Change in the future the 20000 value- to show that is sleepin

%% %%%%%%%%%%%Read the RFID files according to the date- Found the number of antenna for each mouse detected near to each time frame%%%%%%%%
% Read RFID parameters
RFIDobj=FilesTreat;%use class FilesTreat
RFIDobj.directory=DataDirectory;
RFIDobj.extension='.txt';
N=RFIDobj.NumFiles(RFIDobj.ListFiles);
DateFiles=RFIDobj.DateFiles(RFIDobj.ListFiles,N);

% According to date select RFID text files 
DateToBeConsidered=datenum(Date,'dd/mm/yyyy');
IndexFilesDates=find(DateFiles==DateToBeConsidered);
SelectedDataRFID=RFIDobj.ReadFilesAllDate(RFIDobj.ListFiles,IndexFilesDates); %Note: position includes repeats of coordinates

% Find for each mouse a list with time frame,  antenna number,rfid time ,(which detected the mouse) and delta time between time frame and
% rfid
MouseArray=FindAntennaList(miceList,miceListRibs,miceListRibsSide,SelectedDataRFID,TimeExp);   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Go through each frame to find trajectory%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TotalFrames=size(MouseArray,1);
% LOOP OVER EACH FRAME
TotalFrames=5000; % for internal checking
for countFrames=[TotalFrames:-1:1]
    % Variables initialization
       global h
       AntennaForMice=[];
       DeltaTimeRFID=[]; %Difference in time between the rfid detection and actual frame
       IndexSleeping=[];
       Position=[];
       Orientation=[];
       RepetitionCoord=[];
    
       
       Coordinatesx=zeros((length(miceList)),1); % coord. in mm
       Coordinatesy=zeros((length(miceList)),1);
       CoordinatesxP=zeros((length(miceList)),1);
       CoordinatesyP=zeros((length(miceList)),1);% coord. in pixels
       SignalNoSurePosition=zeros(1,(length(miceList)));%Matrix indicating with one no sure positions
       MouseOrientation=zeros(1,(length(miceList)));
       VelocityMouse=zeros((length(miceList)),1);
       VelocityMouseX=zeros((length(miceList)),1);
       VelocityMouseY=zeros((length(miceList)),1);
       
       
    % add a bar to know status
      countFrames
      set(h.WaitBarRFID,'Position',[0.00001 0.00900 ((TotalFrames-countFrames+1)/TotalFrames) 0.8]);
      h.WaitBarRFID.Color='b';
      pause(0.01);
      
    % List antenna number for each mouse
       for j=1:length(miceList)
       AntennaForMice(j,1)=str2num(MouseArray{countFrames,2,j}); 
       DeltaTimeRFID(j,1)=MouseArray{countFrames,4,j};
       end

         %% ---------------------------Read segmentation parameters--------------------------------------
          Position(:,2)=Locomotion.CoordinatesWithRepeats(find(Locomotion.CoordinatesWithRepeats(:,1)==countFrames+1),2);% The segmentation coordinates for the given frame
          Position(:,3)=Locomotion.CoordinatesWithRepeats(find(Locomotion.CoordinatesWithRepeats(:,1)==countFrames+1),3);
          Orientation=Locomotion.SegmentationDetails.Orientation(find(Locomotion.Coordinates(:,1)==countFrames+1),2);
          RepetitionCoord=Locomotion.SegmentationDetails.RepetitionCoord(find(Locomotion.Coordinates(:,1)==countFrames+1),2); 
         % Add values to orientation and repetion coord. when there are
         % repetions
          if any(RepetitionCoord)%correct orientation for duplicates
            Orientation=AddRepeatsToParams(Orientation,RepetitionCoord,Locomotion,countFrames);
          end
           LastFrame=TotalFrames;
          %% Read last frame for count frame>1
          if countFrames==LastFrame
            OrientationLastFrame=[];
             XPixelLastFrame=[];
             YPixelLastFrame=[];
             XLastFrame=[];
             YLastFrame=[];
             VelLastFrame=[];
             VelLastFrameX=zeros((length(miceList)),1);
             VelLastFrameY=zeros((length(miceList)),1);
              NoSureSignalLastFrame=[];
          end
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %% Read the arena parameters and do conversions from pixels to mm
          Params=ParametersArenaFix();
          Position(:,4)=PixelsToMM(Position(:,2),Corn(1,1),Corn(2,1),Params.Width); %convet to mm x coord
          Position(:,5)=PixelsToMM(Position(:,3),Corn(1,2),Corn(4,2),Params.Width); %convert to mm y coord
        %% Create parameter of conversion from MM to pixel  
        Conversionx=(Corn(2,1)-Corn(1,1))/Params.Width;
        Conversiony=(Corn(4,2)-Corn(1,2))/Params.Width;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
 %% %%%%%%%%%%%%%%%%%% Find which mice are sleeping and the sleeping coordinates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         [IsSleeping,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,IlogicalSleeping]=FindSleeping(IsSleeping,AntennaForMice,Params.SleepingAntenna,Params.SleepingBox,.....
                                                                                               Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Corn,countFrames);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% %%%%%%%%%%%%%%%%%%%%%Find if it is in the arena %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Find the antennas inside the arena
          IndexArena=find(IlogicalSleeping==0);
        % look for these antenna
          if ~isempty(IndexArena)
              % Add position if the number of antenna inside arena larger
              % than positions (means positions weren't detected by the
              % video- Assign a very large valu
              if   length(Position(:,2))< length(AntennaForMice(IndexArena,1)) % There are less positions than mice detected inside arena
                   NewLine=length(Position(:,2))+1:length(AntennaForMice(IndexArena,1));
                   Position(NewLine,2)=1e6;
                   Position(NewLine ,3)=1e6;
                   Position(NewLine,4)=1e6;
                   Position(NewLine,5)=1e6;
                   Orientation(NewLine,1)=1e6;
              end
              
              
              % Find from the segmentation the position inside the arena
              
              [XAssignment,YAssignment, XAssignmentPixel,YAssignmentPixel,IindicateNoSureCoord,OrientationAssignment,velocityFinal,velocityX,velocityY]=FindArenaInverse(IndexArena,AntennaForMice,Params.AntennaCoord,DeltaTimeRFID,countFrames,.....
                                                                                                                       Position(:,2),Position(:,3),....
                                                                                                                       Position(:,4),Position(:,5),MaxRFIDDistance,DeltaFrame,... 
                                                                                                                       Orientation,OrientationLastFrame,XPixelLastFrame,YPixelLastFrame,XLastFrame,YLastFrame,....
                                                                                                                       TimeExp,VelocityThreshold, VelLastFrame, NoSureSignalLastFrame,FactorAcceleration,MinimumAngleTolerance,...
                                                                                                                       MaxDistanceToleranceRFID,VelLastFrameX,VelLastFrameY,...
                                                                                                                       Conversionx,Conversiony,LastFrame);
               % Couple to the coordinates
                   Coordinatesx(IndexArena,1)=XAssignment;
                   Coordinatesy(IndexArena,1)=YAssignment;
                   CoordinatesxP(IndexArena,1)=XAssignmentPixel;
                   CoordinatesyP(IndexArena,1)=YAssignmentPixel;
                   VelocityMouse(IndexArena,1)=velocityFinal;
                   VelocityMouseX(IndexArena,1)=velocityX;
                   VelocityMouseY(IndexArena,1)=velocityY;
                   SignalNoSurePosition(1,IndexArena)=IindicateNoSureCoord;
                   MouseOrientation(1,IndexArena)=OrientationAssignment;
                   
          end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Summarize the data into a structure
   
    Locomotion.AssigRFIDInverse.XcoordPixel=[Locomotion.AssigRFIDInverse.XcoordPixel;( CoordinatesxP)'];
    Locomotion.AssigRFIDInverse.YcoordPixel=[Locomotion.AssigRFIDInverse.YcoordPixel;(CoordinatesyP)'];
    Locomotion.AssigRFIDInverse.XcoordMM=[Locomotion.AssigRFIDInverse.XcoordMM;(Coordinatesx)'];
    Locomotion.AssigRFIDInverse.YcoordMM=[Locomotion.AssigRFIDInverse.YcoordMM;(Coordinatesy)'];
    Locomotion.AssigRFIDInverse.NoSureSignal=[Locomotion.AssigRFIDInverse.NoSureSignal;SignalNoSurePosition];
    Locomotion.AssigRFIDInverse.MouseOrientation=[Locomotion.AssigRFIDInverse.MouseOrientation;MouseOrientation];
    Locomotion.AssigRFIDInverse.VelocityMouse=[Locomotion.AssigRFIDInverse.VelocityMouse;(VelocityMouse)'];
    % the orientation is zero where is sleeping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% Arrange last coordinates
     XPixelLastFrame=( CoordinatesxP)';
     YPixelLastFrame=(CoordinatesyP)';
     OrientationLastFrame=MouseOrientation;
     XLastFrame=( Coordinatesx)';
     YLastFrame=(Coordinatesy)';
     VelLastFrame=(VelocityMouse)';
      VelLastFrameX=(VelocityMouseX)';
       VelLastFrameY=(VelocityMouseY)';
     NoSureSignalLastFrame=SignalNoSurePosition;
end
   
    Locomotion.AssigRFIDInverse.IsSleeping=IsSleeping;
   % Fip up down the coordinates matrix
   Locomotion.AssigRFIDInverse.XcoordPixel=flipud(Locomotion.AssigRFIDInverse.XcoordPixel);
   Locomotion.AssigRFIDInverse.YcoordPixel=flipud(Locomotion.AssigRFIDInverse.YcoordPixel);
   Locomotion.AssigRFIDInverse.XcoordMM=flipud(Locomotion.AssigRFIDInverse.XcoordMM);
   Locomotion.AssigRFIDInverse.YcoordMM=flipud(Locomotion.AssigRFIDInverse.YcoordMM);
   Locomotion.AssigRFIDInverse.NoSureSignal=flipud(Locomotion.AssigRFIDInverse.NoSureSignal);
   Locomotion.AssigRFIDInverse.MouseOrientation=flipud(Locomotion.AssigRFIDInverse.MouseOrientation);
   Locomotion.AssigRFIDInverse.VelocityMouse=flipud(Locomotion.AssigRFIDInverse.VelocityMouse);
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%---------------The idea is to correct the coordinates in
    %%%%%%%%%%%%%%%%%%%which the mice are near and the identity is mixed,
    %%%%%%%%%%%%%%%%%%%in the moment the identity returned there is a big
    %%%%%%%%%%%%%%%%%%%jump in the velocity
    %Locomotion=correctionVelocity(Locomotion,VelocityThresholForCorrection,DistanceToSwapIdentity);
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 
    
    
end