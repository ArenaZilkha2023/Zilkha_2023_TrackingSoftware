function FidelityMatrix=Find_fidelity(countFrames,FidelityMatrix,Imouse,Iindicate_uniqueAntenna,SubsetDeltaTimeRFID,DistanceFromAntenna,ThresholdRFIDDistance,NoDetectionTime)
%7 means that the position is sure-the antenna are unique and the distance
%from the antenna is less than 57 and the time is less than 80ms

Ilogical1=(Iindicate_uniqueAntenna==1) & (DistanceFromAntenna'<ThresholdRFIDDistance) & (SubsetDeltaTimeRFID<NoDetectionTime);
%antenna unique but either of the other conditions is not satisfied
Ilogical2=(Iindicate_uniqueAntenna==1) & ((DistanceFromAntenna'>ThresholdRFIDDistance) | (SubsetDeltaTimeRFID>NoDetectionTime));
%antenna is not unique
Ilogical3=~(Iindicate_uniqueAntenna==1);

FidelityMatrix(countFrames,Imouse(Ilogical1))=7;% seven is the maximum value

FidelityMatrix(countFrames,Imouse(Ilogical2))=6; %six must evaluate more

FidelityMatrix(countFrames,Imouse(Ilogical3))=5; %five must evaluate more includes duplicates
end