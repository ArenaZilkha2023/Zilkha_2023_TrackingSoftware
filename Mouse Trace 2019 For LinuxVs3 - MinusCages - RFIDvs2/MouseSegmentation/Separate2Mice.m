function [centroidsdTotalR,RepetitiondTotal,centroidsdTotal,areadTotal,MajorAxisLengthdTotal,MinorAxisLengthdTotal,OrientationdTotal,BoundingBoxdTotal,PixelListdTotal]=Separate2Mice(DifImage,Index2M,s,BoundingBox)

  %consider 2 mice together
              centroidsdTotal=[];
              centroidsdTotalR=[]; %as centroidsdTotal but with addition of repetitions
              areadTotal=[];
              MajorAxisLengthdTotal=[];
              OrientationdTotal=[];
              MinorAxisLengthdTotal=[];
              BoundingBoxdTotal=[];
              RepetitiondTotal=[];
              PixelListdTotal=[];
            
       for countDouble=1:length(Index2M) %loop over each cluster
           
           [centroidsd,aread,MajorAxisLengthd,MinorAxisLengthd,BoundingBoxd,Orientationd,PixelListd]=ApplyWatershed(DifImage,Index2M(countDouble),s,BoundingBox,'cityblock'); 
    
           if size(centroidsd,1)>1 %only consider if the separatation was done
                [~,Idupl]=sort(aread,'descend');
    
                centroidsd=centroidsd(Idupl(1:2),:);
                aread=aread(Idupl(1:2),:);
                MajorAxisLengthd=MajorAxisLengthd(Idupl(1:2),:);
                MinorAxisLengthd=MinorAxisLengthd(Idupl(1:2),:);
                BoundingBoxd= BoundingBoxd(Idupl(1:2),:);
                Orientationd=Orientationd(Idupl(1:2),:);
                PixelListd=PixelListd(Idupl(1:2),:);
    %% %%%%%%%%%%%%%%%% Group all centroids together %%%%%%%%%%%%%%%%
    
            centroidsdTotal=[centroidsdTotal;centroidsd];
            centroidsdTotalR=[centroidsdTotalR;centroidsd];
            areadTotal=[areadTotal;aread];
            MajorAxisLengthdTotal=[MajorAxisLengthdTotal;MajorAxisLengthd];
            MinorAxisLengthdTotal=[MinorAxisLengthdTotal;MinorAxisLengthd];
            BoundingBoxdTotal=[BoundingBoxdTotal; BoundingBoxd];
            OrientationdTotal=[OrientationdTotal; Orientationd];
            RepetitiondTotal=[RepetitiondTotal;0;0];
             PixelListdTotal=[PixelListdTotal;PixelListd];
             
           else %if the separation isn't good try other method for distance
               [centroidsd,aread,MajorAxisLengthd,MinorAxisLengthd,BoundingBoxd,Orientationd,PixelListd]=ApplyWatershed(DifImage,Index2M(countDouble),s,BoundingBox,'euclidean'); 
         
              if size(centroidsd,1)>1 %only consider if the separatation was done
                [~,Idupl]=sort(aread,'descend');
    
                centroidsd=centroidsd(Idupl(1:2),:);
                aread=aread(Idupl(1:2),:);
                MajorAxisLengthd=MajorAxisLengthd(Idupl(1:2),:);
                MinorAxisLengthd=MinorAxisLengthd(Idupl(1:2),:);
                BoundingBoxd= BoundingBoxd(Idupl(1:2),:);
                Orientationd=Orientationd(Idupl(1:2),:);
                PixelListd=PixelListd(Idupl(1:2),:);
    %% %%%%%%%%%%%%%%%% Group all centroids together %%%%%%%%%%%%%%%%
    
            centroidsdTotal=[centroidsdTotal;centroidsd];
            centroidsdTotalR=[centroidsdTotalR;centroidsd];
            areadTotal=[areadTotal;aread];
            MajorAxisLengthdTotal=[MajorAxisLengthdTotal;MajorAxisLengthd];
            MinorAxisLengthdTotal=[MinorAxisLengthdTotal;MinorAxisLengthd];
            BoundingBoxdTotal=[BoundingBoxdTotal; BoundingBoxd];
            OrientationdTotal=[OrientationdTotal; Orientationd];          
            RepetitiondTotal=[RepetitiondTotal;0;0];
            PixelListdTotal=[PixelListdTotal;PixelListd];
              else %add of duplicate no definition for the axis
           
            
            centroidsdTotal=[centroidsdTotal;centroidsd];
            areadTotal=[areadTotal;aread];
            MajorAxisLengthdTotal=[MajorAxisLengthdTotal;MajorAxisLengthd];
            MinorAxisLengthdTotal=[MinorAxisLengthdTotal;MinorAxisLengthd];
            BoundingBoxdTotal=[BoundingBoxdTotal; BoundingBoxd];
            OrientationdTotal=[OrientationdTotal; Orientationd];          
            RepetitiondTotal=[RepetitiondTotal;1]; %This parameter tell us if there are duplicate positions because of 
           %wrong separation
            centroidsdTotalR=[centroidsdTotalR;centroidsd;centroidsd];%when the coordinate is repeated
           
            PixelListdTotal=[PixelListdTotal;PixelListd];
           
           end
      end
           
    end













