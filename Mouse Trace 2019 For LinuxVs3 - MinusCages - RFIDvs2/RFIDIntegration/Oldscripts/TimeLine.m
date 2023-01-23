classdef TimeLine;
   %This is an object  for the time
    
    properties
        FrameTime;
        RFIDTime;
        
    end
    
    methods
        
        %% ---------------------Find elapse time between frame time and rfid-------
        function DeltaTime=DeltaTime(obj)
            t1=datevec(obj.FrameTime,'HH:MM:SS.FFF');   
            t2=datevec(obj.RFIDTime,'HH:MM:SS.FFF'); 
        
            DeltaTime=etime(t1,t2);
        
        
        end
    
        
        %% ------------------Find frame difference----------------------
        function FrameTimeDif=FrameTimeDif(obj)
        t1=datevec(obj.FrameTime,'HH:MM:SS.FFF'); 
        t2=t1(2:end,:);
        FrameTimeDif=cumsum([0; etime(t1(1:end-1,:),t2)]); %to get accumulative sum
        end
end
end
