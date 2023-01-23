%Insert to the rfid
function ManagerRFIDCoupling()
%% Variables
Date='14/12/2016';
DateToBeConsidered=datenum(Date,'dd/mm/yyyy');
load('D:\DataToBuildNewGui2\MatlabFiles\timeReal.mat');
TimeExp=TimeExp(2:end);
load('D:\DataToBuildNewGui2\MatlabFiles\coordinatesR.mat');
Position=SegmentationDataR(2:end,:);%dont consider the first frame without time

[VideoFileName,VideoPathName] = uigetfile('*.avi','Select Avi file');%select video
v1=VideoReader(fullfile(VideoPathName,VideoFileName));
v2=VideoReader(fullfile(VideoPathName,VideoFileName));

%% find male and female list- Root directory and sheet given by the user
sheet='Exp53L_12_14_2016';
[num,txt,raw]=xlsread(strcat('D:\DataToBuildNewGui2\Parameters','\','MiceID.xlsx'),sheet);

miceList=raw(2:6,2);
miceList=strrep(miceList,'''',''); %for removing double quotes
miceListRibs=raw(2:6,3);
miceListRibs=strrep(miceListRibs,'''','');

%% 
%%Select  the RFID files 



%% ----------------------------------Read Parameters of RFID files----------------


RFIDobj=FilesTreat;%use class FilesTreat
RFIDobj.directory='D:\DataToBuildNewGui2\RFID\';
RFIDobj.extension='.txt';
N=RFIDobj.NumFiles(RFIDobj.ListFiles);
DateFiles=RFIDobj.DateFiles(RFIDobj.ListFiles,N);

%% ---------------------------Define object Time---------------------------------
Timeobj=TimeLine;
%% ---------------According to date select RFID

 IndexFilesDates=find(DateFiles==DateToBeConsidered);
 SelectedDataRFID=RFIDobj.ReadFilesAllDate(RFIDobj.ListFiles,IndexFilesDates);



 
 %% 

% Rearrange the data according to the mice in a multidimensional array

for j=1:length(miceList) %for each mouse
    
    
  %% --------Found in the RFID selected data the mouse with 2 identities head or reabs--
%%----------Couple RFID with original time----------------------------------


AuxID=vertcat(SelectedDataRFID{:,1});%identity
Auxtime=vertcat(SelectedDataRFID{:,3}); %time
Auxantenna=vertcat(SelectedDataRFID{:,4}); %antenna


Iaux=[find(strcmp(miceList(j),AuxID)==1); find(strcmp(miceListRibs(j),AuxID)==1)]; %find the identity of the respective mouse either with the ribs or head ID




%for the specific mouse
 AuxIDn=AuxID(Iaux);
 Auxtimen=Auxtime(Iaux);
 Auxantennan=Auxantenna(Iaux);
 
 TimeExp=strrep(TimeExp,'''','');
 
  %search the similar time points for each frame in the csv file
  d=knnsearch(datenum(Auxtimen,'HH:MM:SS.FFF'),datenum(TimeExp,'HH:MM:SS.FFF'));
  
  
       %% ---------------------------- Treat with the time-------------------------
    Timeobj.FrameTime=TimeExp;
    Timeobj.RFIDTime=Auxtimen(d);
    
    DeltaTimeFrameRFID=abs(Timeobj.DeltaTime)*1000 ;%for getting in ms-- difference between rfid and the frame time
   
  
  
  

   MouseArray(:,1,j)=strcat('''',TimeExp,'''');
   MouseArray(:,3,j)=strcat('''',Auxtimen(d),''''); %RFID time
   MouseArray(:,2,j)=Auxantennan(d); %antenna rfid
   MouseArray(:,4,j)=num2cell(DeltaTimeFrameRFID);
     %% 

%   
%     sheet=char(miceList(j));
%     
%     xlswrite('MouseInf.xlsx',MouseArray(:,:,j),sheet);
%      xlswrite('Coord.xlsx',Position,sheet);
%     
    
%% --------------Go over each frame and assign the correct coordinate---------------------


    
    
    
    
    
    
end
%% Coupling the antenna
AntennaForMice=[];
CoordinatesFinalMice=[];
CoordinatesFinalMiceMM=[];

% For the bacward
AntennaForMiceB=[];
CoordinatesFinalMiceB=[];
CoordinatesFinalMiceMMB=[];


%% Create new variables for marking the cases which are wrong
FidelityMatrix=zeros(20000,length(miceList)); %the columns are the mouse and the rows are the frames-if the value is 1 the coord have to be reviewed later
FidelityAntenna=zeros(20000,length(miceList));
FidelityForNonCoord=zeros(20000,length(miceList));
IsSleeping=zeros(20000,length(miceList)); %Change in the future the 20000 value

%% Define matrix to backward process
FidelityMatrixB=zeros(20000,length(miceList)); %the columns are the mouse and the rows are the frames-if the value is 1 the coord have to be reviewed later
FidelityAntennaB=zeros(20000,length(miceList));
FidelityForNonCoordB=zeros(20000,length(miceList));
IsSleepingB=zeros(20000,length(miceList)); %Change in the future the 20000 value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 


% for  countFrames=1:size(MouseArray,1)-1 %Loop over the frames
TotalFrames=size(MouseArray,1)

;

%% For internal checking

  for  countFrames=1:TotalFrames  
     for j=1:length(miceList)
       AntennaForMiceT(countFrames,j)=str2num(MouseArray{countFrames,2,j}); 
       DeltaTimeRFIDT(countFrames,j)=MouseArray{countFrames,4,j};
     end
  end

% xlswrite('AntennaTotal', AntennaForMiceT);
% xlswrite('DeltaTimeTotal', DeltaTimeRFIDT);

%% 

for countFrames=1:TotalFrames
    countFrames
    AuxCoordinates=[];
     AuxCoordinatesMM=[];
     
     %for backward
      AuxCoordinatesB=[];
      AuxCoordinatesMMB=[];
     
     
  for j=1:length(miceList)
       AntennaForMice(j,1)=str2num(MouseArray{countFrames,2,j}); 
       DeltaTimeRFID(j,1)=MouseArray{countFrames,4,j};
  end
  
  %% Add 1e6 when there are more mice than antenna. This means that a mouse dissapears in general under the food container or around the arena
 % if size(AntennaForMice,1)<length(miceList)
  %   AntennaForMice(setdiff(1:size(AntennaForMice,1),1:length(miceList)),1)=1e6; 
      
  %end
  
  %% 

Indexes=find(Position(:,1)==countFrames+1);


 [IsSleeping,FidelityMatrix,FidelityAntenna,FidelityForNonCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP]=AddIdentityToCoord(IsSleeping,TimeExp,FidelityMatrix,FidelityAntenna,FidelityForNonCoord,countFrames,DeltaTimeRFID,TotalFrames,Position(Indexes,:),AntennaForMice,length(miceList),CoordinatesFinalMice,CoordinatesFinalMiceMM);   %discard first frame without time 
 
 
%  %Repeat the process backward
%  TimeExpB=ReverseMatrix(TimeExp);
%  for j=1:length(miceList)
%        AntennaForMiceB(j,1)=str2num(MouseArray{TotalFrames-countFrames+2,2,j}); 
%        DeltaTimeRFIDB(j,1)=MouseArray{TotalFrames-countFrames+2,4,j};
%   end
%  
%  
%  IndexesB=find(Position(:,1)==TotalFrames-countFrames+2);
%  
%  [IsSleepingB,FidelityMatrixB,FidelityAntennaB,FidelityForNonCoordB,CoordinatesxB,CoordinatesyB,CoordinatesxPB,CoordinatesyPB]=AddIdentityToCoord(IsSleepingB,TimeExpB,FidelityMatrixB,FidelityAntennaB,FidelityForNonCoordB,countFrames,DeltaTimeRFIDB,TotalFrames,Position(IndexesB,:),AntennaForMiceB,length(miceList),CoordinatesFinalMiceB,CoordinatesFinalMiceMMB);   %discard first frame without time 
%  
 
 %% 
  
 AuxCoordinates(1:2:2*length(CoordinatesxP)-1)=CoordinatesxP';
 AuxCoordinates(2:2:2*length(CoordinatesxP))=CoordinatesyP';
 
  CoordinatesFinalMice=[CoordinatesFinalMice; AuxCoordinates]; 
  
  
   AuxCoordinatesMM(1:2:2*length(Coordinatesx)-1)=Coordinatesx';
   AuxCoordinatesMM(2:2:2*length(Coordinatesx))=Coordinatesy';
 
   CoordinatesFinalMiceMM=[CoordinatesFinalMiceMM; AuxCoordinatesMM]; 
   %% For the backward case
   
%     AuxCoordinatesB(1:2:2*length(CoordinatesxPB)-1)=CoordinatesxPB';
%     AuxCoordinatesB(2:2:2*length(CoordinatesxPB))=CoordinatesyPB';
%  
%   CoordinatesFinalMiceB=[CoordinatesFinalMiceB; AuxCoordinatesB]; 
%   
%   
%    AuxCoordinatesMMB(1:2:2*length(CoordinatesxB)-1)=CoordinatesxB';
%    AuxCoordinatesMMB(2:2:2*length(CoordinatesxB))=CoordinatesyB';
%  
%    CoordinatesFinalMiceMMB=[CoordinatesFinalMiceMMB; AuxCoordinatesMMB]; 
%    
%    
  
   %% 
  
%   %% Show the frame with the marked mice
%   Frame=read(v1,countFrames+1);
%   C={'red','blue','green','yellow','magenta'};
%   
%   for m=1:length(miceList)
%      position=[CoordinatesxP(m,1),CoordinatesyP(m,1),4];   
%      Frame=insertShape(Frame,'FilledCircle',position,'LineWidth', 2,'Color',C{m});  
%       
%   end
%   imshow(Frame)
  

  
  
    
end

%% Reverse the backward coordinates in order to compare forward with backward
% CoordinatesFinalMiceMMBF = ReverseMatrix(CoordinatesFinalMiceMMB);
% CoordinatesFinalMiceBF=ReverseMatrix(CoordinatesFinalMiceB);
% 


%% ----------------------Add the mouse identity we couldn't see before
% [CoordinatesFinalMiceMM,CoordinatesFinalMice,FidelityMatrix,FidelityAntenna]=DoCorrections(CoordinatesFinalMiceMM,CoordinatesFinalMice,FidelityMatrix,FidelityAntenna); 
%% ----------------------------------Correct the coordinates---------------------------
  %% Compare forward and reverse coordinates and create a new matrix with one in the places with differences
  
  
%Difference_FR=CompareForwardReverse(CoordinatesFinalMice,CoordinatesFinalMiceBF);

%[CoordinatesFinalMice, CoordinatesFinalMiceMM]= Final_Correction_Coordinates(CoordinatesFinalMice, CoordinatesFinalMiceMM,CoordinatesFinalMiceBF,CoordinatesFinalMiceMMBF,FidelityMatrix,Difference_FR,FidelityMatrixB);


        
        
        
        
%  %% Show the frames
%  t=1;
%  for countFrames=1:TotalFrames
%      countFrames
%    Frame=read(v1,countFrames+1);
%   C={'red','blue','green','yellow','magenta'};   
%      
%     for m=1:length(miceList)
%    
%         position=[CoordinatesFinalMice(countFrames,2*m-1),CoordinatesFinalMice(countFrames,2*m),4];   
%         Frame=insertShape(Frame,'FilledCircle',position,'LineWidth', 2,'Color',C{m}); 
%         
%         if IsSleeping(countFrames,m)==1
%             position1=[CoordinatesFinalMice(countFrames,2*m-1),CoordinatesFinalMice(countFrames,2*m)];   
%              Frame=insertMarker(Frame,position1,'+','size', 6,'Color',C{m}); %add a marker when it is sleeping
%             
%         end
%         
%       
%   end
%  % imshow(Frame)   
%  
%  
%      
%  %Create movie
% 
%  mov(t)=im2frame(Frame);
% 
% t=t+1;
% 
%      
% 
%  
%  
%  end
%  
%  
%    w=cd;  %current directory
% v1 = VideoWriter('temp.avi');
% v1.FrameRate=12.8;
% open(v1)
% writeVideo(v1,mov)
% % 
% close(v1)  
 

 
 
 
 %% Do the same for the backward
 
 
  %% Show the frames
%  t=1;
%  for countFrames=1:TotalFrames
%      countFrames
%    Frame=read(v2,countFrames+1);
%   C={'red','blue','green','yellow','magenta'};   
%      
%     for m=1:length(miceList)
%    
%         position=[CoordinatesFinalMiceBF(countFrames,2*m-1),CoordinatesFinalMiceBF(countFrames,2*m),4];   
%         Frame=insertShape(Frame,'FilledCircle',position,'LineWidth', 2,'Color',C{m}); 
%         
%         if IsSleeping(countFrames,m)==1
%             position1=[CoordinatesFinalMiceBF(countFrames,2*m-1),CoordinatesFinalMiceBF(countFrames,2*m)];   
%              Frame=insertMarker(Frame,position1,'+','size', 6,'Color',C{m}); %add a marker when it is sleeping
%             
%         end
%         
%       
%   end
%  % imshow(Frame)   
%  
%  
%      
%  %Create movie
% 
%  mov(t)=im2frame(Frame);
% 
% t=t+1;
% 
%      
% 
%  
%  
%  end
%  
%  
%    w=cd;  %current directory
% v2 = VideoWriter('tempb.avi');
% v2.FrameRate=12.8;
% open(v2)
% writeVideo(v2,mov)
% % 
% close(v2)  
%  




%% 

%  xlswrite('fidelity.xlsx',FidelityMatrix)
%   xlswrite('Coord.xlsx',CoordinatesFinalMice)
%  xlswrite('fidelitya.xlsx',FidelityAntenna)
% %  xlswrite('fidelityB.xlsx',FidelityMatrixB)
% %   xlswrite('CoordB.xlsx',CoordinatesFinalMiceBF)
% %  xlswrite('fidelityaB.xlsx',FidelityAntennaB)
%  xlswrite('fidelityCoord.xlsx',FidelityForNonCoord)
%  %xlswrite('fidelityCoordB.xlsx',FidelityForNonCoordB)
 

 %xlswrite('Difference_FR.xlsx',Difference_FR)
 %% 
end