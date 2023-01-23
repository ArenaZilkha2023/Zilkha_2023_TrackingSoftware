function [miceType,malesList,femalesList,mice_3_chips,malesListRibs,femalesListRibs,malesListRibsSecond,femalesListRibsSecond]=getMiceIDsComputeAll(DIR,sheet)
% Types:
% 'M'  -  male
% 'F'  -  female
% 'M*' -  knock-outs
% 'Mi' -  intruder


%% Read data

mice_3_chips=cell(0,3);


%% find male and female list- Root directory and sheet given by the user
[num,txt,raw]=xlsread([DIR,'\','Parameters','\','MiceID.xlsx'],sheet);


index1=find(strcmp(raw(1,:),'Sex')==1);
index2=find(strcmp(raw(1,:),'Chip1')==1); %identity on the head
index3=find(strcmp(raw(1,:),'Chip3')==1); %identity of the third ribs_introduced by Itzik.
index4=find(strcmp(raw(1,:),'Chip2')==1); %identity on the ribs

[NumMice,Conditions]=size(raw);

malesList=cellfun(@male,raw(2:end,index1),raw(2:end,index2),'UniformOutput', false);
malesList=malesList;
%remove empty spaces
Ind1=find(strcmp(malesList,'')==0);
malesList=malesList(Ind1);
malesList=malesList';

%%for Ribs
malesListRibs=cellfun(@male,raw(2:end,index1),raw(2:end,index4),'UniformOutput', false);
malesListRibs=malesListRibs;
%remove empty spaces
Ind1=find(strcmp(malesListRibs,'')==0);
malesListRibs=malesListRibs(Ind1);
malesListRibs=malesListRibs';

if isempty(find(isnan([raw{2:end,index3}])==1)) %if the chip3 was implanted
%for the Ribs on the other side in chip3
malesListRibsSecond=cellfun(@male,raw(2:end,index1),raw(2:end,index3),'UniformOutput', false);
malesListRibsSecond=malesListRibsSecond;
%remove empty spaces
Ind2=find(strcmp(malesListRibsSecond,'')==0);
malesListRibsSecond=malesListRibsSecond(Ind2);
malesListRibsSecond=malesListRibsSecond';
else
    malesListRibsSecond=raw(2:end,index3);
end






femalesList=cellfun(@female,raw(2:end,index1),raw(2:end,index2),'UniformOutput', false);
femalesList=femalesList;
%remove empty spaces
Ind2=find(strcmp(femalesList,'')==0);
femalesList=femalesList(Ind2);
femalesList=femalesList';

%for the Ribs
femalesListRibs=cellfun(@female,raw(2:end,index1),raw(2:end,index4),'UniformOutput', false);
femalesListRibs=femalesListRibs;
%remove empty spaces
Ind2=find(strcmp(femalesListRibs,'')==0);
femalesListRibs=femalesListRibs(Ind2);
femalesListRibs=femalesListRibs';

if isempty(find(isnan([raw{2:end,index3}])==1)) %no implatantion to all the mice of a third chip
%for the Ribs on the other side in chip3
femalesListRibsSecond=cellfun(@female,raw(2:end,index1),raw(2:end,index3),'UniformOutput', false);
femalesListRibsSecond=femalesListRibsSecond;
%remove empty spaces
Ind2=find(strcmp(femalesListRibsSecond,'')==0);
femalesListRibsSecond=femalesListRibsSecond(Ind2);
femalesListRibsSecond=femalesListRibsSecond';
else
    femalesListRibsSecond=raw(2:end,index3);
end

mice_3_chips=raw(2:end,index2:index3);
mice_3_chips=cellfun(@RemoveIsnan,mice_3_chips,'UniformOutput', false)

%% do mice type structure
for i=2:NumMice
    if isnan(raw{i,index2})==0
    Aux=raw(i,index2);
   Aux=strrep( Aux,'''','') %eliminate double quotes
    %% 
    
     Aux=char(Aux);

Aux1=strcat('x',Aux(length(Aux)-3:length(Aux)))


if strcmp(raw(i,index1),'male')==1
 
    miceType.(Aux1)='M';
else
   
   miceType.(Aux1)='F';
end
end
end
end
%% Auxiliary functions
function result=male(a,b)
if strcmp(a,'male')==1
  result=b;
else
    result='';
end



end


function result=female(a,b)
if strcmp(a,'female')==1
  result=b; 
else
    result='';
end



end

function result=RemoveIsnan(a)
if isnan(a)==1
    result='';
else
    result=a;
end


end
%% 


