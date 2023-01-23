function Locomotion=ReassingSleepingCoordinates(Locomotion)

IsSleeping=Locomotion.AssigRFID.IsSleeping;

%% Find interval sleeping for each mice

for countMouse=1:size(IsSleeping,2) %loop over each mice
    EventsBeg=[];
    EventsEnd=[];
    
    [EventsBeg EventsEnd]=getEventsIndexesGV(IsSleeping(:,countMouse),size(IsSleeping(:,countMouse),1));
  if ~isempty(EventsBeg)  
    for countEvents=1:size(EventsBeg,1)
       
       Locomotion.AssignRFID.XcoordMM(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse)=Locomotion.AssigRFID.IsSleepingCoordx(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse); 
       Locomotion.AssignRFID.YcoordMM(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse)=Locomotion.AssigRFID.IsSleepingCoordy(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse); 
       Locomotion.AssignRFID.XcoordPixel(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse)=Locomotion.AssigRFID.IsSleepingCoordxP(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse); 
       Locomotion.AssignRFID.YcoordPixel(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse)=Locomotion.AssigRFID.IsSleepingCoordyP(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse); 
       
        Locomotion.AssigRFID.XcoordMM(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse)=Locomotion.AssigRFID.IsSleepingCoordx(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse); 
       Locomotion.AssigRFID.YcoordMM(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse)=Locomotion.AssigRFID.IsSleepingCoordy(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse); 
       Locomotion.AssigRFID.XcoordPixel(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse)=Locomotion.AssigRFID.IsSleepingCoordxP(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse); 
       Locomotion.AssigRFID.YcoordPixel(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse)=Locomotion.AssigRFID.IsSleepingCoordyP(EventsBeg(countEvents,1):EventsEnd(countEvents,1),countMouse); 

    end
  end   
end




end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% AUXILIARY FUNCTIONS
function [EventsBeg EventsEnd]=getEventsIndexesGV(IndLogical,n)

EventsBeg=find(diff(IndLogical)==1)+1;
EventsEnd=find(diff(IndLogical)==-1);

if isempty(EventsBeg)||isempty(EventsEnd)
    if(isempty(EventsBeg)&&~isempty(EventsEnd))
        EventsBeg=[1;EventsBeg];
    elseif(isempty(EventsEnd)&&~isempty(EventsBeg))
        EventsEnd=[EventsEnd;n];
    else
        if sum(IndLogical)==n
            EventsBeg=1;
            EventsEnd=n;
        end
    end
else
    if(EventsBeg(1)>EventsEnd(1))
        EventsBeg=[1;EventsBeg];
    end
    
    if(EventsBeg(end)>EventsEnd(end))
        EventsEnd=[EventsEnd;n];
    end
end

end