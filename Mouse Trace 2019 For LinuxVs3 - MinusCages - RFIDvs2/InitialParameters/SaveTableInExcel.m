function SaveTableInExcel(~,~)
%variables
global h
Initial_Parameters=Parameters();

%% 
table=get(h.table,'data');


Ichar=strfind(char(Initial_Parameters.DataDirectory),'\');
Root_directory=char(Initial_Parameters.DataDirectory);

% mkdir([Root_directory(1:Ichar(2)),Initial_Parameters.ExperimentName,'\']);


%% load Arenas coordinates
S=load(strcat(Root_directory(1:Ichar(length(Ichar))),Initial_Parameters.ExperimentName,'\Parameters\','MovingParametersInArena.mat'))
HidingCoordinatesCentral=S.HidingCoordinatesCentral;
Corn=S.Corners_PixelCoordinates;
FoodCoordinates=S.Food_PixelCoordinates;
WaterCoordinates=S.Drink_PixelCoordinates;
% CoordSleepingCells=S.CoordSleepingCells;
BridgesCoordinatesNarrow=S.NarrowBridge_PixelCoordinates;
BridgesCoordinatesLarger=S.LargeBridge_PixelCoordinates;
OutZone_PixelCoordinates=(S.OutZone_PixelCoordinates)';%gives coorner width and height
First_HidingCoordinates=S.First_HidingCoordinates;
Second_HidingCoordinates=S.Second_HidingCoordinates;
Third_HidingCoordinates=S.Third_HidingCoordinates;
Four_HidingCoordinates=S.Four_HidingCoordinates;






%% 

%create table
raw(1,2:7)={'Chip1','Chip2','Chip3','Sex','Genotype','Idah'};
raw(2:8,1)={'Mouse1','Mouse2','Mouse3','Mouse4','Mouse5','Mouse6','Mouse7'}; %CONSIDER 7 MOUSES
raw(2:end,2:end)=strcat('''',table,'''');

%% Create a table with the coordinates
raw1(1,1)={'Hiding Central Coordinates x'};
raw1(1,2)={'Hiding Central Coordinates y'};
raw1(1,3)={'Corners x'};
raw1(1,4)={'Corners y'};
raw1(1,5)={'Food coordinates x'};
raw1(1,6)={'Food coordinates y'};
raw1(1,7)={'Water coordinates x'};
raw1(1,8)={'Water coordinates y'};
raw1(1,9)={'Sleeping cells x'};
raw1(1,10)={'Sleeping cells y'};
raw1(1,11)={'Narrow bridge x'};
raw1(1,12)={'Narrow bridge y'};
raw1(1,13)={'Large bridge x'};
raw1(1,14)={'Large bridge y'};
raw1(1,15)={'Zone Coord. x y w h'};
raw1(1,16)={'First hiding Coord. x'};
raw1(1,17)={'First hiding Coord. y'};

raw1(1,18)={'Second hiding Coord. x'};
raw1(1,19)={'Second hiding Coord. y'};

raw1(1,20)={'Third hiding Coord. x'};
raw1(1,21)={'Third hiding Coord. y'};

raw1(1,22)={'Four hiding Coord. x'};
raw1(1,23)={'Four hiding Coord. y'};




raw1(2:length(HidingCoordinatesCentral(:,1))+1,1:2)=num2cell(HidingCoordinatesCentral);
raw1(2:length(Corn(:,1))+1,3:4)=num2cell(Corn);
raw1(2:length(FoodCoordinates(:,1))+1,5:6)=num2cell(FoodCoordinates);
raw1(2:length(WaterCoordinates(:,1))+1,7:8)=num2cell(WaterCoordinates);
%raw1(2:length(CoordSleepingCells(:,1))+1,9:10)=num2cell(CoordSleepingCells);
raw1(2:length(BridgesCoordinatesNarrow(:,1))+1,11:12)=num2cell(BridgesCoordinatesNarrow);
raw1(2:length(BridgesCoordinatesLarger(:,1))+1,13:14)=num2cell(BridgesCoordinatesLarger);

raw1(2:length(OutZone_PixelCoordinates(:,1))+1,15)=num2cell(OutZone_PixelCoordinates);

raw1(2:length(First_HidingCoordinates(:,1))+1,16:17)=num2cell(First_HidingCoordinates);
raw1(2:length(Second_HidingCoordinates(:,1))+1,18:19)=num2cell(Second_HidingCoordinates);
raw1(2:length(Third_HidingCoordinates(:,1))+1,20:21)=num2cell(Third_HidingCoordinates);
raw1(2:length(Four_HidingCoordinates(:,1))+1,22:23)=num2cell(Four_HidingCoordinates);




%raw1(2:length(MarkCoordinates(:,1))+1,15:16)=num2cell(MarkCoordinates);


%% save in a sheet with experiment name and date in the udisk

% formatOut = 'mm-dd-yy';
% date=datestr(now,formatOut)
%sheet=strcat(ExpName,date)
% sheet=strcat( Initial_Parameters.ExperimentName,'_',date)
sheet=strcat(Initial_Parameters.ExperimentName);
xlswrite(strcat(Root_directory(1:Ichar(length(Ichar))),Initial_Parameters.ExperimentName,'\Parameters\','MiceID.xlsx'),raw,sheet);

% sheet=strcat(Initial_Parameters.ExperimentName,'_Arena Coord.','_',date)
sheet=strcat(Initial_Parameters.ExperimentName,'_Arena Coord.');
xlswrite(strcat(Root_directory(1:Ichar(length(Ichar))),Initial_Parameters.ExperimentName,'\Parameters\','MiceID.xlsx'),raw1,sheet);

% save raw data 
fileaux=strcat(Root_directory(1:Ichar(length(Ichar))),Initial_Parameters.ExperimentName,'\Parameters\','MiceID.mat');
save('fileaux','raw');





end

