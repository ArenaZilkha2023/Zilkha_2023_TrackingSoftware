function [XAssignment,YAssignment, XAssignmentPixel,YAssignmentPixel,IindicateNoSureCoord,OrientationAssignment,velocityFinal]=FindArena(IndexArena,AntennaNumber,AntennaCoord,DeltaTimeRFID,countFrames,....
                   xposPixel,yposPixel,xpos,ypos,MaxRFIDDistance,DeltaFrame,......
                   Orientation,OrientationLastFrame,XPixelLastFrame,YPixelLastFrame,XLastFrame,YLastFrame,...
                   TimeExp,VelocityThreshold,VelLastFrame, NoSureSignalLastFrame,FactorAcceleration,MinimumAngleTolerance,...
                   MaxDistanceToleranceRFID)
%This function find the coordinates of the mouse in the arena a vector 
%% Variables
 DistanceAssignment=[];
  XAssignment=[];
  YAssignment=[];
  XAssignmentPixel=[];
  YAssignmentPixel=[];
  OrientationAssignment=[];
  
%% ------- Select the antenna inside the arena which are unique and duplicate duplicate-----------------
SubsetAntennaNumber=AntennaNumber(IndexArena,1);
SubsetDeltaTimeRFID=DeltaTimeRFID(IndexArena,1);
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
     end
   % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create a vector to know the cetainty of the data%%%%%%%%%%%%%%%%%%%%  
    Ilogical=(DistanceAssignment'<MaxRFIDDistance)& ((DeltaRFIDaux(1,:))'<DeltaFrame)& Iindicate_uniqueAntenna ;
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
                NoSureSignalLastFrame=NoSureSignalLastFrame(IndexArena); 
                
    end           
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
 %% ----------------Correction of the situations in which last positions weren't undefined.------------
 % %% Have 2 situations one that the antenna report is considered as right
 % when the distance from the antenna is reasonable although is not
 % satisfied the conditions above and the other case that of sure the
 % distance is so large that the position must be again undefined.
   if countFrames~=1
        IndexForNonDefinedLastFrameMouse=find(XLastFrame==1e+6 & XAssignment~=1e+6); 
    if ~isempty( IndexForNonDefinedLastFrameMouse)     
       for counti=1:length(IndexForNonDefinedLastFrameMouse)
           x=XAssignment(IndexForNonDefinedLastFrameMouse(counti));
           y=YAssignment(IndexForNonDefinedLastFrameMouse(counti));
           Indexposition=find(xpos==x & ypos==y);
           
            if DistanceMatrix(Indexposition,IndexForNonDefinedLastFrameMouse(counti))>MaxDistanceToleranceRFID %check the distance to the respective antenna
                XAssignment(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
                YAssignment(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
                XAssignmentPixel(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
                YAssignmentPixel(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
                OrientationAssignment(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
                IindicateNoSureCoord(IndexForNonDefinedLastFrameMouse(counti))=1;
            else
                IindicateNoSureCoord(IndexForNonDefinedLastFrameMouse(counti))=0; % although is not defined in the last frame, it is considered sure
            end
       end

      end
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % Checking the validity of positions which were considered sure%%%%%%%%%%%%%%%%%%%%%%
 if countFrames>1
        if ~isempty(find(IindicateNoSureCoord==0)) % this is done only with sure candidates  coordinates
          IindicateNoSureCoord=CheckingValidity(countFrames,find(IindicateNoSureCoord==0),XAssignment(find(IindicateNoSureCoord==0)),YAssignment(find(IindicateNoSureCoord==0)),.....
                      XLastFrame(find(IindicateNoSureCoord==0)),YLastFrame(find(IindicateNoSureCoord==0)),...
                      TimeExp{countFrames-1},TimeExp{countFrames},NoSureSignalLastFrame,....
                      VelocityThreshold,IindicateNoSureCoord,VelLastFrame,FactorAcceleration,OrientationLastFrame(find(IindicateNoSureCoord==0)),OrientationAssignment(find(IindicateNoSureCoord==0)),MinimumAngleTolerance);
        end  
 
        
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
              indexX=ismember(xpos,XAssignment(find(IindicateNoSureCoord==1))); % return the xpos which aren't in Xassignment- The index is logical
              indexY=ismember(ypos,YAssignment(find(IindicateNoSureCoord==1))); % return the xpos which aren't in Xassignment-the index is logical
              xposAfterRFID=xpos(indexX & indexY);
              yposAfterRFID=ypos(indexX & indexY);
              xposPixelAfterRFID=xposPixel(indexX & indexY);
              yposPixelAfterRFID=yposPixel(indexX & indexY);
              OrientationAfterRFID=(Orientation(indexX & indexY));
              XPixelLastFrameAfter=XPixelLastFrame(IsubAfterRFID);
              YPixelLastFrameAfter=YPixelLastFrame(IsubAfterRFID);
              XLastFrameAfter=XLastFrame(IsubAfterRFID);
              YLastFrameAfter=YLastFrame(IsubAfterRFID);
%               OrientationLastFrameAfter=deg2rad(OrientationLastFrame(IsubAfterRFID));
              OrientationLastFrameAfter=(OrientationLastFrame(IsubAfterRFID));
              % Convert degrees into radians
              
            % Arrange Matrix with distance and orientations  
             [MatrixToMinimizeSecond,MatrixToMinimizeSecondOriginal]=Matrix_to_Consider_LastFrame(xposPixelAfterRFID,yposPixelAfterRFID,OrientationAfterRFID,.....
                                  XPixelLastFrameAfter,YPixelLastFrameAfter,OrientationLastFrameAfter); 
             % Minimize the matrix
                [assignmentFSecond,~]=munkresForMiceTracer(MatrixToMinimizeSecond); 
             % Do again the assignment

             for countAssigment=1:length(assignmentFSecond) 
                 % ------------------Do assignment but take into account
                 % that a big value in the matrix means no position
                 % determination if last and next frame different from 1e6
                 % but the proposed position is incorrect because of segmentation
                 
                 
                    XAssignment(IsubAfterRFID(countAssigment))=xposAfterRFID(assignmentFSecond(countAssigment));
                    YAssignment(IsubAfterRFID(countAssigment))=yposAfterRFID(assignmentFSecond(countAssigment));
                    XAssignmentPixel(IsubAfterRFID(countAssigment))=xposPixelAfterRFID(assignmentFSecond(countAssigment));
                    YAssignmentPixel(IsubAfterRFID(countAssigment))=yposPixelAfterRFID(assignmentFSecond(countAssigment));
                    OrientationAssignment(IsubAfterRFID(countAssigment))=OrientationAfterRFID(assignmentFSecond(countAssigment));
                
%                      %Arrange  the vector to know the cetainty of the data. Be sure that the position is different from 1e6 and the velocity is reasonable.
%                       velocity=VelocityCalculation(XAssignment(IsubAfterRFID(countAssigment)),....
%                                        YAssignment(IsubAfterRFID(countAssigment)),.....
%                                         XLastFrameAfter(countAssigment),YLastFrameAfter(countAssigment),...
%                                         TimeExp{countFrames-1},TimeExp{countFrames});
%                      
%                        % Arrange the indicator vector 
%                        if velocity <VelocityThreshold
%                            % If the condition is applied then the
%                            % assignment is sure
%                            IindicateNoSureCoord(IsubAfterRFID(countAssigment))=0; 
%                        end
    
             end

          end

          
          
    end     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% --------------------------Add a final vector of velocity for final control--------------------
   if countFrames>1
    
    IindicateNoSureCoord=zeros(1,length(IndexArena));
    [IindicateNoSureCoord,velocityFinal]=CheckingValidityFinal(countFrames,XAssignment,YAssignment,.....
                      XLastFrame,YLastFrame,TimeExp{countFrames-1},TimeExp{countFrames},NoSureSignalLastFrame,....
                      VelocityThreshold,IindicateNoSureCoord,VelLastFrame,FactorAcceleration,IndexRightWithRFID,...
                      OrientationLastFrame,OrientationAssignment,MinimumAngleTolerance);
   
   else
      velocityFinal=zeros(size(IndexArena,1),1);  
       
   end
   
   %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CORRECTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % 1)- Suppose that one wrong position was added by segmentation and
   % another position dissapeared mainly under  the eat holder. In addition the last position is defined-thus
   % evaluate velocity if it is larger two times the threshold velocity
   % -all the assignment are considered not defined
%  
if countFrames~=1
   IndexForNonDefined= zeros(size(IndexArena,1),1); 
   IndexForNonDefined=(velocityFinal > 700) & (XLastFrame'<1e+6); %HERE APPLY CONDITION
   if any(IndexForNonDefined)
    XAssignment(IndexForNonDefined)=1e+6;
    YAssignment(IndexForNonDefined)=1e+6;
    XAssignmentPixel(IndexForNonDefined)=1e+6;
    YAssignmentPixel(IndexForNonDefined)=1e+6;
    OrientationAssignment(IndexForNonDefined)=1e+6;
   end
end   

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
   %% 
   
   
   
   
  
end