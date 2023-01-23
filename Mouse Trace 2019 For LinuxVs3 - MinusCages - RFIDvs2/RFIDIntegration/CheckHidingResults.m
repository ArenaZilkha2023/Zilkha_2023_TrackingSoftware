function [IsHiding,IlogicalHiding,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=CheckHidingResults(IsSleeping,IsHiding,countFrames,AntennaForMice,Corn,XLastFrame,YLastFrame,VelLastFrameX,VelLastFrameY,...
                        IlogicalHiding,HidingAntenna,HidingAntennaCoord,Timefinal,Timeinitial,parameterDistance,...
                        Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,XLastLastFrame,SignTimeRFID)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Brief Script
% 1)- Find the predicted mice in the hiding box
% 2)- Loop over each predicted mouse 
      % 3)- if the mouse wasn't in the hiding box in the last position.and
      % it wasn't in the sleeping box- also eliminate if it wasnt defined--
      % Respect t0 sleeping box - if the condition wasnot consider I
      % checked one position before.
        %   4)- Calculate distance between center hiding box and predicted
        %   distance
              % 5)- if the distance bigger than antenna radius
                   % 6)-IlogicalHiding(that mouse)=0; Ths the position in
                   % hiding box is not consider.
        % 6) in the sleeping box
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
max_width=1139;


%%  Step 1
IndexHidingMouse=find(IlogicalHiding==1);

for count=1:length(IndexHidingMouse)
    
     if IsHiding(countFrames-1,IndexHidingMouse(count))==0 & IsSleeping(countFrames-1,IndexHidingMouse(count))==0 & XLastFrame(IndexHidingMouse(count))~=1e6
        antennaH=AntennaForMice(IndexHidingMouse(count));
        IndexH=find(HidingAntenna==antennaH);
        HidingAntennaCoord(IndexH,:); % convert pixels into mm
        xhiding=PixelsToMM(HidingAntennaCoord(IndexH,1),Corn(1,1),Corn(2,1),max_width);
        yhiding=PixelsToMM(HidingAntennaCoord(IndexH,2),Corn(1,2),Corn(4,2),max_width);
        
        %% ------------------------Conversion of time------------------------
          %translate TimeExp to vector

           Timefinal=strrep(Timefinal,'''',''); %Remove double string before
            Timeinitial=strrep(Timeinitial,'''','');
            TimeVectorAfter=datevec(Timefinal,'HH:MM:SS.FFF');
            TimeVectorBefore=datevec(Timeinitial,'HH:MM:SS.FFF');
            ElapseTime=abs(etime(TimeVectorAfter,TimeVectorBefore));% elapsed time in seconds
        
            distance=sqrt((xhiding- (XLastFrame(IndexHidingMouse(count))+VelLastFrameX(IndexHidingMouse(count))*ElapseTime))^2+(yhiding-(YLastFrame(IndexHidingMouse(count))+VelLastFrameY(IndexHidingMouse(count))*ElapseTime))^2);
                     if distance > 50
                         
                         %Condition width hiding box
                         
                         IlogicalHiding(IndexHidingMouse(count),1)=0;
                         Coordinatesx(IndexHidingMouse(count),1)=0;
                         Coordinatesy(IndexHidingMouse(count),1)=0;
                         CoordinatesxP(IndexHidingMouse(count),1)=0;
                         CoordinatesyP(IndexHidingMouse(count),1)=0;
                         IsHiding(countFrames,IndexHidingMouse(count))=0;
                     end
        
         elseif IsSleeping(countFrames-1,IndexHidingMouse(count))==1 
                         IlogicalHiding(IndexHidingMouse(count),1)=0;
                         Coordinatesx(IndexHidingMouse(count),1)=0;
                         Coordinatesy(IndexHidingMouse(count),1)=0;
                         CoordinatesxP(IndexHidingMouse(count),1)=0;
                         CoordinatesyP(IndexHidingMouse(count),1)=0;
                         IsHiding(countFrames,IndexHidingMouse(count))=0;
    
        elseif IsHiding(countFrames-1,IndexHidingMouse(count))==0 & IsSleeping(countFrames-1,IndexHidingMouse(count))==0 & XLastFrame(IndexHidingMouse(count))==1e6
%           
                         if SignTimeRFID(IndexHidingMouse(count))<0
 %Thus the consideration for hiding box isn't good                             
                               IlogicalHiding(IndexHidingMouse(count),1)=0;
                                Coordinatesx(IndexHidingMouse(count),1)=0;
                                Coordinatesy(IndexHidingMouse(count),1)=0;
                                CoordinatesxP(IndexHidingMouse(count),1)=0;
                                CoordinatesyP(IndexHidingMouse(count),1)=0;
                                IsHiding(countFrames,IndexHidingMouse(count))=0;
                             
                         
                         end
     end



 end
end

%%-------------------------- Auxiliary functions---------------------------
%Convert pixel to mm 

function XP=MMToPixels(XMM,Corn0,Corn1,max_width)
XP=(XMM*(Corn1-Corn0))/max_width+Corn0; 

end 