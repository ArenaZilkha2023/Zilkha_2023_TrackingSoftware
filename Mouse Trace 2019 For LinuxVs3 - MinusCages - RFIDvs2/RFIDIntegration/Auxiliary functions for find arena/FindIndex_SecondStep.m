function  [IndexMiceSecond,IndexPositionSecond,IndexMiceSecondNonDefined]=FindIndex_SecondStep(FinalDistance,Ilogical_lastframe_withNonDefCoord,assignment,Imouse,Iindicate_uniqueAntenna,Ilogical_ForSecondStep)
 
WidthArena=200;

Inondefined=Ilogical_ForSecondStep & Iindicate_uniqueAntenna & Ilogical_lastframe_withNonDefCoord & (FinalDistance' < WidthArena); %antenna unicas and non defined in the last frame

%for this cases take the assigment given by the antenna distance

IndexPositionSecond=assignment(Inondefined);

IndexMiceSecond=Imouse(Inondefined);

Inondefined1=Ilogical_ForSecondStep & Iindicate_uniqueAntenna & Ilogical_lastframe_withNonDefCoord & FinalDistance' > WidthArena;



IndexMiceSecondNonDefined=Imouse(Inondefined1);


end