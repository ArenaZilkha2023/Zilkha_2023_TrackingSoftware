function [IsHiding,IsHidingCoordx,IsHidingCoordy,IsHidingCoordxP,IsHidingCoordyP,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Index]=FindHiding(IsHiding,IsHidingCoordx,IsHidingCoordy,IsHidingCoordxP,IsHidingCoordyP,...
    AntenaNumber,HidingAntenna,HidingAntennaCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Corn,countFrames)

%this function find the sleeping coordinates

%Find the sleeping box antenna in Antenna number

Index=ismember(AntenaNumber,HidingAntenna);
max_width=1139;
%% 
if any(Index)
    Idx=find(Index==1);
   for j=1:length(Idx) %loop over the antenna
       i=Idx(j);
       IsHiding(countFrames,i)=1;
        switch(AntenaNumber(i))  
            case 9
               CoordinatesxP(i,1)= HidingAntennaCoord(1,1);
               CoordinatesyP(i,1)= HidingAntennaCoord(1,2);
            case 13
                 CoordinatesxP(i,1)= HidingAntennaCoord(2,1);
                 CoordinatesyP(i,1)= HidingAntennaCoord(2,2);
            case 41
               CoordinatesxP(i,1)= HidingAntennaCoord(3,1);
               CoordinatesyP(i,1)= HidingAntennaCoord(3,2);
            case 37
                 CoordinatesxP(i,1)= HidingAntennaCoord(4,1);
                 CoordinatesyP(i,1)= HidingAntennaCoord(4,2);
        end    
       
       Coordinatesx(i,1)=PixelsToMM(CoordinatesxP(i,1),Corn(1,1),Corn(2,1),max_width);
       Coordinatesy(i,1)=PixelsToMM(CoordinatesyP(i,1),Corn(1,2),Corn(4,2),max_width);
       
       %Save hiding coordinates for last validation
       IsHidingCoordx(countFrames,i)=Coordinatesx(i,1);
       IsHidingCoordy(countFrames,i)=Coordinatesy(i,1);
       IsHidingCoordxP(countFrames,i)=CoordinatesxP(i,1);
       IsHidingCoordyP(countFrames,i)=CoordinatesyP(i,1);
   end    
end
end

%%-------------------------- Auxiliary functions---------------------------
%Convert pixel to mm 

function XP=MMToPixels(XMM,Corn0,Corn1,max_width)
XP=(XMM*(Corn1-Corn0))/max_width+Corn0; 

end 


