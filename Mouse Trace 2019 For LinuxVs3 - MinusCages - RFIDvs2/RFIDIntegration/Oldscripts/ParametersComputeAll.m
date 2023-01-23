
function Params=ParametersComputeAll()

%%----------------Variables------------------
global h

%% ------------------Uicontrol parameters--------------
Params.exp_name=get(h.editAllRFID2,'string') %load experiment;
DIR=get( h.editAllRFID1,'string'); %get the directory of all the experimental data


Params.DataDir=fullfile(DIR, '\', [Params.exp_name 'Video']);%where is the csv data
Params.DataRFID=fullfile(DIR, '\', [Params.exp_name 'RFID']);%where is the RFID data
Params.DataMissingPosition=fullfile(DIR, '\', [Params.exp_name 'MissingPosition']);%where is the Missing position

Params.resultsDir=fullfile(DIR, '\',[Params.exp_name 'ResultsMatlab']);%where are the results
Params.ForSomeFile=get( h.Checkbox2,'Value'); %if there is taking separated files
Params.ForMissingPosition=get( h.Checkbox3,'Value'); %if we consider the csv file which contains information of missing positions(In Erans program)

contents = get(h.popupAll,'String'); %to get if the user wants information of either males or females
Params.ChoiceList= contents{get(h.popupAll,'Value')};
Params.SaveDirectory=get(h.edit3x,'string');

%% -------------------------Mice identity--------------------

% numbers of mice to be displayed:
Params.mices = 'all';

% Mice identity that it is on excel file
%the sheet is from the gui
contents = get(h.popupmenuRFID1,'String'); 
popupmenu1value = contents{get(h.popupmenuRFID1,'Value')};
sheet= popupmenu1value;

[miceType,malesList,femalesList, mice_3_chips,malesListRibs,femalesListRibs,malesListRibsSecond,femalesListRibsSecond] = getMiceIDsComputeAll(DIR,sheet);

Params.miceType = miceType;
Params.malesList = malesList;
Params.femalesList = femalesList;
Params.mice_3_chips = mice_3_chips;
Params.malesListRibs=malesListRibs
Params.femalesListRibs=femalesListRibs;
Params.malesListRibsSecond=malesListRibsSecond;
Params.femalesListRibsSecond=femalesListRibsSecond;
%% --------------------------------------Getting the cooordinates of the arena-------------------------------------
%
Params.ArenaLength=1140; 
 max_width=Params.ArenaLength;  
% if Params.exp_name(end)=='L'
%   max_width=Params.ArenaLength;  
%   Params.ArenaLength=1140; 
% 
% HidingCoordinates=[184.1501458	486.2376093;... % 24 points(xy)-6 boxes: 4 shelters without 2 bridges
% 213.5379009	434.1793003;...                        % (in pixels)
% 245.4446064	460.2084548;...
% 216.0568513	507.228863;...
% % 172.3950437	339.2988338;...
% % 169.8760933	232.6632653;...
% % 258.0393586	232.6632653;...
% % 257.1997085	341.8177843;...
% 202.622449	135.2638484;...
% 185.8294461	82.36588921;...
% 220.255102	67.25218659;...
% 237.8877551	120.1501458;...
% 461.2346939	108.3950437;...
% 494.8206997	56.33673469;...
% 527.5670554	81.52623907;...
% 493.1413994	134.4241983;...
% % 478.8673469	348.5349854;...
% % 478.0276968	212.5116618;...
% % 507.4154519	212.5116618;...
% % 512.4533528	349.3746356;...
% 495.6603499	507.228863;...
% 462.9139942	450.9723032;...
% 493.9810496	429.9810496;...
% 528.4067055	479.5204082];
% 
% %HidingCoordinatesCentral=[212 482;501 485;503 92; 211 99];
% HidingCoordinatesCentral=[211 99;503 92;501 485;212 482];
% HidingCoordinates1=[211 438; 254 466;208 534 ;168 508];    
% HidingCoordinates2=[459 469; 506 437;548 500;499 535];
% HidingCoordinates3=[502 50; 551 84;499 146;461 114];
% HidingCoordinates4=[172 78; 222 52;250 124;203 149];
% 
% XYCorners=[123.6953353	30.30758017;...,
% 591.3804665	25.2696793;...,
% 591.3804665	536.6166181;...,
% 126.2142857	539.9752187];
% 
% FoodCoordinates=[319.3338192 242.7390671;...
% 317.654519 211.6720117;...
% 394.0626822 215.8702624;...
% 394.0626822 246.0976676];
% 
% WaterCoordinates=[352.9198251 305.712828];
% 
% CoordSleepingCells=[222	31;...,
% 495	29;...,
% 594	151;...,
% 594	418;...,
% 480	532;...,
% 234	540;...,
% 126	418;...,
% 127	141];%Left
% 
% BridgesCoordinatesNarrow=[210 211;241 211;210 355;241 355];
% BridgesCoordinatesLarger=[464 239;558 239;464 351;558 351];
% BridgesCoordinates=[BridgesCoordinatesNarrow BridgesCoordinatesLarger];
% 
% 
% 
% 
% % pixels--> cm. rescaling based on max_wd (cm) and XYCorners (pix-ref) data
% HidingCoordinates=rescaleCoordinatesGV(HidingCoordinates,XYCorners,max_width); 
% FoodCoordinates=rescaleCoordinatesGV(FoodCoordinates,XYCorners,max_width);
% WaterCoordinates=rescaleCoordinatesGV(WaterCoordinates,XYCorners,max_width);
% CoordSleepingCells=rescaleCoordinatesGV(CoordSleepingCells,XYCorners,max_width);
% HidingCoordinatesCentral=rescaleCoordinatesGV(HidingCoordinatesCentral,XYCorners,max_width);
% 
% 
% 
% Params.Coordinates.HidingCoordinates=HidingCoordinates;
% Params.Coordinates.FoodCoordinates=FoodCoordinates;
% Params.Coordinates.WaterCoordinates=WaterCoordinates;
% Params.Coordinates.CoordSleepingCells=CoordSleepingCells;
% Params.Coordinates.XYCorners=XYCorners;
% Params.HidingCoordinatesCentral=HidingCoordinatesCentral;
% else
%       
%   Params.ArenaLength=1140;
%    max_width=Params.ArenaLength;
%  HidingCoordinates=[165.6778426 443.4154519;...
% 187.5087464 463.5670554;...
% 158.9606414	501.351312;...
% 137.9693878	483.7186589;...
% % 120.3367347	249.4562682;...
% % 190.0276968	246.0976676;...
% % 193.3862974	340.138484;...
% % 124.5349854	342.6574344;...
% 132.0918367	91.60204082;...
% 157.2813411	73.96938776;...
% 180.7915452	115.951895;...
% 160.6399417	134.4241983;...
% 453.6778426	79.00728863;...
% 468.7915452	99.99854227;...
% 441.9227405	129.3862974;...
% 425.1297376	110.074344;...
% % 436.0451895	225.9460641;...
% % 455.3571429	226.7857143;...
% % 454.5174927	350.2142857;...
% % 431.8469388	350.2142857;...
% 428.4883382	465.2463557;...
% 451.1588921	449.2930029;...
% 472.1501458	482.0393586;...
% 449.4795918	499.6720117];
% 
% 
% HidingCoordinatesCentral=[205 102;495 105;497 476;203 476];
% % HidingCoordinates1=[211 438; 254 466;208 534 ;168 508]; Arrange   
% % HidingCoordinates2=[459 469; 506 437;548 500;499 535];
% % HidingCoordinates3=[502 50; 551 84;499 146;461 114];
% % HidingCoordinates4=[172 78; 222 52;250 124;203 149];
% 
% XYCorners=[114 34;593 27;594 555;120 545];
% 
% FoodCoordinates=[305 235;386 233;384 261;306 263];
% 
% WaterCoordinates=[341 312];
% 
% CoordSleepingCells=[218 28;483 23;600 147;596 444;477 561;219 555;114 436; 110 153];%Right
% 
%  BridgesCoordinatesNarrow=[212 218;241 218;242 360;214 358];
%  BridgesCoordinatesLarger=[454 239;546 240;545 357;448 355];
%  BridgesCoordinates=[BridgesCoordinatesNarrow BridgesCoordinatesLarger];
% 
% % pixels--> cm. rescaling based on max_wd (cm) and XYCorners (pix-ref) data
% HidingCoordinates=rescaleCoordinatesGV(HidingCoordinates,XYCorners,max_width); 
% FoodCoordinates=rescaleCoordinatesGV(FoodCoordinates,XYCorners,max_width);
% WaterCoordinates=rescaleCoordinatesGV(WaterCoordinates,XYCorners,max_width);
% CoordSleepingCells=rescaleCoordinatesGV(CoordSleepingCells,XYCorners,max_width);
% HidingCoordinatesCentral=rescaleCoordinatesGV(HidingCoordinatesCentral,XYCorners,max_width);
% 
%  
% Params.Coordinates.HidingCoordinates=HidingCoordinates;
% Params.Coordinates.FoodCoordinates=FoodCoordinates;
% Params.Coordinates.WaterCoordinates=WaterCoordinates;
% Params.Coordinates.CoordSleepingCells=CoordSleepingCells;
% Params.Coordinates.XYCorners=XYCorners;
% Params.HidingCoordinatesCentral=HidingCoordinatesCentral; 
% end

%----------Load mat file-----------------------

FolderParams=strcat(DIR, '\','Parameters','\');

S=load(strcat(FolderParams,Params.exp_name,'ArenaCoord.mat'));
HidingCoordinatesCentral=S.HidingCoordinatesCentral;
XYCorners=S.Corn
FoodCoordinates=S.FoodCoordinates;
WaterCoordinates=S.WaterCoordinates;
CoordSleepingCells=S.CoordSleepingCells;
BridgesCoordinatesNarrow=S.BridgesCoordinatesNarrow;
BridgesCoordinatesLarger=S.BridgesCoordinatesLarger;
HidingCoordinates=S.HidingCoordinates;
HidingCoordinates=S.HidingCoordinates;
ZoneCoord=S.MarkCoordPixel;

% % pixels--> mm rescaling based on max_wd (cm) and XYCorners (pix-ref) data
 HidingCoordinates=rescaleCoordinatesGV(HidingCoordinates,XYCorners,max_width); 
 FoodCoordinates=rescaleCoordinatesGV(FoodCoordinates,XYCorners,max_width);
 WaterCoordinates=rescaleCoordinatesGV(WaterCoordinates,XYCorners,max_width);
 CoordSleepingCells=rescaleCoordinatesGV(CoordSleepingCells,XYCorners,max_width);
 HidingCoordinatesCentral=rescaleCoordinatesGV(HidingCoordinatesCentral,XYCorners,max_width);
 ZoneCoord=rescaleCoordinatesGV(ZoneCoord,XYCorners,max_width);
 
% 
%  
 Params.Coordinates.HidingCoordinates=HidingCoordinates;
 Params.Coordinates.FoodCoordinates=FoodCoordinates;
Params.Coordinates.WaterCoordinates=WaterCoordinates;
 Params.Coordinates.CoordSleepingCells=CoordSleepingCells;
 Params.Coordinates.XYCorners=XYCorners;
Params.HidingCoordinatesCentral=HidingCoordinatesCentral; 
Params.ZoneCoord=ZoneCoord; 

 clear HidingCoordinates FoodCoordinates WaterCoordinates CoordSleepingCells XYCorners
%% 
 %%-------- Information of the antenna----------------
 Params.AntennaCage=[2,5,7,35,47,45,43,8];%order according to the cages order-Order according to clock way
 Params.SideBoxAntenna=[49,50,51,52,53,54,55,56];%this is detected if the mouse is jumping- Order according to clock way
 Params.AntennaHidingBox=[9,13,41,37];
 %% %  %% ----------------Insert antenna cooordinates in mm--
  AntennaCoord=zeros(56,2);
%  
  AntennaCoord(1,:)=[70.6 69.9];
  AntennaCoord(3,:)=[403.2 69.9];
  AntennaCoord(4,:)=[735.8 69.9];
  AntennaCoord(6,:)=[1068.4 69.9];
 
  AntennaCoord(15,:)=[70.6 269.7];
  AntennaCoord(10,:)=[403.2 269.7];
  AntennaCoord(12,:)=[735.8 269.7];
  AntennaCoord(14,:)=[1068.4 269.7];
  
  AntennaCoord(9,:)=[236.9 169.8];
  AntennaCoord(11,:)=[569.5 169.8];
  AntennaCoord(13,:)=[902.1 169.8];
  
  AntennaCoord(48,:)=[236.9 369.6];
  AntennaCoord(18,:)=[569.5 369.6];
  AntennaCoord(20,:)=[902.1 369.6];
  
  AntennaCoord(22,:)=[70.6 469.5];
  AntennaCoord(17,:)=[403.2 469.5];
  AntennaCoord(19,:)=[735.8 469.5];
  AntennaCoord(21,:)=[1068.4 469.5];
  
  AntennaCoord(24,:)=[236.9 569.4];
  AntennaCoord(26,:)=[569.5 569.4];
  AntennaCoord(28,:)=[902.1 569.4];
  
  AntennaCoord(23,:)=[70.6 669.3];
  AntennaCoord(25,:)=[403.2 669.3];
  AntennaCoord(27,:)=[735.8 669.3];
  AntennaCoord(33,:)=[1068.4 669.3];
  
  AntennaCoord(29,:)=[236.9 769.2];
  AntennaCoord(30,:)=[569.5 769.2];
  AntennaCoord(32,:)=[902.1 769.2];
  
  AntennaCoord(36,:)=[70.6 869.1];
  AntennaCoord(38,:)=[403.2 869.1];
  AntennaCoord(31,:)=[735.8 869.1];
  AntennaCoord(34,:)=[1068.4 869.1];
  
  AntennaCoord(37,:)=[236.9 969];
  AntennaCoord(39,:)=[569.5 969];
  AntennaCoord(41,:)=[902.1 969];
  
  AntennaCoord(44,:)=[70.6 1068.9];
  AntennaCoord(46,:)=[403.2 1068.9];
  AntennaCoord(40,:)=[735.8 1068.9];
  AntennaCoord(42,:)=[1068.4 1068.9];
  
  
  if Params.exp_name(end)=='L'
      CoordSleepingCells1=Params.Coordinates.CoordSleepingCells;
    AntennaCoord(2,:)=[CoordSleepingCells1(1,1) CoordSleepingCells1(1,2)];  
    AntennaCoord(5,:)=[CoordSleepingCells1(2,1) CoordSleepingCells1(2,2)];   
    AntennaCoord(7,:)=[CoordSleepingCells1(3,1) CoordSleepingCells1(3,2)];    
    AntennaCoord(35,:)=[CoordSleepingCells1(4,1) CoordSleepingCells1(4,2)]; 
    AntennaCoord(47,:)=[CoordSleepingCells1(5,1) CoordSleepingCells1(5,2)];    
    AntennaCoord(45,:)=[CoordSleepingCells1(6,1) CoordSleepingCells1(6,2)];
    AntennaCoord(43,:)=[CoordSleepingCells1(7,1) CoordSleepingCells1(7,2)]; 
    AntennaCoord(8,:)=[CoordSleepingCells1(8,1) CoordSleepingCells1(8,2)];  
  end    
  
  
 Params. AntennaCoord= AntennaCoord;
 
 
 %% Parameters related with chasing
 
 Params.AngleMaximum1=str2num(get(h.editChasingAng1,'string'));
 Params.AngleMaximum2=str2num(get(h.editChasingAng2,'string'));
 Params.editpar1=str2num(get(h.editpar1,'string'));
 Params.editpar2=str2num(get(h.editpar2,'string'));
 Params.editpar3=str2num(get(h.editpar3,'string'));
 Params.editpar4=str2num(get(h.editpar4,'string'));
 Params.editpar5=str2num(get(h.editpar5,'string'));
 Params.editpar6=str2num(get(h.editpar6,'string'));
 Params.editpar7=str2num(get(h.editpar7,'string'));
 %% Parameters for distinguish mouse activity (either stop,walk or run)
 Params.TreshRun=40; %40cm/sec
 Params.TreshWalk=0.5; %walking minimum 0.5cm/sec
 
 %% ------------Parameters related with eating/drinking
Params.VelocityThreshFood=5;  %velocity when is either eating or drinking in cm/sec
Params.radiusD=40; %radius around drinking  in mm
 %% 
 %% 
 Params.DistanceToBeTogheter=100; %distance to be considered together in mm
 
 %% Parameters related with avoidance
%  Params.Distance_thresh_For_Avoidance=400; %in mm 
%  Params.Dist_thresh_Fine_Tuning_For_Avoidance=100; %in mm
%  Params.Velocity_For_Avoidance=35; %in cm/sec
%  Params.Radius_Within_Avoidance=300; %in mm

 Params.Distance_thresh_For_Avoidance=str2num(get(h.Avoidance1,'string')); %in mm 
 Params.Dist_thresh_Fine_Tuning_For_Avoidance=str2num(get(h.Avoidance4,'string')); %in mm
 Params.Velocity_For_Avoidance=str2num(get(h.Avoidance2,'string')); %in cm/sec
 Params.Radius_Within_Avoidance=str2num(get(h.Avoidance3,'string')); %in mm





 %% ----Parameters related with approaching-----------------
%  Params.Distance_thresh_For_Approaching=400; %According to GV this is 40cm
%  Params.Distance_Thresh_For_Approaching_Fine_Tuning=100;%According to GV this is 10cm
%  Params.CorrFactor_between_mice_For_Approaching=0.3; %According to GV this is 0.3
%  Params.Velocity_Thresh_To_beSamePlace_For_Approaching=25; %According to GV this is 25cm/sec

 
 
  Params.Distance_thresh_For_Approaching=str2num(get(h.Approaching1,'string')); %According to GV this is 40cm
  Params.Distance_Thresh_For_Approaching_Fine_Tuning=str2num(get(h.Approaching4,'string'));%According to GV this is 10cm
  Params.CorrFactor_between_mice_For_Approaching=str2num(get(h.Approaching2,'string')); %According to GV this is 0.3
  Params.Velocity_Thresh_To_beSamePlace_For_Approaching=str2num(get(h.Approaching3,'string')); %According to GV this is 25cm/sec
 
 
 
 %% 
 
%  %% Params.FPS=30; % hardcoding - not so good (must be external parameter)
%  Params.FPS=30; %it is 30ms per frame 30 frames per second
%  %% Parameter for cleaning original data
%  Params.NoDetection=1e6; %x y data larger than 1e6 is not considered. It is considered as NAN
%  Params.XYLimit=2e3;
%  Params.MaximumArena=1146.2; %in mm maximum can go
%  Params.MinimumArena=-9.4; %minimum can go
%  %% 
%  %Parameters for detection of sleeping
%  Params.ThresholdDistance=1.5e4;
%  Params.DistSleep=10; %distance between coordinates sleeping and..........It is in the case the first value is not detected.
%  %%
%  %Kalman filter to trajectories
%  % Kalman filter initialization
% Params.KalmanR=[[0.2845,0.0045]',[0.0045,0.0455]'];
% Params.KalmanH=[[1,0]',[0,1]',[0,0]',[0,0]'];
% Params.KalmanQ=0.01*eye(4);
% Params.KalmanP = 100*eye(4);
% Params.Kalmandt=1;
% dt=1;
% Params.KalmanA=[[1,0,0,0]',[0,1,0,0]',[dt,0,1,0]',[0,dt,0,1]'];
% Params.Kalmang = .6; % pixels^2/time step
% g=0.6;
% Params.KalmanBu = [0,0,0,g]';
% Params.Kalmankfinit=0;
% %%
% Params.VelocityThreshFood=1 %velocity is less this when eating.
%  Params.DistTreshDrinking=1; %distance is less this when drinking.
%  Params.running=30; 
%  Params.CenterCoords=[15 15;114-15 15;114-15 114-15;15 114-15];
 %% Parameters for running for walking etc.. found in ethograms script
%  Params.TreshRun=40;
% Params.TreshWalk=.5;
%% Parameters for elorating
% Params.k=100;
% Params.initial_rating=1000;
 
 %save('Parameters','Params')
end
%% 
%%-------------------------- Auxiliary functions---------------------------
function XY=rescaleCoordinatesGV(XY,Corners,max_width)
XY=(XY-repmat(Corners(1,:),size(XY,1),1))...,
    ./repmat(Corners(3,:)-Corners(1,:),size(XY,1),1)*max_width; % max_wd - cm. ACCORDING TO THIS THE DIAGONAL GIVES THE MAX WIDITH
% XY(:,2)=max_width-XY(:,2); % my comment-03.01.13: obviously flip for y-dimension To begin the zero from the bottom left
% XY(XY>max_width)=max_width;
% XY(XY<0)=0;
end 








