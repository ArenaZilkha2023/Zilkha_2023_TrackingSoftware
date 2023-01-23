function [ErrorFXobs_Xpred,ErrorFYobs_Ypred,IpositionArenaDueToAntenna,VectorCluster,XAssignment,YAssignment, XAssignmentPixel,YAssignmentPixel,IindicateNoSureCoord,OrientationAssignment,velocityFinal,velocityX,velocityY]=FindArena(IndexArena,AntennaNumber,AntennaCoord,DeltaTimeRFID,countFrames,....
                   xposPixel,yposPixel,xpos,ypos,MaxRFIDDistance,DeltaFrame,......
                   Orientation,OrientationLastFrame,XPixelLastFrame,YPixelLastFrame,XLastFrame,YLastFrame,...
                   TimeExp,VelocityThreshold,VelLastFrame, NoSureSignalLastFrame,FactorAcceleration,MinimumAngleTolerance,...
                   MaxDistanceToleranceRFID,velocityLastFrameX,velocityLastFrameY,...
                   Conversionx,Conversiony,Clusters,ErrorThreshold,...
                   XErrorXobs_predLastFrame,YErrorYobs_predLastFrame,Corn,WidthArena)
%This function find the coordinates of the mouse in the arena a vector 
%% Variables
 DistanceAssignment=[];
  XAssignment=[];
  YAssignment=[];
  XAssignmentPixel=[];
  YAssignmentPixel=[];
  OrientationAssignment=[];
  IndexE=[]
  ErrorFXobs_Xpred=zeros(1,length(IndexArena));
  ErrorFYobs_Ypred=zeros(1,length(IndexArena));
  ErrorAsignment=zeros(1,length(IndexArena));
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
                   ErrorFXobs_Xpred(IsubAfterRFID(countAssigment))=ErrorXobs_Xpred(assignmentFSecond(countAssigment),countAssigment);
                   ErrorFYobs_Ypred(IsubAfterRFID(countAssigment))=ErrorYobs_Ypred(assignmentFSecond(countAssigment),countAssigment);
                 
                    XAssignment(IsubAfterRFID(countAssigment))=xposAfterRFID(assignmentFSecond(countAssigment));
                    YAssignment(IsubAfterRFID(countAssigment))=yposAfterRFID(assignmentFSecond(countAssigment));
                    XAssignmentPixel(IsubAfterRFID(countAssigment))=xposPixelAfterRFID(assignmentFSecond(countAssigment));
                    YAssignmentPixel(IsubAfterRFID(countAssigment))=yposPixelAfterRFID(assignmentFSecond(countAssigment));
                    OrientationAssignment(IsubAfterRFID(countAssigment))=OrientationAfterRFID(assignmentFSecond(countAssigment));
                

    
             end
             
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  % Try to correct the position assigned when the error between measured and predicted is very large.This happen in an incorrect assignment due to incorrect segmentation
%              % instead of on the mice. Thus the position will be predect.
%               
%              
%              [ XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,IndexE,OrientationAssignment]=CorrectionErrorSegmentation(ErrorAsignment,IsubAfterRFID, XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,OrientationAssignment,ErrorThreshold,...
%                                        XPixelLastFrame,YPixelLastFrame,XLastFrame,YLastFrame, Conversionx,Conversiony,...
%                                        velocityLastFrameX,velocityLastFrameY,ElapseTime,XErrorXobs_predLastFrame,YErrorYobs_predLastFrame,Corn,WidthArena,OrientationLastFrame);
             

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             
             
             
             
             
             

             

          end

          
          
    end     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
   
   %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CORRECTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % 1)- Suppose that one wrong position was added by segmentation and
   % another position dissapeared mainly under  the eat holder. In addition the last position is defined-thus
   % evaluate velocity if it is larger two times the threshold velocity
   % -all the assignment are considered not defined
%  
% if countFrames~=1
%    IndexForNonDefined= zeros(size(IndexArena,1),1); 
%    IndexForNonDefined=(velocityFinal > 700) & (XLastFrame'<1e+6); %HERE APPLY CONDITION
%    if any(IndexForNonDefined)
%     XAssignment(IndexForNonDefined)=1e+6;
%     YAssignment(IndexForNonDefined)=1e+6;
%     XAssignmentPixel(IndexForNonDefined)=1e+6;
%     YAssignmentPixel(IndexForNonDefined)=1e+6;
%     OrientationAssignment(IndexForNonDefined)=1e+6;
%    end
% end   

%% 2)- % 1)- Suppose that one wrong position was added by segmentation and
   % another position dissapeared mainly under  the eat holder.In addition last position is not defined-thus
   % evaluate the distance to correspondence antenna. If the distance is
   % larger the position isn't correct.
   % -all the assignment are considered not defined
   %if countFrames~=1
%   IndexForNonDefinedLastFrameMouse=find(XLastFrame==1e+6 & XAssignment~=1e+6); 
%   if ~isempty( IndexForNonDefinedLastFrameMouse)   
%        
%        for counti=1:length(IndexForNonDefinedLastFrameMouse)
%            x=XAssignment(IndexForNonDefinedLastFrameMouse(counti));
%            y=YAssignment(IndexForNonDefinedLastFrameMouse(counti));
%            Indexposition=find(xpos==x & ypos==y);
%            
%             if DistanceMatrix(Indexposition,IndexForNonDefinedLastFrameMouse(counti))>MaxDistanceToleranceRFID %check the distance to the respective antenna
%                 XAssignment(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
%                 YAssignment(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
%                 XAssignmentPixel(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
%                 YAssignmentPixel(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
%                 OrientationAssignment(IndexForNonDefinedLastFrameMouse(counti))=1e+6;
%        
%             end
%       end
% 
%    end

   %% -----------------Correct the assignment when the position of the last frame is undefined 1e6-----------------
%    % ---------------Recalculate the distance from the antenna-------------------------------
%   if countFrames~=1 & ~isempty(find(XLastFrame==1e+6))%& length(find(XLastFrame==1e+6))>1
% 
%       [IndexMouse,xNew,yNew,xNewPixel,yNewPixel,OrientationNew]=RecalculateIfLastPosNoDefine(XLastFrame,YLastFrame,XAssignment,YAssignment,xpos,ypos,xposPixel,yposPixel,Orientation,AntennaX,AntennaY,MaxDistanceToleranceRFID);
%        if ~isempty(IndexMouse)
%             XAssignment(IndexMouse)=xNew;
%             YAssignment(IndexMouse)=yNew;
%             XAssignmentPixel(IndexMouse)=xNewPixel;
%             YAssignmentPixel(IndexMouse)=yNewPixel;
%             OrientationAssignment(IndexMouse)=OrientationNew;
%           %correct the assigment
%           Iaux1=find(xNew==1e+6);
%           Iaux2=find(xNew~=1e+6);
%           IindicateNoSureCoord(IndexMouse(Iaux1))=1;
%           IindicateNoSureCoord(IndexMouse(Iaux2))=0;
%            
%        end
% 
%   
%   end

% Consider




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Consider the antenna which has entire column non  defined thus no position was assigned yet.%%%%%%%%%%%%
%loop over each antenna
          if countFrames~=1  & any(IindicateNoSureCoord) 
               recordsNoDefined=[];
               ic=1;
               for countaux1=1:size(MatrixToMinimizeSecond,2)
                  Ilogaux=(MatrixToMinimizeSecond(:,countaux1)==1e6 ); 
                  if isempty(find(Ilogaux==0))% all the column is 1e6 
                    recordsNoDefined(ic)=IsubAfterRFID(countaux1); 
                    
                    XAssignment(recordsNoDefined(ic))=1e6;
                    YAssignment(recordsNoDefined(ic))=1e6;
                    XAssignmentPixel(recordsNoDefined(ic))=1e6;
                    YAssignmentPixel(recordsNoDefined(ic))=1e6;
                    OrientationAssignment(recordsNoDefined(ic))=1e6;
                    
                    ic=ic+1;
                  end 
                   
               end
               if ~isempty(recordsNoDefined)
                   
                    [IndexMouse,xNew,yNew,xNewPixel,yNewPixel,OrientationNew]=RecalculatePosition(recordsNoDefined,XAssignment,YAssignment,xpos,ypos,xposPixel,yposPixel,Orientation,AntennaX,AntennaY,MaxDistanceToleranceRFID);
                   
                      if ~isempty(IndexMouse)
                            XAssignment(IndexMouse)=xNew;
                            YAssignment(IndexMouse)=yNew;
                            XAssignmentPixel(IndexMouse)=xNewPixel;
                             YAssignmentPixel(IndexMouse)=yNewPixel;
                             OrientationAssignment(IndexMouse)=OrientationNew;
                            %correct the assigment
                            Iaux1=find(xNew==1e+6);
                            Iaux2=find(xNew~=1e+6);
                            IindicateNoSureCoord(IndexMouse(Iaux1))=1;
                            IindicateNoSureCoord(IndexMouse(Iaux2))=0;
           
                      end
               end
          end   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  
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
        
              VectorCluster(ic)=Clusters(find(xpos==XAssignment(ic)& ypos==YAssignment(ic),1,'first'))  
          

       end
  
  
end