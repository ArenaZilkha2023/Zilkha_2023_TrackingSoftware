function  [ XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,OrientationAssignment]=PositionCorrection(Index,...
                                       XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,OrientationAssignment,...
                                       XLastFrame,YLastFrame,assignmentF1,DistanceMatrix1,TimeInitial,TimeFinal,...
                                       VelocityThreshold,MaxDistanceToleranceRFID,SubDeltaRFID,DeltaFrame)
%%
                                   
% The idea is to verify if the antenna choice is correct.
% We consider 2 cases one with last frame defined. Then consider the
% velocity to accept the assignment.
% Second case : no defined last frame. if the distance from antenna is less
% thant a given value . It is correct
% --------------------Bring information about the cages if there are cages
% Spetial case for cages
global UpperCage
global DownCage

% ---------------------------1-------------------------------
 for count=1:length(Index) % do new prediction
     
   %----------------------------------2-----------------------------------------------  
   if  (XLastFrame(Index(count))~=1e+6 & YLastFrame(Index(count))~=1e+6)
       %--------Calculate velocity of the last subgroup assignment------
        [velocity_aux1,~,~]=VelocityCalculation(XAssignment(Index(count)),YAssignment(Index(count)),...
                    XLastFrame(Index(count)),YLastFrame(Index(count)),TimeInitial,TimeFinal); 
      if velocity_aux1 > VelocityThreshold %no define position
            XAssignmentPixel(Index(count))=1e+6;
             YAssignmentPixel(Index(count))=1e+6;
           XAssignment(Index(count))=1e+6;
          YAssignment(Index(count))=1e+6;
          OrientationAssignment(Index(count))=1e+6; 
      end
   else
    %if DistanceMatrix1(assignmentF1(count),count)>MaxDistanceToleranceRFID || (SubDeltaRFID(count)>3*DeltaFrame)
      if DistanceMatrix1(assignmentF1(count),count)>MaxDistanceToleranceRFID     
            XAssignmentPixel(Index(count))=1e+6;
             YAssignmentPixel(Index(count))=1e+6;
           XAssignment(Index(count))=1e+6;
          YAssignment(Index(count))=1e+6;
          OrientationAssignment(Index(count))=1e+6; 
          
           elseif ~isempty(UpperCage)& ~isempty(DownCage) %in the case there are cages
          xvUpper=[UpperCage(:,1);UpperCage(1,1)]; %prepare polygon of the cages
          yvUpper=[UpperCage(:,2);UpperCage(1,2)];
          xvDown=[DownCage(:,1);DownCage(1,1)];
          yvDown=[DownCage(:,2);DownCage(1,2)];
          
          inUpper=inpolygon(XAssignmentPixel(Index(count)),YAssignmentPixel(Index(count)),xvUpper,yvUpper);
          inDown=inpolygon(XAssignmentPixel(Index(count)),YAssignmentPixel(Index(count)),xvDown,yvDown);
               if DistanceMatrix1(assignmentF1(count),count)>MaxDistanceToleranceRFID/2.5 & or(inUpper,inDown) %if it is inside the cage then the assignment is not good
                       XAssignmentPixel(Index(count))=1e+6;
                       YAssignmentPixel(Index(count))=1e+6;
                       XAssignment(Index(count))=1e+6;
                        YAssignment(Index(count))=1e+6;
                        OrientationAssignment(Index(count))=1e+6; 
                   
                   
               end
          
          
      end
       
      
   end
% --------------------------1------------------------------
 end
end 

