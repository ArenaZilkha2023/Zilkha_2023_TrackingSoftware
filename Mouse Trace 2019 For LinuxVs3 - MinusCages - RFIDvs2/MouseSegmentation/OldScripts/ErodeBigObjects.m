function  [saux,centroidsaux,BW]= ErodeBigObjects(BW,erodePixels,erodeAreasToRemove) 
%This 
       
       se = strel('disk',erodePixels); %structural object
       BW=imerode(BW,se); %erode image
       BW=imfill(BW,'holes'); %fill holes
       
       %remove erode areas unde 10 pixels
       BW=bwareaopen(BW,erodeAreasToRemove);
       
       %find new centroids
       saux=regionprops(BW,'centroid','Area');
       centroidsaux=cat(1,saux.Centroid);
       

end

