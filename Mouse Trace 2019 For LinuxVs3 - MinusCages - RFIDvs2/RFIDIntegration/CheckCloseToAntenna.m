function Ilogical=CheckCloseToAntenna(Ilogical,XAssignment,YAssignment,MaxRFIDDistance,DistanceMatrix,assignmentF)
%% The idea is to determine if the position assignment with the antenna is sure. 
% the idea is to check if the position is in the middle if there are 2
% antenna close to this position we cannot assure to which antenna the
% position is related.
%look if the position detected by other antenna or the antenna detect also
%other position

%%%%%%%%%%%%%%%%%%%
%%
XAssignment=XAssignment';
YAssignment=YAssignment';

for count=1:length(Ilogical)
    distance=[];
    Iaux=[];
    Iaux1=[];
   if Ilogical(count,1)==1
       Aux=setdiff([1:length(Ilogical)],count,'stable'); % other index
      Iaux=DistanceMatrix(assignmentF(count),Aux)<400; %400 is the distance between 2 far antennas for example29 and 30
      if any(Iaux)
          Ilogical(count,1)=0;
      else %look for other position near the respective antenna
          AsFAux=setdiff([1:size(DistanceMatrix,1)],assignmentF(count),'stable'); % other assignment
          Iaux1=DistanceMatrix(AsFAux,count)<400; %instead 400
          if any(Iaux1)
              Ilogical(count,1)=0;
          end
      end
           
   end
end



end