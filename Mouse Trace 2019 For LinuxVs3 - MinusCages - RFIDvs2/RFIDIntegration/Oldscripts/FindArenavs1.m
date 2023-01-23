function  [FidelityMatrix,FidelityAntenna,FidelityForNonCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=FindArena(TimeExp,FidelityMatrix,FidelityAntenna, FidelityForNonCoord,countFrames,DeltaTimeRFID,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,AntennaNumber,IndexArena,Position,AntennaCoord,CoordinatesFinalMice, CoordinatesFinalMiceMM)
%This function find the coordinates of the mouse in the arena.
%% Variable
NoDetectionTime=80; %There are not detection for the antennas to larger times the units are in ms
ThresholdRFIDDistance=57; %mm  units diameter antenna
PositionToChange=Position;
ThresholdVelocity=200;
Arena_length=1139;
%% Select the antenna inside the arena
SubsetAntennaNumber=AntennaNumber(IndexArena,1);
SubsetDeltaTimeRFID=DeltaTimeRFID(IndexArena,1);

%% Get the antenna which are and aren't unique.
[~,ind]=unique(SubsetAntennaNumber,'stable');

SubsetAntennaNumberDuplicate=SubsetAntennaNumber(setdiff(1:size(SubsetAntennaNumber,1),ind));%This gives the antenna number which are duplicated
SubsetAntennaNumberDuplicate=unique(SubsetAntennaNumberDuplicate); %This gives only one number for each duplicate
[SubsetAntennaNumberUnique,id]=setdiff(SubsetAntennaNumber,SubsetAntennaNumberDuplicate); %This gives the antenna number which are unique

%% 

%% 
%%--------------------------------------Consider only unique antennas--------------------

% Sort the difference between video time and RFID time from smallest to larger -The smallest difference means that the mouse is near to such antenna.

[B,I]=sort(SubsetDeltaTimeRFID(id,1)); %Consider the delta time for "unique antennas"

%order the antenna in such order
SubsetAntennaNumberUnique=SubsetAntennaNumberUnique(I,1);

%% Sometimes segmentation adds positions. But if all the antenna are unique, it could be that there are repeated positions then
if ~isempty(SubsetAntennaNumberUnique)& isempty(SubsetAntennaNumberDuplicate)
 PositionToChange=unique(PositionToChange,'rows','stable');


end
%% 


% Loop over each unique antenna beggining with that with larger probability
% find the minimum distance to the position posibilities. Begin to reduce
% this list
Inondefined=[];
if ~isempty(SubsetAntennaNumberUnique)
    
  for i=1:size(SubsetAntennaNumberUnique,1)
  
    %find the index of the antenna number in the original data
    Imouse=find(AntennaNumber==SubsetAntennaNumberUnique(i,1));
    
    %find the antenna coordinate
    AntennaX=AntennaCoord(SubsetAntennaNumberUnique(i,1),1);
    AntennaY=AntennaCoord(SubsetAntennaNumberUnique(i,1),2);
    
  distance=DistCalc(PositionToChange(:,4),PositionToChange(:,5),AntennaX,AntennaY);
    
    if countFrames >1 & DeltaTimeRFID(Imouse,1)>NoDetectionTime & ~isempty(PositionToChange)&(CoordinatesFinalMice(countFrames-1,2*Imouse)~=1e6)
        %% Look for the last frame and get the coordinates of the respective mouse
        %Verify that this position makes sense through the velocity 
    
           [IndexNoRFID,velocityM]=CalcNoRFID(Imouse,countFrames,CoordinatesFinalMiceMM,PositionToChange(:,4),PositionToChange(:,5),TimeExp); %This function gives the index of the adequate coordinate when the detection of RFID wasn't good
% %            [~,Iminimo]=min(distance); 
           %look for near but the distance from the arena no so far
            if velocityM < ThresholdVelocity  %only consider the position correct if this condition is applied if not the mouse is not identified-Also this avoid a wrong assignment
        
             %define the new coordinates
        
             Coordinatesx(Imouse,1)=PositionToChange(IndexNoRFID,4);
             Coordinatesy(Imouse,1)=PositionToChange(IndexNoRFID,5);
             CoordinatesxP(Imouse,1)=PositionToChange(IndexNoRFID,2);
             CoordinatesyP(Imouse,1)=PositionToChange(IndexNoRFID,3);
             
             %% 
             
                              if FidelityMatrix(countFrames-1,Imouse)==1 %if the last position was not sure when there was a double position
                                      FidelityMatrix(countFrames,Imouse)=1; %this means that it is not sure about the position
                                      
                              end    


                              
                              if FidelityForNonCoord(countFrames-1,Imouse)==1 %if the last position was not sure when there was a non defined position
                                      FidelityForNonCoord(countFrames,Imouse)=1; %this means that it is not sure about the position
                                      
                              end  
                              %% 
         
         
             %remove the positions which were defined
             id1=[];
             [~,id1]=setdiff(1:size(PositionToChange,1),IndexNoRFID);
             PositionToChange=PositionToChange(id1,:);
         
            else
          
            Coordinatesx(Imouse,1)=1e6;
            Coordinatesy(Imouse,1)=1e6;
            CoordinatesxP(Imouse,1)=1e6;
            CoordinatesyP(Imouse,1)=1e6;
          
            %no remove position
          
            end
        
   
   
    elseif  ~isempty(PositionToChange)& countFrames >1 & (DeltaTimeRFID(Imouse,1)< NoDetectionTime) & (CoordinatesFinalMice(countFrames-1,2*Imouse)~=1e6)
        
           %Measure the distance between the antennas and each given position and
            %find the minimum one
             Im=[];
             
            
        
             [~,Im]=min(distance); %find the minimum distance to the antenna which is sure whent the minimum distance less than the threshold
             
             %% Correction of the position with the velocity- check if the position wasn't acquired by another mouse for frame>1
             %thus changes the Im
             if (distance(Im)> ThresholdRFIDDistance)
                    Im=CorrectionWithVelocity(distance,Imouse,countFrames,CoordinatesFinalMiceMM,PositionToChange(:,4),PositionToChange(:,5),TimeExp);
                    
                    
                              if FidelityMatrix(countFrames-1,Imouse)==1 %if the last position was not sure
                                      FidelityMatrix(countFrames,Imouse)=1; %this means that it is not sure about the position
                                     
                              end    
                            
                                if FidelityForNonCoord(countFrames-1,Imouse)==1 %if the last position was not sure when there was a non defined position
                                      FidelityForNonCoord(countFrames,Imouse)=1; %this means that it is not sure about the position
                                      
                              end  
%                     
                    
             end
             %% 
             %define the new coordinates
             if ~isempty(Im)
                        Coordinatesx(Imouse,1)=PositionToChange(Im,4);
                        Coordinatesy(Imouse,1)=PositionToChange(Im,5);
                        CoordinatesxP(Imouse,1)=PositionToChange(Im,2);
                        CoordinatesyP(Imouse,1)=PositionToChange(Im,3);
                 
                    %remove the positions which were defined
                        id1=[];
                        [~,id1]=setdiff(1:size(PositionToChange,1),Im);
                        PositionToChange=PositionToChange(id1,:);
             else
                 Coordinatesx(Imouse,1)=1e6;
                 Coordinatesy(Imouse,1)=1e6;
                 CoordinatesxP(Imouse,1)=1e6;
                 CoordinatesyP(Imouse,1)=1e6;
                        
            end
            %% When the position is empty
     elseif isempty(PositionToChange)     
                %when the position is not defined , one million is assigned
                %to the coordinates
              
        
                 Coordinatesx(Imouse,1)=1e6;
                 Coordinatesy(Imouse,1)=1e6;
                 CoordinatesxP(Imouse,1)=1e6;
                 CoordinatesyP(Imouse,1)=1e6;
                 
                 %% Try the cases in which the last coord was not defined
     elseif  ~isempty(PositionToChange)& countFrames >1 & (DeltaTimeRFID(Imouse,1)> NoDetectionTime) & (CoordinatesFinalMice(countFrames-1,2*Imouse)==1e6)
             
              %save the non defined position for later use at the end
               
             Inondefined=[Inondefined; Imouse];  
               
               
             %% 
        elseif  ~isempty(PositionToChange)& countFrames >1 & (DeltaTimeRFID(Imouse,1)< NoDetectionTime) & (CoordinatesFinalMice(countFrames-1,2*Imouse)==1e6)    
                   %Measure the distance between the antennas and each given position and
            %find the minimum one
             Im=[];
             
            
        
             [~,Im]=min(distance); %find the minimum distance to the antenna which is sure whent the minimum distance less than the threshold
             
             %% Correction of the position with the velocity- check if the position wasn't acquired by another mouse for frame>1
             %thus changes the Im
             if (distance(Im)> ThresholdRFIDDistance)
                  Inondefined=[Inondefined; Imouse];    
             else
             %% 
             %define the new coordinates
             
                        Coordinatesx(Imouse,1)=PositionToChange(Im,4);
                        Coordinatesy(Imouse,1)=PositionToChange(Im,5);
                        CoordinatesxP(Imouse,1)=PositionToChange(Im,2);
                        CoordinatesyP(Imouse,1)=PositionToChange(Im,3);
                 
                    %remove the positions which were defined
                        id1=[];
                        [~,id1]=setdiff(1:size(PositionToChange,1),Im);
                        PositionToChange=PositionToChange(id1,:);
             end
            
                 
                 %% For  first frfame
                 
       elseif  ~isempty(PositionToChange)& countFrames==1
        
                %Measure the distance between the antennas and each given position and
                %find the minimum one
            	Im=[];
             
        
                [~,Im]=min(distance); %find the minimum distance to the antenna which is sure whent the minimum distance less than the threshold
             
            
             
                %define the new coordinates
        
                 Coordinatesx(Imouse,1)=PositionToChange(Im,4);
                 Coordinatesy(Imouse,1)=PositionToChange(Im,5);
                 CoordinatesxP(Imouse,1)=PositionToChange(Im,2);
                 CoordinatesyP(Imouse,1)=PositionToChange(Im,3);
                 
                    %remove the positions which were defined
                id1=[];
                [~,id1]=setdiff(1:size(PositionToChange,1),Im);
                PositionToChange=PositionToChange(id1,:);
   
    end
    
    
    
 end
end
%% Correction





%%

%% ----------------------------------Consider only duplicate antennas-------------------

if countFrames >1 & ~isempty(SubsetAntennaNumberDuplicate)
     for i=1:size(SubsetAntennaNumberDuplicate,1)
    %Reset variables
    distanced=[];
    distanceC=[];
    Imouse=[];
  %%--Find the probable positions.  
    %find the index of the antenna number in the original data
    Imouse=find(AntennaNumber==SubsetAntennaNumberDuplicate(i,1)); %it is more than one mouse
    
    %find the antenna coordinate
    AntennaX=AntennaCoord(SubsetAntennaNumberDuplicate(i,1),1);
    AntennaY=AntennaCoord(SubsetAntennaNumberDuplicate(i,1),2); 
    
    %find the distance between the antenna and the positions that left
    distanced=DistCalc(PositionToChange(:,4),PositionToChange(:,5),AntennaX,AntennaY);
    
    %sort the distance in order to take the smaller ones
    [distanced,Isortdist]=sort(distanced);
    
            if   size(PositionToChange,1)< length(Imouse)  %consider when there is no position for one mouse
                    [Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=FindPositionWithNonDefined(countFrames,Imouse,PositionToChange,CoordinatesFinalMiceMM,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP);
                    %select the possible distance according to the repeats
            else %if all the positions exist 
                distanceC=distanced(1:length(Imouse));
                PositionSelectedx=PositionToChange(Isortdist(1:length(Imouse)),4);
                PositionSelectedy=PositionToChange(Isortdist(1:length(Imouse)),5);
    
                PositionSelectedxP=PositionToChange(Isortdist(1:length(Imouse)),2); %Get the same position in pixel
                PositionSelectedyP=PositionToChange(Isortdist(1:length(Imouse)),3);  %Get the same position in pixel
    
    %% 
                
                %same antenna and same position
                [Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=SameAntenna_SamePositions(distanceC,Imouse,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionSelectedx,PositionSelectedy,PositionSelectedxP,PositionSelectedyP);
                %same antenna different positions
                [FidelityMatrix, FidelityAntenna,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=SameAntenna_DifPositions(FidelityMatrix, FidelityAntenna,SubsetAntennaNumberDuplicate(i,1),countFrames,distanceC,Imouse,CoordinatesFinalMiceMM,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionSelectedx,PositionSelectedy,PositionSelectedxP,PositionSelectedyP);
    


            end
               %after each assignment remove the used positions
                id=[];
                [~,id]=setdiff(PositionToChange(:,4),Coordinatesx); %find the values of position which were not yet considered.
                PositionToChange=PositionToChange(id,:);
     end

end
%%

%% ------------------Considered the non defined cases where the segmentation didn't work a frame before ---------------
if ~isempty(Inondefined) & ~isempty(PositionToChange)
   
    %% There is only one non defined
    [Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionToChange]=NoDefined_OneData(AntennaNumber,AntennaCoord,Inondefined,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionToChange,Arena_length);
    
    %% There is more than one define
    
    [FidelityMatrix,FidelityForNonCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionToChange]=NoDefined_MoreData(FidelityMatrix,FidelityForNonCoord,countFrames,AntennaNumber,AntennaCoord,Inondefined,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionToChange);
    
    
elseif ~isempty(Inondefined) & isempty(PositionToChange)
    
      %when the position is not defined , one million is assigned
                %to the coordinates
              
        
                 Coordinatesx(Inondefined,1)=1e6;
                 Coordinatesy(Inondefined,1)=1e6;
                 CoordinatesxP(Inondefined,1)=1e6;
                 CoordinatesyP(Inondefined,1)=1e6;
        
  end   
            
                 
                 
     
       
   
    
    
    
    



end



%% ---------------------------------Auxiliary function --------------------------------




%% 

function Result=notEqual(a,b)

for i=1:size(a,1)
    if length(unique(a(i,:)))==1 & length(unique(b(i,:)))==1 %Thus the coordinates are the same for the given mous
        Result(i)=0;
    else
        Result(i)=1;
        
    end

end
end