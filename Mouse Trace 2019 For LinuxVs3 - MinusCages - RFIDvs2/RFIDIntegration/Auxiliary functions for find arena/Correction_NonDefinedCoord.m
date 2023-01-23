function [CoordinatesFinalMice CoordinatesFinalMiceMM]=Correction_NonDefinedCoord(countFrames,TimeExp,CoordinatesFinalMice,CoordinatesFinalMiceMM,FidelityForNonCoord,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP,ThresholdVelocity)
% Go through each mice
Imouse=[1:size(FidelityForNonCoord,1)];
for Mouse=1:size(FidelityForNonCoord,2)
    
% Find the intervals with one that is non-defined positions

[EventsBeg EventsEnd]=getEventsIndexesGV(FidelityForNonCoord(:,Mouse),size(FidelityForNonCoord,1));

% Go Through each interval

        for event=1:length(EventsBeg)-1 
    
            %% Go to each event
            %% Check the anchor point isn't defined
         for count=1:(EventsEnd(event)-EventsBeg(event)+1) %loop over all the non defined coord
           
           if count==1  
            AnchorPointx=CoordinatesFinalMiceMM(EventsEnd(event)+1,2*Mouse-1); %the last +1 event has to be defined
            AnchorPointy=CoordinatesFinalMiceMM(EventsEnd(event)+1,2*Mouse); 
            FrameToChange=EventsEnd(event);
           else
                AnchorPointx=CoordinatesFinalMiceMM(EventsEnd(event)-count+2,2*Mouse-1); %the last +1 event has to be defined
                AnchorPointy=CoordinatesFinalMiceMM(EventsEnd(event)-count+2,2*Mouse); 
                 FrameToChange=EventsEnd(event)-count+2-1;
               
           end
            
            
            
            Iindication=(AnchorPointx==1e6);
                    if  Iindication==0
                            %% Check that the coordinates to use aren't included in the mm
                            CoordToUsex=FidelityForNonCoord_x(FrameToChange,:);
                            CoordToUsey=FidelityForNonCoord_y(FrameToChange,:);
           
                             CoordToUsexP=FidelityForNonCoord_xP(FrameToChange,:);
                            CoordToUseyP=FidelityForNonCoord_yP(FrameToChange,:);
                           %Iindication1= bsxfun(@eq,CoordinatesFinalMiceMM(FrameToChange,2*Imouse-1),CoordToUsex')& bsxfun(@eq,CoordinatesFinalMiceMM(FrameToChange,2*Imouse),CoordToUsex');
            
                      %  if any(Iindication1)
                         %not considered that positionFINISH
             
    
                        %end
         
                             %% Find the position with the minimum distance
                            distance=DistCalc(CoordToUsex',CoordToUsey',AnchorPointx,AnchorPointy);
                            [~,Imin]=min(distance);
                            
                            velocityM= Velocity_Calculation(TimeExp,EventsEnd(event),distance(Imin))
                            
                            %% Decision
                            if velocityM < ThresholdVelocity
                                
                                CoordinatesFinalMiceMM(FrameToChange,2*Mouse-1)=CoordToUsex(Imin);
                                CoordinatesFinalMiceMM(FrameToChange,2*Mouse)=CoordToUsey(Imin);
                                
                                CoordinatesFinalMice(FrameToChange,2*Mouse-1)=CoordToUsexP(Imin);
                                CoordinatesFinalMice(FrameToChange,2*Mouse)=CoordToUseyP(Imin);
                            
                            end
         
                    end
        end
        end


       

end