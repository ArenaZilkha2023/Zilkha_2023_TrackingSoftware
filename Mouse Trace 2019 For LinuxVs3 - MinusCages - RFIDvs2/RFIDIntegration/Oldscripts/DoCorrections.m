function[CoordinatesFinalMiceMM,CoordinatesFinalMice,FidelityMatrix,FidelityAntenna]=DoCorrections(CoordinatesFinalMiceMM,CoordinatesFinalMice,FidelityMatrix,FidelityAntenna)

%The idea is to find when the mouse identity was lost because in some frame
%the position of 2or more mice was the same

 for i=1:size(FidelityMatrix,2) %Loop over every mouse

%Find the intervals in which FidelityMatrix is one

[EventsBeg EventsEnd]=getEventsIndexesGV(FidelityMatrix(:,i),size(FidelityMatrix,1))

     if ~isempty(EventsBeg)
%each event is treated separetely
            for j=1:length(EventsBeg)          
              Antenna=FidelityAntenna(EventsBeg(j),i);
              
              %The idea is to find the others mice with the same antenna
              Imouse=find(FidelityAntenna(EventsBeg(j),:)==Antenna);
              
              %find las coord before splitting
              CoordxWithoutIdent=CoordinatesFinalMiceMM(EventsBeg(j):EventsEnd(j),2*Imouse-1);
              CoordyWithoutIdent=CoordinatesFinalMiceMM(EventsBeg(j):EventsEnd(j),2*Imouse);
              
              CoordxWithoutIdentP=CoordinatesFinalMice(EventsBeg(j):EventsEnd(j),2*Imouse-1);
              CoordyWithoutIdentP=CoordinatesFinalMice(EventsBeg(j):EventsEnd(j),2*Imouse); %in pixel
              
              %find the coordinates after splitting, which are sure
              CoordxAfterSplit=CoordinatesFinalMiceMM(EventsEnd(j)+1,2*Imouse-1);
              CoordyAfterSplit=CoordinatesFinalMiceMM(EventsEnd(j)+1,2*Imouse);
                 
                   for z=1:length(Imouse)
                       Im=[];
                       distancia=[];
                       Icorrecmouse=Imouse(z);
                       distancia=DistCalc(CoordxWithoutIdent(end,:)',CoordyWithoutIdent(end,:)', CoordxAfterSplit(z),CoordyAfterSplit(z));
                       [~,Im]=min(distancia);
                     
                       CoordinatesFinalMiceMM(EventsBeg(j):EventsEnd(j),2*Imouse(z)-1)=CoordxWithoutIdent(1:end,Im);
                       CoordinatesFinalMiceMM(EventsBeg(j):EventsEnd(j),2*Imouse(z))=CoordyWithoutIdent(1:end,Im);
                       
                       
                       CoordinatesFinalMice(EventsBeg(j):EventsEnd(j),2*Imouse(z)-1)=CoordxWithoutIdentP(1:end,Im);
                       CoordinatesFinalMice(EventsBeg(j):EventsEnd(j),2*Imouse(z))=CoordyWithoutIdentP(1:end,Im);
                       
                      FidelityMatrix(EventsBeg(j):EventsEnd(j),Imouse(z))=0;
                      FidelityAntenna(EventsBeg(j):EventsEnd(j),Imouse(z))=0;
                      
                      
                   end
            end
     end    
 end

end