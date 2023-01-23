function Ilogical=CheckCloseToMice(Ilogical,XAssignment,YAssignment,MaximumDistanceOfProximity)
%% The idea is to determine if the position assignment with the antenna is sure. If the mouse is near other whitin antenna radius we dismissed from
% the assignment.

%%%%%%%%%%%%%%%%%%%
%%
XAssignment=XAssignment';
YAssignment=YAssignment';

for count=1:length(Ilogical)
    distance=[];
    Iaux=[];
   if Ilogical(count,1)==1
       Aux=setdiff([1:length(Ilogical)],count,'stable'); % other index
       % check distance to other mice
       distance=((XAssignment(Aux,1)-repmat(XAssignment(count,1),length(Aux),1)).^2+(YAssignment(Aux,1)-repmat(YAssignment(count,1),length(Aux),1)).^2).^0.5;
       Iaux= (distance < MaximumDistanceOfProximity);
         if ~ isempty(find(Iaux==1)) %if detect clossness to another mouse
             Ilogical(count,1)=0;
         end
           
   end
end



end