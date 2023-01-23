function  MatrixResult=ArrangeMatrix_ForDistance(xpos,ypos,AntennaX,AntennaY)

%% Rearrangement of data
AntennaXaux=repmat(AntennaX',[size(xpos,1),1]);
AntennaYaux=repmat(AntennaY',[size(ypos,1),1]);

xposaux=repmat(xpos,[1,size(AntennaX,1)]);
yposaux=repmat(ypos,[1,size(AntennaY,1)]);

%% Calculate distance
 MatrixResult=sqrt((xposaux-AntennaXaux).^2+(yposaux-AntennaYaux).^2);

% Add large values for non defined positions
INonDefined=find(xpos==1e6);
MatrixResult(INonDefined,:)=1e6;
 
%consider the case the position of the last frame is not defined when
%distance from the last frame is considered
IlastFrameNonDefined=find(AntennaX==1e6);
MatrixResult(:,IlastFrameNonDefined)=1e6;

end