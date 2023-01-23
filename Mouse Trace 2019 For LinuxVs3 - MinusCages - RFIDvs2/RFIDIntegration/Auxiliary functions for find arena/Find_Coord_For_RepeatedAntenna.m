function [FidelityMatrix,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=Find_Coord_For_RepeatedAntenna(IDuplMouse,xDupLastFrame,yDupLastFrame,xPosition_ForDup,yPosition_ForDup,xPositionP_ForDup,yPositionP_ForDup,velocity_ForDup,FidelityMatrix,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,ThresholdVelocity,distanceToAntenna)
%For treating duplicates
WidthArena=1139; %in mm units
%% Consider different positions in the actual assignment and in the last frame thus the assigment with the minimal distance is accepted. 
%But check velocity if velocity >200 discard the data
if length(unique([xPosition_ForDup,yPosition_ForDup],'rows'))==size(xPosition_ForDup,1) %different coord
     if length(unique([xDupLastFrame,yDupLastFrame],'rows'))==size(xDupLastFrame,1) %different coord for last frame
         
                                     IDupDefined=find(velocity_ForDup < ThresholdVelocity);
                                     %this includes cases in which the
                                     %coord was not  defined in the last
                                     %frame
                                    IDupDefined1=find((velocity_ForDup' > ThresholdVelocity) & (distanceToAntenna < WidthArena/3));
                                    
                                    IDupNonDefined=find((velocity_ForDup' > ThresholdVelocity) & (distanceToAntenna > WidthArena/3));
                                     
%% 

                                      %Define if the new position is true
                                      %or not
                                      
                                      
                                      
                                      
                                      %% 
                                      
                                      

         
                                      Coordinatesx(IDuplMouse(IDupDefined),1)=xPosition_ForDup(IDupDefined);
                                      Coordinatesy(IDuplMouse(IDupDefined),1)=yPosition_ForDup(IDupDefined);
                                      CoordinatesxP(IDuplMouse(IDupDefined),1)=xPositionP_ForDup(IDupDefined);
                                      CoordinatesyP(IDuplMouse(IDupDefined),1)=yPositionP_ForDup(IDupDefined);
                                      
                                      
                                      Coordinatesx(IDuplMouse(IDupDefined1),1)=xPosition_ForDup(IDupDefined1);
                                      Coordinatesy(IDuplMouse(IDupDefined1),1)=yPosition_ForDup(IDupDefined1);
                                      CoordinatesxP(IDuplMouse(IDupDefined1),1)=xPositionP_ForDup(IDupDefined1);
                                      CoordinatesyP(IDuplMouse(IDupDefined1),1)=yPositionP_ForDup(IDupDefined1);
                                      
                                      
                                       Coordinatesx(IDuplMouse(IDupNonDefined),1)=1e6;
                                      Coordinatesy(IDuplMouse(IDupNonDefined),1)=1e6;
                                      CoordinatesxP(IDuplMouse(IDupNonDefined),1)=1e6;
                                      CoordinatesyP(IDuplMouse(IDupNonDefined),1)=1e6;
                                      
                                      
                                      %% Correct the assignment of positions for 2 mice with same antenna but different position
                                      
                                      if size( Coordinatesx(IDuplMouse,1),1)==2 & isempty(find(Coordinatesx(IDuplMouse,1)==1e6))& isempty(find(xDupLastFrame==1e6))
                                          
                                           [Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=Same_Antenna_TwoMice_Dif_Pos(Coordinatesx(IDuplMouse,1),Coordinatesy(IDuplMouse,1),CoordinatesxP(IDuplMouse,1),CoordinatesyP(IDuplMouse,1),xDupLastFrame,yDupLastFrame,IDuplMouse,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP);
                                          
                                          
                                      end
         
         
     end
    
    
end


%% Consider the case in which the coordinates are the same
if length(unique([xPosition_ForDup,yPosition_ForDup],'rows'))==1 %The coordinates of the repeats are the same.All will have the same value.


                                      Coordinatesx(IDuplMouse,1)=xPosition_ForDup;
                                      Coordinatesy(IDuplMouse,1)=yPosition_ForDup;
                                      CoordinatesxP(IDuplMouse,1)=xPositionP_ForDup;
                                      CoordinatesyP(IDuplMouse,1)=yPositionP_ForDup;





end

end