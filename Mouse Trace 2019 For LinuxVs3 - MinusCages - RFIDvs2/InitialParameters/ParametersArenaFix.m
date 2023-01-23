function Params=ParametersArenaFix()
global First_HidingCoordinates
global Second_HidingCoordinates
global Third_HidingCoordinates
global Four_HidingCoordinates
global Corn
global UpperCage
global DownCage

%Parameters
%The zero is define on the top left where the arena begins

%Corn is in pixels
% Corn(1,:)=[120,25]; %To be inserted from outside-This is the zero
% Corn(2,:)=[604,25];
% Corn(3,:)=[602,559];
% Corn(4,:)=[120,559];
%Read parameters

Width=1139; %in mm


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
  %% Insert coordinates of sleeping box in mm
  %Do 5 mm from the border
  Sbox8=[5,269.7]; %this is related to antenna 8 and 56
  Sbox7=[5,869.1]; %this is related to antenna 43 and 55
  Sbox6=[236.9,1134]; %this is related to antenna 45 and 54
  Sbox5=[902.1,1134]; %this is related to antenna 47 and 53
  Sbox4=[1134,869.1]; %this is related to antenna 35 and 52
  Sbox3=[1134,269.7]; %this is related to antenna 7 and 51
  Sbox2=[902.1,5]; %this is related to antenna 5 and 50
  Sbox1=[236.9,5]; %this is related to antenna 2 and 49
 
  SleepingBox=[Sbox1;Sbox2;Sbox3;Sbox4;Sbox5;Sbox6;Sbox7;Sbox8];
  
  SleepingAntenna=[2;5;7;35;47;45;43;8;49;50;51;52;53;54;55;56];
  
  %% Add information about hiding box antenna , and  center of the box
   HidingAntenna=[9;13;41;37];
   HidingAntennaCoord1=[(First_HidingCoordinates(1,1)+First_HidingCoordinates(3,1))/2,(First_HidingCoordinates(1,2)+First_HidingCoordinates(3,2))/2];
   HidingAntennaCoord2=[(Second_HidingCoordinates(1,1)+Second_HidingCoordinates(3,1))/2,(Second_HidingCoordinates(1,2)+Second_HidingCoordinates(3,2))/2];    
   HidingAntennaCoord3=[(Third_HidingCoordinates(1,1)+Third_HidingCoordinates(3,1))/2,(Third_HidingCoordinates(1,2)+Third_HidingCoordinates(3,2))/2];
   HidingAntennaCoord4=[(Four_HidingCoordinates(1,1)+First_HidingCoordinates(3,1))/2,(Four_HidingCoordinates(1,2)+Four_HidingCoordinates(3,2))/2];
   HidingAntennaCoord=[HidingAntennaCoord1;HidingAntennaCoord2;HidingAntennaCoord3;HidingAntennaCoord4];
    
   % Calculate width of hiding box for example first box
         First_HidingCoordinatesMM(1,1)=PixelsToMM(First_HidingCoordinates(1,1),Corn(1,1),Corn(2,1),Width); %convet to mm x coord
          First_HidingCoordinatesMM(1,2)=PixelsToMM(First_HidingCoordinates(1,2),Corn(1,2),Corn(4,2),Width);  %convet to mm y coord
          
          First_HidingCoordinatesMM(2,1)=PixelsToMM(First_HidingCoordinates(2,1),Corn(1,1),Corn(2,1),Width); %convet to mm x coord
          First_HidingCoordinatesMM(2,2)=PixelsToMM(First_HidingCoordinates(2,2),Corn(1,2),Corn(4,2),Width);  %convet to mm y coord
          
   
   WidthHidingBox=sqrt(sum((First_HidingCoordinatesMM(1,:) - First_HidingCoordinatesMM(2,:)) .^ 2));
   
  %% Create a structure
Params.AntennaCoord=AntennaCoord;
Params.SleepingBox=SleepingBox;
Params.Width=Width; 
%Params.Corn=Corn;
Params.SleepingAntenna=SleepingAntenna;

% Params of hiding box
Params.HidingAntenna=HidingAntenna;
Params.HidingAntennaCoord=HidingAntennaCoord;
Params.WidthHidingBox=WidthHidingBox;

% Save hiding coordinates of each box in pixels
Params.FirstHidingBox=First_HidingCoordinates;
Params.SecondHidingBox=Second_HidingCoordinates;
Params.ThirdHidingBox=Third_HidingCoordinates;
Params.FourHidingBox=Four_HidingCoordinates;

%Saving upper and down cage boxes
Params.UpperCage=UpperCage; %in pixel
Params.DownCage=DownCage;

end

