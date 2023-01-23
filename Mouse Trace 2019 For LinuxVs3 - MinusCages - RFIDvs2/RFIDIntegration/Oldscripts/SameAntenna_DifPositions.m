function  [FidelityMatrix, FidelityAntenna,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=SameAntenna_DifPositions(FidelityMatrix, FidelityAntenna,AntennaNumber,countFrames,distancePosToAntenna,Imouse,CoordinatesFinalMiceMM,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,PositionSelectedx,PositionSelectedy,PositionSelectedxP,PositionSelectedyP)


 if length(unique(distancePosToAntenna))==length(distancePosToAntenna) %Thus the positions aren't repeated
            %% Get the coordinates for the respective mice of the  last frame
            for i=1:length(Imouse)
            xmouse(i)=CoordinatesFinalMiceMM(countFrames-1,2*Imouse(i)-1);
            ymouse(i)=CoordinatesFinalMiceMM(countFrames-1,2*Imouse(i));
    
            end


%% If the position of the last frame is the same assigned a position to each mouse in arbitrary way and create a fidelity matrix 
            if length(unique(xmouse))==1 & length(unique(ymouse))==1
                    for i=1:length(Imouse) % in arbitrary way we are doing the assignment and complete the fidelity and antenna fidelity
                  
                            Coordinatesx(Imouse(i),1)=PositionSelectedx(i,1);
                            Coordinatesy(Imouse(i),1)=PositionSelectedy(i,1);
                            CoordinatesxP(Imouse(i),1)=PositionSelectedxP(i,1);
                            CoordinatesyP(Imouse(i),1)=PositionSelectedyP(i,1); 
                  
                            FidelityMatrix(countFrames,Imouse(i))=1; %the identity of the mouse is not sure
                  
                            FidelityAntenna(countFrames,Imouse(i))=AntennaNumber;
                  
                  
                    end
               
               %% 
               
            elseif  ~(length(unique(xmouse))==1 & length(unique(ymouse))==1) & isempty(find(xmouse==1e6))   %if the positions of last frame different and different from 1e6
                %consider the case with 2 positions by assuming that the
                %mouse is going all the time forward- cannot go reverse
                     if length(Imouse)==2 %for only 2 mice
                                    [Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=Same_Antenna_TwoMice_Dif_Pos(PositionSelectedx,PositionSelectedy,PositionSelectedxP,PositionSelectedyP,xmouse,ymouse,Imouse,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP);
                      else  
                            for j=1:length(Imouse)
                    
                                    Im=[];
                                    distanceFromLastToNew=[];
                                    distanceFromLastToNew=DistCalc(PositionSelectedx,PositionSelectedy,xmouse(j),ymouse(j));%x and y last positions
                                    [~,Im]=min(distanceFromLastToNew);
                   
                                    Coordinatesx(Imouse(j),1)=PositionSelectedx(Im,1);
                                    Coordinatesy(Imouse(j),1)=PositionSelectedy(Im,1);
                                    CoordinatesxP(Imouse(j),1)=PositionSelectedxP(Im,1);
                                    CoordinatesyP(Imouse(j),1)=PositionSelectedyP(Im,1); 
                  
                                    if FidelityMatrix(countFrames-1,Imouse(j))==1 %if the last position was not sure
                                      FidelityMatrix(countFrames,Imouse(j))=1; %this means that it is not sure about the position
                                      FidelityAntenna(countFrames,Imouse(j))=AntennaNumber;
                                    end      
                    
                            end  
                     end            
                  
            elseif ~(length(unique(xmouse))==1 & length(unique(ymouse))==1) & ~isempty(find(xmouse==1e6)) %if the positions are different and there are non defined last positions 1e6
               [~,iIsort]=sort(xmouse); %last values are the one non-defined
                
                            for ii=1:length(iIsort)
                                  if ii==1
                                     Im=[];
                                     distanceFromLastToNew=[];
                                     distanceFromLastToNew=DistCalc( PositionSelectedx,PositionSelectedy,xmouse(iIsort(ii)),ymouse(iIsort(ii)));%x and y last positions
                                     [~,Im]=min(distanceFromLastToNew);
                   
                                    Coordinatesx(Imouse(iIsort(ii)),1)=PositionSelectedx(Im,1);
                                    Coordinatesy(Imouse(iIsort(ii)),1)=PositionSelectedy(Im,1);
                                    CoordinatesxP(Imouse(iIsort(ii)),1)=PositionSelectedxP(Im,1);
                                    CoordinatesyP(Imouse(iIsort(ii)),1)=PositionSelectedyP(Im,1); 
                  
                                          if FidelityMatrix(countFrames-1,Imouse(iIsort(ii)))==1 %if the last position was not sure
                                              FidelityMatrix(countFrames,Imouse(iIsort(ii)))=1; %this means that it is not sure about the position
% % %                                               FidelityAntenna(countFrames,Imouse(iIsort(ii)))=SubsetAntennaNumberDuplicate(i,1);
                                          end  
                                  elseif  length(iIsort)==2 %Not considerer more than 2      
                                          
                                          NextPosx=setdiff(PositionSelectedx,PositionSelectedx(Im,1));
                                          NextPosy=setdiff(PositionSelectedy,PositionSelectedy(Im,1));
                                         
                                          NextPosxP=setdiff(PositionSelectedxP,PositionSelectedxP(Im,1));
                                          NextPosyP=setdiff(PositionSelectedyP,PositionSelectedyP(Im,1));
                                          
                                          
                                            Coordinatesx(Imouse(iIsort(ii)),1)=NextPosx;
                                            Coordinatesy(Imouse(iIsort(ii)),1)=NextPosy;
                                            CoordinatesxP(Imouse(iIsort(ii)),1)=NextPosxP;
                                            CoordinatesyP(Imouse(iIsort(ii)),1)=NextPosyP; 
                                            
                                            
                                          if FidelityMatrix(countFrames-1,Imouse(iIsort(ii)))==1 %if the last position was not sure
                                              FidelityMatrix(countFrames,Imouse(iIsort(ii)))=1; %this means that it is not sure about the position
                                             % FidelityAntenna(countFrames,Imouse(iIsort(ii)))=SubsetAntennaNumberDuplicate(i,1);
                                          end 
                                            
                                            
                                          
                                  end  
                
                
                            end
                

           end
       
 end


end


%% ------------------------------------------Auxiliary functions----------------------

function  [Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=Same_Antenna_TwoMice_Dif_Pos(PositionSelectedx,PositionSelectedy,PositionSelectedxP,PositionSelectedyP,xmouseLastFrame,ymouseLastFrame,Imouse,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP)

vectorLastFrame=[xmouseLastFrame(2)-xmouseLastFrame(1),ymouseLastFrame(2)-ymouseLastFrame(1)];

vector1=[PositionSelectedx(2,1)-PositionSelectedx(1,1),PositionSelectedy(2,1)-PositionSelectedy(1,1)];

    if dot(vectorLastFrame,vector1)>=0
     
                                    Coordinatesx(Imouse(1),1)=PositionSelectedx(1,1);
                                    Coordinatesy(Imouse(1),1)=PositionSelectedy(1,1);
                                    CoordinatesxP(Imouse(1),1)=PositionSelectedxP(1,1);
                                    CoordinatesyP(Imouse(1),1)=PositionSelectedyP(1,1);
                                    
                                    
                                    Coordinatesx(Imouse(2),1)=PositionSelectedx(2,1);
                                    Coordinatesy(Imouse(2),1)=PositionSelectedy(2,1);
                                    CoordinatesxP(Imouse(2),1)=PositionSelectedxP(2,1);
                                    CoordinatesyP(Imouse(2),1)=PositionSelectedyP(2,1); 
    
    else
                                  
                                   Coordinatesx(Imouse(2),1)=PositionSelectedx(1,1);
                                    Coordinatesy(Imouse(2),1)=PositionSelectedy(1,1);
                                    CoordinatesxP(Imouse(2),1)=PositionSelectedxP(1,1);
                                    CoordinatesyP(Imouse(2),1)=PositionSelectedyP(1,1);
                                    
                                    
                                    Coordinatesx(Imouse(1),1)=PositionSelectedx(2,1);
                                    Coordinatesy(Imouse(1),1)=PositionSelectedy(2,1);
                                    CoordinatesxP(Imouse(1),1)=PositionSelectedxP(2,1);
                                    CoordinatesyP(Imouse(1),1)=PositionSelectedyP(2,1); 
    
        
        
    end



end


