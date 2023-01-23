function Locomotion=correctionVelocity(Locomotion,VelocityThresholForCorrection,DistanceToSwapIdentity)

%% Idea is to correct the cases in which: the mice are very near for mixing identities (due to incorect segmentation).
% The identity is wrong until the mice found a correct read of the antenna.
% Then the identity jump again.

% 1)- Given the velocity matrix, find the points with velocity > a given
% threshold and less than 1e6 for not considered non defined coordinates.

% 2)- Find the rows with ones.

% 3)- Loop over the frames with ones
% Consider each case separetaly
% 4)- Consider only rows with 2 ones
% 5)-Go from the back to the point that the coordinates are near
% 6)- measure the velocity of each place : if vel <190 return continue 
%% -------------------Do step 1)-------------------------
vel=Locomotion.AssigRFID.VelocityMouse;
XcoordMM=Locomotion.AssigRFID.XcoordMM;
YcoordMM=Locomotion.AssigRFID.YcoordMM;
XcoordPixel=Locomotion.AssigRFID.XcoordPixel;
YcoordPixel=Locomotion.AssigRFID.YcoordPixel;
MouseOrientation=Locomotion.AssigRFID.MouseOrientation;

Locomotion.AssigRFID.MatrixChangedCoordinatesInverse=zeros(size(vel,1),size(vel,2));

Logical_forlargervelocity=(vel>VelocityThresholForCorrection & vel<1e6)&(Locomotion.AssigRFID.XcoordMM~=1e6);


%% -------------------------Do step 2) find frames to  arrange--------------------------------
[r,c,v]=find(Logical_forlargervelocity==1);
frames=unique(r);
%% ------------------------------Do step 3)-----------------------
for countr=1:length(frames)
   % step 4)-
          Index=[];
          Index=find(Logical_forlargervelocity(frames(countr),:)==1);
          if length(Index)==2 
              counti=1;
              while frames(countr)-counti>=1 %step 5)-
                 Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(1))=XcoordMM(frames(countr)-counti,Index(2));
                 Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(2))=XcoordMM(frames(countr)-counti,Index(1));
                 Locomotion.AssigRFID.XcoordPixel(frames(countr)-counti,Index(1))=XcoordPixel(frames(countr)-counti,Index(2));
                 Locomotion.AssigRFID.XcoordPixel(frames(countr)-counti,Index(2))=XcoordPixel(frames(countr)-counti,Index(1));
                 
                  Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(1))=YcoordMM(frames(countr)-counti,Index(2));
                  Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(2))=YcoordMM(frames(countr)-counti,Index(1));
                  Locomotion.AssigRFID.YcoordPixel(frames(countr)-counti,Index(1))=YcoordPixel(frames(countr)-counti,Index(2));
                  Locomotion.AssigRFID.YcoordPixel(frames(countr)-counti,Index(2))=YcoordPixel(frames(countr)-counti,Index(1));
                  
                  Locomotion.AssigRFID.MouseOrientation(frames(countr)-counti,Index(2))=MouseOrientation(frames(countr)-counti,Index(1));
                  Locomotion.AssigRFID.MouseOrientation(frames(countr)-counti,Index(1))=MouseOrientation(frames(countr)-counti,Index(2));
                  
                  %% If the distance is very near break
                  
                  distance=sqrt(( Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(1))- Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(2)))^2+(Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(1))-Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(2)))^2);
                  if distance <DistanceToSwapIdentity
                      
                     break; 
                  end
                  
                  
                  %% 
                  
                  
                  [velocity1,velocityX1,velocityY1]=VelocityCalculation(Locomotion.AssigRFID.XcoordMM(frames(countr)-counti+1,Index(1)),Locomotion.AssigRFID.YcoordMM(frames(countr)-counti+1,Index(1)),...
                                                     Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(1)),Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(1)),...
                                                     Locomotion.ExperimentTime{frames(countr)-counti},Locomotion.ExperimentTime{frames(countr)-counti+1});
                  [velocity2,velocityX2,velocityY2]=VelocityCalculation(Locomotion.AssigRFID.XcoordMM(frames(countr)-counti+1,Index(2)),Locomotion.AssigRFID.YcoordMM(frames(countr)-counti+1,Index(2)),...
                                                     Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(2)),Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(2)),...
                                                     Locomotion.ExperimentTime{frames(countr)-counti},Locomotion.ExperimentTime{frames(countr)-counti+1});

                                                 %% 
                                                 
                    if or(velocity1>=VelocityThresholForCorrection ,velocity2>=VelocityThresholForCorrection)% setp 6)-
                           Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(1))=XcoordMM(frames(countr)-counti,Index(1));
                           Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(2))=XcoordMM(frames(countr)-counti,Index(2));
                            Locomotion.AssigRFID.XcoordPixel(frames(countr)-counti,Index(1))=XcoordPixel(frames(countr)-counti,Index(1));
                           Locomotion.AssigRFID.XcoordPixel(frames(countr)-counti,Index(2))=XcoordPixel(frames(countr)-counti,Index(2));
                           
                 
                            Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(1))=YcoordMM(frames(countr)-counti,Index(1));
                            Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(2))=YcoordMM(frames(countr)-counti,Index(2));
                            Locomotion.AssigRFID.YcoordPixel(frames(countr)-counti,Index(1))=YcoordPixel(frames(countr)-counti,Index(1));
                            Locomotion.AssigRFID.YcoordPixel(frames(countr)-counti,Index(2))=YcoordPixel(frames(countr)-counti,Index(2));
                            
                             Locomotion.AssigRFID.MouseOrientation(frames(countr)-counti,Index(1))=MouseOrientation(frames(countr)-counti,Index(1));
                             Locomotion.AssigRFID.MouseOrientation(frames(countr)-counti,Index(2))=MouseOrientation(frames(countr)-counti,Index(2));
                            
                        break;
                    end
                    
                          %% Rearrange new velocity
                 Locomotion.AssigRFID.VelocityMouse(frames(countr)-counti+1,Index(1))=velocity1;                                
                 Locomotion.AssigRFID.VelocityMouse(frames(countr)-counti+1,Index(2))=velocity2;                                 
                                                 
         %% Mark the coordinates which were corrected to be able to follow                                           
                  Locomotion.AssigRFID.MatrixChangedCoordinatesInverse(frames(countr)-counti,Index(1))=1;
                   Locomotion.AssigRFID.MatrixChangedCoordinatesInverse(frames(countr)-counti,Index(2))=1;
                    
                    
      %% 
                    
                    
                 counti=counti+1;
              end
              
              
             
          end
end

%% 
