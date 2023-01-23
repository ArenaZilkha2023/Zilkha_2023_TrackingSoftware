
function [MatrixToMinimizeSecond,MatrixToMinimizeSecondOriginal,ErrorXobs_Xpred,ErrorYobs_Ypred,ElapseTime]=Matrix_to_Consider_LastFrame(xposPixelAfterRFID,yposPixelAfterRFID,OrientationAfterRFID,......
                                XPixelLastFrame,YPixelLastFrame,OrientationLastFrame,VelocityLastFramex,VelocityLastFramey,Timefinal,Timeinitial,...
                                Conversionx,Conversiony) 
                            
ErrorXobs_Xpred=[];
ErrorYobs_Ypred=[];
%%%%%%%%%%%%%% In this matrix the columns are the antenna and the rows the
%%%%%%%%%%%%%% positions
%% Rearrangement of data of last frame
LastXaux=repmat(XPixelLastFrame,[size(xposPixelAfterRFID,1),1]);
LastYaux=repmat(YPixelLastFrame,[size(yposPixelAfterRFID,1),1]);

xposaux=repmat(xposPixelAfterRFID,[1,size(XPixelLastFrame,2)]);
yposaux=repmat(yposPixelAfterRFID,[1,size(YPixelLastFrame,2)]);

% Correct the angle when it is negative, take the absolute value and add 90
% degrees
OrientationLastFrameAux=OrientationLastFrame; 
IndexOLF=find(OrientationLastFrame<0);
if ~isempty(IndexOLF)  
OrientationLastFrameAux(IndexOLF)=90+abs(OrientationLastFrame(IndexOLF));  %for negative angles 
end
MouseOrientation=repmat(OrientationLastFrameAux,[size(yposPixelAfterRFID,1),1]);
%%%%%%%%%%%%%%%%
% The velocity is also considered -conversion to pixels
LastVelocityx=Conversionx*repmat(VelocityLastFramex,[size(xposPixelAfterRFID,1),1]);
LastVelocityy=Conversiony*repmat(VelocityLastFramey,[size(yposPixelAfterRFID,1),1]);

%% ------------------------Conversion of time------------------------
%translate TimeExp to vector

Timefinal=strrep(Timefinal,'''',''); %Remove double string before
Timeinitial=strrep(Timeinitial,'''','');
TimeVectorAfter=datevec(Timefinal,'HH:MM:SS.FFF');
TimeVectorBefore=datevec(Timeinitial,'HH:MM:SS.FFF');
ElapseTime=abs(etime(TimeVectorAfter,TimeVectorBefore));% elapsed time in seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create matrix of  distance- Add also velocity for velocity correction
 DistanceMatrix=((xposaux-(LastXaux+LastVelocityx*ElapseTime)).^2+(yposaux-(LastYaux+LastVelocityy*ElapseTime)).^2);
%  ErrorXobs_Xpred=(xposaux-(LastXaux+LastVelocityx*ElapseTime));
%  ErrorYobs_Ypred=(yposaux-(LastYaux+LastVelocityy*ElapseTime));
 %% Consider when the correction of velocity isn't possible
Inondef_vel=find(abs(VelocityLastFramex)>500); %larger than 500 cm/sec
InonNaN_vel=isnan(VelocityLastFramex); % or the velocity is nan
if ~isempty(Inondef_vel)
 DistanceMatrix(:,Inondef_vel)=((xposaux(:,Inondef_vel)-LastXaux(:,Inondef_vel)).^2+(yposaux(:,Inondef_vel)-LastYaux(:,Inondef_vel)).^2);
%  ErrorXobs_Xpred(:,Inondef_vel)=(xposaux(:,Inondef_vel)-LastXaux(:,Inondef_vel));
%  ErrorYobs_Ypred(:,Inondef_vel)=(yposaux(:,Inondef_vel)-LastYaux(:,Inondef_vel));
end 
if ~isempty(find(InonNaN_vel==1))
 DistanceMatrix(:,find(InonNaN_vel==1))=((xposaux(:,find(InonNaN_vel==1))-LastXaux(:,find(InonNaN_vel==1))).^2+(yposaux(:,find(InonNaN_vel==1))-LastYaux(:,find(InonNaN_vel==1))).^2);
%  ErrorXobs_Xpred(:,find(InonNaN_vel==1))=(xposaux(:,find(InonNaN_vel==1)-LastXaux(:,find(InonNaN_vel==1))));
%  ErrorYobs_Ypred(:,find(InonNaN_vel==1))=(yposaux(:,find(InonNaN_vel==1)-LastYaux(:,find(InonNaN_vel==1))));
end 
 %% 
 
%  DistanceMatrix=((xposaux-(LastXaux)).^2+(yposaux-(LastYaux)).^2);
%Calculate orientation-Consider actual orientation
%DistanceSqrt=sqrt((xposaux-LastXaux).^2+(yposaux-LastYaux).^2);
%AngleWithX_MassCenter=asin((yposaux-LastYaux)./DistanceSqrt);
%AngleWithX_MassCenter=rad2deg(AngleWithX_MassCenter);
% Correct the angle when it is negative, take the absolute value and add 90
% degrees
OrientationAfterRFIDAux=OrientationAfterRFID; 
IndexAR=find(OrientationAfterRFID<0);
if ~isempty(IndexAR) 
OrientationAfterRFIDAux(IndexAR)=90+abs(OrientationAfterRFID(IndexAR));  %for negative angles 
end
AngleWithX_MassCenter=repmat(OrientationAfterRFIDAux,[1,size(OrientationLastFrame,2)]);% the angle is in degrees
R=(abs(AngleWithX_MassCenter)-abs(MouseOrientation));
%Determine if to consider the angle approximation for each mouse
for icount=1:size(R,2)
    Ia=[];
   Ia=find(abs(R(:,icount))>2 );%less than 2 degree 
   if ~isempty(Ia)
       R(Ia,icount)=0; %don't consider angle correction
   end
end
%%%%%%%%%%%%%%%
%% Create a final matrix with the errors 
 %MatrixToMinimizeSecond=DistanceMatrix+1000*(((abs(AngleWithX_MassCenter)-abs(MouseOrientation))*2*pi/360).^2);
 MatrixToMinimizeSecond=DistanceMatrix+1000*((R*2*pi/360).^2);
 
 
 
 % When the position found by segmentation is the same the mouse
 % orientation isn't defined thus only the distance is considered.
 I=find(AngleWithX_MassCenter==1e6);
 if ~isempty(I)
      MatrixToMinimizeSecond(I)=DistanceMatrix(I); 
 end
  % When the position found by segmentation in the "last frame" is the same the mouse
 % orientation isn't defined thus only the distance is considered.
 I2=find(MouseOrientation==1e6);
 if ~isempty(I2)
      MatrixToMinimizeSecond(I2)=DistanceMatrix(I2); 
 end
%%%%%%%%%%%%% 
%MatrixToMinimizeSecond=DistanceMatrix+((AngleWithX_MassCenter-MouseOrientation).^2);
%MatrixToMinimizeSecond=DistanceMatrix;
%MatrixToMinimizeSecond=pi*DistanceMatrix.*(abs(AngleWithX_MassCenter-MouseOrientation)/360);%area to cover

% %% %% If the number of positions less than antenna assign a new arrow to matrix to minimize-e.g. when is on the side
% if size(xposPixelAfterRFID,1)<size(XPixelLastFrame,2)
%  MatrixToMinimizeSecond((size(xposPixelAfterRFID,1)+1):size(XPixelLastFrame,2))=1e6;   % assume a big value  
% end
%% If the last position wasn't defined with value 1e6 then we assign 1e6 to the matrix
 %%a- Find no defined positions and assign no defined value to matrix
if ~isempty(find(xposPixelAfterRFID==1e6))
  
    MatrixToMinimizeSecond(find(xposPixelAfterRFID==1e6),:)=1e6;
end
%% If the last position is 1e6 not defined-ALL POSITIONS ARE 1E6
if ~isempty(find(XPixelLastFrame==1e6))
    MatrixToMinimizeSecond(:,find(XPixelLastFrame==1e6))=1e6;
end

%% If the value of matrix is more than 1e+4- convert to a uniform value of 1e6 for preventing localization of points which were incorrectely find by the segmentation
MatrixToMinimizeSecondOriginal=MatrixToMinimizeSecond;
MatrixToMinimizeSecond(find(MatrixToMinimizeSecond>=1e+4))=1e+6;%Before was 1e4

% Spetial matrix if all the matrix is 1e6 nothing can say, thus return to
% the previous value
if isempty(find(MatrixToMinimizeSecond~=1e6))
MatrixToMinimizeSecond=MatrixToMinimizeSecondOriginal;

end


end