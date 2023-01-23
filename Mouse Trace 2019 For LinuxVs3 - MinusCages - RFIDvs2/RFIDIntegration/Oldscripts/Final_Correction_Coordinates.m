function [CoordinatesFinalMice, CoordinatesFinalMiceMM]= Final_Correction_Coordinates(CoordinatesFinalMice, CoordinatesFinalMiceMM,CoordinatesFinalMiceBF,CoordinatesFinalMiceMMBF,FidelityMatrixF,Difference_FR,FidelityMatrixR)

%The idea is to correct the forward position when there is uncertainty at
%the beggining

%% Loop over every mice
   for i=1:size(FidelityMatrixF,2)
      %% Variables initialization
         EventsBeg=[];
         EventsEnd=[];
      
      %% Find for each mouse the events with one in the fidelity forward matrix
      [EventsBeg EventsEnd]=getEventsIndexesGV(FidelityMatrixF(:,i),size(FidelityMatrixF,1))

                %% Loop over each event
                   for j=1:length(EventsBeg)
                            %% Check for each interval event if there are true values in the difference_FR 
                            if ~isempty(find(Difference_FR(EventsBeg(j):EventsEnd(j),i)==1))
                                     %% then check if the fidelity reverse is all zero thus change the coordinates with the reverse
                                     if isempty(find(FidelityMatrixR(EventsBeg(j):EventsEnd(j),i)==1))
                                      
                                         CoordinatesFinalMice(EventsBeg(j):EventsEnd(j),2*i-1)= CoordinatesFinalMiceBF(EventsBeg(j):EventsEnd(j),2*i-1);%for x coord
                                         CoordinatesFinalMice(EventsBeg(j):EventsEnd(j),2*i)= CoordinatesFinalMiceBF(EventsBeg(j):EventsEnd(j),2*i); %for y coord
                                         
                                         CoordinatesFinalMiceMM(EventsBeg(j):EventsEnd(j),2*i-1)=CoordinatesFinalMiceMMBF(EventsBeg(j):EventsEnd(j),2*i-1);%for x coord
                                         CoordinatesFinalMiceMM(EventsBeg(j):EventsEnd(j),2*i)=CoordinatesFinalMiceMMBF(EventsBeg(j):EventsEnd(j),2*i); %for y coord
                                         
                                     elseif ~isempty(find(FidelityMatrixR(EventsBeg(j):EventsEnd(j),i)==0)) 
                                                  Index=find(FidelityMatrixR(EventsBeg(j):EventsEnd(j),i)==0); %only this one I took into account
                                            for t=1:length(Index)
                                               CoordinatesFinalMice(EventsBeg(j)+Index(t)-1,2*i-1)= CoordinatesFinalMiceBF(EventsBeg(j)+Index(t)-1,2*i-1);%for x coord
                                               CoordinatesFinalMice(EventsBeg(j)+Index(t)-1,2*i)= CoordinatesFinalMiceBF(EventsBeg(j)+Index(t)-1,2*i); %for y coord
                                         
                                               CoordinatesFinalMiceMM(EventsBeg(j)+Index(t)-1,2*i-1)=CoordinatesFinalMiceMMBF(EventsBeg(j)+Index(t)-1,2*i-1);%for x coord
                                               CoordinatesFinalMiceMM(EventsBeg(j)+Index(t)-1,2*i)=CoordinatesFinalMiceMMBF(EventsBeg(j)+Index(t)-1,2*i);    
                                                
                                            end    
                             
                                     end
                            end
                   end

    end
end



%% -----------------------------Auxiliary function--------------------------------------------------------

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


%% 
