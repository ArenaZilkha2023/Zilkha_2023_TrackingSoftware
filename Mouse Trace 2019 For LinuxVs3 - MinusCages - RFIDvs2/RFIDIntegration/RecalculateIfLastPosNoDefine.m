function [IndexMouse,xNew,yNew,xNewPixel,yNewPixel,OrientationNew]=RecalculateIfLastPosNoDefine(XLastFrame,YLastFrame,XAssignment,YAssignment,xpos,ypos,xposPixel,yposPixel,Orientation,AntennaX,AntennaY,MaxDistanceToleranceRFID)
IndexMouse=[];
xNew=[];
yNew=[];
xNewPixel=[];
yNewPixel=[];
OrientationNew=[];
indexX=zeros(length(xpos),1);
indexY=zeros(length(ypos),1);

x=XAssignment(find(XLastFrame~=1e+6)); % positions which were assigned
y=YAssignment(find(YLastFrame~=1e+6)); % positions which were assigned

% ------------------------------return the xpos which are in Xassignment-The index is logical----------
xauxpos=xpos;
yauxpos=ypos
for countaux=1:length(x)
   Iaux=find(xauxpos==x(countaux)); 
   if ~isempty(Iaux)
    indexX(Iaux(1))=1; %choice only one
    xauxpos(Iaux(1))=-1;%to eliminate it from the next loop
   end
end
for countaux=1:length(y)
   Iaux=find(yauxpos==y(countaux)); 
   if ~isempty(Iaux)
    indexY(Iaux(1))=1; %choice only one
    yauxpos(Iaux(1))=-1;%to eliminate it from the next loop
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% indexX=ismember(xpos,x); 
% indexY=ismember(ypos,y);

xnoassign=xpos(~indexX);% no assign position
ynoassign=ypos(~indexY);
xnoassignPixel=xposPixel(~indexX);% no assign position
ynoassignPixel=yposPixel(~indexY);
Orientationnoassign=Orientation(~indexY);
AntennaX=AntennaX(find(XLastFrame==1e+6));
AntennaY=AntennaY(find(XLastFrame==1e+6));


   % %%%%%%%%%%%%%%%%Arrange distance from antenna into a matrix%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


   %% Rearrangement of data
AntennaXaux=repmat(AntennaX',[size(xnoassign,1),1]);
AntennaYaux=repmat(AntennaY',[size(ynoassign,1),1]);

xposaux=repmat(xnoassign,[1,size(AntennaX,1)]);
yposaux=repmat(ynoassign,[1,size(AntennaY,1)]);

%% Create matrix of  distance
 DistanceMatrix=sqrt((xposaux-AntennaXaux).^2+(yposaux-AntennaYaux).^2);

 %% Calculate the function to be minimum which consider both distance from antenna 
MatrixToMinimize=DistanceMatrix;

%% Find no defined positions and assign no defined value to matrix
   MatrixToMinimize(find(xnoassign==1e6),:)=1e6;

   % %%%%%%%%%%%%%%Assign to each antenna the minimum distance in such a way that the sum
        %is minimum and each antenna receive a different assignment,application
        %of hungariam algoritm%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        [assignmentF,~]=munkresForMiceTracer(MatrixToMinimize); 

    IndexMouse=recordsNoDefined;

    for countAssigment=1:length(assignmentF) 
        DistanceAssignment(countAssigment)=DistanceMatrix(assignmentF(countAssigment),countAssigment); 
        
        %%----------------------- Do correction if the distance to antenna is large -----------------
        if DistanceMatrix(assignmentF(countAssigment),countAssigment)>MaxDistanceToleranceRFID %check the distance to the respective antenna
                xNew(countAssigment)=1e+6;
                yNew(countAssigment)=1e+6;
                xNewPixel(countAssigment)=1e+6;
                yNewPixel(countAssigment)=1e+6;
                OrientationNew(countAssigment)=1e+6;
        else
     
                xNew(countAssigment)=xnoassign(assignmentF(countAssigment));
                yNew(countAssigment)=ynoassign(assignmentF(countAssigment));
                xNewPixel(countAssigment)=xnoassignPixel(assignmentF(countAssigment));
                yNewPixel(countAssigment)=ynoassignPixel(assignmentF(countAssigment));
                OrientationNew(countAssigment)=Orientation(assignmentF(countAssigment));
        end
       
    end


end