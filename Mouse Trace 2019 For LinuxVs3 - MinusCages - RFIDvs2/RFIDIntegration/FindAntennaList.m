function MouseArray=FindAntennaList(miceList,miceListRibs,miceListRibsSide,SelectedDataRFID,TimeExp)

% Loop over each mouse- Remember that the each mouse should has more than one ID chip (head or ribs)
for j=1:length(miceList)
  
    AuxID=vertcat(SelectedDataRFID{:,1});%identity- read RDID data
    Auxtime=vertcat(SelectedDataRFID{:,3}); %time
     %% ADDITION
    % t1=datenum(Auxtime,'HH:MM:SS.FFF');
     % t2=datenum('00:00:01.000','HH:MM:SS.FFF');
     % t=datestr(t1+t2,'HH:MM:SS.FFF');
     % Auxtime=cellstr(t); %REMOVE THIS IS ONLY FOR DELAY PROBLEM WITH ANTENNA
     %%%%%%%%%%%%%%%%%%FINISH
    Auxantenna=vertcat(SelectedDataRFID{:,4}); %antenna  
    
    %% Find each mouse according to the head or to the rib ID
      if ~isempty(miceListRibsSide) %if there are 3 identities 
       Iaux=[find(strcmp(miceList(j),AuxID)==1); find(strcmp(miceListRibs(j),AuxID)==1); find(strcmp(miceListRibsSide(j),AuxID)==1)];
       else
       if strcmp(miceList(j),miceListRibs(j))==0     
        Iaux=[find(strcmp(miceList(j),AuxID)==1); find(strcmp(miceListRibs(j),AuxID)==1)]; %find the identity of the respective mouse either with the ribs or head ID  
       else %sometimes the ribs fall then add same number
          Iaux=[find(strcmp(miceList(j),AuxID)==1)]; 
       end
      end
    %% Retain the list for each mouse
     AuxIDn=AuxID(Iaux);
     Auxtimen=Auxtime(Iaux);
     Auxantennan=Auxantenna(Iaux);
     %% Search the nearest RFID time to the frame time
      TimeExp=strrep(TimeExp,'''','');%Frame time
      d=knnsearch(datenum(Auxtimen,'HH:MM:SS.FFF'),datenum(TimeExp,'HH:MM:SS.FFF'));
      
      % Find delta in ms between rfid and frame time
      t1=datevec(TimeExp,'HH:MM:SS.FFF');   %experimental time
      t2=datevec(Auxtimen(d),'HH:MM:SS.FFF'); %antenna time
      DeltaTime=etime(t1,t2);
      DeltaTimeFrameRFID=abs(DeltaTime)*1000 ;
      SignTimeFrameRFId=sign(DeltaTime); %add the sign if it is positive experimental time before than antenna what is logic
      
      %% Create mouse arrays
       MouseArray(:,1,j)=strcat('''',TimeExp,'''');  %frame time
       MouseArray(:,2,j)=Auxantennan(d); %antenna rfid
       MouseArray(:,3,j)=strcat('''',Auxtimen(d),''''); %RFID time
       MouseArray(:,4,j)=num2cell(DeltaTimeFrameRFID);
       MouseArray(:,5,j)=num2cell(SignTimeFrameRFId);%sign of the time
%end 







end