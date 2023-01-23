function  [ XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,Index,OrientationAssignment]=CorrectionErrorSegmentation(ErrorAsignment,IsubAfterRFID, XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,OrientationAssignment,ErrorThreshold,...
                                       XPixelLastFrame,YPixelLastFrame,XLastFrame,YLastFrame, Conversionx,Conversiony,...
                                       VelocityLastFramex,VelocityLastFramey,ElapseTime,XErrorXobs_predLastFrame,YErrorYobs_predLastFrame,Corn,WidthArena,OrientationLastFrame)

%% -----------Steps----------------------------
% Idea: Correct wrong assignment due to wrong segmentation to the
% respective mice
% 1)- Find Error larger than a threshold-with Error assignment-and x
% asignment is defined
% 2)- Go through each index-
% 3)- Do assignment according to prediction-





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --------------Step 1-----------------------------


Ilogical=(ErrorAsignment>ErrorThreshold)& XAssignmentPixel~=1e6 & XPixelLastFrame~=1e6;
Index=find(Ilogical==1);
% -------------------1------------------------
if ~isempty(Index)
% ---------------------------2-------------------------------
 for count=1:length(Index) % do new prediction
    Distance=sqrt((XAssignment(Index(count))-XLastFrame(Index(count))).^2+(YAssignment(Index(count))-YLastFrame(Index(count))).^2); 
    velocity=Distance*0.1/ElapseTime;
  if velocity  >500   %assure that ther is a jump
   % The velocity is also considered -conversion to pixels
    LastVelocityx=Conversionx*VelocityLastFramex(Index(count));
    LastVelocityy=Conversiony*VelocityLastFramey(Index(count));  
    ErrorPreditionPixelx=XErrorXobs_predLastFrame(Index(count)); %This is in pixel units
    ErrorPreditionPixely=YErrorYobs_predLastFrame(Index(count));  %This is in pixel units- gives previous error between observation and prediction
    
    XAssignmentPixel(Index(count))=XPixelLastFrame(Index(count))+LastVelocityx*ElapseTime;
    YAssignmentPixel(Index(count))=YPixelLastFrame(Index(count))+LastVelocityy*ElapseTime;
    
    XAssignment(Index(count))=XLastFrame(Index(count))+VelocityLastFramex(Index(count))*ElapseTime;
    YAssignment(Index(count))=YLastFrame(Index(count))+VelocityLastFramey(Index(count))*ElapseTime;
    
     OrientationAssignment(Index(count))=OrientationLastFrame(Index(count));
   end
  end

% --------------------------2------------------------------

end 
% ------------------------------1----------------------



end