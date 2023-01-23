function [PixelsArenaContour]=ThresholdingBackgroundFrame(InitialFrame)

%The idea is to find the region in pixels which is the contour of our image


%Thresholding the image-initial frame only the arena without mouse
level=graythresh(InitialFrame);
BinaryImage = imbinarize(InitialFrame,level);
BinaryImageAux=imfill(BinaryImage,'holes');%fill the useful part of the arena

BinaryImageAux=bwareaopen(BinaryImageAux,100000);%remain only the central part

%dilate the binary image in order to remove reflection on the cages


BinaryImageAux=imdilate(BinaryImageAux,strel('rectangle',[10,10]));


%% get image information

    s = regionprops(~BinaryImageAux,'PixelIdxList');
    PixelsArenaContour=s.PixelIdxList; %gives the indexes of the pixels

   

end