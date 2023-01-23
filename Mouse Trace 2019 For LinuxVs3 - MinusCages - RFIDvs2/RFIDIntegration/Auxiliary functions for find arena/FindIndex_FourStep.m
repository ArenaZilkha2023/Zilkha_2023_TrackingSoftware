function [IndexMiceFour,IndexPositionFour,IndexMiceNonDefinedFour]=FindIndex_FourStep(ImouseLeftSecond,ImouseLeftUniqueSecond,assignmentF_Second,Velocity_ForEachPositionF,ThresholdVelocity)

%Find which index of the subset are unique
Ileft_unique_mouse=zeros(length(ImouseLeftSecond),1);

Ileft_unique_mouse(ImouseLeftUniqueSecond)=1;


%find the adequate indexes


Iaux1=(Velocity_ForEachPositionF' < ThresholdVelocity)& (Ileft_unique_mouse);

IndexMiceFour=ImouseLeftSecond(Iaux1);

IndexPositionFour=assignmentF_Second(Iaux1);

Iaux2=(Velocity_ForEachPositionF' > ThresholdVelocity)& (Ileft_unique_mouse);


IndexMiceNonDefinedFour=ImouseLeftSecond(Iaux2);
end