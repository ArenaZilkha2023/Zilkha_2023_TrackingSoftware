function [BinaryImage,s,centroids,area,MajorAxisLength,MinorAxisLength,BoundingBox,Orientation,Repetition]=BinarizeImage(DifImage,level,BackGroundImage,AreaToFilter,MinElongationFactor);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Filter the image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%% Remove background and convert into binary image %%%%%%%%%%%%%%

BinaryImage = imbinarize(DifImage,level); %convert to binary image
BinaryImage([557:557+19],[265:265+170])=0; %remove the date at the bottom of the image
%% %% ---Find the contour of the arena -
 [PixelsArenaContour]=ThresholdingBackgroundFrame(BackGroundImage);
BinaryImage(PixelsArenaContour)=0;%Remove contour -where the side cages are


%% %% ---Find the contour of the arena -
 [PixelsArenaContour]=ThresholdingBackgroundFrame(BackGroundImage);
 BinaryImage(PixelsArenaContour)=0;%Remove contour
 %% %Clean the binary image  areas with pixels less than 100
 %NOTE THAT THIS CONDITION WAS INSERTED-This parameter must be variable
P=AreaToFilter;
BinaryImage=bwareaopen(BinaryImage,P);
%
CC = bwconncomp(BinaryImage); %find connected components
STATS = regionprops(CC,'centroid','Area','MajorAxisLength','MinorAxisLength','PixelIdxList');
MajorAxisLength=cat(1,STATS.MajorAxisLength);
MinorAxisLength=cat(1,STATS.MinorAxisLength);
RatioElongation=MajorAxisLength./MinorAxisLength;

if ~isempty(find(RatioElongation>MinElongationFactor)) %Eliminate boundary detections
    Index=find(RatioElongation>MinElongationFactor);
   for count=1:length(Index) 
       PixelToEliminate=[]; 
       PixelToEliminate=STATS(Index(count)).PixelIdxList;
       BinaryImage(PixelToEliminate)=0;
   end    
end


%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   %% update the display 
% axes(h.SetThreshold.hAxisT);
% imagesc(BinaryImage)
% 
% colormap gray
%% Get parameters
% 
     CC = bwconncomp(BinaryImage); %find connected components
     s = regionprops(CC,'Centroid','Area','MajorAxisLength','MinorAxisLength','BoundingBox','Orientation','PixelIdxList','Perimeter','PixelList');
     
% 
    centroids = cat(1, s.Centroid);
    area=cat(1,s.Area);
    MajorAxisLength=cat(1,s.MajorAxisLength);
    MinorAxisLength=cat(1,s.MinorAxisLength);
    BoundingBox=cat(1,s.BoundingBox);
    Orientation=cat(1,s.Orientation); 
    Repetition=zeros(size(centroids,1),1);
end

