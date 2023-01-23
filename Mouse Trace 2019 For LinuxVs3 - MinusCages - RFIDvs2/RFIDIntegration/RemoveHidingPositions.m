function IndexToRemove=RemoveHidingPositions(IsHiding,AntennaForMice,FirstHidingBox,SecondHidingBox,ThirdHidingBox,FourHidingBox,Xcand,Ycand,HidingAntenna,HidingAntennaCoord)

%% The idea is to remove hiding positions due to segmentation. The output are the indexes to remove.
 
% 1)- Find Hiding antenna. Loop over each antenna. Also how much times appear.
% 2)- For the given antenna find the respective 4 coordinates which delimit
% the hiding box. Do a small script case.
% 3)- Find the candidate positions which are inside the hiding box.Use inpolygon. 
% 4)-Find if there are points inside. 
% 5)- If the length of points is positive and less equal than the number of antenna. Eliminate those
% positions- that is put empty in those points.
%6)OPTIONAL If there are more positions than antenna Find the nearest points to the
%given antenna as eliminate those points according to number antenna. 

IndexToRemove=[];
%% --------------Step 1--------------------
HidingAntennaS=AntennaForMice(find(IsHiding));
HidingAntennaS=unique(HidingAntennaS,'stable');
%%
for count=1:length(HidingAntennaS)
     NumberRepetitions=length(find(AntennaForMice==HidingAntennaS(count)));
% --------------------Step2----------------------
     Index=find(HidingAntenna==HidingAntennaS(count));

    switch(Index)
        case 1
          xv=[FirstHidingBox(:,1);FirstHidingBox(1,1)];
          yv=[FirstHidingBox(:,2);FirstHidingBox(1,2)];
        case 2
          xv=[SecondHidingBox(:,1);SecondHidingBox(1,1)];
          yv=[SecondHidingBox(:,2);SecondHidingBox(1,2)];
        case 3
          xv=[ThirdHidingBox(:,1);ThirdHidingBox(1,1)];
          yv=[ThirdHidingBox(:,2);ThirdHidingBox(1,2)];
        case 4
          xv=[FourHidingBox(:,1);FourHidingBox(1,1)];
          yv=[FourHidingBox(:,2);FourHidingBox(1,2)];
    
    end   
    
%------------------Step3---------------    
    [in,on]=inpolygon( Xcand,Ycand,xv,yv); 
    
 % -----------------Step4/5---------------------
 
     if ~isempty(find(in==1 | on==1))
     
        if length(find(in==1 | on==1))<= NumberRepetitions %dont remove if there are more points as a mouse on the roof ofthe hiding box
               
             IndexToRemove=[IndexToRemove; find(in==1 | on==1)];  
        end
     
    end
 
 
 
    
    
end






end