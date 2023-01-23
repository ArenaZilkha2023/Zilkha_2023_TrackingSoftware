
function  [MatrixToMinimize,DistanceMatrix,DeltaRFIDaux]=Matrix_to_Consider_RFID(xpos,ypos,AntennaX,AntennaY,.....
                                                    DeltaRFID,MaxRFIDDistance,DeltaFrame,Orientation)
%%%%%%%%%%%%%% In this matrix the columns are the antenna and the rows the
%%%%%%%%%%%%%% positions


%% Rearrangement of data
AntennaXaux=repmat(AntennaX',[size(xpos,1),1]);
AntennaYaux=repmat(AntennaY',[size(ypos,1),1]);

xposaux=repmat(xpos,[1,size(AntennaX,1)]);
yposaux=repmat(ypos,[1,size(AntennaY,1)]);
orienaux=repmat(Orientation,[1,size(AntennaY,1)]);
%% Create matrix of  distance
 DistanceMatrix=sqrt((xposaux-AntennaXaux).^2+(yposaux-AntennaYaux).^2);
 %% Create matrix of time
 DeltaRFIDaux=repmat(DeltaRFID',[size(ypos,1),1]);
 %% Calculate the function to be minimum which consider both distance from antenna and time detection
%MatrixToMinimize=(DistanceMatrix/MaxRFIDDistance).^2+ (DeltaRFIDaux/DeltaFrame).^2;
MatrixToMinimize=DistanceMatrix;
%% Find no defined positions and assign no defined value to matrix
MatrixToMinimize(find(xpos==1e6),:)=1e6;











end