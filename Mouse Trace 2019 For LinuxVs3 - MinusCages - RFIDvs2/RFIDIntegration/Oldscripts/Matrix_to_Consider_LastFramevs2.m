function MatrixToMinimizeSecond=Matrix_to_Consider_LastFrame(xposPixelAfterRFID,yposPixelAfterRFID,OrientationAfterRFID,......
                                XPixelLastFrame,YPixelLastFrame,OrientationLastFrame) 

%%%%%%%%%%%%%% In this matrix the columns are the antenna and the rows the
%%%%%%%%%%%%%% positions
%% Rearrangement of data of last frame
LastXaux=repmat(XPixelLastFrame,[size(xposPixelAfterRFID,1),1]);
LastYaux=repmat(YPixelLastFrame,[size(yposPixelAfterRFID,1),1]);

xposaux=repmat(xposPixelAfterRFID,[1,size(XPixelLastFrame,2)]);
yposaux=repmat(yposPixelAfterRFID,[1,size(YPixelLastFrame,2)]);

MouseOrientation=repmat(OrientationLastFrame,[size(yposPixelAfterRFID,1),1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create matrix of  distance
 DistanceMatrix=((xposaux-LastXaux).^2+(yposaux-LastYaux).^2);

%Calculate orientation-Consider actual orientation
%DistanceSqrt=sqrt((xposaux-LastXaux).^2+(yposaux-LastYaux).^2);
%AngleWithX_MassCenter=asin((yposaux-LastYaux)./DistanceSqrt);
%AngleWithX_MassCenter=rad2deg(AngleWithX_MassCenter);
AngleWithX_MassCenter=repmat(OrientationAfterRFID,[1,size(OrientationLastFrame,2)]);
%R=((AngleWithX_MassCenter-MouseOrientation));
%% Create a final matrix with the errors 
 MatrixToMinimizeSecond=DistanceMatrix+DistanceMatrix.*(((AngleWithX_MassCenter-MouseOrientation)*2*pi/360).^2);
%MatrixToMinimizeSecond=DistanceMatrix+((AngleWithX_MassCenter-MouseOrientation).^2);
%MatrixToMinimizeSecond=DistanceMatrix;
%MatrixToMinimizeSecond=pi*DistanceMatrix.*(abs(AngleWithX_MassCenter-MouseOrientation)/360);%area to cover

% %% %% If the number of positions less than antenna assign a new arrow to matrix to minimize-e.g. when is on the side
% if size(xposPixelAfterRFID,1)<size(XPixelLastFrame,2)
%  MatrixToMinimizeSecond((size(xposPixelAfterRFID,1)+1):size(XPixelLastFrame,2))=1e6;   % assume a big value  
% end
%% If the last position wasn't defined with value 1e6 then we assign 1e6 to the matrix
 %% Find no defined positions and assign no defined value to matrix
MatrixToMinimizeSecond(find(xposPixelAfterRFID==1e6),:)=1e6;






end