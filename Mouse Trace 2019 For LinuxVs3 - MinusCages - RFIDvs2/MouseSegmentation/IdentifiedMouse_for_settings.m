

function IdentifiedMouse_for_settings(~,~)
%% ----------------------Read the data of the gui------------------------
global h

VideoFilename=get(h.SetThreshold.editLoadDirectoryChild,'string');
FrameNumber=str2num(get(h.SetThreshold.editNumFrames,'string')); % Number of frames
AreaToFilter=str2num(get(h.SetThreshold.AreaToFilter,'string')); % Number of frames
MinElongationFactor=str2num(get(h.SetThreshold.MinElongationFactor,'string')); % Number of frames
LimitArea1To2=str2num(get( h.SetThreshold.AreaMouse,'string'));%default 650
LimitArea2To3=str2num(get( h.SetThreshold.Area2Mouse,'string'));%default 1150
%% 

 % ---------------Auxiliary operations ---------------------
 % suppose that background is inside the respective folder
 
 %%
 
 Aux1=strfind(VideoFilename,'\');
 SaveFile=strcat(VideoFilename(1:Aux1(length(Aux1))),'BackgroundImage.mat');

%% ---------------Load background------------------ 
if exist(SaveFile)==0
    
    errormessage('No background image exists');
else    
load(SaveFile); %load the background

  v=VideoReader(VideoFilename);

  FrameToConsider=rgb2gray(read(v,FrameNumber)); 
  
  
  DifImage=imabsdiff(FrameToConsider,BackGroundImage); %Find the mice which are different from the background
%  DifImage=insertShape(DifImage,'FilledRectangle',[ 265.5100  557.5100  176.9800   18.9800],'color','white');
%   DifImage=rgb2gray(DifImage);

  %% update the display 
axes(h.SetThreshold.hAxisWB);
imagesc(DifImage)
colormap gray
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% Thresholding According Otsu method
%% Threshold the image
[level,EM]=graythresh(DifImage);
[BinaryImage,s,centroids,area,MajorAxisLength,MinorAxisLength,BoundingBox,Orientation,Repetition]=BinarizeImage(DifImage,level,BackGroundImage,AreaToFilter,MinElongationFactor);
    
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% Reconsider the cases in which the segmentation is much
    %%%%%%%%%%%%%% larger-NOTE SUPPOSE 10
    if size(centroids,1)>10
       % establish new level
       level=level/EM;
        [BinaryImage,s,centroids,area,MajorAxisLength,MinorAxisLength,BoundingBox,Orientation,Repetition]=BinarizeImage(DifImage,level,BackGroundImage,AreaToFilter,MinElongationFactor);
    end
    
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find the extremes of the mice %%%%%%%%%%%%%
% Find intersection with bounding box
% Find perimeter
 



for countCentroid=1:size(centroids,1)
   MousePixels=s(countCentroid).PixelList; 
   points=bbox2points(BoundingBox(countCentroid,:,:,:));
   
   for i=1:4
            distance=sqrt((MousePixels(:,1)-repmat(points(i,1),size(MousePixels,1),1)).^2+(MousePixels(:,2)-repmat(points(i,2),size(MousePixels,1),1)).^2);
    
            [MinDist(i),index(i)]=min(distance);
   end
    [~,Isort]=sort(MinDist,'ascend');
    
    ExtremePoints1(countCentroid,:)=[MousePixels(index(Isort(1)),1),MousePixels(index(Isort(1)),2)];
     ExtremePoints2(countCentroid,:)=[MousePixels(index(Isort(2)),1),MousePixels(index(Isort(2)),2)];
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% Separate mice together %%%%%%%%%%%%%%%%
    %% Parameters
%       LimitArea1To2=650;%was 700
%       LimitArea2To3=1150;%It was 1150
      erodePixels=5;
      erodeAreasToRemove=6;
      Index2M=[];
       Index3M=[];
    %% 
    centroidsd=[];
     centroidst=[];
       Index2M=find([s.Area]>=LimitArea1To2 & [s.Area]<LimitArea2To3 );
       Index3M=find([s.Area]>=LimitArea2To3 );
       %% %%%%%%%%%%%%%%%%%%%%%%%%Separate a cluster of 2Mice %%%%%%%%%%%%%%%%%%%%%%%
     if ~isempty(Index2M)  
       [centroidsdTotalR,RepetitiondTotal,centroidsdTotal,areadTotal,MajorAxisLengthdTotal,MinorAxisLengthdTotal,OrientationdTotal,BoundingBoxdTotal]=Separate2Mice(DifImage,Index2M,s,BoundingBox)
     end 
    
       %% %%%%%%%%%%%%%%%%%%%%%%%%%% Separate a cluster of 3Mice %%%%%%%%%%%%%%%%%%%%%%
       if ~isempty(Index3M) %consider 2 mice together
         [centroidstTotalR,RepetitiontTotal,centroidstTotal,areatTotal,MajorAxisLengthtTotal,MinorAxisLengthtTotal,OrientationtTotal,BoundingBoxtTotal]=Separate3Mice(DifImage,Index3M,s,BoundingBox); 
           
    end 
       
    %% 
       
       
       
       
       
       
       
       
       %% 
       
       
       
       
       
       
       
       
       % Idea 
       %1)- if we know the index2M we can know pixel list
     %2)- Extract inside a loop each cluster
     %3)-Erode the area  and plot the new binary image
     %4)- Applied kmeans
     %5)Intenta water shed
       
       
       
       
       
    
%             
%  if ~isempty(Index2M) %consider 2 mice together
%      cluster=2;
%    [centroidsCorrect2M,CentroidsCorrectedRepeats2M] =ManagerSegmentation(BinaryImage,[s.Area],Index2M,erodePixels,erodeAreasToRemove,length(Index2M),cluster);
%    centroids(Index2M,:)=[];
%    centroids=[centroids; centroidsCorrect2M];
%    
%    %centroidsR(Index2M,:)=[];
%    %centroidsR=[centroidsR; CentroidsCorrectedRepeats2M];
%  end  
    
  %% update the display 
axes(h.SetThreshold.hAxisT);
imagesc(BinaryImage)

colormap gray
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Add the position to the original image in the third panel
   
    Frame=FrameToConsider;
     position=[centroids,repmat(3,size(centroids,1),1)];   
      position1=[ ExtremePoints1,repmat(3,size(centroids,1),1)]; 
       position2=[ ExtremePoints2,repmat(3,size(centroids,1),1)];  
        
    
    Frame=insertShape(Frame,'circle',position,'LineWidth', 2,'Color','yellow');
    Frame=insertShape(Frame,'Rectangle',BoundingBox,'LineWidth', 2,'Color','cyan');
     Frame=insertShape(Frame,'FilledCircle',position1,'LineWidth', 2,'Color','red');
    Frame=insertShape(Frame,'FilledCircle',position2,'LineWidth', 2,'Color','blue');
    
    if  ~isempty(Index2M) & ~isempty(centroidsdTotal)
     positiondupl=[centroidsdTotal,repmat(3,size(centroidsdTotal,1),1)];
    Frame=insertShape(Frame,'circle',positiondupl,'LineWidth', 2,'Color','magenta');
    end
    
     if ~isempty(Index3M) & ~isempty(centroidstTotal)
     positiontriple=[centroidstTotal,repmat(3,size(centroidstTotal,1),1)];
    Frame=insertShape(Frame,'circle',positiontriple,'LineWidth', 2,'Color','magenta');
    end
    
    
    axes(h.SetThreshold.hAxisB);
     imshow(Frame)
    
%    figure
%    
%     imshow(Frame)
    %% For adding ellipse
    
    t = linspace(0,2*pi,50);

hold on
for k = 1:size(centroids,1)
    if s(k).Area < LimitArea1To2  
    
    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;
    Xc = s(k).Centroid(1);
    Yc = s(k).Centroid(2);
    phi = deg2rad(-s(k).Orientation);
    x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
    y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
    plot(x,y,'r','Linewidth',1)
    end
end
hold off
    
hold on
if  ~isempty(Index2M) & ~isempty(centroidsdTotal)
   for k = 1:size(centroidsdTotal,1)
    
    
    a = MajorAxisLengthdTotal(k)/2;
    b = MinorAxisLengthdTotal(k)/2;
    Xc = centroidsdTotal(k,1);
    Yc = centroidsdTotal(k,2);
    phi = deg2rad(-OrientationdTotal(k));
    x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
    y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
    plot(x,y,'r','Linewidth',1)
    


   end
end
hold off


hold on
if  ~isempty(Index3M) & ~isempty(centroidstTotal)
   for k = 1:size(centroidstTotal,1)
    
    
    a = MajorAxisLengthtTotal(k)/2;
    b = MinorAxisLengthtTotal(k)/2;
    Xc = centroidstTotal(k,1);
    Yc = centroidstTotal(k,2);
    phi = deg2rad(-OrientationtTotal(k));
    x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
    y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
    plot(x,y,'r','Linewidth',1)
    


   end
end
hold off



   
end








end