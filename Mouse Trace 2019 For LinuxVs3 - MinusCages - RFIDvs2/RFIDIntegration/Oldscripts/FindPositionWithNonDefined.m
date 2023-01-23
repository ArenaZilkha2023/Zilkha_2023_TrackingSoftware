function  [Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=FindPositionWithNonDefined(countFrames,Imouse,PositionToChange,CoordinatesFinalMiceMM,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP)

if length(Imouse)==2 & size(PositionToChange,1)==1
   x=CoordinatesFinalMiceMM(countFrames-1,2*Imouse-1); 
   y=CoordinatesFinalMiceMM(countFrames-1,2*Imouse);
   
   distance=DistCalc(x,y,PositionToChange(:,4),PositionToChange(:,5)) 
    
   [~,Im]=min(distance);
   
                 Coordinatesx(Imouse(Im),1)=PositionToChange(:,4);
                 Coordinatesy(Imouse(Im),1)=PositionToChange(:,5);
                  CoordinatesxP(Imouse(Im),1)=PositionToChange(:,2);
                  CoordinatesyP(Imouse(Im),1)=PositionToChange(:,3);
   
   Inondefined=setdiff(Imouse,Imouse(Im));
   
    
                 Coordinatesx(Inondefined,1)=1e6;
                 Coordinatesy(Inondefined,1)=1e6;
                  CoordinatesxP(Inondefined,1)=1e6;
                  CoordinatesyP(Inondefined,1)=1e6;
end




end