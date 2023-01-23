function [s,centroids,BinaryImage]=RemoveCorners(s,centroids,BinaryImage,AreaToFilter,MajorAxis)

%Remove the white corners from the image using 2 conditions the small area
%and the major axis and recalculate the parameters

%--Create auxiliary image by elliminating areas more than a certain value

AuxiliaryImage=bwpropfilt(BinaryImage,'Area',[0 AreaToFilter]); %condition of area'\

AuxiliaryImage1=bwpropfilt(AuxiliaryImage,'MajorAxisLength',[MajorAxis +Inf]); %condition of major length

%----Find the pixels of this structure------------

saux=regionprops(AuxiliaryImage1,'PixelIdxList');
if ~isempty(saux)
 clear centroids;
 clear s;
    
for i=1:length(saux)
% clear centroids
%  clear s 
 %recalculate
 
BinaryImage(saux(i).PixelIdxList)=0;


   

end

%% ------------Recalculate centroids------------------------
  s = regionprops(BinaryImage,'centroid','Area','EulerNumber','MajorAxisLength','MinorAxisLength');
    centroids = cat(1, s.Centroid);

end

end

