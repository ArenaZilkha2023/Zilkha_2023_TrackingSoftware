function [ExtremePoints1,ExtremePoints2]=FindHeadTail(s,Index1M,BoundingBox)

for countMice=1:length(Index1M)
   MousePixels=s(Index1M(countMice)).PixelList; 
   points=bbox2points(BoundingBox(Index1M(countMice),:,:,:));
   
   for i=1:4
            distance=sqrt((MousePixels(:,1)-repmat(points(i,1),size(MousePixels,1),1)).^2+(MousePixels(:,2)-repmat(points(i,2),size(MousePixels,1),1)).^2);
    
            [MinDist(i),index(i)]=min(distance);
   end
    [~,Isort]=sort(MinDist,'ascend');
    
    ExtremePoints1(Index1M(countMice),:)=[MousePixels(index(Isort(1)),1),MousePixels(index(Isort(1)),2)];
     ExtremePoints2(Index1M(countMice),:)=[MousePixels(index(Isort(2)),1),MousePixels(index(Isort(2)),2)];
end





end