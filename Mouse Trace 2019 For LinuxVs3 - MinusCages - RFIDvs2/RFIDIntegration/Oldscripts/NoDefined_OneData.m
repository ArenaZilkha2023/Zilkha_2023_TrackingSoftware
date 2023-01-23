function  [Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionToChange]=NoDefined_OneData(AntennaNumber,AntennaCoord,Inondefined,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionToChange,Arena_length)

%% 
 if length(Inondefined)==1
         %find the antenna coordinate
         AntennaX=AntennaCoord(AntennaNumber(Inondefined),1);
         AntennaY=AntennaCoord(AntennaNumber(Inondefined),2);
    
         distance=DistCalc(PositionToChange(:,4),PositionToChange(:,5),AntennaX,AntennaY); 
            [~,Im]=min(distance); %find the minimum distance to the antenna which is sure whent the minimum distance less than the threshold
          
       if distance(Im)< Arena_length/2 %THERE ARE CASES THAT THE LAST POSITION IS FROM A MOUSE DETECTED ALREADY BY A SLEEPING ANTENNA THUS THIS POSITION IS WRONG-Cannot be that the distance to the arena is very larg
                %define the new coordinates
        
                 Coordinatesx(Inondefined,1)=PositionToChange(Im,4);
                 Coordinatesy(Inondefined,1)=PositionToChange(Im,5);
                 CoordinatesxP(Inondefined,1)=PositionToChange(Im,2);
                 CoordinatesyP(Inondefined,1)=PositionToChange(Im,3);
                 
                    %remove the positions which were defined
                id1=[];
                [~,id1]=setdiff(1:size(PositionToChange,1),Im);
                PositionToChange=PositionToChange(id1,:);
                
       else %In the case of wrong position
           
                 Coordinatesx(Inondefined,1)=1e6;
                 Coordinatesy(Inondefined,1)=1e6;
                 CoordinatesxP(Inondefined,1)=1e6;
                 CoordinatesyP(Inondefined,1)=1e6;
           
           
       end    


 end



end