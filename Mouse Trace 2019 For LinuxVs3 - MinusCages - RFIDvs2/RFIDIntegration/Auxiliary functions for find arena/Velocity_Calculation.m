function velocityM= Velocity_Calculation(t,countFrames,Distance_FromLastFrame)


%% Find the time between frames

  
        Timeinitial=t{countFrames-1};
        Timefinal=t{countFrames};
        
         Timefinal=strrep(Timefinal,'''',''); %Remove double string before
            Timeinitial=strrep(Timeinitial,'''','');
            TimeVectorAfter=datevec(Timefinal,'HH:MM:SS.FFF');
            TimeVectorBefore=datevec(Timeinitial,'HH:MM:SS.FFF');
            FrameTimeDif=abs(etime(TimeVectorAfter,TimeVectorBefore));%the time is in seconds
        
        
        %% Calculate distance between each position and the coordinates of last frame
        distanceM=Distance_FromLastFrame/10;
        velocityM=distanceM./ FrameTimeDif; %get the velocity in cm/sec



end