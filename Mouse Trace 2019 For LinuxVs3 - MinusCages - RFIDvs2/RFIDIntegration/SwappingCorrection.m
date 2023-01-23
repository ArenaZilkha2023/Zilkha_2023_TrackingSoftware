function Locomotion=SwappingCorrection(Locomotion,TimeExp,PosArenaDueToAntenna,VelocityMouse,countFrames,IsSleeping,IsHiding,VelocityThreshold,...
CoordinatesxBeforeCorrection,CoordinatesyBeforeCorrection,CoordinatesxPBeforeCorrection,CoordinatesyPBeforeCorrection,VelocityMouseBeforeCorrection)
%% 




% 1)-Look for the mouse that the position was defined by the antenna but
% still has no logical velocity larger than a given threshold. This means
% that may be the identity was swapped
% 2)-Look for the first candidate. Find the mouse who swap identity. Find
% mouse with velocity bigger than. If there is a swap the velocity was also
% jumped.

% 3)- If there is only one choice. Rest to iterchange. But the point has to
% be determine.
% 4)- Calculate each time the error for getting a new position background.
% Check that the error is small or velocity is still smaller until the
% velocity is larger then or the cluster is 2 

%% ---------------------------Previous step-----------------------------
X=Locomotion.AssigRFID.XcoordMM;
Y=Locomotion.AssigRFID.YcoordMM;

%% ---------------------Step 1-----------------------------

%IpositionToCorrect=(PosArenaDueToAntenna(countFrames,:)==1 & PosArenaDueToAntenna(countFrames-1,:)==0 & VelocityMouse(countFrames,:)>VelocityThreshold &...
                %     ~IsSleeping(countFrames,:) &
                %     ~IsHiding(countFrames,:));Do yefim analysis
                 
IpositionToCorrect=(PosArenaDueToAntenna(countFrames,:)==1 & PosArenaDueToAntenna(countFrames-1,:)==0 & VelocityMouse(countFrames,:)>VelocityThreshold &...
                     ~IsSleeping(countFrames,:) & ~IsHiding(countFrames,:) & X(countFrames-1,:)~=1e6);                 
Index1MainA=find(IpositionToCorrect==1);
if ~isempty(Index1MainA) 
 Index1Main=Index1MainA(1);
%% ------------------------Step2------------------------
VelocityMouseBeforeCorrection=VelocityMouseBeforeCorrection';
InonDefinedVelocity=((VelocityMouseBeforeCorrection-VelocityMouseBeforeCorrection(Index1Main))/VelocityMouseBeforeCorrection(Index1Main))<0.3 & VelocityMouseBeforeCorrection~=0 & ~IsSleeping(countFrames,:) & ~IsHiding(countFrames,:);
InonDefinedVelocity(Index1Main)=0;
IndexSecondary=find(InonDefinedVelocity==1);
%% -----------------------------Step3-------------------------------
if length(find(InonDefinedVelocity==1))==1 % only one possibility
    frames=countFrames;
     X(frames,Index1Main)=CoordinatesxBeforeCorrection(IndexSecondary);
     Y(frames,Index1Main)=Y(IndexSecondary);
    while frames>1
        Distance_FromLastFrame=DistCalc(X(frames,Index1Main),Y(frames,Index1Main),X(frames-1,IndexSecondary),Y(frames-1,IndexSecondary));
        velocityM= Velocity_Calculation(TimeExp,frames,Distance_FromLastFrame);
        if velocityM < VelocityThreshold  &  Locomotion.AssigRFID.Clusters(frames,Index1Main)==1  % continue with the process 
          frames=frames-1;
          X(frames,Index1Main)=X(frames,IndexSecondary);
          Y(frames,Index1Main)=Y(frames,IndexSecondary);
          
        elseif (Locomotion.AssigRFID.Clusters(frames,Index1Main)==0 & Locomotion.AssigRFID.Clusters(frames,IndexSecondary)==1)
             frames=frames-1;
             X(frames,Index1Main)=X(frames,IndexSecondary);
             Y(frames,Index1Main)=Y(frames,IndexSecondary);
        else
             break;
        end
    end
  frameInitial=frames;
  frameFinal=countFrames-1;
  
 %% ---------------------------Step 4----------------------------------
% Rearrange locomotion
Locomotion=RearrangeLocomotion(Locomotion,Index1Main,IndexSecondary,frameInitial,frameFinal); 
  
  
end

end

end