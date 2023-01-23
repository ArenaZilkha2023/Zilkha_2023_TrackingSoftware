function centroids=RemoveCentroidsOnContour(centroids,PixelsArenaContour)
%
count=1;
Index=[];
for i=1:size(centroids,1)
    A=repmat(round(centroids(i,1)),size(PixelsArenaContour,1),1);
     B=repmat(round(centroids(i,2)),size(PixelsArenaContour,1),1); 
    
   I=PixelsArenaContour(:,1)==A & PixelsArenaContour(:,2)==B;%if they are in the contour
   
   if any(I)
      
    Index(count)=i;
     count=count+1;  
   end
    
end

if ~isempty(Index)
    centroids(Index,:)=[];
end


end

