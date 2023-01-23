function [OrientationAux]=AddRepeatsToParams(Orientation,RepetitionCoord,Locomotion,countFrames)

Xrepeat=Locomotion.CoordinatesWithRepeats(find(Locomotion.CoordinatesWithRepeats(:,1)==countFrames+1),2);
Yrepeat=Locomotion.CoordinatesWithRepeats(find(Locomotion.CoordinatesWithRepeats(:,1)==countFrames+1),3);

XWithoutrepeat=Locomotion.Coordinates(find(Locomotion.Coordinates(:,1)==countFrames+1),2);
YWithoutrepeat=Locomotion.Coordinates(find(Locomotion.Coordinates(:,1)==countFrames+1),3);


% Create new orientation vector with duplicates
OrientationAux=zeros(length(Xrepeat),1);


% find the coord which should be repeated
xvaluedup=XWithoutrepeat(find(RepetitionCoord~=0)); %find the values of repeated coordinates
yvaluedup=YWithoutrepeat(find(RepetitionCoord~=0));
orientation_valuedup=Orientation(find(RepetitionCoord~=0));
%find the duplicate coord value and assing the corresponding orientation
for count=1:length(xvaluedup)
    OrientationAux(find(Xrepeat==xvaluedup(count)& Yrepeat==yvaluedup(count)))= 1e6;  %give a big value since you cannot use this value
        
end


% find the coord which shouldn't be repeated
xvaluesingle=XWithoutrepeat(find(RepetitionCoord==0)); %find the values of repeated coordinates
yvaluesingle=YWithoutrepeat(find(RepetitionCoord==0));
orientation_valuesingle=Orientation(find(RepetitionCoord==0));
%find the duplicate coord value and assing the corresponding orientation
for count=1:length(xvaluesingle)
    OrientationAux(find(Xrepeat==xvaluesingle(count) & Yrepeat==yvaluesingle(count)))= orientation_valuesingle(count);      
end





end