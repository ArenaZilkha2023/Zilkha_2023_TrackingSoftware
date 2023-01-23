function [Im,velocityM]=CalcNoRFID(Imouse,NumberOfFrame,CoordinatesFinalMiceMM,X,Y,TimeExp)

%This function takes the posible positions and calculates which position is
%minimum to the last frame.

 xmouseLast=CoordinatesFinalMiceMM(NumberOfFrame-1,2*Imouse-1);
  ymouseLast=CoordinatesFinalMiceMM(NumberOfFrame-1,2*Imouse);

distance=DistCalc(X,Y,xmouseLast,ymouseLast);

[distanceM,Im]=min(distance);
%% %% Find the time between frames

  t=datevec(TimeExp,'HH:MM:SS.FFF');
        t1=t(NumberOfFrame-1,:);
        t2=t(NumberOfFrame,:);
        FrameTimeDif=abs(etime(t1,t2)); %the time is in seconds
        
        
        %% Calculate distance between each position and the coordinates of last frame
        distanceM=distanceM/10;
        velocityM=distanceM./FrameTimeDif; %get the velocity in cm/sec


end