function [centroids,s,BinaryImage,level]=Thresholding(DifImage)

%Thresholding the image

%level=graythresh(DifImage);
%add
%level=0.09
[level,metric] = multithresh(DifImage,4);
BinaryImage = imbinarize(DifImage,level(3));

saux = regionprops(BinaryImage,'centroid','Area');
 Area = cat(1, saux.Area);
Iaux=Area>100;
if any(Iaux)==0 %there are not mice detected
  
BinaryImage = imbinarize(DifImage,level(2));  
    
    
end



%Clean the binary image  areas with pixels less than 200
% P=205; %NOTE THAT THIS CONDITION WAS INSERTED-This parameter must be variable
%  BinaryImage=bwareaopen(BinaryImage,P);
% BinaryImage=imfill(BinaryImage,'holes');

%Clean the binary image  areas with pixels less than 200
%P=205; %NOTE THAT THIS CONDITION WAS INSERTED-This parameter must be variable
P=100;
BinaryImage=bwareaopen(BinaryImage,P);
BinaryImage=imfill(BinaryImage,'holes'); %fill holes and then remove


%% get image information

%     s = regionprops(BinaryImage,'centroid','Area','Eccentricity','Extent','EquivDiameter','EulerNumber','FilledArea','MajorAxisLength','MinorAxisLength','Orientation','Perimeter','Solidity','ConvexArea','BoundingBox');
    s = regionprops(BinaryImage,'centroid','Area','EulerNumber','MajorAxisLength','MinorAxisLength');
    centroids = cat(1, s.Centroid);

end