function [IsSleeping,IsSleepingCoordx,IsSleepingCoordy,IsSleepingCoordxP,IsSleepingCoordyP,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Index]=FindSleeping(IsSleeping,IsSleepingCoordx,IsSleepingCoordy,IsSleepingCoordxP,IsSleepingCoordyP,...
    AntenaNumber,SleepingAntenna,SleepingBox,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Corn,countFrames)

%this function find the sleeping coordinates

%Find the sleeping box antenna in Antenna number

Index=ismember(AntenaNumber,SleepingAntenna);
max_width=1139;
%% 
if any(Index)
    Idx=find(Index==1);
   for j=1:length(Idx) %loop over the antenna
       i=Idx(j);
       IsSleeping(countFrames,i)=1;
        switch(AntenaNumber(i))  
            case 2
               Coordinatesx(i,1)= SleepingBox(1,1);
               Coordinatesy(i,1)= SleepingBox(1,2);
               
            case 5
                 Coordinatesx(i,1)= SleepingBox(2,1);
                 Coordinatesy(i,1)= SleepingBox(2,2);
            case 7
               Coordinatesx(i,1)= SleepingBox(3,1);
               Coordinatesy(i,1)= SleepingBox(3,2);
            case 35
                 Coordinatesx(i,1)= SleepingBox(4,1);
                 Coordinatesy(i,1)= SleepingBox(4,2);
            case 47
                Coordinatesx(i,1)= SleepingBox(5,1);
                 Coordinatesy(i,1)= SleepingBox(5,2);
            case 45
                Coordinatesx(i,1)= SleepingBox(6,1);
                 Coordinatesy(i,1)= SleepingBox(6,2);
            case 43
                Coordinatesx(i,1)= SleepingBox(7,1);
                 Coordinatesy(i,1)= SleepingBox(7,2);
            case 8
                Coordinatesx(i,1)= SleepingBox(8,1);
                 Coordinatesy(i,1)= SleepingBox(8,2);
            case 49
                Coordinatesx(i,1)= SleepingBox(1,1);
                 Coordinatesy(i,1)= SleepingBox(1,2);
            case 50
                Coordinatesx(i,1)= SleepingBox(2,1);
                 Coordinatesy(i,1)= SleepingBox(2,2);
            case 51
                Coordinatesx(i,1)= SleepingBox(3,1);
                 Coordinatesy(i,1)= SleepingBox(3,2);
            case 52
                Coordinatesx(i,1)= SleepingBox(4,1);
                 Coordinatesy(i,1)= SleepingBox(4,2);
            case 53
                Coordinatesx(i,1)= SleepingBox(5,1);
                 Coordinatesy(i,1)= SleepingBox(5,2);
            case 54
                Coordinatesx(i,1)= SleepingBox(6,1);
                 Coordinatesy(i,1)= SleepingBox(6,2);
            case 55
                 Coordinatesx(i,1)= SleepingBox(7,1);
                 Coordinatesy(i,1)= SleepingBox(7,2);
            case 56
                Coordinatesx(i,1)= SleepingBox(8,1);
                 Coordinatesy(i,1)= SleepingBox(8,2);
       
        end    
       
       CoordinatesxP(i,1)=MMToPixels(Coordinatesx(i,1),Corn(1,1),Corn(2,1),max_width);
       CoordinatesyP(i,1)=MMToPixels(Coordinatesy(i,1),Corn(1,2),Corn(4,2),max_width);
       
       %Save sleeping coordinates for last validation
       IsSleepingCoordx(countFrames,i)=Coordinatesx(i,1);
       IsSleepingCoordy(countFrames,i)=Coordinatesy(i,1);
       IsSleepingCoordxP(countFrames,i)=CoordinatesxP(i,1);
       IsSleepingCoordyP(countFrames,i)=CoordinatesyP(i,1);
   end    
end
end

%%-------------------------- Auxiliary functions---------------------------
%Convert pixel to mm 

function XP=MMToPixels(XMM,Corn0,Corn1,max_width)
XP=(XMM*(Corn1-Corn0))/max_width+Corn0; 

end 


