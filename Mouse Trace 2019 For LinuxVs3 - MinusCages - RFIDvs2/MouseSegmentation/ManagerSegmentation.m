function  [IndicationClusterWithRepeats,IndicationClusterWithoutRepeats,CoordinatesPixelR,CoordinatesPixel,Frame,MajorAxisLengthAll,OrientationTotal,RepetitionAll,...
    MinorAxisLengthAll,areaTotalAll,BoundingBoxAll,...
    MousePixels]=ManagerSegmentation(Frame,BackgroundImage,PixelsArenaContour,AreaToFilter,MaxElongationFactorAllow,LimitArea1To2,LimitArea2To3,...
                                     CheckboxAdditionalBack,CheckboxAdditionalCirc,CheckboxAdditionalArea,...
                                      BackgroundFactor,CircularityFactor,AreaFinalFactor,CheckboxContourArena) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function retreives the coordinates of each mouse for a given
% ManagerSegmentation(Iaux,Initial_Parameters.BackgroundImage,PixelsArenaContour, Initial_Parameters.AreaToFilter, Initial_Parameters.MajorAxis,Initial_Parameters.LimitArea1To2,Initial_Parameters.LimitArea2To3)
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Define variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CoordinatesPixel=[];
CoordinatesPixelR=[];
MajorAxisLengthAll=[];
OrientationTotal=[];
RepetitionAll=[];
centroids=[]; 
centroidsdTotalR=[];
centroidsdTotal=[];
centroidstTotalR=[];
centroidstTotal=[];
MajorAxisLength=[];
MajorAxisLengthdTotal=[];
MajorAxisLengthtTotal=[];
Orientation=[];
OrientationdTotal=[];
OrientationtTotal=[];
Repetition=[];
RepetitiondTotald=[];
RepetitiontTotalt=[];
MinorAxisLength=[];
MinorAxisLengthdTotal=[];
MinorAxisLengthtTotal=[];
area=[];
areadTotal=[];
areatTotal=[];
BoundingBox=[];
BoundingBoxdTotal=[];
BoundingBoxtTotal=[];
PixelListdTotal=[];
PixelListtTotal=[];
%% %%%%%%%%%% Remove background and convert into binary image %%%%%%%%%%%%%%
DifImage=imabsdiff(rgb2gray(Frame),BackgroundImage);
[level,EM]=graythresh(DifImage); % Threshold the image
[BinaryImage,s,centroids,area,MajorAxisLength,MinorAxisLength,BoundingBox,Orientation,Repetition,Perimeter]=BinarizeImageOnline(DifImage,level,AreaToFilter,MaxElongationFactorAllow,PixelsArenaContour,CheckboxContourArena);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
 %%%%%%%%%%%%%% Reconsider the cases in which the segmentation is much
    %%%%%%%%%%%%%% larger-NOTE SUPPOSE 10 and recalculate again
    if size(centroids,1)>10
       % establish new level
       level=level/EM;
        [BinaryImage,s,centroids,area,MajorAxisLength,MinorAxisLength,BoundingBox,Orientation,Repetition,Perimeter]=BinarizeImageOnline(DifImage,level,AreaToFilter,MaxElongationFactorAllow,PixelsArenaContour,CheckboxContourArena);
    end
  %% ADD Fix Threshold instead the automatic one
                if CheckboxAdditionalBack==1
                            level=BackgroundFactor;
                  [BinaryImage,s,centroids,area,MajorAxisLength,MinorAxisLength,BoundingBox,Orientation,Repetition,Perimeter]=BinarizeImageOnline(DifImage,level,AreaToFilter,MaxElongationFactorAllow,PixelsArenaContour,CheckboxContourArena);          
            end 
            %% ADD Additional restrictions for final segmentation
          Circularity=(Perimeter.^2)./(4*pi*area);
    
 if CheckboxAdditionalArea==1 & ~isempty(find(area<AreaFinalFactor)) %Eliminate according to area
    Indexa=find(area>AreaFinalFactor);
    area=area(Indexa);
    centroids = centroids(Indexa,:);
    MajorAxisLength=MajorAxisLength(Indexa);
    MinorAxisLength= MinorAxisLength(Indexa);
    BoundingBox=BoundingBox(Indexa);
    Orientation=Orientation(Indexa); 
    Circularity= Circularity(Indexa);
    Repetition=zeros(size(centroids,1),1);
    Perimeter=Perimeter(Indexa);
    s=s(Indexa);
   BoundingBox=cat(1,s.BoundingBox);
    Orientation=cat(1,s.Orientation); 
end 

  if CheckboxAdditionalCirc==1 & ~isempty(find(Circularity>CircularityFactor)) %Eliminate according to circulaty
    Indexc=find(Circularity<CircularityFactor);
    area=area(Indexc);
    centroids = centroids(Indexc,:);
    MajorAxisLength=MajorAxisLength(Indexc);
    MinorAxisLength= MinorAxisLength(Indexc);
    BoundingBox=BoundingBox(Indexc);
    Orientation=Orientation(Indexc); 
    Repetition=zeros(size(centroids,1),1);
    Perimeter=Perimeter(Indexc);
    s=s(Indexc);
   BoundingBox=cat(1,s.BoundingBox);
    Orientation=cat(1,s.Orientation); 
end    
    
    
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

%% Continue to identify clusters
 
 Index1M=find([s.Area]<LimitArea1To2);    
 Index2M=find([s.Area]>=LimitArea1To2 & [s.Area]<LimitArea2To3 );%find cluster of 2 mice
 Index3M=find([s.Area]>=LimitArea2To3 ); %find cluster of more than 3 mice.   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%% Separate clusters of 2 mice%%%%%%%%%%%%%%%%%%%%%%%

 if ~isempty(Index2M)  
       [centroidsdTotalR,RepetitiondTotald,centroidsdTotal,areadTotal,MajorAxisLengthdTotal,MinorAxisLengthdTotal,OrientationdTotal,BoundingBoxdTotal,PixelListdTotal]=Separate2Mice(DifImage,Index2M,s,BoundingBox);
 end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% Separate clusters of 3 mice %%%%%%%%%%%%%%%%

 if ~isempty(Index3M) %consider 2 mice together
         [centroidstTotalR,RepetitiontTotalt,centroidstTotal,areatTotal,MajorAxisLengthtTotal,MinorAxisLengthtTotal,OrientationtTotal,BoundingBoxtTotal,PixelListtTotal]=Separate3Mice(DifImage,Index3M,s,BoundingBox); 
           
 end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find for single mice the front and rear of the mouse%%%%%%%%%%%%%%%%%%%%%%%%%
%TO DO
% [ExtremePoints1,ExtremePoints2]=FindHeadTail(s,Index1M,BoundingBox);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Summarize the information %%%%%%%%%%

CoordinatesPixel=[centroids(Index1M,:);centroidsdTotal;centroidstTotal];
CoordinatesPixelR=[centroids(Index1M,:);centroidsdTotalR;centroidstTotalR];
MajorAxisLengthAll=[MajorAxisLength(Index1M,:);MajorAxisLengthdTotal;MajorAxisLengthtTotal];
MinorAxisLengthAll=[MinorAxisLength(Index1M,:);MinorAxisLengthdTotal;MinorAxisLengthtTotal];
areaTotalAll=[area(Index1M,:);areadTotal;areatTotal];
OrientationTotal=[Orientation(Index1M,:);OrientationdTotal;OrientationtTotal];
RepetitionAll=[Repetition(Index1M,:);RepetitiondTotald;RepetitiontTotalt];
BoundingBoxAll=[BoundingBox(Index1M,:);BoundingBoxdTotal;BoundingBoxtTotal];
MousePixels=[{s(Index1M).PixelList}';PixelListdTotal;PixelListtTotal];

% Add the information if the coordinate belong to one (1) or comes from a
% two cluster or a three cluster

IndicationClusterWithoutRepeats=[ones(size(centroids(Index1M,:),1),1);2*ones(size(centroidsdTotal,1),1);3*ones(size(centroidstTotal,1),1)];
IndicationClusterWithRepeats=[ones(size(centroids(Index1M,:),1),1);2*ones(size(centroidsdTotalR,1),1);3*ones(size(centroidstTotalR,1),1)]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create a frame to save later with the coordinates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

position=[CoordinatesPixel,repmat(3,size(CoordinatesPixel,1),1)];   
Frame=insertShape(Frame,'circle',position,'LineWidth', 2,'Color','yellow');

 % Add head and  tail
% position=[ExtremePoints1,repmat(3,size(ExtremePoints1,1),1)];   
% Frame=insertShape(Frame,'circle',position,'LineWidth', 2,'Color','red');
% position=[ExtremePoints2,repmat(3,size(ExtremePoints2,1),1)];   
% Frame=insertShape(Frame,'circle',position,'LineWidth', 2,'Color','blue');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 



end
