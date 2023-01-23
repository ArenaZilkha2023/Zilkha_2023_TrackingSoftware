function [Locomotion,IsHiding]=JumpFromHidingCorrection(Locomotion,TimeExp,PosArenaDueToAntenna,VelocityMouse,countFrames,IsSleeping,IsHiding,VelocityThreshold)
%% Consider the cases that the mice was a frame before in the hiding box , and in the next point it jumps according to the velocity.
% This happens when the mouse is not detected by the antenna of the hiding
% box instead by a nearest antenna.
% Solution:to return the coordinate to the hiding box.
% 1)-Find mice with the condition v bigger and the last position was hiding
% box.
% 2)-Change coordinates to that of the hiding box ie. to the last position



%% -----------------------Step1---------------------------

IpositionToCorrect=(VelocityMouse(countFrames,:)>VelocityThreshold & IsHiding(countFrames-1,:));
IndexMain=find(IpositionToCorrect==1);

%% ------------------------------Step2--------------------------------
if ~isempty(IndexMain)
  for count=1:length(IndexMain)
    Locomotion.AssigRFID.XcoordMM(countFrames,IndexMain(count))= Locomotion.AssigRFID.XcoordMM(countFrames-1,IndexMain(count));
    Locomotion.AssigRFID.YcoordMM(countFrames,IndexMain(count))= Locomotion.AssigRFID.YcoordMM(countFrames-1,IndexMain(count));

    Locomotion.AssigRFID.XcoordPixel(countFrames,IndexMain(count))=Locomotion.AssigRFID.XcoordPixel(countFrames-1,IndexMain(count));
    Locomotion.AssigRFID.YcoordPixel(countFrames,IndexMain(count))=Locomotion.AssigRFID.YcoordPixel(countFrames-1,IndexMain(count));

    Locomotion.AssigRFID.MouseOrientation(countFrames,IndexMain(count))= Locomotion.AssigRFID.MouseOrientation(countFrames-1,IndexMain(count));
     IsHiding(countFrames,IndexMain(count))=1;
  end  
end

end