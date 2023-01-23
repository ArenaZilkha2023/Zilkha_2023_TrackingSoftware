function Locomotion=VelocityRecalculation(Locomotion)

Xmatrix=Locomotion.AssigRFID.XcoordMM;
Ymatrix=Locomotion.AssigRFID.YcoordMM;
Time=Locomotion.ExperimentTime;

%% ------------------------Conversion of time------------------------
%translate TimeExp to vector

Time=strrep(Time,'''',''); %Remove double string before
%Timeinitial=strrep(Timeinitial,'''','');
TimeVectorBefore=datevec(Time,'HH:MM:SS.FFF');
TimeVectorAfter=TimeVectorBefore(2:end,:);
%TimeVectorBefore=datevec(Timeinitial,'HH:MM:SS.FFF');
ElapseTime=abs(etime(TimeVectorAfter,TimeVectorBefore(1:size(TimeVectorAfter,1),:)));% elapsed time in seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -----------Create a vector of time------------
TimeM=repmat(ElapseTime,1,size(Xmatrix,2));

%% ----------------------Calculate the distance between two frames ----------------
distance=sqrt((diff(Xmatrix,1,1)).^2+(diff(Ymatrix,1,1)).^2); %this is the distance in mm
% conversion distance to cm
distance=distance/10;
%% --------------------------Calculate velocity--------------------------
velocityx=0.1*diff(Xmatrix,1,1)./ElapseTime; % units cm/sec
velocityy=0.1*diff(Ymatrix,1,1)./ElapseTime; % units cm/sec
velocity=distance./ElapseTime;
velocity=[zeros(1,size(velocity,2));velocity]; %for the first one
Locomotion.AssigRFID.VelocityMouse=velocity;
Locomotion.AssigRFID.DistanceFromFrameToFrame=[zeros(1,size(distance,2));distance]; %for the first one- distance in mm
Locomotion.AssigRFID.VelocityMouseY=[zeros(1,size(velocityy,2));velocityy]; 
Locomotion.AssigRFID.VelocityMouseX=[zeros(1,size(velocityx,2));velocityx]; 

end