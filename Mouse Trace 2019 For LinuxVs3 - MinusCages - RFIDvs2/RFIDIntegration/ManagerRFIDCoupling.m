function Locomotion=ManagerRFIDCoupling(DataDirectory,Date,TimeExp,miceList,miceListRibs,miceListRibsSide,Locomotion,Corn)
% Fix Variables
MaxRFIDDistance=57; %mm  units diameter antenna, before 57 mm;57+80
MaxRFIDDistance1=180;
DeltaFrame=80; % 300 There are not detection for the antennas to larger times the units are in ms-it was 80-UNTIL 2019 WAS 80MS
VelocityThreshold=250;%VEL 250 %No possible velocity larger than this value in cm/sec was 200-Last was 150 in 7/8/2018 %120/150/180 doesn't cover all range on 13-5-2019
FactorAcceleration=305; %Acceleration 150 cm/sec^2
MinimumAngleTolerance=55; % Angle of tolerance-angle larger than this assume a swap in the identification
MaxDistanceToleranceRFID=140;%tOLERANCE DISTANCE TO BE CONSIDERED NO REAL was 400 in mm units
VelocityThresholForCorrection=170; % in cm/sec it was 170 cm/sec
DistanceToSwapIdentity=80; % in mm this is the distance maximum to swap identities because of wrong segmentation
ErrorThreshold=1000; %This is the maximum error between observed and predicted position/orientation which is allowed
MaximumDistanceOfProximity=120; % distance in mm 114mm. This distance is two evaluate if 2 mice are sitting on the same antenna.Thus the measurement of the antenna is not sure.Was 150

Locomotion.AssigRFID.XcoordPixel=[];
Locomotion.AssigRFID.YcoordPixel=[];
Locomotion.AssigRFID.XcoordMM=[];
Locomotion.AssigRFID.YcoordMM=[];
Locomotion.AssigRFID.NoSureSignal=[];
Locomotion.AssigRFID.MouseOrientation=[];
Locomotion.AssigRFID.VelocityMouse=[];
Locomotion.AssigRFID.Clusters=[];
Locomotion.AssigRFID.PosArenaDueToAntenna=[];
Locomotion.AssigRFID.AntennaPerMice=[];
Locomotion.AssigRFID.DeltaTimeRFID=[];
Locomotion.AssigRFID.XErrorXobs_pred=[];
Locomotion.AssigRFID.YErrorYobs_pred=[];


MouseArray=[];
%% %%%%%%%%%%%%%%%%%%%% Variables and initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
IsSleeping=zeros(size(Locomotion.ExperimentTime,1),length(miceList)); %Change in the future the 20000 value- to show that is sleepin
IsSleepingCoordx=zeros(size(Locomotion.ExperimentTime,1),length(miceList)); % Add also the sleeping coordinates
IsSleepingCoordy=zeros(size(Locomotion.ExperimentTime,1),length(miceList));
IsSleepingCoordxP=zeros(size(Locomotion.ExperimentTime,1),length(miceList)); % Add also the sleeping coordinates in pixel
IsSleepingCoordyP=zeros(size(Locomotion.ExperimentTime,1),length(miceList));

IsHiding=zeros(size(Locomotion.ExperimentTime,1),length(miceList));
IsHidingCoordx=zeros(size(Locomotion.ExperimentTime,1),length(miceList));
IsHidingCoordy=zeros(size(Locomotion.ExperimentTime,1),length(miceList));
IsHidingCoordxP=zeros(size(Locomotion.ExperimentTime,1),length(miceList));
IsHidingCoordyP=zeros(size(Locomotion.ExperimentTime,1),length(miceList));

IsCages=zeros(size(Locomotion.ExperimentTime,1),length(miceList));
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
%TotalFrames=1500; % for internal checking
% for countFrames=1:TotalFrames
for countFrames=1:TotalFrames
    % Variables initialization
       global h
       AntennaForMice=[];
       DeltaTimeRFID=[]; %Difference in time between the rfid detection and actual frame
       SignTimeRFID=[]; %Sign of time difference which should be larger than zero.
       IndexSleeping=[];
       Position=[];
       Orientation=[];
       RepetitionCoord=[];
       Clusters=[];
       
       Coordinatesx=zeros((length(miceList)),1); % coord. in mm
       Coordinatesy=zeros((length(miceList)),1);
       CoordinatesxP=zeros((length(miceList)),1);
       CoordinatesyP=zeros((length(miceList)),1);% coord. in pixels
       SignalNoSurePosition=zeros(1,(length(miceList)));%Matrix indicating with one no sure positions
       MouseOrientation=zeros(1,(length(miceList)));
       VelocityMouse=zeros((length(miceList)),1);
       VelocityMouseX=zeros((length(miceList)),1);
       VelocityMouseY=zeros((length(miceList)),1);
       VectorClusterA=zeros(1,length(miceList));
       IArenaDueToAntenna=zeros(1,(length(miceList)));%Matrix indicating the positions get from the antennas
       ErrorXobs_pred=zeros(1,(length(miceList)));
       ErrorYobs_pred=zeros(1,(length(miceList)));
       
        CoordinatesxBeforeCorrection=zeros((length(miceList)),1); % coord. in mm
       CoordinatesyBeforeCorrection=zeros((length(miceList)),1);
       CoordinatesxPBeforeCorrection=zeros((length(miceList)),1);
       CoordinatesyPBeforeCorrection=zeros((length(miceList)),1);% coord. in pixels
       VelocityMouseBeforeCorrection=zeros((length(miceList)),1);
       
    % add a bar to know status
      countFrames
%      set(h.WaitBarRFID,'Position',[0.00001 0.00900 (countFrames/TotalFrames) 0.8]);
%      h.WaitBarRFID.Color='b';
 %     pause(0.01);
      
    % List antenna number for each mouse
       for j=1:length(miceList)
       AntennaForMice(j,1)=str2num(MouseArray{countFrames,2,j}); 
       DeltaTimeRFID(j,1)=MouseArray{countFrames,4,j};
       SignTimeRFID(j,1)=MouseArray{countFrames,5,j};
       end

         %% ---------------------------Read segmentation parameters--------------------------------------
         if ~isempty(Locomotion.Coordinates)
          Position(:,2)=Locomotion.CoordinatesWithRepeats(find(Locomotion.CoordinatesWithRepeats(:,1)==countFrames+1),2);% The segmentation coordinates for the given frame
          Position(:,3)=Locomotion.CoordinatesWithRepeats(find(Locomotion.CoordinatesWithRepeats(:,1)==countFrames+1),3);
          Orientation=Locomotion.SegmentationDetails.Orientation(find(Locomotion.Coordinates(:,1)==countFrames+1),2);
          RepetitionCoord=Locomotion.SegmentationDetails.RepetitionCoord(find(Locomotion.Coordinates(:,1)==countFrames+1),2); 
          Clusters=Locomotion.SegmentationDetails.MarkClusterR(find(Locomotion.SegmentationDetails.MarkClusterR(:,1)==countFrames+1),2);
         end 
         % 
          
          
         % Add values to orientation and repetion coord. when there are
         % repetions
          if any(RepetitionCoord)%correct orientation for duplicates
            Orientation=AddRepeatsToParams(Orientation,RepetitionCoord,Locomotion,countFrames);
          end
          
          %% Read last frame for count frame>1
          if countFrames==1
             OrientationLastFrame=[];
             XPixelLastFrame=[];
             YPixelLastFrame=[];
             XLastFrame=[];
             YLastFrame=[];
             VelLastFrame=[];
             VelLastFrameX=zeros((length(miceList)),1);
             VelLastFrameY=zeros((length(miceList)),1);
              NoSureSignalLastFrame=[];
              XErrorXobs_predLastFrame=[];
              YErrorYobs_predLastFrame=[];
          end
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %% Read the arena parameters and do conversions from pixels to mm
          Params=ParametersArenaFix();
          WidthHidingBox=Params.WidthHidingBox;
         
          
         if ~isempty(Position)
          Position(:,4)=PixelsToMM(Position(:,2),Corn(1,1),Corn(2,1),Params.Width); %convet to mm x coord
          Position(:,5)=PixelsToMM(Position(:,3),Corn(1,2),Corn(4,2),Params.Width); %convert to mm y coord
         end
        %% Create parameter of conversion from MM to pixel  
        Conversionx=(Corn(2,1)-Corn(1,1))/Params.Width;
        Conversiony=(Corn(4,2)-Corn(1,2))/Params.Width;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
 %% %%%%%%%%%%%%%%%%%% Find which mice are sleeping and the sleeping coordinates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         [IsSleeping,IsSleepingCoordx,IsSleepingCoordy,IsSleepingCoordxP,IsSleepingCoordyP,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,IlogicalSleeping]=FindSleeping(IsSleeping,IsSleepingCoordx,IsSleepingCoordy,IsSleepingCoordxP,IsSleepingCoordyP,...
                                                                                                          AntennaForMice,Params.SleepingAntenna,Params.SleepingBox,...
                                                                                                          Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Corn,countFrames);
 %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Find which mice are in the hiding box%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      [IsHiding,IsHidingCoordx,IsHidingCoordy,IsHidingCoordxP,IsHidingCoordyP,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,IlogicalHiding]=FindHiding(IsHiding,IsHidingCoordx,IsHidingCoordy,IsHidingCoordxP,IsHidingCoordyP,...
                                                                                                                                          AntennaForMice,Params.HidingAntenna,Params.HidingAntennaCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Corn,countFrames);     
                                                                                                                                      
           if countFrames>2
               
               [IsHiding,IlogicalHiding,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=CheckHidingResults(IsSleeping,IsHiding,countFrames,AntennaForMice,Corn,XLastFrame,YLastFrame,VelLastFrameX,VelLastFrameY,...
                        IlogicalHiding,Params.HidingAntenna,Params.HidingAntennaCoord,TimeExp{countFrames},TimeExp{countFrames-1},MaxRFIDDistance,...
                        Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Locomotion.AssigRFID.XcoordPixel(countFrames-2,:),SignTimeRFID);
                    
                    if ~isempty(find(IsHiding(countFrames,:)==1)) & size(Position)~=[0 0]
                        IndexToRemove=RemoveHidingPositions(IsHiding(countFrames,:),AntennaForMice,Params.FirstHidingBox,Params.SecondHidingBox,Params.ThirdHidingBox,Params.FourHidingBox,...
                                     Position(:,2),Position(:,3),Params.HidingAntenna,Params.HidingAntennaCoord);
                         %remove hiding positions due to segmentation
                         if ~isempty(IndexToRemove)
                              Position(IndexToRemove,:)=[];
                             
                         end
                    end
           
           
           end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find if there are cages the mice inside them %%%%%%%%%%%%%%%
 %If there are cages and 7 mice. the 2 last mice are in the cages and they will be removed from subsequent analysis.
 IslogicalCages=zeros(size(miceList,1),1);
 if ~isempty(Params.UpperCage) & ~isempty(Params.DownCage) & size(miceList,1)==7
   IslogicalCages(6,1)=1;
    IslogicalCages(7,1)=1;
    Coordinatesx(6,1)= Params.AntennaCoord(AntennaForMice(6,1),1); %this is in mm units
    Coordinatesy(6,1)=Params.AntennaCoord(AntennaForMice(6,1),2);
    CoordinatesxP(6,1)=Conversionx*Coordinatesx(6,1)+Corn(1,1);
    CoordinatesyP(6,1)=Conversiony*Coordinatesy(6,1)+Corn(1,2);
    Coordinatesx(7,1)=Params.AntennaCoord(AntennaForMice(7,1),1);
    Coordinatesy(7,1)=Params.AntennaCoord(AntennaForMice(7,1),2);
    CoordinatesxP(7,1)=Conversionx*Coordinatesx(7,1)+Corn(1,1);
    CoordinatesyP(7,1)=Conversiony*Coordinatesy(7,1)+Corn(1,2);
    
    % Remove positions in the upper and lower cages found by segmentation.
    
   [Position,Clusters,Orientation]=FindSegmentationInCages(Position,Params.UpperCage,Params.DownCage,Clusters,Orientation);

    % Remove the mice which jumps on the cages if the antenna 39 of down
    % cage or antenna 11 of upper cage detected these mice.
    if ~isempty(find(AntennaForMice==39)) 
        AntAux=find(AntennaForMice==39);
       for icountAux=1:length(find(AntennaForMice==39)) 
        if AntAux(icountAux)~=6 & AntAux(icountAux)~=7
          IslogicalCages(AntAux(icountAux),1)=1;
          Coordinatesx(AntAux(icountAux),1)= Params.AntennaCoord(39,1)+20; %this is in mm units
          Coordinatesy(AntAux(icountAux),1)=Params.AntennaCoord(39,2);
          CoordinatesxP(AntAux(icountAux),1)=Conversionx*Coordinatesx(AntAux(icountAux),1)+Corn(1,1);
          CoordinatesyP(AntAux(icountAux),1)=Conversiony*Coordinatesy(AntAux(icountAux),1)+Corn(1,2);
        end
       end
    end
     if ~isempty(find(AntennaForMice==11)) 
         AntAux=find(AntennaForMice==11);
        for icountAux=1:length(find(AntennaForMice==11)) 
        if AntAux(icountAux)~=6 & AntAux(icountAux)~=7
          IslogicalCages(AntAux(icountAux),1)=1;
          Coordinatesx(AntAux(icountAux),1)= Params.AntennaCoord(11,1)+20; %this is in mm units
          Coordinatesy(AntAux(icountAux),1)=Params.AntennaCoord(11,2);
          CoordinatesxP(AntAux(icountAux),1)=Conversionx*Coordinatesx(AntAux(icountAux),1)+Corn(1,1);
          CoordinatesyP(AntAux(icountAux),1)=Conversiony*Coordinatesy(AntAux(icountAux),1)+Corn(1,2);
        end
        end
     end
  end
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% %%%%%%%%%%%%%%%%%%%%%Find if it is in the arena %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Find the antennas inside the arena
          IndexArena=find(IlogicalSleeping==0 & IlogicalHiding==0 & IslogicalCages==0); %remove data both in hiding and sleeping and also removed in the case of cages

        % look for these antenna
          if ~isempty(IndexArena) & ~isempty(Position) %if no position found in segmentation
              % Add position if the number of antenna inside arena larger
              % than positions (means positions weren't detected by the
              % video- Assign a very large valu
              if   length(Position(:,2))< length(AntennaForMice(IndexArena,1)) % There are less positions than mice detected inside arena
                   NewLine=length(Position(:,2))+1:length(AntennaForMice(IndexArena,1));
                   Position(NewLine,2)=1e6;
                   Position(NewLine ,3)=1e6;
                   Position(NewLine,4)=1e6;
                   Position(NewLine,5)=1e6;
                   Orientation(NewLine,1)=1;
                   Clusters(NewLine,1)=1;%cluster no defined
                   
              elseif length(Position(:,2))> length(AntennaForMice(IndexArena,1))   %There are more positions than mice
                   
                   
              end
              
              
              % Find from the segmentation the position inside the arena

              
              
              [ErrorFXobs_Xpred,ErrorFYobs_Ypred,IpositionArenaDueToAntenna,VectorCluster,XAssignment,YAssignment, XAssignmentPixel,YAssignmentPixel,IindicateNoSureCoord,OrientationAssignment,velocityFinal,velocityX,velocityY,XAssignmentBeforeCorrection,YAssignmentBeforeCorrection,XAssignmentPixelBeforeCorrection,YAssignmentPixelBeforeCorrection,velocityBeforeCorrection]=FindArena(IndexArena,AntennaForMice,Params.AntennaCoord,DeltaTimeRFID,countFrames,.....
                                                                                                                       Position(:,2),Position(:,3),....
                                                                                                                       Position(:,4),Position(:,5),MaxRFIDDistance,DeltaFrame,......
                                                                                                                       Orientation,OrientationLastFrame,XPixelLastFrame,YPixelLastFrame,XLastFrame,YLastFrame,....
                                                                                                                       TimeExp,VelocityThreshold, VelLastFrame, NoSureSignalLastFrame,FactorAcceleration,MinimumAngleTolerance,...
                                                                                                                       MaxDistanceToleranceRFID,VelLastFrameX,VelLastFrameY,...
                                                                                                                       Conversionx,Conversiony,Clusters,ErrorThreshold,...
                                                                                                                        XErrorXobs_predLastFrame,YErrorYobs_predLastFrame,Corn,Params.Width,SignTimeRFID,...
                                                                                                                        MaximumDistanceOfProximity);
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
                   VectorClusterA(1,IndexArena)=VectorCluster;
                   IArenaDueToAntenna(1,IndexArena)=IpositionArenaDueToAntenna';
%                    ErrorXobs_pred(1,IndexArena)=ErrorFXobs_Xpred;
%                    ErrorYobs_pred(1,IndexArena)=ErrorFYobs_Ypred; 
%  Add coordinates before correction
                  CoordinatesxBeforeCorrection(IndexArena,1)=XAssignmentBeforeCorrection;
                   CoordinatesyBeforeCorrection(IndexArena,1)=YAssignmentBeforeCorrection;
                   CoordinatesxPBeforeCorrection(IndexArena,1)=XAssignmentPixelBeforeCorrection;
                   CoordinatesyPBeforeCorrection(IndexArena,1)=YAssignmentPixelBeforeCorrection;
                   VelocityMouseBeforeCorrection(IndexArena,1)=velocityBeforeCorrection;

           elseif ~isempty(IndexArena) & isempty(Position)
                Coordinatesx(IndexArena,1)=1e6;
                   Coordinatesy(IndexArena,1)=1e6;
                   CoordinatesxP(IndexArena,1)=1e6;
                   CoordinatesyP(IndexArena,1)=1e6;
                   MouseOrientation(1,IndexArena)=1e6;
                   
                   CoordinatesxBeforeCorrection(IndexArena,1)=1e6;
                    CoordinatesyBeforeCorrection(IndexArena,1)=1e6;
                    CoordinatesxPBeforeCorrection(IndexArena,1)=1e6;
                    CoordinatesyPBeforeCorrection(IndexArena,1)=1e6;
          end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Summarize the data into a structure
   
    Locomotion.AssigRFID.XcoordPixel=[Locomotion.AssigRFID.XcoordPixel;( CoordinatesxP)'];
    Locomotion.AssigRFID.YcoordPixel=[Locomotion.AssigRFID.YcoordPixel;(CoordinatesyP)'];
    Locomotion.AssigRFID.XcoordMM=[Locomotion.AssigRFID.XcoordMM;(Coordinatesx)'];
    Locomotion.AssigRFID.YcoordMM=[Locomotion.AssigRFID.YcoordMM;(Coordinatesy)'];
    Locomotion.AssigRFID.NoSureSignal=[Locomotion.AssigRFID.NoSureSignal;SignalNoSurePosition];
    Locomotion.AssigRFID.MouseOrientation=[Locomotion.AssigRFID.MouseOrientation;MouseOrientation];
    Locomotion.AssigRFID.VelocityMouse=[Locomotion.AssigRFID.VelocityMouse;(VelocityMouse)'];
    Locomotion.AssigRFID.VelocityMouseX=[Locomotion.AssigRFID.VelocityMouse;(VelocityMouseX)'];
    Locomotion.AssigRFID.VelocityMouseY=[Locomotion.AssigRFID.VelocityMouse;(VelocityMouseY)'];
    Locomotion.AssigRFID.Clusters=[Locomotion.AssigRFID.Clusters;VectorClusterA];
    Locomotion.AssigRFID.PosArenaDueToAntenna=[Locomotion.AssigRFID.PosArenaDueToAntenna;(IArenaDueToAntenna)];
    Locomotion.AssigRFID.AntennaPerMice=[Locomotion.AssigRFID.AntennaPerMice;(AntennaForMice)'];
    Locomotion.AssigRFID.DeltaTimeRFID=[Locomotion.AssigRFID.DeltaTimeRFID;(DeltaTimeRFID)'];
%     Locomotion.AssigRFID.XErrorXobs_pred=[Locomotion.AssigRFID.XErrorXobs_pred;ErrorXobs_pred];
%     Locomotion.AssigRFID.YErrorYobs_pred=[Locomotion.AssigRFID.YErrorYobs_pred;ErrorYobs_pred];
    
    % the orientation is zero where is sleeping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%ADD SWAPPING CORRECTIONS
if countFrames>2
  [Locomotion,IsHiding]=JumpsCorrection(Locomotion,TimeExp,Locomotion.AssigRFID.PosArenaDueToAntenna,Locomotion.AssigRFID.VelocityMouse,...
                               countFrames,IsSleeping,IsHiding,VelocityThreshold,...
                               CoordinatesxBeforeCorrection,CoordinatesyBeforeCorrection,CoordinatesxPBeforeCorrection,CoordinatesyPBeforeCorrection,VelocityMouseBeforeCorrection);
end
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
     XErrorXobs_predLastFrame=ErrorXobs_pred;
     YErrorYobs_predLastFrame=ErrorYobs_pred;
end
    Locomotion.AssigRFID.IsSleeping=IsSleeping;
    Locomotion.AssigRFID.IsSleepingCoordx=IsSleepingCoordx;
    Locomotion.AssigRFID.IsSleepingCoordy=IsSleepingCoordy;
    Locomotion.AssigRFID.IsSleepingCoordxP=IsSleepingCoordxP;
    Locomotion.AssigRFID.IsSleepingCoordyP=IsSleepingCoordyP;
    
    
    Locomotion.AssigRFID.IsHidingTracking=IsHiding;
    Locomotion.AssigRFID.IsHidingCoordxTracking=IsHidingCoordx;
    Locomotion.AssigRFID.IsHidingCoordyTracking=IsHidingCoordy;
    Locomotion.AssigRFID.IsHidingCoordxPTracking=IsHidingCoordxP;
    Locomotion.AssigRFID.IsHidingCoordyPTracking=IsHidingCoordyP;
    

    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%---------------The idea is to correct the coordinates in
    %%%%%%%%%%%%%%%%%%%which the mice are near and the identity is mixed,
    %%%%%%%%%%%%%%%%%%%in the moment the identity returned there is a big
    %%%%%%%%%%%%%%%%%%%jump in the velocity
%  for it=1:100
%  First correction
%     
% % Locomotion=correctionVelocity(Locomotion,VelocityThresholForCorrection,Conversionx,Conversiony,TotalFrames);
    %Locomotion=correctionVelocityCluster(Locomotion,VelocityThresholForCorrection,Conversionx,Conversiony,TotalFrames,IsSleeping);%ADD
   % THIS
%% Reassign again the sleeping coordinates in the case the correction fails
%Locomotion=ReassingSleepingCoordinates(Locomotion);

% Recalculation of the velocity
    
%     Locomotion=VelocityRecalculation(Locomotion);%ADD
%      MatrixfinalWithHighVelocity= Locomotion.AssigRFID.VelocityMouse>VelocityThresholForCorrection;%ADD
%     Locomotion.AssigRFID.FinalIndicationHighVelocity=MatrixfinalWithHighVelocity;%ADD
    
    
    
    
    %% %  Second correction When the velocity is nan in one mouse and there is a jump
%     
% % Locomotion=correctionVelocity(Locomotion,VelocityThresholForCorrection,Conversionx,Conversiony,TotalFrames);
   % Locomotion=correction2VelocityCluster(Locomotion,VelocityThresholForCorrection,Conversionx,Conversiony,TotalFrames,IsSleeping);%ADD
   % THIS
%% Reassign again the sleeping coordinates in the case the correction fails
%Locomotion=ReassingSleepingCoordinates(Locomotion);

% Recalculation of the velocity
    
    

Locomotion=VelocityRecalculation(Locomotion);%ADD
     MatrixfinalWithHighVelocity= Locomotion.AssigRFID.VelocityMouse>VelocityThresholForCorrection;%ADD
    Locomotion.AssigRFID.FinalIndicationHighVelocity=MatrixfinalWithHighVelocity;%ADD
    Locomotion=VelocityRecalculationWithoutnonDefinedPositions(Locomotion);
    Locomotion.AssigRFID.FinalIndicationVelocityWithoutNonDefined=Locomotion.AssigRFID.VelocityMouseWithoutNonDefined>VelocityThresholForCorrection;

   %end 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% Consider cases in which there isn't position assign by%%%
    %%%%%%%%%%% segmentation for a given mouse either because the mouse%%%
    %%%%%%%%%%% dissapeare from the video or either it is near othe mice%%%
    %%%%%%%%%%% but the segmentation into 2 objects fail.Thus wrong position from wrong segmentation is assigned%%%
%     % Second correction
%       Locomotion=correctionJumpsOneMouse(Locomotion,VelocityThresholForCorrection);
% 
%      % Recalculation of the velocity  
%      Locomotion=VelocityRecalculation(Locomotion);
%      MatrixfinalWithHighVelocity= Locomotion.AssigRFID.VelocityMouse>VelocityThresholForCorrection;
%      Locomotion.AssigRFID.FinalIndicationHighVelocity=MatrixfinalWithHighVelocity;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end