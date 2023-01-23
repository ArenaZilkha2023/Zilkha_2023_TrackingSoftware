function Locomotion=correctionVelocity(Locomotion,VelocityThresholForCorrection)

%% Idea is to correct the cases in which: the mice are very near for mixing identities (due to incorect segmentation).
% The identity is wrong until the mice found a correct read of the antenna.
% Then the identity jump again.

% 1)- Given the velocity matrix, find the points with velocity > a given
% threshold and less than 1e6 for not considered non defined coordinates.

% 2)- Find the rows with ones.

% 3)- Loop over the frames with ones

% 4)- Consider only rows with 2 ones
% 5)-Change the coordinates of the last row-since there should be a swap of
% identities.
% 6)- measure the velocity of each place : if vel <190 return continue 
%% -------------------Do step 1)-------------------------
vel=Locomotion.AssigRFID.VelocityMouse;
XcoordMM=Locomotion.AssigRFID.XcoordMM;
YcoordMM=Locomotion.AssigRFID.YcoordMM;
Logical_forlargervelocity=(vel>VelocityThresholForCorrection & vel<1e6)&(Locomotion.AssigRFID.XcoordMM~=1e6);


%% -------------------------Do step 2)--------------------------------
[r,c,v]=find(Logical_forlargervelocity==1);
frames=unique(r);
%% ------------------------------Do step 3)-----------------------
for countr=1:length(frames)
   % step 4)-
          Index=[];
          Index=find(Logical_forlargervelocity(countr,:)==1);
          if length(Index)==2 
              counti=1;
              while countr-counti>=1 %step 5)-
                 Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(1))=XcoordMM(frames(countr)-counti,Index(2));
                 Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(2))=XcoordMM(frames(countr)-counti,Index(1));
                 
                  Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(1))=YcoordMM(frames(countr)-counti,Index(2));
                  Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(2))=YcoordMM(frames(countr)-counti,Index(1));
                  
                  [velocity1,velocityX1,velocityY1]=VelocityCalculation(Locomotion.AssigRFID.XcoordMM(frames(countr)-counti+1,Index(1)),Locomotion.AssigRFID.YcoordMM(frames(countr)-counti+1,Index(1)),...
                                                     Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(1)),Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(1)),...
                                                     Locomotion.ExperimentTime{frames(countr)-counti},Locomotion.ExperimentTime{frames(countr)-counti+1});
                  [velocity2,velocityX2,velocityY2]=VelocityCalculation(Locomotion.AssigRFID.XcoordMM(frames(countr)-counti+1,Index(2)),Locomotion.AssigRFID.YcoordMM(frames(countr)-counti+1,Index(2)),...
                                                     Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(2)),Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(2)),...
                                                     Locomotion.ExperimentTime{frames(countr)-counti},Locomotion.ExperimentTime{frames(countr)-counti+1});
                    if or(velocity1>=VelocityThresholForCorrection ,velocity2>=VelocityThresholForCorrection)% setp 6)-
                           Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(1))=XcoordMM(frames(countr)-counti,Index(1));
                           Locomotion.AssigRFID.XcoordMM(frames(countr)-counti,Index(2))=XcoordMM(frames(countr)-counti,Index(2));
                 
                            Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(1))=YcoordMM(frames(countr)-counti,Index(1));
                            Locomotion.AssigRFID.YcoordMM(frames(countr)-counti,Index(2))=YcoordMM(frames(countr)-counti,Index(2));
                        break;
                    end
                 counti=counti+1;
              end
              
              
             
          end
end

%% 
