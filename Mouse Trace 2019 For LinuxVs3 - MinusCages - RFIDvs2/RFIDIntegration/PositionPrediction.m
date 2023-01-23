function  [ XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,Index,OrientationAssignment]=PositionPrediction(Index,...
                                       XAssignmentPixel,YAssignmentPixel,XAssignment,YAssignment,OrientationAssignment,...
                                       XPixelLastFrame,YPixelLastFrame,XLastFrame,YLastFrame,OrientationLastFrame,...
                                       Conversionx,Conversiony,...
                                       VelocityLastFramex,VelocityLastFramey,ElapseTime)

%% -----------Steps----------------------------
% Idea: Correct wrong assignment due to wrong segmentation to the
% respective mice



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --------------Step 1-----------------------------

% ---------------------------1-------------------------------
 for count=1:length(Index) % do new prediction
     
   %----------------------------------2-----------------------------------------------  
%   if  XLastFrame(Index(count))~=1e+6 & YLastFrame(Index(count))~=1e+6
%       
%     LastVelocityx=Conversionx*VelocityLastFramex(Index(count));
%     LastVelocityy=Conversiony*VelocityLastFramey(Index(count));  
% %     ErrorPreditionPixelx=XErrorXobs_predLastFrame(Index(count)); %This is in pixel units
% %     ErrorPreditionPixely=YErrorYobs_predLastFrame(Index(count));  %This is in pixel units- gives previous error between observation and prediction
%     
%     XAssignmentPixel(Index(count))=XPixelLastFrame(Index(count))+LastVelocityx*ElapseTime;
%     YAssignmentPixel(Index(count))=YPixelLastFrame(Index(count))+LastVelocityy*ElapseTime;
%     
%     XAssignment(Index(count))=XLastFrame(Index(count))+VelocityLastFramex(Index(count))*ElapseTime;
%     YAssignment(Index(count))=YLastFrame(Index(count))+VelocityLastFramey(Index(count))*ElapseTime;
%     
%      OrientationAssignment(Index(count))=OrientationLastFrame(Index(count));
%   else %in the case the last frame is undefined thus the position left undefined
      XAssignmentPixel(Index(count))=1e+6;
      YAssignmentPixel(Index(count))=1e+6;
      XAssignment(Index(count))=1e+6;
      YAssignment(Index(count))=1e+6;
      OrientationAssignment(Index(count))=1e+6; 
%  end
  %------------------------2------------------------
 end
% --------------------------1------------------------------

end 




