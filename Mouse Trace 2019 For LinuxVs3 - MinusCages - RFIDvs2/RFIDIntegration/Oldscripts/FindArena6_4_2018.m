function  [FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP,FidelityMatrix,FidelityVelocity,FidelityForNonCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,velocityMAll]=FindArena(TimeExp,FidelityMatrix,FidelityVelocity, FidelityForNonCoord,countFrames,DeltaTimeRFID,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,AntennaNumber,IndexArena,Position,AntennaCoord,CoordinatesFinalMice, CoordinatesFinalMiceMM,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP)
%This function find the coordinates of the mouse in the arena.
%% Variable
NoDetectionTime=80; %There are not detection for the antennas to larger times the units are in ms-last value 80
ThresholdRFIDDistance=57; %mm  units diameter antenna
PositionToChange=Position;
ThresholdVelocity=200;
Arena_length=1139;

%% Select the antenna inside the arena
SubsetAntennaNumber=AntennaNumber(IndexArena,1);
SubsetDeltaTimeRFID=DeltaTimeRFID(IndexArena,1);
Iindicate_uniqueAntenna=zeros(size(SubsetAntennaNumber,1),1);
Iindicate_duplicateAntenna=zeros(size(SubsetAntennaNumber,1),1);

%% Get the antenna which are and aren't unique.
[~,ind]=unique(SubsetAntennaNumber,'stable');

SubsetAntennaNumberDuplicate=SubsetAntennaNumber(setdiff(1:size(SubsetAntennaNumber,1),ind));%This gives the antenna number which are duplicated
SubsetAntennaNumberDuplicate=unique(SubsetAntennaNumberDuplicate); %This gives only one number for each duplicate
[SubsetAntennaNumberUnique,id]=setdiff(SubsetAntennaNumber,SubsetAntennaNumberDuplicate,'stable'); %This gives the antenna number which are unique


%% %% Sometimes segmentation adds positions. But if all the antenna are unique, it could be that there are repeated positions then
if ~isempty(SubsetAntennaNumberUnique)& isempty(SubsetAntennaNumberDuplicate)
 PositionToChange=unique(PositionToChange,'rows','stable');


end

%% ----------------------------------BEGIN CALCULATION -----------------------
%% First Create a matrix in which the column are mice , and the rows are positions. Calculate the distance between each antenna and the given positions.
%Here consider all the antennas.
     assignment=[];
     FinalDistance=[];
     velocityMAll=[];
    %find the antenna coordinate
    AntennaX=AntennaCoord(SubsetAntennaNumber,1);
    AntennaY=AntennaCoord(SubsetAntennaNumber,2);
    
    %The number of mice for the antenna in the arena
    Imouse=IndexArena;
    %% 
 % %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculate assignment of positions according to distance from the antenna %%%%%%%%%%%%%%%%%%%%%%%%%  
  %% If the number of antenna is more than the positions (this means that there are non defined positions) add rows with 1e6 value.
 if length(PositionToChange(:,4)) < length(AntennaX)
  
      PositionToChange(length(PositionToChange(:,4))+1:length(AntennaX),2:5)=1e6;
      
 end
 
 
    %Arrange distance from antenna into a matrix
   Distance_Matrix= ArrangeMatrix_ForDistance(PositionToChange(:,4),PositionToChange(:,5),AntennaX,AntennaY);
    
   %Assign to each antenna the minimum distance in such a way that the sum
   %is minimum and each antenna receive a different assignment,application
   %of hungariam algoritm
   
   [assignment,FinalDistance]=munkresForMiceTracer(Distance_Matrix);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   
       
        %%  % %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculate assignment of positions according to distance from the last frame %%%%%%%%%%%%%%%%%%%%%%%%%  
 if countFrames~=1
       
     
        %Arrange distance from antenna into a matrix
        Distance_FromLastFrame= ArrangeMatrix_ForDistance(PositionToChange(:,4),PositionToChange(:,5),(CoordinatesFinalMiceMM(countFrames-1,2*Imouse-1))',(CoordinatesFinalMiceMM(countFrames-1,2*Imouse))');
    
        %Assign to each antenna the minimum distance in such a way that the sum
        %is minimum and each antenna receive a different assignment,application
        %of hungariam algoritm
   
        [assignmentF,FinalDistanceF]=munkresForMiceTracer(Distance_FromLastFrame);
        
       Velocity_ForEachPosition= Velocity_Calculation(TimeExp,countFrames,FinalDistanceF);
       
       %create vector with non defined positions for the last or previous
       %frame
       
       Ilogical_lastframe_withNonDefCoord=Find_lastframe_withNonDefCoord(CoordinatesFinalMiceMM(countFrames-1,2*Imouse-1),CoordinatesFinalMiceMM(countFrames-1,2*Imouse));
       
       
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 end  
   %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%Create a vector of uniqness/duplicates with the antenna in the arena%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   Iindicate_uniqueAntenna(id,1)=1;
   iddouble=setdiff(1:size(SubsetAntennaNumber,1),id,'stable')
   Iindicate_duplicateAntenna(iddouble,1)=1;
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   %% 
   
  
   
   %Find the feasibility of the assigment
%    FidelityMatrix=Find_fidelity(countFrames,FidelityMatrix,Imouse,Iindicate_uniqueAntenna,SubsetDeltaTimeRFID,FinalDistance,ThresholdRFIDDistance,NoDetectionTime);
   
   %Assign position. Without evalution for the first frame
   if countFrames==1
        
             Coordinatesx(Imouse,1)=PositionToChange(assignment,4);
             Coordinatesy(Imouse,1)=PositionToChange(assignment,5);
             CoordinatesxP(Imouse,1)=PositionToChange(assignment,2);
             CoordinatesyP(Imouse,1)=PositionToChange(assignment,3);
   else%there is a series of exceptions

       
       IndexMice=[];
            IndexPosition=[];
            ImouseLeftSecond=[];
            ImouseLeft=[];
            ImouseLeftUnique=[];
            IndexMiceSecond=[];
            IndexPositionSecond=[];
            IndexMiceThird=[];
            IndexPositionThird=[];
            IndexMiceSecondNonDefined=[];
            
            %iF THERE ARE COINCIDENCE IN THE ASSIGNMENT BETWEEN DISTANCE FROM ANTENNA OR FROM
            %LAST FRAME
            [IndexMice,IndexPosition,IndexMiceNonDefined,IndexMiceNonDefined1,Ilogical_ForSecondStep]=FindIndex_FirstStep(FinalDistance,Imouse,assignment,assignmentF,Iindicate_uniqueAntenna,Velocity_ForEachPosition,ThresholdVelocity,Ilogical_lastframe_withNonDefCoord);
           
            
            
             Coordinatesx(IndexMice,1)=PositionToChange(IndexPosition,4);
             Coordinatesy(IndexMice,1)=PositionToChange(IndexPosition,5);
             CoordinatesxP(IndexMice,1)=PositionToChange(IndexPosition,2);
             CoordinatesyP(IndexMice,1)=PositionToChange(IndexPosition,3);
             
             
             Coordinatesx(IndexMiceNonDefined,1)=1e6;
             Coordinatesy(IndexMiceNonDefined,1)=1e6;
             CoordinatesxP(IndexMiceNonDefined,1)=1e6;
             CoordinatesyP(IndexMiceNonDefined,1)=1e6;
             
             
             
              Coordinatesx(IndexMiceNonDefined1,1)=1e6;
             Coordinatesy(IndexMiceNonDefined1,1)=1e6;
             CoordinatesxP(IndexMiceNonDefined1,1)=1e6;
             CoordinatesyP(IndexMiceNonDefined1,1)=1e6;
             
             %Eliminate the positions done
             %% 
             
             if any(Ilogical_ForSecondStep) & any(Ilogical_lastframe_withNonDefCoord)
                                     %Consider the cases in which the previous event was undefined thus the next event must be defined by the antenna
                                     %here we add the  fidelity matrix future use
                                    [IndexMiceSecond,IndexPositionSecond,IndexMiceSecondNonDefined]=FindIndex_SecondStep(FinalDistance,Ilogical_lastframe_withNonDefCoord,assignment,Imouse,Iindicate_uniqueAntenna,Ilogical_ForSecondStep);
                                                                                     
                                      Coordinatesx(IndexMiceSecond,1)=PositionToChange(IndexPositionSecond,4);
                                      Coordinatesy(IndexMiceSecond,1)=PositionToChange(IndexPositionSecond,5);
                                      CoordinatesxP(IndexMiceSecond,1)=PositionToChange(IndexPositionSecond,2);
                                      CoordinatesyP(IndexMiceSecond,1)=PositionToChange(IndexPositionSecond,3);
                                      
                                     Coordinatesx(IndexMiceSecondNonDefined,1)=1e6;
                                    Coordinatesy(IndexMiceSecondNonDefined,1)=1e6;
                                    CoordinatesxP(IndexMiceSecondNonDefined,1)=1e6;
                                    CoordinatesyP(IndexMiceSecondNonDefined,1)=1e6;
                                      
                                      FidelityMatrix(countFrames,IndexMiceSecond)=2; %This means that the position isnt not sure completely refine this
                                     
             end   
             %% CASES IN WHICH THE ASSIGMENT DIFFER BETWEEN DISTANCE OF ANTENNA AND DISTANCE FROM THE LAST FRAME
             %First consider unique antenna
           
             
             %% Associate the mice which left to assign
             AntennaX=[];
             AntennaY=[];
             [ImouseLeft,PositionToChangeLeft,ImouseLeftUnique]=Find_MiceAndPosition_to_Assign(AntennaNumber,SubsetAntennaNumberUnique,PositionToChange,Imouse,[IndexMice;IndexMiceNonDefined;IndexMiceSecond;IndexMiceSecondNonDefined],[IndexPosition';IndexPositionSecond']);
             AntennaX=AntennaCoord(AntennaNumber(ImouseLeft,1),1);
             AntennaY=AntennaCoord(AntennaNumber(ImouseLeft,1),2);
             
            if ~isempty(ImouseLeft) 
             
                   %calculate again the distance from the antenna to the position of the left data
                   Distance_FromAntenna_Second=ArrangeMatrix_ForDistance(PositionToChangeLeft(:,4),PositionToChangeLeft(:,5),AntennaX,AntennaY);
                  
                   %calculate the optimal distance  
                   [assignment_Second,FinalDistance_Second]=munkresForMiceTracer(Distance_FromAntenna_Second);
                  
                   %% Consider unique antenna in which the position given by the antenna is sure.
             
                        if ~isempty(ImouseLeftUnique)
                     
                                %Find the dist from antenna which are sure for unique %antenna -These are the cases in which the %position is fixed by antenna since %mice was on the arena, in a reasonable
                                %time
                     
                                      [IndexMiceThird,IndexPositionThird]=FindIndex_ThirdStep(assignment_Second,FinalDistance_Second,ImouseLeft,ImouseLeftUnique,DeltaTimeRFID,ThresholdRFIDDistance,NoDetectionTime);
                     
                                      Coordinatesx(IndexMiceThird,1)=PositionToChangeLeft(IndexPositionThird,4);
                                      Coordinatesy(IndexMiceThird,1)=PositionToChangeLeft(IndexPositionThird,5);
                                      CoordinatesxP(IndexMiceThird,1)=PositionToChangeLeft(IndexPositionThird,2);
                                      CoordinatesyP(IndexMiceThird,1)=PositionToChangeLeft(IndexPositionThird,3);
                     
                 
                        end
                        %% Consider unique antenna in which the position given by the antenna is not sure.
                      %% Associate the mice which left to assign
                         [ImouseLeftSecond,PositionToChangeLeftSecond,ImouseLeftUniqueSecond]=Find_MiceAndPosition_to_Assign(AntennaNumber,SubsetAntennaNumberUnique,PositionToChange,Imouse,[IndexMice;IndexMiceNonDefined;IndexMiceSecond;IndexMiceSecondNonDefined;IndexMiceThird],[IndexPosition';IndexPositionSecond';IndexPositionThird']);
                    
                          %Arrange distance from antenna into a matrix
                         Distance_FromLastFrame_Second= ArrangeMatrix_ForDistance(PositionToChangeLeftSecond(:,4),PositionToChangeLeftSecond(:,5),(CoordinatesFinalMiceMM(countFrames-1,2*ImouseLeftSecond-1))',(CoordinatesFinalMiceMM(countFrames-1,2*ImouseLeftSecond))');
                         
                       if ~isempty(ImouseLeftSecond)  
                         %calculate the optimal distance  
                                 [assignmentF_Second,FinalDistanceF_Second]=munkresForMiceTracer(Distance_FromLastFrame_Second);
                        
                                    Velocity_ForEachPositionF= Velocity_Calculation(TimeExp,countFrames,FinalDistanceF_Second);
                         
                        
                     
                                %
                                if ~isempty(ImouseLeftUniqueSecond)
                                    
                                     [IndexMiceFour,IndexPositionFour,IndexMiceNonDefinedFour]=FindIndex_FourStep(ImouseLeftSecond,ImouseLeftUniqueSecond,assignmentF_Second,Velocity_ForEachPositionF,ThresholdVelocity);
                                    
                                    
                                     Coordinatesx(IndexMiceFour,1)=PositionToChangeLeftSecond(IndexPositionFour,4);
                                      Coordinatesy(IndexMiceFour,1)=PositionToChangeLeftSecond(IndexPositionFour,5);
                                      CoordinatesxP(IndexMiceFour,1)=PositionToChangeLeftSecond(IndexPositionFour,2);
                                      CoordinatesyP(IndexMiceFour,1)=PositionToChangeLeftSecond(IndexPositionFour,3);
                                      
                                      Coordinatesx(IndexMiceNonDefinedFour,1)=1e6;
                                      Coordinatesy(IndexMiceNonDefinedFour,1)=1e6;
                                      CoordinatesxP(IndexMiceNonDefinedFour,1)=1e6;
                                      CoordinatesyP(IndexMiceNonDefinedFour,1)=1e6;
                                      
                                      
                     
                                end
                                
                                %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Working with double %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                % Looping over each repeated antennna.
                                % %%%%%%%%%%%%%%%%%%
                       if ~isempty( SubsetAntennaNumberDuplicate)        
                                for count=1:size(SubsetAntennaNumberDuplicate,1)
                                    

                                    
                                    
                                    IndexDuplicate=FindValues_InsideList(AntennaNumber(ImouseLeftSecond,1),SubsetAntennaNumberDuplicate(count));
                                  
                                  IDuplMouse=ImouseLeftSecond(IndexDuplicate);%then number of mouse with duplicate
                                    
                                  %Calculate coordinate of the last Frame
                                  
                                  xDupLastFrame=(CoordinatesFinalMiceMM(countFrames-1,2*IDuplMouse-1))';
                                  
                                  yDupLastFrame=(CoordinatesFinalMiceMM(countFrames-1,2*IDuplMouse))';
                                  
                                  %calculate new position assignment
                                  
                                  xPosition_ForDup=PositionToChangeLeftSecond(assignmentF_Second(IndexDuplicate),4);
                                  
                                  yPosition_ForDup=PositionToChangeLeftSecond(assignmentF_Second(IndexDuplicate),5);
                                  
                                  xPositionP_ForDup=PositionToChangeLeftSecond(assignmentF_Second(IndexDuplicate),2);
                                  
                                  yPositionP_ForDup=PositionToChangeLeftSecond(assignmentF_Second(IndexDuplicate),3);
                                  
                                  %calculate velocity
                                    velocity_ForDup=Velocity_ForEachPositionF(IndexDuplicate);
                                    
                                    %calculate distance to the antenna
                                   distanceToAntenna=DistCalc(xPosition_ForDup,yPosition_ForDup,AntennaCoord(AntennaNumber(IDuplMouse),1),AntennaCoord(AntennaNumber(IDuplMouse),2));
                                  
                                    [FidelityMatrix,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=Find_Coord_For_RepeatedAntenna(IDuplMouse,xDupLastFrame,yDupLastFrame,xPosition_ForDup,yPosition_ForDup,xPositionP_ForDup,yPositionP_ForDup,velocity_ForDup,FidelityMatrix,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,ThresholdVelocity,distanceToAntenna);
                                end
                          end      
                                
                                
                                
                                
                                
                                
                                
                                
                 
                        end
                    
                    
             
            end
     
            
            
            
             
             %% Detect where the coordinates are million inside the arena then save for later use a matrix indicating where including the coordinates which where not used.
             
             
             if ~isempty(find(Coordinatesx(Imouse,1)==1e6)) %only for non defined mice
                 
               [FidelityForNonCoord,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP]=Find_Non_solved_values(countFrames,FidelityForNonCoord,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP,Coordinatesx,PositionToChange);
             end
             %% Add 2 vectors one for velocity  and one which tell when the velocity is higher than 200cm/sec
            %order coordmm in a column of x and y
            
           a=CoordinatesFinalMiceMM(countFrames-1,1:2:(size(CoordinatesFinalMiceMM,2)-1));
           b=CoordinatesFinalMiceMM(countFrames-1,2:2:(size(CoordinatesFinalMiceMM,2)));
            
            
            %calculate the dist with DistCalc
            distanceAll=DistCalc(Coordinatesx,Coordinatesy,a',b');
            
            velocityMAll= Velocity_Calculation(TimeExp,countFrames,distanceAll);
            
             %Create a matrix which account for the velocity jumping and discard the cases in which the coord was not defined before or after -which
             %means a change in identity
             
             FidelityVelocity(countFrames,:)=(velocityMAll > 180 & a' < 1e6 & Coordinatesx < 1e6)';
            
        end
   
    
   
     
       
         
       
   end
   
    





