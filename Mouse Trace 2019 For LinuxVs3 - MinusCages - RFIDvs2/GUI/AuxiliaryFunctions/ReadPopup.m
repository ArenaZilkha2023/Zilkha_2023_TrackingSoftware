%% ------------------------Auxiliary functions------------------------------------------------------


%Function for reading Arena coordinates panel

function [Corners_option,Eating_option,Drinking_option,LargeBridge_option,NarrowBridge_option]=ReadPopup(~,~)
%The output  of this function is a string either 'set default' or 'change'.
global h

list=get(h.popup1,'String');
idx=get(h.popup1,'Value');
Corners_option=list(idx);

list=get(h.popup2,'String');
idx=get(h.popup2,'Value');
Eating_option=list(idx);

list=get(h.popup3,'String');
idx=get(h.popup3,'Value');
Drinking_option=list(idx);

list=get(h.popup4,'String');
idx=get(h.popup4,'Value');
LargeBridge_option=list(idx);


list=get(h.popup5,'String');
idx=get(h.popup5,'Value');
NarrowBridge_option=list(idx);


list=get(h.popup6,'String');
idx=get(h.popup6,'Value');
Arena_option=list(idx);


list=get(h.popup7,'String');
idx=get(h.popup7,'Value');
Hiding_Box_option=list(idx);


list=get(h.popup8,'String');
idx=get(h.popup8,'Value');
Out_Zone_option=list(idx);

RearrangeArenaCoord(Corners_option,Eating_option,Drinking_option,LargeBridge_option,NarrowBridge_option,Arena_option,Hiding_Box_option,Out_Zone_option);

end