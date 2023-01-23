function Imcorrected=CorrectionWithVelocity(distance,Imouse,countFrames,CoordinatesFinalMiceMM,x,y,TimeExp)
%
ThresholdVelocity=200; %in units cm/sec
%% Read last coordinates for the given mouse
xlastFrame=CoordinatesFinalMiceMM(countFrames-1,2*Imouse-1);
ylastFrame=CoordinatesFinalMiceMM(countFrames-1,2*Imouse);

%% Find the time between frames

  t=datevec(TimeExp,'HH:MM:SS.FFF');
        t1=t(countFrames-1,:);
        t2=t(countFrames,:);
        FrameTimeDif=abs(etime(t1,t2)); %the time is in seconds
        
        
        %% Calculate distance between each position and the coordinates of last frame
        distanceM=DistCalc(x,y,xlastFrame,ylastFrame)/10;
        velocityM=distanceM./ FrameTimeDif; %get the velocity in cm/sec
%         %% Sort the distance according to smaller to larger and also sort the velocity in the same order 
%          
%           [~,Isorted]=sort(distance);
%           
%           velocityMs=velocityM(Isorted);
%           
%           %find the first velocity smaller than the threshold one
%           I=find(velocityMs < ThresholdVelocity,1,'first');
%           Imcorrected=Isorted(I);

%% Find the minimum velocity and check that it is not larger than the threshold
[Value,Imin]=min(velocityM);

    if Value< ThresholdVelocity
     Imcorrected=Imin;
     
    else
       Imcorrected=[]; 
    
    end




end