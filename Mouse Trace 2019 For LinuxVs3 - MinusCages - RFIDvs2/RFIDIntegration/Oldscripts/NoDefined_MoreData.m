function  [FidelityMatrix,FidelityForNonCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionToChange]=NoDefined_MoreData(FidelityMatrix,FidelityForNonCoord,countFrames,AntennaNumber,AntennaCoord,Inondefined,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionToChange)
  
ValueMaxOfMeasure=450 ; % more than this value is not considered-NOTE A VALUE WAS ASSUMED

 if length(Inondefined)~=1 
     
                for j=1:length(Inondefined) %assign arbitrary
             
                        if ~isempty(PositionToChange)
                            
                                        %find the antenna coordinate
                                        AntennaX=AntennaCoord(AntennaNumber(Inondefined(j)),1);
                                        AntennaY=AntennaCoord(AntennaNumber(Inondefined(j)),2);
    
                                        distance=DistCalc(PositionToChange(:,4),PositionToChange(:,5),AntennaX,AntennaY); 
                                        [~,Im]=min(distance); %find the minimum distance to the antenna which is sure whent the minimum distance less than the threshold
                            
                                if distance(Im)< ValueMaxOfMeasure %this gives some reliabity to the measure 
                                        Coordinatesx(Inondefined(j),1)=PositionToChange(Im,4);
                                        Coordinatesy(Inondefined(j),1)=PositionToChange(Im,5);
                                        CoordinatesxP(Inondefined(j),1)=PositionToChange(Im,2);
                                        CoordinatesyP(Inondefined(j),1)=PositionToChange(Im,3);
                                        FidelityForNonCoord(countFrames,Inondefined(j))=1; %this means that it is not sure about the position
                                    
                                            %remove the positions which were defined
                                        id1=[];
                                        [~,id1]=setdiff(1:size(PositionToChange,1),Im);
                                        PositionToChange=PositionToChange(id1,:);
                                else
                                    
                                        Coordinatesx(Inondefined(j),1)=1e6;
                                        Coordinatesy(Inondefined(j),1)=1e6;
                                        CoordinatesxP(Inondefined(j),1)=1e6;
                                        CoordinatesyP(Inondefined(j),1)=1e6;
                                    
                                    
                                    
                                end
                                    
                        else
           %%     
                                    Coordinatesx(Inondefined(j),1)=1e6;
                                    Coordinatesy(Inondefined(j),1)=1e6;
                                    CoordinatesxP(Inondefined(j),1)=1e6;
                                    CoordinatesyP(Inondefined(j),1)=1e6;
                                    
                                   FidelityMatrix(countFrames,Inondefined(j))=1; %this means that it is not sure about the position
                        end
                end 
        
end




end

