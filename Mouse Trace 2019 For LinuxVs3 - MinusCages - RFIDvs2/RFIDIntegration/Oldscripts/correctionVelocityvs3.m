function Locomotion=correctionVelocity(VectorCluster,Locomotion,VelocityThresholForCorrection,Conversionx,Conversiony,TotalFrames)

%% Idea is to correct the cases in which: the mice are very near for mixing identities (due to incorect segmentation).
% The identity is wrong until the mice found a correct read of the antenna.
% Then the identity jump again.

% 1)- Given the velocity matrix, find the points with velocity > a given
% threshold and less than 1e6 for not considered non defined coordinates.

% 2)- Find the rows with ones.

% 3)- Loop over the frames with ones
% Consider each case separetaly
% 4)- Consider only rows with 2 ones- given the swaping identities create a
% matrix with the last frame and find new assignment -check velocity  - and
% continue until the new position coincides with the forward position
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
frames=sort(frames,'descend');
Locomotion.AssigRFID.FramesHighVelocity=[];
Locomotion.AssigRFID.FramesHighVelocity=frames;
%% ------------------------------Do step 3)-----------------------
for countr=1:length(frames)
   % step 4)-
          Index=[];
          Index=find(Logical_forlargervelocity(frames(countr),:)==1);
          
          %% %%%%%%%%%%%%%%%%%%%%%%% Consider the case of a swap of 2 defined identities %%%%%%%%%%%%%%%%%%%%%%
          % Initialization
          XAllProbablyMM=[];
          YAllProbablyMM=[];
          XAllProbablyPixel=[];
          YAllProbablyPixel=[];
          OrientationAllNew=[];
          VelocityAllNew=[];
          
          if length(Index)==2 
              counti=1;
              while frames(countr)-counti>=1  %step 5)-
               f= frames(countr)
               a=frames(countr)-counti
           
              
                    xNextPixel= Locomotion.AssigRFID.XcoordPixel(frames(countr)-counti,Index);
                    yNextPixel= Locomotion.AssigRFID.YcoordPixel(frames(countr)-counti,Index);
                    OrientationNextPixel=Locomotion.AssigRFID.MouseOrientation(frames(countr)-counti,Index);
                    xNextMM= Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index);
                    yNextMM= Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index);
                    
             if counti==1
                    xBeforePixel=Locomotion.AssigRFID.XcoordPixel(frames(countr)-counti+1,Index);
                    yBeforePixel=Locomotion.AssigRFID.YcoordPixel(frames(countr)-counti+1,Index);
                    OrientationBeforePixel=Locomotion.AssigRFID.MouseOrientation(frames(countr)-counti+1,Index);
                    xBeforeMM=Locomotion.AssigRFID.XcoordMM(frames(countr)-counti+1,Index);
                    yBeforeMM=Locomotion.AssigRFID.YcoordMM(frames(countr)-counti+1,Index);
             else
                    xBeforePixel=XnewProbablyPixel;
                    yBeforePixel= YnewProbablyPixel;
                    OrientationBeforePixel=OrientationNew;
                    xBeforeMM= XnewProbablyMM;
                    yBeforeMM=YnewProbablyMM;
             end

                Timefinal=Locomotion.ExperimentTime{frames(countr)-counti};
                
                TimeInitial=Locomotion.ExperimentTime{frames(countr)-counti+1};
               
              if counti==1  
                VelxBefore=zeros(1,length(Index));
                VelyBefore=zeros(1,length(Index));
                OrientationNextPixel=zeros(1,length(Index));
                OrientationBeforePixel=zeros(1,length(Index));
              else
                  VelxBefore=velocityX1'; %This is in mm/sec
                  VelyBefore=velocityY1'; %This is in mm/sec
                  
              end
              % Calculation of the matrix and munkres assignment
               [MatrixToMinimize,~]=Matrix_to_Consider_LastFrame(xNextPixel',yNextPixel',OrientationNextPixel',......
                                xBeforePixel,yBeforePixel, OrientationBeforePixel,VelxBefore,VelyBefore,Timefinal, TimeInitial,...
                                Conversionx,Conversiony);
                            
                              [assignmentReverse,~]=munkresForMiceTracer(MatrixToMinimize); 
                              %% %%%%%%%%%%%%%%%%New assigment
                              
              %  Do assigment
                 for countAssignment=1:length(assignmentReverse) 
                    XnewProbablyMM(countAssignment)=Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(assignmentReverse(countAssignment)));
                    YnewProbablyMM(countAssignment)=Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(assignmentReverse(countAssignment))); 
                    XnewProbablyPixel(countAssignment)=Locomotion.AssigRFID.XcoordPixel(frames(countr)-counti,Index(assignmentReverse(countAssignment)));
                    YnewProbablyPixel(countAssignment)=Locomotion.AssigRFID.YcoordPixel(frames(countr)-counti,Index(assignmentReverse(countAssignment))); 
                    OrientationNew(countAssignment)=Locomotion.AssigRFID.MouseOrientation(frames(countr)-counti,Index(assignmentReverse(countAssignment))); 
                   
                 end
                 
                  % Velocity 
               
                  [velocity1,velocityX1,velocityY1]=VelocityCalculation(XnewProbablyMM, YnewProbablyMM,...
                                                     xBeforeMM,yBeforeMM,...
                                                     Locomotion.ExperimentTime{frames(countr)-counti+1},Locomotion.ExperimentTime{frames(countr)-counti});
                 % Calculate distance
                  distanceBefore=sqrt((xBeforeMM(1)-xBeforeMM(2))^2+(yBeforeMM(1)-yBeforeMM(2))^2);
                  distanceAfter=sqrt((XnewProbablyMM(1)-XnewProbablyMM(2))^2+(YnewProbablyMM(1)-YnewProbablyMM(2))^2);
                                                 
              if distanceAfter-distanceBefore<=20    
                 % Add to a probably vector
                 XAllProbablyMM=[XAllProbablyMM;XnewProbablyMM];
                 YAllProbablyMM=[YAllProbablyMM;YnewProbablyMM];
                 XAllProbablyPixel=[XAllProbablyPixel;XnewProbablyPixel];
                 YAllProbablyPixel=[YAllProbablyPixel;YnewProbablyPixel];
                 OrientationAllNew=[OrientationAllNew; OrientationNew];
                 VelocityAllNew=[VelocityAllNew;velocity1'];
                 
                 %% 
              elseif  (distanceAfter >20+ distanceBefore)& isempty(VelocityAllNew)    %at the beggining
                         break;
              elseif (distanceAfter >20+ distanceBefore) & ( ~isempty(find(VelocityAllNew(:,1)>VelocityThresholForCorrection)))  
                           break;
                   elseif  (distanceAfter > 20+ distanceBefore) &(isempty(find(VelocityAllNew(:,1)>VelocityThresholForCorrection)))                            
               % if  condition of at least one of the 2 mice                                
                   % if (XnewProbablyMM(1)==xNextMM(1) & YnewProbablyMM(1)==yNextMM(1))
                  
                          Locomotion.AssigRFID.XcoordMM(frames(countr)-1:-1:frames(countr)-counti+1,Index)=XAllProbablyMM;
                          Locomotion.AssigRFID.XcoordPixel(frames(countr)-1:-1:frames(countr)-counti+1,Index)=XAllProbablyPixel;
                          Locomotion.AssigRFID.YcoordMM(frames(countr)-1:-1:frames(countr)-counti+1,Index)=YAllProbablyMM;
                          Locomotion.AssigRFID.YcoordPixel(frames(countr)-1:-1:frames(countr)-counti+1,Index)=YAllProbablyPixel;
                          Locomotion.AssigRFID.MouseOrientation(frames(countr)-1:-1:frames(countr)-counti+1,Index)= OrientationAllNew;
                          Locomotion.AssigRFID.VelocityMouse(frames(countr):-1:frames(countr)-counti+2,Index)=VelocityAllNew;
                          % Mark the coordinates which were corrected to be able to follow                                           
                          Locomotion.AssigRFID.MatrixChangedCoordinatesInverse(frames(countr)-1:-1:frames(countr)-counti+1,Index)=1;
                        
                        break; % if the position from back to forward was acquired or the velocity is wrong
                        
                    elseif frames(countr)-counti==1 % change original coordinates    
                        
                        break;
                        
               end
                                                 
         
          %% 
          
          
          
                          %% Rearrange new velocity
%                  Locomotion.AssigRFID.VelocityMouse(frames(countr)-counti+1,Index(1))=velocity1(1);                                
%                  Locomotion.AssigRFID.VelocityMouse(frames(countr)-counti+1,Index(2))=velocity1(2);                                 
%                                                  
%          %% Mark the coordinates which were corrected to be able to follow                                           
%                   Locomotion.AssigRFID.MatrixChangedCoordinatesInverse(frames(countr)-counti,Index(1))=1;
%                    Locomotion.AssigRFID.MatrixChangedCoordinatesInverse(frames(countr)-counti,Index(2))=1;
                    
                    
      %% 
                    
               counti=counti+1;
          end          
                
              
              
             
          end
end

%% 
