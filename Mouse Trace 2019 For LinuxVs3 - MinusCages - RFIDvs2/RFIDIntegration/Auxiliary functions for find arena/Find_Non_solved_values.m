function [FidelityForNonCoord,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP]=Find_Non_solved_values(countFrames,FidelityForNonCoord,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP,Coordinatesx,PositionToChange)


%%Find the positions which were left
IndexPositionAssigned1=FindValues_InsideList(PositionToChange(:,4),Coordinatesx);

%% Also Remove positions which are on the border with the time title in which the segmentation is performed
   IndexPositionOnBorder=find(PositionToChange(:,5) > 1130); %Width of the arena
   %% 

   IndexPositionAssigned=([IndexPositionAssigned1;IndexPositionOnBorder]);
   
   
 [~,indexPositionLeft]=setdiff([1:size(PositionToChange,1)]',IndexPositionAssigned,'stable');%find the index not considered
    Inon_defined_mouse=find(Coordinatesx==1e6);

  %% Positions that left without assignment
if ~isempty(indexPositionLeft)
    
    
    
     Position_Leftx=PositionToChange(indexPositionLeft,4);
    Position_Lefty=PositionToChange(indexPositionLeft,5);
    Position_LeftxP=PositionToChange(indexPositionLeft,2);
    Position_LeftyP=PositionToChange(indexPositionLeft,3);

    
  
    %% Save in a matrix
    
    FidelityForNonCoord(countFrames,Inon_defined_mouse)=1;
    
    FidelityForNonCoord_x(countFrames,1:length(Position_Leftx))=Position_Leftx';
    FidelityForNonCoord_y(countFrames,1:length(Position_Lefty))=Position_Lefty';
    FidelityForNonCoord_xP(countFrames,1:length(Position_LeftxP))=Position_LeftxP';
    FidelityForNonCoord_yP(countFrames,1:length(Position_LeftyP))=Position_LeftyP';
end

end