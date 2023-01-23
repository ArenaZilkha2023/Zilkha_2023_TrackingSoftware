function  [FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP,IsSleeping,FidelityMatrix,FidelityVelocity,FidelityForNonCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,velocityMAll]=AddIdentityToCoord(Corn,IsSleeping,TimeExp,FidelityMatrix,FidelityVelocity,FidelityForNonCoord,countFrames,DeltaTimeRFID,NumberOfFrame,Position,AntennaNumber,L,CoordinatesFinalMice, CoordinatesFinalMiceMM,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP)

%Variables
Coordinatesx=zeros(L,1); %L is number of mice
Coordinatesy=zeros(L,1);
CoordinatesxP=zeros(L,1);
CoordinatesyP=zeros(L,1);


%Read parameters RFID and sleeping box

Params=ParametersArenaFix();
%Corn=Params.Corn;

%% Convert the position in pixels into mm

 X=PixelsToMM(Position(:,2),Corn(1,1),Corn(2,1),Params.Width); %convet to mm x coord
 
  Y=PixelsToMM(Position(:,3),Corn(1,2),Corn(4,2),Params.Width); %convert to mm y coord

Position(:,4)=X;
Position(:,5)=Y;
%% 
%%Find  the antenna related with sleeping and add coordinates

[IsSleeping,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Idx]=FindSleeping(IsSleeping,AntennaNumber,Params.SleepingAntenna,Params.SleepingBox,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,Corn,countFrames);


%%Find the antennas inside the arena

IndexArena=find(Idx==0);

%look for these antenna

if ~isempty(IndexArena)
    
    
   [FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP,FidelityMatrix,FidelityVelocity,FidelityForNonCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,velocityMAll]=FindArena(TimeExp,FidelityMatrix,FidelityVelocity,FidelityForNonCoord,countFrames,DeltaTimeRFID,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,AntennaNumber,IndexArena,Position,Params.AntennaCoord,CoordinatesFinalMice, CoordinatesFinalMiceMM,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP);
    
else
    
    if countFrames==1
        velocityMAll=[];
        FidelityVelocity=[];
    else
    
    %calculate the velocity when no mouse in the arena
    
    
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








end

%%-------------------------- Auxiliary functions---------------------------
%Convert pixel to mm 

function X=PixelsToMM(XPixel,Corn0,Corn1,max_width)
X=(XPixel-Corn0)*(max_width/(Corn1-Corn0)); 

end 