function  Locomotion=correctionJumpsOneMouse(Locomotion,VelocityThresholForCorrection)

%% Idea is to consider the cases in which the mice position wasn't find by segmentation, either the mouse was hidden (eating holder) or the cluster segmentation didn't identified all the mice of that cluster.
%% Thus the program identified a wrong position from wrong segmentation.
% 1)- Loop over every mouse
% 2)- Find the first jump in velocity, with the conditions the cluster is 1 (no association with other mouse).
% 3)- If there is a jump there is a return jump , find next jump.
% 4)- Assure that the cluster is 1 along all the path.
% 5)- Assign no define position
% 5)- Continue with the next until all the  higher were cover. 
%% 
%% -------------------------Variables---------------------------
vel=Locomotion.AssigRFID.VelocityMouse;
VectorCluster=Locomotion.AssigRFID.Clusters;
%% ------------------------Do step 1)-----------------------------------------------
% ----------------------1-------------------------------
for countMouse=1:size(vel,2)
% Create logical vector with the conditions  
countMouse
Ilogic=[];
Ilogic=(vel(:,countMouse)>VelocityThresholForCorrection & vel(:,countMouse)<1e6)&(Locomotion.AssigRFID.XcoordMM(:,countMouse)~=1e6)&(VectorCluster(:,countMouse)==1);    
% ------------------------2-----------------------  
  while any(Ilogic)
     
     Index=find(Ilogic==1,2,'first');
     % -----------------------------3----------------------------------
     if ~isempty(Index(1)) & ~isempty(Index(2))
                      if  VectorCluster(Index(1):Index(2)-1,countMouse)==1
                           Locomotion.AssigRFID.XcoordMM(Index(1):Index(2)-1,countMouse)=1e+6;
                           Locomotion.AssigRFID.XcoordPixel(Index(1):Index(2)-1,countMouse)=1e+6;
                           Locomotion.AssigRFID.YcoordMM(Index(1):Index(2)-1,countMouse)=1e+6;
                           Locomotion.AssigRFID.YcoordPixel(Index(1):Index(2)-1,countMouse)=1e+6;
                           Locomotion.AssigRFID.MouseOrientation(Index(1):Index(2)-1,countMouse)=1e+6;
                           Ilogic(Index(1))=0;
                           Ilogic(Index(2))=0;
                      end  
     end             
                      if ~isempty(Index(1))
                       Ilogic(Index(1))=0;
                      end 
                      if ~isempty(Index(2))
                           Ilogic(Index(2))=0;
                      end
      % ---------------------------------------------3--------------------------------------                       
     
     
  end

% -----------------------2-----------------------
end
%-----------------------1-----------------------------
end