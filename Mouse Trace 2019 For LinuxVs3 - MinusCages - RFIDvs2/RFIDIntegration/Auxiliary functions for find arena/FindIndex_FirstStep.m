function [IndexMice,IndexPosition,IndexMiceNonDefined,IndexMiceNonDefined1,Ilogical_ForSecondStep]=FindIndex_FirstStep(DistanceFromAntenna,Imouse,assignment,assignmentF,Iindicate_uniqueAntenna,Velocity_ForEachPosition,ThresholdVelocity,Ilogical_lastframe_withNonDefCoord)

WidthArena=1139;

% check which mouse gets same position either from the distance to antenna
% or from the last frame
Ilogical1=assignment'==assignmentF';

% get only uniquess index
Ilogical2=Ilogical1 & Iindicate_uniqueAntenna;

%% Look for the index which in addition the velocity is so large meaning that the position is not defined
IlogicalNonDefined=Ilogical2 & (Velocity_ForEachPosition' > ThresholdVelocity)& ~Ilogical_lastframe_withNonDefCoord; %not consider if the last frame was not defined

%% Not consider cases in which the last frame was not defined but the new assigment is not logic  since the distance between the antenna and new position is very large

IlogicalNonDefined1=Ilogical2 & (DistanceFromAntenna' > WidthArena/3)& Ilogical_lastframe_withNonDefCoord;

%% 

IndexPosition=assignment(Ilogical2);

IndexMice=Imouse(Ilogical2);

IndexMiceNonDefined=Imouse(IlogicalNonDefined);

IndexMiceNonDefined1=Imouse(IlogicalNonDefined1);

%% Find the index not considered
Ilogical_ForSecondStep=~(Ilogical2 | IlogicalNonDefined | IlogicalNonDefined1);

end