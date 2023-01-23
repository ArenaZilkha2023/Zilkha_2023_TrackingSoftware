%Insert to the rfid
function [AntennaForMiceT,CoordinatesFinalMiceMM,CoordinatesFinalMice,FidelityMatrix,FidelityVelocity,FidelityForNonCoord,IsSleeping,TotalVelocity]= ManagerRFIDCoupling(Corn,TimeExp,Position,miceList,miceListRibs,miceListRibsSide,DataDirectory,Date)

global h

%% Variable
NoDetectionTime=80; %There are not detection for the antennas to larger times the units are in ms-it was 80
ThresholdRFIDDistance=57; %mm  units diameter antenna
PositionToChange=Position;
ThresholdVelocity=200;
Arena_length=1139;
%% Select  the RFID files 



%% ----------------------------------Read Parameters of RFID files----------------


RFIDobj=FilesTreat;%use class FilesTreat
RFIDobj.directory=DataDirectory;
RFIDobj.extension='.txt';
N=RFIDobj.NumFiles(RFIDobj.ListFiles);
DateFiles=RFIDobj.DateFiles(RFIDobj.ListFiles,N);

%% ---------------------------Define object Time---------------------------------
Timeobj=TimeLine;
%% ---------------According to date select RFID
 DateToBeConsidered=datenum(Date,'dd/mm/yyyy');
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

%if there are 3 chips then

  if ~isempty(miceListRibsSide)
    
      Iaux=[find(strcmp(miceList(j),AuxID)==1); find(strcmp(miceListRibs(j),AuxID)==1); find(strcmp(miceListRibsSide(j),AuxID)==1)];
      
  end


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

TotalVelocity=[];

%% Create new variables for marking the cases which are wrong
FidelityMatrix=zeros(20000,length(miceList)); %the columns are the mouse and the rows are the frames-if the value is 1 the coord have to be reviewed later
FidelityVelocity=zeros(20000,length(miceList));
FidelityForNonCoord=zeros(20000,length(miceList)); %the last values is for coord position either in mm or pixel

FidelityForNonCoord_x=zeros(20000,100);
FidelityForNonCoord_y=zeros(20000,100);
FidelityForNonCoord_xP=zeros(20000,100);
FidelityForNonCoord_yP=zeros(20000,100);


IsSleeping=zeros(20000,length(miceList)); %Change in the future the 20000 value

%% Define matrix to backward process
FidelityMatrixB=zeros(20000,length(miceList)); %the columns are the mouse and the rows are the frames-if the value is 1 the coord have to be reviewed later
FidelityAntennaB=zeros(20000,length(miceList));
FidelityForNonCoordB=zeros(20000,length(miceList));
IsSleepingB=zeros(20000,length(miceList)); %Change in the future the 20000 value


%% 


% for  countFrames=1:size(MouseArray,1)-1 %Loop over the frames
TotalFrames=size(MouseArray,1);

%% For internal checking
%

TotalFrames=5000;
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
    
    set(  h.WaitBarRFID,'Position',[0.00001 0.00900 (countFrames/TotalFrames) 0.8]);
    h.WaitBarRFID.Color='b';
   pause(0.01) 
   
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


 [FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP,IsSleeping,FidelityMatrix,FidelityVelocity,FidelityForNonCoord,Coordinatesx,Coordinatesy,CoordinatesxP,CoordinatesyP,velocityMAll]=AddIdentityToCoord(Corn,IsSleeping,TimeExp,FidelityMatrix,FidelityVelocity,FidelityForNonCoord,countFrames,DeltaTimeRFID,TotalFrames,Position(Indexes,:),AntennaForMice,length(miceList),CoordinatesFinalMice,CoordinatesFinalMiceMM,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP);   %discard first frame without time 
 
 
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
   
   
   TotalVelocity=[TotalVelocity;velocityMAll'];
   
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

%% Correction of non-defined coordinates





[CoordinatesFinalMice CoordinatesFinalMiceMM]=Correction_NonDefinedCoord(countFrames,TimeExp,CoordinatesFinalMice,CoordinatesFinalMiceMM,FidelityForNonCoord,FidelityForNonCoord_x, FidelityForNonCoord_y,FidelityForNonCoord_xP,FidelityForNonCoord_yP,ThresholdVelocity);










%% 








%% Reverse the backward coordinates in order to compare forward with backward
% CoordinatesFinalMiceMMBF = ReverseMatrix(CoordinatesFinalMiceMMB);
% CoordinatesFinalMiceBF=ReverseMatrix(CoordinatesFinalMiceB);
% 


%% ----------------------Add the mouse identity we couldn't see before
% [CoordinatesFinalMiceMM,CoordinatesFinalMice,FidelityMatrix,FidelityVelocity]=DoCorrections(CoordinatesFinalMiceMM,CoordinatesFinalMice,FidelityMatrix,FidelityVelocity); 
%% ----------------------------------Correct the coordinates---------------------------
  %% Compare forward and reverse coordinates and create a new matrix with one in the places with differences
  
  
%Difference_FR=CompareForwardReverse(CoordinatesFinalMice,CoordinatesFinalMiceBF);

%[CoordinatesFinalMice, CoordinatesFinalMiceMM]= Final_Correction_Coordinates(CoordinatesFinalMice, CoordinatesFinalMiceMM,CoordinatesFinalMiceBF,CoordinatesFinalMiceMMBF,FidelityMatrix,Difference_FR,FidelityMatrixB);


        
        
        
%         
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
%  xlswrite('fidelitya.xlsx',FidelityVelocity)
% %  xlswrite('fidelityB.xlsx',FidelityMatrixB)
% %   xlswrite('CoordB.xlsx',CoordinatesFinalMiceBF)
% %  xlswrite('fidelityaB.xlsx',FidelityAntennaB)
%  xlswrite('fidelityCoord.xlsx',FidelityForNonCoord)
 %xlswrite('fidelityCoordB.xlsx',FidelityForNonCoordB)
 

 %xlswrite('Difference_FR.xlsx',Difference_FR)
 %% 
 end