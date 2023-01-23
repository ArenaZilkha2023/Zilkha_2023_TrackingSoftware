function [ImouseLeft,PositionToChangeLeft,ImouseLeftUnique]=Find_MiceAndPosition_to_Assign(AntennaNumber,SubsetAntennaNumberUnique,PositionToChange,Imouse,Imouse_assigned,IndexPositionAssigned)

%this function left the mice and position which are still to be assigment.

ImouseLeft=setdiff(Imouse,Imouse_assigned,'stable'); %number of mouse which wasn't consider

[~,indexPosition]=setdiff([1:size(PositionToChange,1)]',IndexPositionAssigned,'stable');%find the index not considered



PositionToChangeLeft=PositionToChange(indexPosition,:); %only the position to change

% Find which mouse are unique antenna from the left.


ImouseLeftUnique=FindValues_InsideList(AntennaNumber(ImouseLeft,1),SubsetAntennaNumberUnique);

end