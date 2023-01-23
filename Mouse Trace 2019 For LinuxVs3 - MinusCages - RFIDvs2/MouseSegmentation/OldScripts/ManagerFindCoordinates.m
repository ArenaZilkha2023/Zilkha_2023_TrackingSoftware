function  [CoordinatesR,NumberOfFrameR,Coordinates,NumberOfFrame,Frame]=ManagerFindCoordinates(Frame,InitialFrame,PixelsArenaContour,CoordinatesR,NumberOfFrameR,Coordinates,NumberOfFrame,count)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function retreives the coordinates of each mouse for a given
% including the marking inside the frame




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Initialize variables
% Coordinates=[];
% NumberOfFrame=[];
% CoordinatesR=[];
% NumberOfFrameR=[]; 

% t=1;

 centroids=[];
 centroidsR=[];   
 %% %% Read initial parameter
Initial_Parameters=Parameters();
 
    %% 
    
Frame=rgb2gray(Frame);%convert to gray scale from rgb 

Frame=mat2gray(Frame); %normalize between 0 to 1
FrameObs=Frame;
%% 
DifImage=imabsdiff(Frame,InitialFrame); %Find the mice which are different from the background


%% -Thesholding the image
[centroids,s,BinaryImage,level]=Thresholding(DifImage);


 
 %% -----------------------Remove small structures less than 300 pixels area related with the borders------------
AreaToFilter=Initial_Parameters.AreaToFilter; %Default is 290
MajorAxis=Initial_Parameters.MajorAxis; %Default is 40
[s,centroids,BinaryImage]=RemoveCorners(s,centroids,BinaryImage,AreaToFilter,MajorAxis);
 
centroidsR=centroids;
 
 
 %%
 %%%%%%%%%%%%%% 
 %%----------CONSIDER THE CASES IN WHICH 2 OR 3 MICE ARE TOGETHER AND THERE AREN'T SEPARATION BETWEEN THEM---------------
LimitArea1To2= Initial_Parameters.LimitArea1To2; % Default is 700 pixels units
LimitArea2To3=Initial_Parameters.LimitArea2To3; %Default is 1150 pixels units
erodePixels=Initial_Parameters.erodePixels;  %Default is 6
erodeAreasToRemove=Initial_Parameters.erodeAreasToRemove; %Default is 10

%% Find mice together
 Index2M=[];
 Index3M=[];
 
 Index2M=find([s.Area]>LimitArea1To2 & [s.Area]<LimitArea2To3 );
 Index3M=find([s.Area]>LimitArea2To3 );
 
 %% 
     
 if ~isempty(Index2M) %consider 2 mice together
     cluster=2;
   [centroidsCorrect2M,CentroidsCorrectedRepeats2M] =ManagerSegmentation(BinaryImage,[s.Area],Index2M,erodePixels,erodeAreasToRemove,length(Index2M),cluster);
   %centroids(Index2M,:)=[];
   centroids=[centroids; centroidsCorrect2M];
   
   %centroidsR(Index2M,:)=[];
   centroidsR=[centroidsR; CentroidsCorrectedRepeats2M];
 end   
     
 %% 
     
 if ~isempty(Index3M) %consider 3 mice together
     cluster=3;
   [centroidsCorrect3M,CentroidsCorrectedRepeats3M] =ManagerSegmentation(BinaryImage,[s.Area],Index3M,erodePixels,erodeAreasToRemove,length(Index3M),cluster);
   %centroids(Index3M,:)=[];
   centroids=[centroids; centroidsCorrect3M];
   
   %centroidsR(Index3M,:)=[];
   centroidsR=[centroidsR; CentroidsCorrectedRepeats3M];
 end   
 %% Remove old centroids
 if ~isempty(Index2M)& ~isempty(Index3M)
     
    centroids([Index2M,Index3M],:)=[];
 elseif ~isempty(Index2M)& isempty(Index3M)
    centroids(Index2M,:)=[];
 elseif isempty(Index2M)& ~isempty(Index3M)
     centroids(Index3M,:)=[];
 end
 %% -------Remove centroids that are on the contour of the arena and receive new centroids--------------------
 centroids=RemoveCentroidsOnContour(centroids,PixelsArenaContour);
 centroidsR=RemoveCentroidsOnContour(centroidsR,PixelsArenaContour);
%% Save the results
Coordinates=[Coordinates ; centroids];


NumberOfFrame=[NumberOfFrame; repmat(count,size(centroids,1),1)];

% SegmentationData=[NumberOfFrame,Coordinates];
%% By including repeated coordinates in the list

CoordinatesR=[CoordinatesR ; centroidsR];

NumberOfFrameR=[NumberOfFrameR; repmat(count,size(centroidsR,1),1)];

% SegmentationDataR=[NumberOfFrameR,CoordinatesR];








%% 
% %draw in the pictures the positions

position=[centroids,repmat(3,size(centroids,1),1)];   
Frame=insertShape(Frame,'circle',position,'LineWidth', 2);
 %imshowpair(Frame,BinaryImage,'montage')

%Create movie
% 
%  mov(t)=im2frame(Frame);
% 
% t=t+1;



% %save data
% save(strcat(DirectoryToSave,'coordinates.mat'),'SegmentationData');
% save(strcat(DirectoryToSave,'coordinatesR.mat'),'SegmentationDataR');
% 
% %% ------------------------Save video------------------
% w=cd;  %current directory
% v1 = VideoWriter(strcat(DirectoryToSave,'temp.avi'));
% v1.FrameRate=12.8;
% open(v1)
% writeVideo(v1,mov)
% % 
% close(v1)

end
