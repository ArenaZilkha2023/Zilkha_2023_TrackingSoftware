function  [IndexMiceThird,IndexPositionThird]=FindIndex_ThirdStep(assignment_Second,FinalDistance_Second,ImouseLeft,ImouseLeftUnique,DeltaTimeRFID,ThresholdRFIDDistance,NoDetectionTime)

%Find which index of the subset are unique
Ileft_unique_mouse=zeros(length(ImouseLeft),1);


AuxDeltaTime=DeltaTimeRFID(ImouseLeft);
Ileft_unique_mouse(ImouseLeftUnique)=1;

Iaux1=(FinalDistance_Second'<ThresholdRFIDDistance) & (AuxDeltaTime<NoDetectionTime)& (Ileft_unique_mouse);

IndexMiceThird=ImouseLeft(Iaux1);


IndexPositionThird=assignment_Second(Iaux1);

%now consider index in which the condition is not obey

Iaux2=((FinalDistance_Second' > ThresholdRFIDDistance) | (AuxDeltaTime > NoDetectionTime));


end