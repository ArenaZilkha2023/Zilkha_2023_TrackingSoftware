function Locomotion=correctionVelocityCluster(Locomotion,VelocityThresholForCorrection,Conversionx,Conversiony,TotalFrames)

%% Idea is to correct the cases in which: the mice are very near for mixing identities (due to incorect segmentation).
% The identity is wrong until the mice found a correct read of the antenna.
% Then the identity jump again.

% 1)- Given the velocity matrix, find the points with velocity > a given
% threshold and less than 1e6 for not considered non defined coordinates.

% 2)- Find the rows with ones.

% 3)- Consider the case of 2 mice swapping identity.
% Find where is the cluster of the 2 mice.
% Assure the velocity is not larger during this period

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
VectorCluster=Locomotion.AssigRFID.Clusters;
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
          Iaux=[];
          
          if length(Index)==2 
              counti=1;
              % Find clusters
            Iaux=or(VectorCluster(1:frames(countr)-1,Index)==[2 2],VectorCluster(1:frames(countr)-1,Index)==[3 3]);
             % Iaux=VectorCluster(1:frames(countr)-1,Index)==[2 2];
              ifinishcluster=find(Iaux(:,1)==1,1,'Last');
              ibegincluster=find(Iaux(1:ifinishcluster,1)==0,1,'Last');
              
              % find minimum distance inside cluster
               distance=sqrt((XcoordMM(ibegincluster:ifinishcluster,Index(1))-XcoordMM(ibegincluster:ifinishcluster,Index(2))).^2+(YcoordMM(ibegincluster:ifinishcluster,Index(1))-YcoordMM(ibegincluster:ifinishcluster,Index(2))).^2);
               [~,Imindist]=min(distance);
              % Add restriction for preventing wrong corrections
              if isempty(find(vel(ifinishcluster+1:frames(countr)-1,Index(1))>VelocityThresholForCorrection & vel(ifinishcluster+1:frames(countr)-1,Index(2))>VelocityThresholForCorrection)) 
                  if isempty(find(VectorCluster(ifinishcluster+1:frames(countr)-1,Index(1))==2 & VectorCluster(ifinishcluster+1:frames(countr)-1,Index(1))==3)) 
                      if isempty(find(VectorCluster(ifinishcluster+1:frames(countr)-1,Index(2))==2 & VectorCluster(ifinishcluster+1:frames(countr)-1,Index(2))==3)) 
                  % interchange coordinates
                  
                           Locomotion.AssigRFID.XcoordMM(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1))=XcoordMM(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2));
                           Locomotion.AssigRFID.XcoordMM(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2))=XcoordMM(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1));
                           Locomotion.AssigRFID.XcoordPixel(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1))=XcoordPixel(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2));
                           Locomotion.AssigRFID.XcoordPixel(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2))=XcoordPixel(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1));
                           
                 
                            Locomotion.AssigRFID.YcoordMM(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1))=YcoordMM(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2));
                            Locomotion.AssigRFID.YcoordMM(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2))=YcoordMM(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1));
                            Locomotion.AssigRFID.YcoordPixel(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1))=YcoordPixel(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2));
                            Locomotion.AssigRFID.YcoordPixel(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2))=YcoordPixel(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1));
                            
                             Locomotion.AssigRFID.MouseOrientation(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1))=MouseOrientation(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2));
                             Locomotion.AssigRFID.MouseOrientation(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(2))=MouseOrientation(frames(countr)-1:-1:ibegincluster+Imindist-1,Index(1));
                             
%                              % Recalculation of the velocity 
%                              
%                              for iv=ibegincluster+Imindist:frames(countr)
%                              [velocity1,velocityX1,velocityY1]=VelocityCalculation( Locomotion.AssigRFID.XcoordMM(iv,Index(1)),Locomotion.AssigRFID.YcoordMM(iv,Index(1))...
%                                  ,Locomotion.AssigRFID.XcoordMM(iv-1,Index(1)),Locomotion.AssigRFID.YcoordMM(iv-1,Index(1))...
%                                  ,Locomotion.ExperimentTime{iv-1}, Locomotion.ExperimentTime{iv}); %for mouse 1
%                              
%                              [velocity2,velocityX2,velocityY2]=VelocityCalculation( Locomotion.AssigRFID.XcoordMM(iv,Index(2)),Locomotion.AssigRFID.YcoordMM(iv,Index(2))...
%                                  ,Locomotion.AssigRFID.XcoordMM(iv-1,Index(2)),Locomotion.AssigRFID.YcoordMM(iv-1,Index(2))...
%                                  ,Locomotion.ExperimentTime{iv-1}, Locomotion.ExperimentTime{iv}); %for mouse 1
%                              
%                              
%                              Locomotion.AssigRFID.VelocityMouse(iv,Index(1))=velocity1;
%                              Locomotion.AssigRFID.VelocityMouseX(iv,Index(1))=velocityX1;
%                              Locomotion.AssigRFID.VelocityMouseY(iv,Index(1))=velocityY1;
%                              
%                                
%                              Locomotion.AssigRFID.VelocityMouse(iv,Index(2))=velocity2;
%                              Locomotion.AssigRFID.VelocityMouseX(iv,Index(2))=velocityX2;
%                              Locomotion.AssigRFID.VelocityMouseY(iv,Index(2))=velocityY2;
%                              
%                              end
                      end       
                  end  
              end
              %find the minimum distance
               counti=counti+1;
          end          
                
              
              
             
          end
end

%% 
