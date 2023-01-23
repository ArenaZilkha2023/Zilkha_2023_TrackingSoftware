function  [centroidsd,aread,MajorAxisLengthd,MinorAxisLengthd,BoundingBoxd,Orientationd,PixelListd]= ApplyWatershed(DifImage,IndexCluster,s,BoundingBox,method)
            
                            
               
             pixelsAux=s(IndexCluster).PixelList; 
            
             Uppercornerx=BoundingBox(IndexCluster,1);
             Uppercornery=BoundingBox(IndexCluster,2);
             
             % crop the desired picture
             I=imcrop(DifImage,BoundingBox(IndexCluster,:));
          
             level=graythresh(I);
             BinaryImageCrop = imbinarize(I,level);
             
             %% %%%%%%%%%% Apply watershed method %%%%%%%%
             
            D = bwdist(~BinaryImageCrop,method);
            D = -D;
            D(~BinaryImageCrop) = Inf; 
             L = watershed(D,8);
             L(~BinaryImageCrop) = 0;
             
             % only for testing
%             rgb = label2rgb(L,'jet',[.5 .5 .5]);
%             figure
%             imshow(rgb,'InitialMagnification','fit')

            %% Get information

            sd = regionprops(L,'Centroid','Area','MajorAxisLength','MinorAxisLength','BoundingBox','Orientation','PixelIdxList','Perimeter','PixelList');
     
% 
            centroidsd = cat(1, sd.Centroid)+[Uppercornerx, Uppercornery];
            aread=cat(1,sd.Area);
            MajorAxisLengthd=cat(1,sd.MajorAxisLength);
            MinorAxisLengthd=cat(1,sd.MinorAxisLength);
            BoundingBoxd=cat(1,sd.BoundingBox);
            Orientationd=cat(1,sd.Orientation)
            PixelListd={sd.PixelList}';






end