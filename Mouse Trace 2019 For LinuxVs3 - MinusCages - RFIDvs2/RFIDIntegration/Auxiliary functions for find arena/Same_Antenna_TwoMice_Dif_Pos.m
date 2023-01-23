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


