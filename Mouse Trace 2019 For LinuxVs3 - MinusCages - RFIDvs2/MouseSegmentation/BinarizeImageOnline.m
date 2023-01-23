function [BinaryImage,s,centroids,area,MajorAxisLength,MinorAxisLength,BoundingBox,Orientation,Repetition,Perimeter]=BinarizeImageOnline(DifImage,level,AreaToFilter,MaxElongationFactorAllow,PixelsArenaContour,CheckboxContourArena)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Filter the image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%% Remove background and convert into binary image %%%%%%%%%%%%%%
BinaryImage = imbinarize(DifImage,level); %convert to binary image
BinaryImage([557:557+19],[265:265+170])=0; %remove the date at the bottom of the image
if CheckboxContourArena==0 %gives the option to consider mice on the arena border
  BinaryImage(PixelsArenaContour)=0;%Remove contour -where the side cages are
end

%% %%%%%%%%%%%%%%%%%%%% Remove small objectes and very ellipsoidal objects - according to external parameters %%%%%%%%
BinaryImage=bwareaopen(BinaryImage,AreaToFilter);%remove objects area less than areatofilter
CC = bwconncomp(BinaryImage); %find connected components
STATS = regionprops(CC,'MajorAxisLength','MinorAxisLength','PixelIdxList');% do statistics
MajorAxisLength=cat(1,STATS.MajorAxisLength);
MinorAxisLength=cat(1,STATS.MinorAxisLength);
RatioElongation=MajorAxisLength./MinorAxisLength; %if it is a circle is one

if ~isempty(find(RatioElongation>MaxElongationFactorAllow))%Eliminate boundary detections
       Index=find(RatioElongation>MaxElongationFactorAllow)  
    for count=1:length(Index)
     PixelToEliminate=[];   
     PixelToEliminate=STATS(Index(count)).PixelIdxList;
     BinaryImage(PixelToEliminate)=0;
    end 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Recalculate the properties of the data including clusters %%%%%%%%%%%%%%%%%%%%

CC = bwconncomp(BinaryImage); %find connected components
     s = regionprops(CC,'Centroid','Area','MajorAxisLength','MinorAxisLength','BoundingBox','Orientation','PixelIdxList','Perimeter','PixelList','Perimeter');
     
     centroids = cat(1, s.Centroid);
     area=cat(1,s.Area);
     MajorAxisLength=cat(1,s.MajorAxisLength);
     MinorAxisLength=cat(1,s.MinorAxisLength);
     BoundingBox=cat(1,s.BoundingBox);
     Orientation=cat(1,s.Orientation); 
     Repetition=zeros(size(centroids,1),1);
     Perimeter=cat(1,s.Perimeter);
end

