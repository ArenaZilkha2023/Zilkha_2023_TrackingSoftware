function Difference_FR=CompareForwardReverse(CoordinatesFinalMice,CoordinatesFinalMiceBF)

xF=CoordinatesFinalMice(:,1:2:size(CoordinatesFinalMice,2)-1);
yF=CoordinatesFinalMice(:,2:2:size(CoordinatesFinalMice,2));

xB=CoordinatesFinalMiceBF(:,1:2:size(CoordinatesFinalMiceBF,2)-1);
yB=CoordinatesFinalMiceBF(:,2:2:size(CoordinatesFinalMiceBF,2));

Difference_FR=~(xF==xB)&~(yF==yB); %a one indicates difference between forward and reverse for a given mouse
end

