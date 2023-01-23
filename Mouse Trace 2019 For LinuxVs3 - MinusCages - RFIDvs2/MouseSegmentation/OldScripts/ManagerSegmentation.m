function [CentroidsCorrected,CentroidsCorrectedRepeats] =ManagerSegmentation(BinaryImage,Area,Index,erodePixels,erodeAreasToRemove,numberEvents,cluster)

CentroidsCorrected =[];
CentroidsCorrectedRepeats =[];

for j=1:numberEvents %loop for every case
  CentroidsCorrected1=[]; 
  CentroidsCorrected2=[]; 
  
  %selec the objects we are intrested in
  AuxBinary1=bwareafilt(BinaryImage,[Area(1,Index(1,j)),Area(1,Index(1,j))]);
  
  %erode the image
  
 [saux,centroidsaux,AuxBinary2]= ErodeBigObjects(AuxBinary1,erodePixels,erodeAreasToRemove);
 
 %consider if the separation wasn't good
 
if size(centroidsaux,1)==1  %no separation after erode
    
  CentroidsCorrected1=Segmentation(AuxBinary2,cluster);   
     
elseif size(centroidsaux,1)>cluster %more segmentation as neccesary after erode
     
      [idx,CentroidsCorrected1]=kmeans(centroidsaux,cluster);
      
    
elseif size(centroidsaux,1)==cluster %good separation after erode
    
    CentroidsCorrected1=centroidsaux;
elseif cluster==3 & size(centroidsaux,1)==2
    CentroidsCorrected1=Segmentation(AuxBinary2,cluster);  
end

%% 
CentroidsCorrected2=CentroidsCorrected1;

%% Additional correction 

if cluster==2 & size(CentroidsCorrected2,1)==1 %when the separation didn't succesed thus 2 mice in the same place
%add another coordinate to the list
CentroidsCorrected2=[CentroidsCorrected2;CentroidsCorrected2];
end
%% 
%% Additional correction 

if cluster==3 & size(CentroidsCorrected2,1)==1 %when the separation didn't succesed thus 3 mice in the same place
%add 2 other coordinates to the list
CentroidsCorrected2=[CentroidsCorrected2;CentroidsCorrected2;CentroidsCorrected2];
end
%% 
%% Additional correction 

if cluster==3 & size(CentroidsCorrected2,1)==2 %when the separation didn't succesed thus 2 mice in the same place
%add 2 other coordinates to the list
CentroidsCorrected2=[CentroidsCorrected2;CentroidsCorrected2];
end

 
 CentroidsCorrected =[CentroidsCorrected ;CentroidsCorrected1];
 
 CentroidsCorrectedRepeats=[CentroidsCorrectedRepeats ;CentroidsCorrected2];
 
end
     


end