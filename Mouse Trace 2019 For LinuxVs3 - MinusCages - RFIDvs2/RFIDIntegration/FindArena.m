function [ErrorFXobs_Xpred,ErrorFYobs_Ypred,IpositionArenaDueToAntenna,VectorCluster,XAssignment,YAssignment, XAssignmentPixel,YAssignmentPixel,IindicateNoSureCoord,OrientationAssignment,velocityFinal,velocityX,velocityY,XAssignmentBeforeCorrection,YAssignmentBeforeCorrection,XAssignmentPixelBeforeCorrection,YAssignmentPixelBeforeCorrection,velocityBeforeCorrection]=FindArena(IndexArena,AntennaNumber,AntennaCoord,DeltaTimeRFID,countFrames,....
                   xposPixel,yposPixel,xpos,ypos,MaxRFIDDistance,DeltaFrame,......
                   Orientation,OrientationLastFrame,XPixelLastFrame,YPixelLastFrame,XLastFrame,YLastFrame,...
                   TimeExp,VelocityThreshold,VelLastFrame, NoSureSignalLastFrame,FactorAcceleration,MinimumAngleTolerance,...
                   MaxDistanceToleranceRFID,velocityLastFrameX,velocityLastFrameY,...
                   Conversionx,Conversiony,Clusters,ErrorThreshold,...
                   XErrorXobs_predLastFrame,YErrorYobs_predLastFrame,Corn,WidthArena,SignTimeRFID,...
                   MaximumDistanceOfProximity)
%This function find the coordinates of the mouse in the arena a vector 
%% Variables
 DistanceAssignment=[];
  XAssignment=[];
  YAssignment=[];
  XAssignmentPixel=[];
  YAssignmentPixel=[];
  OrientationAssignment=[];
  XAssignmentBeforeCorrection=[];
  YAssignmentBeforeCorrection=[];
  XAssignmentPixelBeforeCorrection=[];
  YAssignmentPixelBeforeCorrection=[];
  ClustersAssignment=[];
  
  IndexE=[]
  ErrorFXobs_Xpred=zeros(1,length(IndexArena));
  ErrorFYobs_Ypred=zeros(1,length(IndexArena));
  ErrorAsignment=zeros(1,length(IndexArena));
%% ------- Select the antenna inside the arena which are unique and duplicate duplicate-----------------
SubsetAntennaNumber=AntennaNumber(IndexArena,1);
SubsetDeltaTimeRFID=DeltaTimeRFID(IndexArena,1);
SubsetSignTimeRFID=SignTimeRFID(IndexArena,1);

% Get the antenna which are and aren't unique.
[~,ind]=unique(SubsetAntennaNumber,'stable');
SubsetAntennaNumberDuplicate=SubsetAntennaNumber(setdiff(1:size(SubsetAntennaNumber,1),ind));%This gives the antenna number which are duplicated
SubsetAntennaNumberDuplicate=unique(SubsetAntennaNumberDuplicate); %This gives only one number for each duplicate
[SubsetAntennaNumberUnique,id]=setdiff(SubsetAntennaNumber,SubsetAntennaNumberDuplicate,'stable'); %This gives the antenna number which are unique
Iindicate_uniqueAntenna=zeros(size(SubsetAntennaNumber,1),1);
Iindicate_uniqueAntenna(id,1)=1;
%find the antenna coordinate
 AntennaX=AntennaCoord(SubsetAntennaNumber,1);
 AntennaY=AntennaCoord(SubsetAntennaNumber,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ----------------------------Consider First Frame -----------------------
% Calculate the distance from each possible postion to a given antenna.
%if the distance less than and delta time less than the result is certain
%and 0 and antenna es unique if not is 1.
%Create a report matrix

   % %%%%%%%%%%%%%%%%Arrange distance from antenna into a matrix%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

   [MatrixToMinimize,DistanceMatrix,DeltaRFIDaux]=Matrix_to_Consider_RFID(xpos,ypos,AntennaX,AntennaY,.....
                                                    SubsetDeltaTimeRFID,MaxRFIDDistance,DeltaFrame,Orientation);
      %% Create matrix of sign in time difference between time frame and rfid time which should be positive.
 SignTimeRFIDaux=repmat(SubsetSignTimeRFID',[size(ypos,1),1]);                                           
                                                
   % %%%%%%%%%%%%%%Assign to each antenna the minimum distance in such a way that the sum
        %is minimum and each antenna receive a different assignment,application
        %of hungariam algoritm%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [assignmentF,~]=munkresForMiceTracer(MatrixToMinimize); 
    % %%%%%%%%%%%%%%%%%%%%%%%Do the assignment according to minimal value%%%%%%%%%%%%%%%%%%%%%%%%
     for countAssigment=1:length(assignmentF) 
        DistanceAssignment(countAssigment)=DistanceMatrix(assignmentF(countAssigment),countAssigment); 
        XAssignment(countAssigment)=xpos(assignmentF(countAssigment));
        YAssignment(countAssigment)=ypos(assignmentF(countAssigment));
        XAssignmentPixel(countAssigment)=xposPixel(assignmentF(countAssigment));
        YAssignmentPixel(countAssigment)=yposPixel(assignmentF(countAssigment));
        OrientationAssignment(countAssigment)=Orientation(assignmentF(countAssigment));
        ClustersAssignment(countAssigment)=Clusters(assignmentF(countAssigment));
     end
     
     % Copy for later use
           XAssignmentBeforeCorrection=XAssignment;  
           YAssignmentBeforeCorrection=YAssignment;  
           XAssignmentPixelBeforeCorrection=XAssignmentPixel;  
           YAssignmentPixelBeforeCorrection=YAssignmentPixel;  
           velocityBeforeCorrection=zeros(size(IndexArena,1),1); 
   % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create a vector to know the cetainty of the data%%%%%%%%%%%%%%%%%%%%  
  %The idea is to define more when the antenna measurement is considered- 
  %Stage 1 consider the cases in which the posible position are on the
  %antenna and the measurement was done less than 80 or 100ms of the frame
   Ilogical_stage1=(DistanceAssignment'<MaxRFIDDistance)& ((DeltaRFIDaux(1,:))'<DeltaFrame)& Iindicate_uniqueAntenna & (ClustersAssignment'==1);

    % Consider cases in which the antenna is correct but the mouse is very
   % %%%%%near another as antenna size thus the assignment could be wrong
     if any(Ilogical_stage1)
        Ilogical_stage1=CheckCloseToMice(Ilogical_stage1,XAssignment,YAssignment,MaximumDistanceOfProximity); 
     end
     %%%%%%%%%%%%%Stage 2 consider the cases it is between the antenna- if the position is in the range of only one antenna
     %%%% it is recognized, if not it is not recognized.
      Ilogical_stage2=(DistanceAssignment'>MaxRFIDDistance)& (DistanceAssignment'<(2*MaxRFIDDistance+80))& Iindicate_uniqueAntenna & (ClustersAssignment'==1);
      if any(Ilogical_stage2)
       Ilogical_stage2=CheckCloseToAntenna(Ilogical_stage2,XAssignment,YAssignment,MaxRFIDDistance,DistanceMatrix,assignmentF); 
     end
     % Combine all the logical
     Ilogical=or(Ilogical_stage1,Ilogical_stage2);
     
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    IpositionArenaDueToAntenna=Ilogical;
    IindicateNoSureCoord=~Ilogical; %1 value indicate that the value isn't sure
    IindicateNoSureCoord=IindicateNoSureCoord';
    % %%%%%%%%%%%%%%%%%%%%Do a Second control for count frames>1%%%%%%%%%%%%%%%%%%%%%%%%%
    if countFrames~=1
      % Find last coord. and orientation inside the arena
                XPixelLastFrame=XPixelLastFrame(IndexArena);
                YPixelLastFrame=YPixelLastFrame(IndexArena);
                XLastFrame=XLastFrame(IndexArena);
                YLastFrame=YLastFrame(IndexArena);
                OrientationLastFrame=OrientationLastFrame(IndexArena);
                VelLastFrame= VelLastFrame(IndexArena); 
                velocityLastFrameX=velocityLastFrameX(IndexArena); 
                velocityLastFrameY=velocityLastFrameY(IndexArena); 
                NoSureSignalLastFrame=NoSureSignalLastFrame(IndexArena); 
 % %%%%%%%%%%%%%%%%%%%%%%%%%% If antenna assignment is equal to last frame assignment the result is sure%%%%%%%%%%%%%%%%%%%               
    % find the assignment of all the data
       % Arrange Matrix with distance and orientations  
%              MatrixToMinimizeSecondAll=Matrix_to_Consider_LastFrame(xposPixel,yposPixel,Orientation,.....
%                                   XPixelLastFrame, YPixelLastFrame, OrientationLastFrame); % Remove no used
%              % Minimize the matrix
%                 [assignmentFSecondAll,~]=munkresForMiceTracer(MatrixToMinimizeSecondAll); %No used
%              % Find similarity with assignment of rfid
%              IndexCoincidenceRFIDLastFrame=find(assignmentF==assignmentFSecondAll); %No used use later for arrangement
    end   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % Checking the validity of positions which were considered sure%%%%%%%%%%%%%%%%%%%%%%
 if countFrames>1
%         if ~isempty(find(IindicateNoSureCoord==0)) % this is done only with sure candidates  coordinates
%           IindicateNoSureCoord=CheckingValidity(countFrames,find(IindicateNoSureCoord==0),XAssignment(find(IindicateNoSureCoord==0)),YAssignment(find(IindicateNoSureCoord==0)),.....
%                       XLastFrame(find(IindicateNoSureCoord==0)),YLastFrame(find(IindicateNoSureCoord==0)),...
%                       TimeExp{countFrames-1},TimeExp{countFrames},NoSureSignalLastFrame,....
%                       VelocityThreshold,IindicateNoSureCoord,VelLastFrame,FactorAcceleration,OrientationLastFrame(find(IindicateNoSureCoord==0)),OrientationAssignment(find(IindicateNoSureCoord==0)),MinimumAngleTolerance);
%         end         
     % For further use get the index of the right places
     IndexRightWithRFID=find(IindicateNoSureCoord==0);
 end                 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
    %% For count frames different from the first one also we take into acount the  last frame
    if countFrames~=1 & any(IindicateNoSureCoord)
    % Group only the positions and antennas which were not defined with
    % RFID
          IsubAfterRFID=find(IindicateNoSureCoord==1);
          if ~isempty(IsubAfterRFID) %consider only no sure assignments
                  
              AntennasubAfterRFID=SubsetAntennaNumber(IsubAfterRFID);
             
             
              indexX=ismember(xpos,XAssignment(find(IindicateNoSureCoord==0))); % return the xpos which are in Xassignment- The index is logical
              indexY=ismember(ypos,YAssignment(find(IindicateNoSureCoord==0))); % return the ypos which are in Yassignment-the index is logical
             if length(unique(xpos))<length(xpos) %without doubles %then must add the double position
                 [n, bin] = histc(xpos, unique(xpos));
                  multiple = find(n > 1);
                 indexaux1 = find(ismember(bin, multiple));
               
                 indexX(indexaux1(2:length(indexaux1)))=0;
                 indexY(indexaux1(2:length(indexaux1)))=0;
             end
              
              
              xposAfterRFID=xpos(~indexX & ~indexY); %only take nonassign positions
              yposAfterRFID=ypos(~indexX & ~indexY);
              xposPixelAfterRFID=xposPixel(~indexX & ~indexY);
              yposPixelAfterRFID=yposPixel(~indexX & ~indexY);
              OrientationAfterRFID=(Orientation(~indexX & ~indexY));
              XPixelLastFrameAfter=XPixelLastFrame(IsubAfterRFID);
              YPixelLastFrameAfter=YPixelLastFrame(IsubAfterRFID);
              XLastFrameAfter=XLastFrame(IsubAfterRFID);
              YLastFrameAfter=YLastFrame(IsubAfterRFID);
              velocityLastFrameXAfter=velocityLastFrameX(IsubAfterRFID);
              velocityLastFrameYAfter=velocityLastFrameY(IsubAfterRFID);
              SubsetSignTimeRFIDAfter=SubsetSignTimeRFID(IsubAfterRFID);
               
%               OrientationLastFrameAfter=deg2rad(OrientationLastFrame(IsubAfterRFID));
              OrientationLastFrameAfter=(OrientationLastFrame(IsubAfterRFID));
              % Convert degrees into radians
              
            % Arrange Matrix with distance and orientations  

            [MatrixToMinimizeSecond,MatrixToMinimizeSecondOriginal,ErrorXobs_Xpred,ErrorYobs_Ypred,ElapseTime]=Matrix_to_Consider_LastFrame(xposPixelAfterRFID,yposPixelAfterRFID,OrientationAfterRFID,.....
                                  XPixelLastFrameAfter,YPixelLastFrameAfter,OrientationLastFrameAfter,velocityLastFrameXAfter,velocityLastFrameYAfter,TimeExp{countFrames},TimeExp{countFrames-1},...
                              Conversionx,Conversiony); 
             % Minimize the matrix

             [assignmentFSecond,~]=munkresForMiceTracer(MatrixToMinimizeSecond); 
             % Do again the assignment
          
           
             
             for countAssigment=1:length(assignmentFSecond) 
                 % ------------------Do assignment but take into account
                 % that a big value in the matrix means no position
                 % determination if last and next frame different from 1e6
                 % but the proposed position is incorrect because of segmentation
                   ErrorAsignment(IsubAfterRFID(countAssigment))= MatrixToMinimizeSecond(assignmentFSecond(countAssigment),countAssigment);
%                    ErrorFXobs_Xpred(IsubAfterRFID(countAssigment))=ErrorXobs_Xpred(assignmentFSecond(countAssigment),countAssigment);
%                    ErrorFYobs_Ypred(IsubAfterRFID(countAssigment))=ErrorYobs_Ypred(assignmentFSecond(countAssigment),countAssigment);
                 
                    XAssignment(IsubAfterRFID(countAssigment))=xposAfterRFID(assignmentFSecond(countAssigment));
                    YAssignment(IsubAfterRFID(countAssigment))=yposAfterRFID(assignmentFSecond(countAssigment));
                    XAssignmentPixel(IsubAfterRFID(countAssigment))=xposPixelAfterRFID(assignmentFSecond(countAssigment));
                    YAssignmentPixel(IsubAfterRFID(countAssigment))=yposPixelAfterRFID(assignmentFSecond(countAssigment));
                    OrientationAssignment(IsubAfterRFID(countAssigment))=OrientationAfterRFID(assignmentFSecond(countAssigment));
                

    
             end
 %% Create auxiliary matrix before assignment            
           XAssignmentBeforeCorrection=XAssignment;  
           YAssignmentBeforeCorrection=YAssignment;  
           XAssignmentPixelBeforeCorrection=XAssignmentPixel;  
           YAssignmentPixelBeforeCorrection=YAssignmentPixel;  
           [velocityBeforeCorrection,~,~]=VelocityCalculation(XAssignment,YAssignment,...
                    XLastFrame,YLastFrame,TimeExp{countFrames-1},TimeExp{countFrames});
           
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %--------Calculate velocity of the assignment through last frame------
    [velocity_aux,~,~]=VelocityCalculation(XAssignment(IsubAfterRFID),YAssignment(IsubAfterRFID),...
                    XLastFrameAfter,YLastFrameAfter,TimeExp{countFrames-1},TimeExp{countFrames});
             
   %----------------------Find the antenna with a velocity jump/nodefined last coord----------------------         
       IsubAfterRFID_HighVel=IsubAfterRFID((velocity_aux > VelocityThreshold) | (XLastFrameAfter'==1e+6 & YLastFrameAfter'==1e+6)); %Consider cases with higher velocity and not defined position
       IantennaLeft=setdiff(IndexArena,IsubAfterRFID_HighVel);
       XassignStep1=setdiff(XAssignment,XAssignment(IsubAfterRFID_HighVel),'stable');
       YassignStep1=setdiff(YAssignment,YAssignment(IsubAfterRFID_HighVel),'stable'); 
    %-------------Find the positions left--------------------- 
    if ~isempty(IsubAfterRFID_HighVel)%ADD
       [xposToassign2, yposToassign2,xposPixelToassign2,yposPixelToassign2,OrientationToassign2]=DetectNoAssignedPositions(XassignStep1,YassignStep1,xpos,ypos,xposPixel,yposPixel,Orientation);%ADD
           
    end      %ADD              
    %------------------------------Do new assignment with antenna----------------------------          
      if ~isempty(IsubAfterRFID_HighVel)  %ADD
         TimeInitial=TimeExp{countFrames-1};
         TimeFinal=TimeExp{countFrames};
         SubAntennaNum=AntennaNumber(IndexArena(IsubAfterRFID_HighVel),1);
         SubDeltaRFID=DeltaTimeRFID(IndexArena(IsubAfterRFID_HighVel),1);
         [assignmentF1,DistanceMatrix1]=AntennaAssignment(xposToassign2, yposToassign2,AntennaCoord(SubAntennaNum,1),AntennaCoord(SubAntennaNum,2),MaxRFIDDistance,DeltaFrame,SubDeltaRFID);
         %--------------------------Null this on august-----------------------------
            for countAssigment=1:length(assignmentF1)   
                XAssignment(IsubAfterRFID_HighVel(countAssigment))=xposToassign2(assignmentF1(countAssigment));
                YAssignment(IsubAfterRFID_HighVel(countAssigment))=yposToassign2(assignmentF1(countAssigment));
                XAssignmentPixel(IsubAfterRFID_HighVel(countAssigment))=xposPixelToassign2(assignmentF1(countAssigment));
                YAssignmentPixel(IsubAfterRFID_HighVel(countAssigment))=yposPixelToassign2(assignmentF1(countAssigment));
                OrientationAssignment(IsubAfterRFID_HighVel(countAssigment))=OrientationToassign2(assignmentF1(countAssigment));
             end  %ADD
             
                  %Rectify the cases  which cannot say nothing with
             %antennna.Cannot be in general that the mouse is detected
             %before it is on the antenna only in leakeage.
             %according to delta time%ADD
%              if (XLastFrameAfter'==1e+6 & YLastFrameAfter'==1e+6 & SubsetSignTimeRFIDAfter<0)
%                  InonDefined=(XLastFrameAfter'==1e+6 & YLastFrameAfter'==1e+6 & SubsetSignTimeRFIDAfter<0);
%                  XAssignment(InonDefined)=1e+6;
%                  YAssignment(InonDefined)=1e+6;
%                  XAssignmentPixel(InonDefined)=1e+6;
%                  YAssignmentPixel(InonDefined)=1e+6;
%                  OrientationAssignment(InonDefined)=1e+6;
%              end %ADD
        %---------------------------1------------------------------------  
      % Check if the assignment is good
        [ XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,OrientationAssignment]=PositionCorrection(IsubAfterRFID_HighVel,...
                                      XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,OrientationAssignment,...
                                   XLastFrame,YLastFrame,assignmentF1,DistanceMatrix1,TimeInitial,TimeFinal,...
                                     VelocityThreshold,MaxDistanceToleranceRFID,SubDeltaRFID,DeltaFrame);
     
     
      end %ADD


          end
        
          
          
    end     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  
     %% --------------------------Add a final vector of velocity for final control--------------------
   if countFrames>1
    
    IindicateNoSureCoord=zeros(1,length(IndexArena));
    [IindicateNoSureCoord,velocityFinal,velocityX,velocityY]=CheckingValidityFinal(countFrames,XAssignment,YAssignment,.....
                      XLastFrame,YLastFrame,TimeExp{countFrames-1},TimeExp{countFrames},NoSureSignalLastFrame,....
                      VelocityThreshold,IindicateNoSureCoord,VelLastFrame,FactorAcceleration,IndexRightWithRFID,...
                      OrientationLastFrame,OrientationAssignment,MinimumAngleTolerance);
   
   else
      velocityFinal=zeros(size(IndexArena,1),1);  
      velocityX=zeros(size(IndexArena,1),1); 
      velocityY=zeros(size(IndexArena,1),1);
   end
  %% Given the assignment create a vector to determine if the position belongs to some cluster
  % loop each assignment
  VectorCluster=zeros(1,length(XAssignment));
 for ic=1:length(XAssignment)
      
   %no consider changes in coord 
      if XAssignment(ic)~=1e6 
        
              VectorCluster(ic)=Clusters(find(xpos==XAssignment(ic)& ypos==YAssignment(ic),1,'first'));  
          

       end
  
  
 end
end