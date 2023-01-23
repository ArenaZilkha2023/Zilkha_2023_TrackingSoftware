function [Position,Clusters,Orientation]=FindSegmentationInCages(Position,UpperCage,DownCage,Clusters,Orientation)

          xvUpper=[UpperCage(:,1);UpperCage(1,1)]; %prepare polygon of the cages
          yvUpper=[UpperCage(:,2);UpperCage(1,2)];
          xvDown=[DownCage(:,1);DownCage(1,1)];
          yvDown=[DownCage(:,2);DownCage(1,2)];

          inUpper=inpolygon(Position(:,2),Position(:,3),xvUpper,yvUpper);
          inDown=inpolygon(Position(:,2),Position(:,3),xvDown,yvDown);
          in=or(inUpper,inDown);
   if any(in)
        Position(in,:)=[];
        Clusters(in,:)=[];
        Orientation(in,:)=[];
   end 
  
end