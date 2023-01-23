

function RearrangeArenaCoord(Corners_option,Eating_option,Drinking_option,LargeBridge_option,NarrowBridge_option,Arena_option,Hiding_Box_option,Out_Zone_option) %add location to video
%% Load variables
global h
Initial_Parameters=Parameters();
%% 
%%Get the reference frame in order to add coordinates 
v = VideoReader(get(h.editLoadDirectoryChild,'string'));

%%Get the intrested frame

Reference_frame_number=get( h.editNumFrames,'string');

Reference_frame=read(v,str2num(Reference_frame_number));
Reference_frameorig=Reference_frame;

%% 
if strcmp(Arena_option,'Left')==1
HidingCoordinates=[184.1501458	486.2376093;... % 24 points(xy)-6 boxes: 4 shelters without 2 bridges
213.5379009	434.1793003;...                        % (in pixels)
245.4446064	460.2084548;...
216.0568513	507.228863;...
% 172.3950437	339.2988338;...
% 169.8760933	232.6632653;...
% 258.0393586	232.6632653;...
% 257.1997085	341.8177843;...
202.622449	135.2638484;...
185.8294461	82.36588921;...
220.255102	67.25218659;...
237.8877551	120.1501458;...
461.2346939	108.3950437;...
494.8206997	56.33673469;...
527.5670554	81.52623907;...
493.1413994	134.4241983;...
% 478.8673469	348.5349854;...
% 478.0276968	212.5116618;...
% 507.4154519	212.5116618;...
% 512.4533528	349.3746356;...
495.6603499	507.228863;...
462.9139942	450.9723032;...
493.9810496	429.9810496;...
528.4067055	479.5204082];

XY=HidingCoordinates
%HidingCoordinatesCentral=[212 482;501 485;503 92; 211 99];
HidingCoordinatesCentral=[211 99;503 92;501 485;212 482];
HidingCoordinates1=[211 438; 254 466;208 534 ;168 508];    
HidingCoordinates2=[459 469; 506 437;548 500;499 535];
HidingCoordinates3=[502 50; 551 84;499 146;461 114];
HidingCoordinates4=[172 78; 222 52;250 124;203 149];
%% Arrange corners if it is necessary

            if strcmp(Corners_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle around the arena. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                Corners_PixelCoordinates=[pos(1) pos(2); pos(1)+pos(3) pos(2);pos(1)+pos(3) pos(2)+pos(4) ;pos(1) pos(2)+pos(4)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Corners_PixelCoordinates,'+','color','red','size',12); %corning
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    Corners_PixelCoordinates=[123.6953353	30.30758017;...,
                    591.3804665	25.2696793;...,
                    591.3804665	536.6166181;...,
                    126.2142857	539.9752187];
                
                    Reference_frame=insertMarker(Reference_frame,Corners_PixelCoordinates,'+','color','red','size',12); %corning
                
                
            end
        image(Reference_frame,'Parent', h.hAxis);
        
        %% For food coordinates
        if strcmp(Eating_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle around the food stand. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                Food_PixelCoordinates=[pos(1) pos(2); pos(1)+pos(3) pos(2);pos(1)+pos(3) pos(2)+pos(4) ;pos(1) pos(2)+pos(4)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Food_PixelCoordinates,'s','color','green','size',12); %food
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    Food_PixelCoordinates=[319.3338192 242.7390671;...
                                          317.654519 211.6720117;...
                                          394.0626822 215.8702624;...
                                          394.0626822 246.0976676];
                
                    Reference_frame=insertMarker(Reference_frame,Food_PixelCoordinates,'s','color','green','size',12); %food
                
                
        end
            image(Reference_frame,'Parent', h.hAxis);
        
        %% 
          %% For drinking coordinates
        if strcmp(Drinking_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a point in the drink stand. When you are ready double click');
                
                haux=figure;
                image(Reference_frameaux);
                
                hp=impoint;
                wait(hp);
                pos=getPosition(hp);
                Drink_PixelCoordinates=[pos(1) pos(2)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Drink_PixelCoordinates,'*','color','magenta','size',12); %drink
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    Drink_PixelCoordinates=[352.9198251 305.712828];
                
                    Reference_frame=insertMarker(Reference_frame,Drink_PixelCoordinates,'*','color','magenta','size',12); %drink
                
                
        end
            image(Reference_frame,'Parent', h.hAxis);
        
          %% For Large bridge
        if strcmp(LargeBridge_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle around the large bridge. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                LargeBridge_PixelCoordinates=[pos(1) pos(2); pos(1)+pos(3) pos(2);pos(1)+pos(3) pos(2)+pos(4) ;pos(1) pos(2)+pos(4)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,LargeBridge_PixelCoordinates,'x','color','magenta','size',12); %bridge
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    LargeBridge_PixelCoordinates=[464 239;558 239;464 351;558 351];
                
                    Reference_frame=insertMarker(Reference_frame,LargeBridge_PixelCoordinates,'x','color','magenta','size',12); %bridge
                
                
        end
            image(Reference_frame,'Parent', h.hAxis); 
            %%         %% For Narrow bridge
        if strcmp(NarrowBridge_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle around the narrow bridge. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                NarrowBridge_PixelCoordinates=[pos(1) pos(2); pos(1)+pos(3) pos(2);pos(1)+pos(3) pos(2)+pos(4) ;pos(1) pos(2)+pos(4)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,NarrowBridge_PixelCoordinates,'x','color','magenta','size',12); %bridge
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    NarrowBridge_PixelCoordinates=[210 211;241 211;210 355;241 355];
                
                    Reference_frame=insertMarker(Reference_frame,NarrowBridge_PixelCoordinates,'x','color','magenta','size',12); %bridge
                
                
        end
            image(Reference_frame,'Parent', h.hAxis); 
            %% Mark the region separated inside from outside zone
            
           if strcmp(Out_Zone_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle marking the out from inside zone. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                OutZone_PixelCoordinates=[pos(1), pos(2), pos(3), pos(4)];
                close(haux)
                
                %draw the rectangle
                Reference_frame=insertShape(Reference_frame,'Rectangle', OutZone_PixelCoordinates,'LineWidth', 5,'color','yellow'); %bridge
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                   OutZone_PixelCoordinates=[123.6953353, 30.30758017,500,500];
                  
                
                    Reference_frame=insertShape(Reference_frame,'Rectangle', OutZone_PixelCoordinates,'LineWidth', 5,'color','yellow'); %bridge
                image(Reference_frame,'Parent', h.hAxis);
                
                
        end
            image(Reference_frame,'Parent', h.hAxis);   
            
            
            
            
            %% For Hiding Box 
            
                  if strcmp(Hiding_Box_option,'Change')==1

                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark the points around the first hiding box Top- Left. When you are ready double click inside the rectangle');

                haux=figure;
                image(Reference_frameaux);

                hrect=impoly;
                wait(hrect);
                pos=getPosition(hrect)
                
              
                
                
                First_HidingCoordinates=[pos(1,1) pos(1,2);pos(2,1) pos(2,2);pos(3,1) pos(3,2);pos(4,1) pos(4,2)]
                
                close(haux)

                %draw new positions
                Reference_frame=insertMarker(Reference_frame,First_HidingCoordinates,'x','color','blue','size',9); %hiding 1
                image(Reference_frame,'Parent', h.hAxis);
                %% 
                  Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark the points around the second hiding box Top- right. When you are ready double click inside the rectangle');

                haux=figure;
                image(Reference_frameaux);

                hrect=impoly;
                wait(hrect);
                pos=getPosition(hrect);
                Second_HidingCoordinates=[pos(1,1) pos(1,2);pos(2,1) pos(2,2);pos(3,1) pos(3,2);pos(4,1) pos(4,2)]
                
                close(haux)

                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Second_HidingCoordinates,'x','color','black','size',9); %hiding2
                image(Reference_frame,'Parent', h.hAxis);
                
                %% 
                    Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark the points around the third hiding box bottom- right. When you are ready double click inside the rectangle');

                haux=figure;
                image(Reference_frameaux);

                hrect=impoly;
                wait(hrect);
                pos=getPosition(hrect)
                Third_HidingCoordinates=[pos(1,1) pos(1,2);pos(2,1) pos(2,2);pos(3,1) pos(3,2);pos(4,1) pos(4,2)]
                
                close(haux)

                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Third_HidingCoordinates,'x','color','black','size',9); %hiding 3
                image(Reference_frame,'Parent', h.hAxis);
                
                %% 
                    Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark the points around the fourth hiding box bottom- left. When you are ready double click inside the rectangle');

                haux=figure;
                image(Reference_frameaux);

                hrect=impoly;
                wait(hrect);
                pos=getPosition(hrect);
                Four_HidingCoordinates=[pos(1,1) pos(1,2);pos(2,1) pos(2,2);pos(3,1) pos(3,2);pos(4,1) pos(4,2)]
                
           
                
                close(haux)

                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Four_HidingCoordinates,'x','color','black','size',9); %hiding 4
                image(Reference_frame,'Parent', h.hAxis);
                
                

            else
                    First_HidingPixelCoordinates=[211 438; 254 466;208 534 ;168 508];

                    Reference_frame=insertMarker(Reference_frame,First_HidingPixelCoordinates,'x','color','black','size',9); 
                    
                    Second_HidingPixelCoordinates=[459 469; 506 437;548 500;499 535];

                    Reference_frame=insertMarker(Reference_frame,Second_HidingPixelCoordinates,'x','color','green','size',9); 
                    
                    
                    Third_HidingPixelCoordinates=[502 50; 551 84;499 146;461 114];

                    Reference_frame=insertMarker(Reference_frame,Third_HidingPixelCoordinates,'x','color','green','size',9); 
                    
                      
                    Four_HidingPixelCoordinates=[172 78; 222 52;250 124;203 149];

                    Reference_frame=insertMarker(Reference_frame,Four_HidingPixelCoordinates,'x','color','green','size',9); 
                    


        end
            image(Reference_frame,'Parent', h.hAxis);
            
            
            
            
        
elseif strcmp(Arena_option,'Right')==1
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%For the right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%option%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
  HidingCoordinates=[165.6778426 443.4154519;...
187.5087464 463.5670554;...
158.9606414	501.351312;...
137.9693878	483.7186589;...
% 120.3367347	249.4562682;...
% 190.0276968	246.0976676;...
% 193.3862974	340.138484;...
% 124.5349854	342.6574344;...
132.0918367	91.60204082;...
157.2813411	73.96938776;...
180.7915452	115.951895;...
160.6399417	134.4241983;...
453.6778426	79.00728863;...
468.7915452	99.99854227;...
441.9227405	129.3862974;...
425.1297376	110.074344;...
% 436.0451895	225.9460641;...
% 455.3571429	226.7857143;...
% 454.5174927	350.2142857;...
% 431.8469388	350.2142857;...
428.4883382	465.2463557;...
451.1588921	449.2930029;...
472.1501458	482.0393586;...
449.4795918	499.6720117];

 XY=HidingCoordinates;
  HidingCoordinatesCentral=[231 110;522 102;526 478;233 476];
%% Arrange corners if it is necessary

            if strcmp(Corners_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle around the arena. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                Corners_PixelCoordinates=[pos(1) pos(2); pos(1)+pos(3) pos(2);pos(1)+pos(3) pos(2)+pos(4) ;pos(1) pos(2)+pos(4)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Corners_PixelCoordinates,'+','color','red','size',12); %corning
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    Corners_PixelCoordinates=[143 33;621 28; 620 551; 150 544];
                
                    Reference_frame=insertMarker(Reference_frame,Corners_PixelCoordinates,'+','color','red','size',12); %corning
                
                
            end
        image(Reference_frame,'Parent', h.hAxis);
        
        %% For food coordinates
        if strcmp(Eating_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle around the food stand. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                Food_PixelCoordinates=[pos(1) pos(2); pos(1)+pos(3) pos(2);pos(1)+pos(3) pos(2)+pos(4) ;pos(1) pos(2)+pos(4)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Food_PixelCoordinates,'s','color','green','size',12); %food
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    Food_PixelCoordinates=[328 253;331 227;408 228;411 256];
                
                    Reference_frame=insertMarker(Reference_frame,Food_PixelCoordinates,'s','color','green','size',12); %food
                
                
        end
            image(Reference_frame,'Parent', h.hAxis);
        
        %% 
          %% For drinking coordinates
        if strcmp(Drinking_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a point in the drink stand. When you are ready double click');
                
                haux=figure;
                image(Reference_frameaux);
                
                hp=impoint;
                wait(hp);
                pos=getPosition(hp);
                Drink_PixelCoordinates=[pos(1) pos(2)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Drink_PixelCoordinates,'*','color','magenta','size',12); %drink
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    Drink_PixelCoordinates=[372 309];
                
                    Reference_frame=insertMarker(Reference_frame,Drink_PixelCoordinates,'*','color','magenta','size',12); %drink
                
                
        end
            image(Reference_frame,'Parent', h.hAxis);
        
          %% For Large bridge
        if strcmp(LargeBridge_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle around the large bridge. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                LargeBridge_PixelCoordinates=[pos(1) pos(2); pos(1)+pos(3) pos(2);pos(1)+pos(3) pos(2)+pos(4) ;pos(1) pos(2)+pos(4)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,LargeBridge_PixelCoordinates,'x','color','magenta','size',12); %bridge
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    LargeBridge_PixelCoordinates=[477 237;569 241;477 354;569 356];
                
                    Reference_frame=insertMarker(Reference_frame,LargeBridge_PixelCoordinates,'x','color','magenta','size',12); %bridge
                
                
        end
            image(Reference_frame,'Parent', h.hAxis); 
            %%         %% For Narrow bridge
        if strcmp(NarrowBridge_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle around the narrow bridge. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                NarrowBridge_PixelCoordinates=[pos(1) pos(2); pos(1)+pos(3) pos(2);pos(1)+pos(3) pos(2)+pos(4) ;pos(1) pos(2)+pos(4)];
                close(haux)
                
                %draw new positions
                Reference_frame=insertMarker(Reference_frame,NarrowBridge_PixelCoordinates,'x','color','magenta','size',12); %bridge
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    NarrowBridge_PixelCoordinates=[231 223;264 228;236 362;271 363];
                
                    Reference_frame=insertMarker(Reference_frame,NarrowBridge_PixelCoordinates,'x','color','magenta','size',12); %bridge
                
                
        end
        %%       %% Mark the region separated inside from outside zone
            
           if strcmp(Out_Zone_option,'Change')==1
                
                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark a rectangle marking the out from inside zone. When you are ready double click inside the rectangle');
                
                haux=figure;
                image(Reference_frameaux);
                
                hrect=imrect;
                wait(hrect);
                pos=getPosition(hrect);
                OutZone_PixelCoordinates=[pos(1), pos(2), pos(3), pos(4)];
                close(haux)
                
                %draw the rectangle
                Reference_frame=insertShape(Reference_frame,'Rectangle', OutZone_PixelCoordinates,'LineWidth', 5,'color','yellow'); %bridge
                image(Reference_frame,'Parent', h.hAxis);
    
            else    
                    OutZone_PixelCoordinates=[143,33,500,500];
                
                    Reference_frame=insertShape(Reference_frame,'Rectangle', OutZone_PixelCoordinates,'LineWidth', 5,'color','yellow'); %bridge
             
                
                
        end
            image(Reference_frame,'Parent', h.hAxis);   
        
        
        %%   For Hiding Box 
            
                 if strcmp(Hiding_Box_option,'Change')==1

                Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark the points around the first hiding box Top- Left. When you are ready double click inside the rectangle');

                haux=figure;
                image(Reference_frameaux);

                hrect=impoly;
                wait(hrect);
                pos=getPosition(hrect)
                
              
                
                
                First_HidingCoordinates=[pos(1,1) pos(1,2);pos(2,1) pos(2,2);pos(3,1) pos(3,2);pos(4,1) pos(4,2)];
                
                close(haux)

                %draw new positions
                Reference_frame=insertMarker(Reference_frame,First_HidingCoordinates,'x','color','blue','size',9); %hiding 1
                image(Reference_frame,'Parent', h.hAxis);
                %% 
                  Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark the points around the second hiding box Top- right. When you are ready double click inside the rectangle');

                haux=figure;
                image(Reference_frameaux);

                hrect=impoly;
                wait(hrect);
                pos=getPosition(hrect);
                Second_HidingCoordinates=[pos(1,1) pos(1,2);pos(2,1) pos(2,2);pos(3,1) pos(3,2);pos(4,1) pos(4,2)];
                
                close(haux)

                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Second_HidingCoordinates,'x','color','black','size',9); %hiding2
                image(Reference_frame,'Parent', h.hAxis);
                
                %% 
                    Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark the points around the third hiding box bottom- right. When you are ready double click inside the rectangle');

                haux=figure;
                image(Reference_frameaux);

                hrect=impoly;
                wait(hrect);
                pos=getPosition(hrect)
                Third_HidingCoordinates=[pos(1,1) pos(1,2);pos(2,1) pos(2,2);pos(3,1) pos(3,2);pos(4,1) pos(4,2)];
                
                close(haux)

                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Third_HidingCoordinates,'x','color','black','size',9); %hiding 3
                image(Reference_frame,'Parent', h.hAxis);
                
                %% 
                    Reference_frameaux=insertText(Reference_frameorig,[20,3],'Mark the points around the fourth hiding box bottom- left. When you are ready double click inside the rectangle');

                haux=figure;
                image(Reference_frameaux);

                hrect=impoly;
                wait(hrect);
                pos=getPosition(hrect);
                Four_HidingCoordinates=[pos(1,1) pos(1,2);pos(2,1) pos(2,2);pos(3,1) pos(3,2);pos(4,1) pos(4,2)];
                
                close(haux)

                %draw new positions
                Reference_frame=insertMarker(Reference_frame,Four_HidingCoordinates,'x','color','black','size',9); %hiding 4
                image(Reference_frame,'Parent', h.hAxis);
                
                

            else
                    First_HidingPixelCoordinates=[211 438; 254 466;208 534 ;168 508];

                    Reference_frame=insertMarker(Reference_frame,First_HidingPixelCoordinates,'x','color','green','size',9); 
                    
                    Second_HidingPixelCoordinates=[459 469; 506 437;548 500;499 535];

                    Reference_frame=insertMarker(Reference_frame,Second_HidingPixelCoordinates,'x','color','green','size',9); 
                    
                    
                    Third_HidingPixelCoordinates=[502 50; 551 84;499 146;461 114];

                    Reference_frame=insertMarker(Reference_frame,Third_HidingPixelCoordinates,'x','color','green','size',9); 
                    
                      
                    Four_HidingPixelCoordinates=[172 78; 222 52;250 124;203 149];

                    Reference_frame=insertMarker(Reference_frame,Four_HidingPixelCoordinates,'x','color','green','size',9); 
                    


        end
        
        
        
        
        
        
        %% 
        
            image(Reference_frame,'Parent', h.hAxis); 

end
%% Save in a mat file in a new directory inside the root folder

Ichar=strfind(char(Initial_Parameters.DataDirectory),'\');
Root_directory=char(Initial_Parameters.DataDirectory);

mkdir([Root_directory(1:Ichar(length(Ichar))),Initial_Parameters.ExperimentName,'\Parameters\']);

save(strcat(Root_directory(1:Ichar(length(Ichar))),Initial_Parameters.ExperimentName,'\Parameters\','MovingParametersInArena.mat'),'HidingCoordinatesCentral','Corners_PixelCoordinates','Food_PixelCoordinates','Drink_PixelCoordinates','NarrowBridge_PixelCoordinates','LargeBridge_PixelCoordinates','First_HidingCoordinates','Second_HidingCoordinates','Third_HidingCoordinates','Four_HidingCoordinates','OutZone_PixelCoordinates');




end

