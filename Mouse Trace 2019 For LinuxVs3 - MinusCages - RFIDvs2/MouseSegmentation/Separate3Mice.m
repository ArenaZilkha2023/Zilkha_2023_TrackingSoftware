function [centroidstTotalR,RepetitiontTotal,centroidstTotal,areatTotal,MajorAxisLengthtTotal,MinorAxisLengthtTotal,OrientationtTotal,BoundingBoxtTotal,PixelListtTotal]=Separate3Mice(DifImage,Index3M,s,BoundingBox)

 %consider 3 mice together-SUPPOSE THERE AREN'T CLUSTER LARGER THAN 3
              centroidstTotal=[];
              areatTotal=[];
              MajorAxisLengthtTotal=[];
              OrientationtTotal=[];
              MinorAxisLengthtTotal=[];
              BoundingBoxtTotal=[];
              RepetitiontTotal=[];
              centroidstTotalR=[];
              PixelListtTotal=[];

    for counttriple=1:length(Index3M) %loop over each cluster
        
        [centroidst,areat,MajorAxisLengtht,MinorAxisLengtht,BoundingBoxt,Orientationt,PixelListt]=ApplyWatershed(DifImage,Index3M(counttriple),s,BoundingBox,'cityblock') 
              
    
    if size(centroidst,1)>2
    [~,Itriple]=sort(areat,'descend');
    
                centroidst=centroidst(Itriple(1:3),:);
                areat=areat(Itriple(1:3),:);
                MajorAxisLengtht=MajorAxisLengtht(Itriple(1:3),:);
                MinorAxisLengtht=MinorAxisLengtht(Itriple(1:3),:);
                BoundingBoxt= BoundingBoxt(Itriple(1:3),:);
                Orientationt=Orientationt(Itriple(1:3),:);
                 PixelListt=PixelListt(Itriple(1:3),:);
    %%  %% %%%%%%%%%%%%%%%% Group all centroids together %%%%%%%%%%%%%%%%
    
            centroidstTotal=[centroidstTotal;centroidst];
            centroidstTotalR=[centroidstTotalR;centroidst];
            areatTotal=[areatTotal;areat];
            MajorAxisLengthtTotal=[MajorAxisLengthtTotal;MajorAxisLengtht];
            MinorAxisLengthtTotal=[MinorAxisLengthtTotal;MinorAxisLengtht];
            BoundingBoxtTotal=[BoundingBoxtTotal; BoundingBoxt];
            OrientationtTotal=[OrientationtTotal; Orientationt];
            
            RepetitiontTotal=[RepetitiontTotal;0;0;0];
            
             PixelListtTotal=[PixelListtTotal;PixelListt];
    
    else % if it is not working use
    
         [centroidst,areat,MajorAxisLengtht,MinorAxisLengtht,BoundingBoxt,Orientationt,PixelListt]=ApplyWatershed(DifImage,Index3M(counttriple),s,BoundingBox,'euclidean') 
              
    
         if size(centroidst,1)>2
                [~,Itriple]=sort(areat,'descend');
    
                centroidst=centroidst(Itriple(1:3),:);
                areat=areat(Itriple(1:3),:);
                MajorAxisLengtht=MajorAxisLengtht(Itriple(1:3),:);
                MinorAxisLengtht=MinorAxisLengtht(Itriple(1:3),:);
                BoundingBoxt= BoundingBoxt(Itriple(1:3),:);
                Orientationt=Orientationt(Itriple(1:3),:);
                 PixelListt=PixelListt(Itriple(1:3),:);
    %%  %% %%%%%%%%%%%%%%%% Group all centroids together %%%%%%%%%%%%%%%%
    
            centroidstTotal=[centroidstTotal;centroidst];
            centroidstTotalR=[centroidstTotalR;centroidst];
            areatTotal=[areatTotal;areat];
            MajorAxisLengthtTotal=[MajorAxisLengthtTotal;MajorAxisLengtht];
            MinorAxisLengthtTotal=[MinorAxisLengthtTotal;MinorAxisLengtht];
            BoundingBoxtTotal=[BoundingBoxtTotal; BoundingBoxt];
            OrientationtTotal=[OrientationtTotal; Orientationt];
            
            RepetitiontTotal=[RepetitiontTotal;0;0;0];
            
             PixelListtTotal=[PixelListtTotal;PixelListt];
        
        elseif  size(centroidst,1)==1
           centroidstTotal=[centroidstTotal;centroidst];
            areatTotal=[areatTotal;areat];
            MajorAxisLengthtTotal=[MajorAxisLengthtTotal;MajorAxisLengtht];
            MinorAxisLengthtTotal=[MinorAxisLengthtTotal;MinorAxisLengtht];
            BoundingBoxtTotal=[BoundingBoxtTotal; BoundingBoxt];
            OrientationtTotal=[OrientationtTotal; Orientationt];
            
            RepetitiontTotal=[RepetitiontTotal;2]; %no the  cluster in 3
            
             centroidstTotalR=[centroidstTotalR;centroidst;centroidst];
             
             PixelListtTotal=[PixelListtTotal;PixelListt];
            
        elseif  size(centroidst,1)==2
            % Find which one is the cluster
            [~,IndexSort]=sort(areat,'descend'); %the first area is from the cluster which couldn't separate
            
            Centroid2mice=centroidst(IndexSort(1),:); %This centroid is repeated
              
            centroidstTotal=[centroidstTotal;centroidst];
            areatTotal=[areatTotal;areat];
            MajorAxisLengthtTotal=[MajorAxisLengthtTotal;MajorAxisLengtht];
            MinorAxisLengthtTotal=[MinorAxisLengthtTotal;MinorAxisLengtht];
            BoundingBoxtTotal=[BoundingBoxtTotal; BoundingBoxt];
            OrientationtTotal=[OrientationtTotal; Orientationt];
            PixelListtTotal=[PixelListtTotal;PixelListt];
            
            RepetitiontTotal=[RepetitiontTotal;1;0]; %only 2 cluster find 
            centroidstTotalR=[centroidstTotalR;centroidst; Centroid2mice];
        
        %% 
        
        end
    end
 end
end