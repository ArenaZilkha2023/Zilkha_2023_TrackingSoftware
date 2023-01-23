function [Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=SameAntenna_SamePositions(distancePosToAntenna,Imouse,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionSelectedx,PositionSelectedy,PositionSelectedxP,PositionSelectedyP)


        if length(unique(distancePosToAntenna))==1 %when there is the same coordinate for all mice in the same antenna since they are very near
                for jj=1:length(Imouse) 
                 
                            Coordinatesx(Imouse(jj),1)=PositionSelectedx(jj,1);
                            Coordinatesy(Imouse(jj),1)=PositionSelectedy(jj,1);
                            CoordinatesxP(Imouse(jj),1)=PositionSelectedxP(jj,1);
                            CoordinatesyP(Imouse(jj),1)=PositionSelectedyP(jj,1);
          
           
                 end
        

        end




end