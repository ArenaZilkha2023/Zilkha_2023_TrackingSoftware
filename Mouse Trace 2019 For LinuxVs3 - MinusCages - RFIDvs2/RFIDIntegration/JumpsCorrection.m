function  [Locomotion,IsHiding]=JumpsCorrection(Locomotion,TimeExp,PosArenaDueToAntenna,VelocityMouse,...
                                countFrames,IsSleeping,IsHiding,VelocityThreshold,CoordinatesxBeforeCorrection,CoordinatesyBeforeCorrection,CoordinatesxPBeforeCorrection,CoordinatesyPBeforeCorrection,VelocityMouseBeforeCorrection)
%% 1)-Swapping/Jump identity between only 2 mice when it is outside hiding box and arena
%%  2)- Jumping from the hiding box to outside . This happens when the hiding antenna doesn't detect and instead a nearest antenna detect.
                            
                            
                            
                            
%% ---------------------------------Step 1------------------------------------------------------                            
%Locomotion=SwappingCorrection(Locomotion,TimeExp,PosArenaDueToAntenna,VelocityMouse,countFrames,IsSleeping,IsHiding,VelocityThreshold,CoordinatesxBeforeCorrection,CoordinatesyBeforeCorrection,CoordinatesxPBeforeCorrection,CoordinatesyPBeforeCorrection,VelocityMouseBeforeCorrection);                         
%% -----------------------------------Step2-------------------------------------                            
 [Locomotion,IsHiding]=JumpFromHidingCorrection(Locomotion,TimeExp,PosArenaDueToAntenna,VelocityMouse,countFrames,IsSleeping,IsHiding,VelocityThreshold);                            
                            
                            
                            
                            
                            
                            
end