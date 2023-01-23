function LoadFolder(~,~)
 
  global h
 global ChipsID
  
  PathName=uigetdir('','Open the folder with RFID and Video to analyse');

  set(h.editLoadDirectoryChild1,'string', PathName);
  
  %% Then add the list of movies to experiments
  
 %% Read the names of the file movies
Movies_file=dir(fullfile(PathName,'*.avi'));

%Add to the list

A=cell(1,70);
for i=1:length(Movies_file)
  
   A(i,1)=cellstr(Movies_file(i).name);
end

B=['All';A(:,1)];


set(h.popupExp,'string',B)

%% Add ID RFID information of mice-open the folder and take the rfid information

headerAll=ReadMiceIdentity(PathName);

       %% Create uiTable to enter mouse id
% Create the column and row names in cell arrays 

cnames = {'Chip 1-Head','Chip 2-Ribs','Chip3-Ribs','Sex','Genotype','Idah' };
rnames = {'Mouse 1','Mouse 2','Mouse 3','Mouse 4','Mouse 5','Mouse 6','Mouse 7','Mouse 8','Mouse 9'};
ChipsID=headerAll';


handles.data=cell(9,6); 
handles.data={[] [] [] [] [] [];[] [] [] [] [] []; [] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] []}

t= uitable(h.PanelParameters, 'ColumnName',cnames,'RowName',rnames,'ColumnWidth',{130},'Data',handles.data,'ColumnFormat',{ChipsID ChipsID ChipsID  {'male' 'female' ' '} {'Wild type' 'knock-out' 'intruder' 'others' ' '} {'Wild mouse' 'Lab. mouse' ' '}},'ColumnEditable', [true true true true true true],'HandleVisibility','callback','Position',[10 90 780 300],'FontSize',14,'CellEditCallback',@GetData)
 
h.table=t;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -------------------Auxiliary functions---------------------

function headerAll=ReadMiceIdentity(Folder_Data)



ListFiles=dir([Folder_Data,'\*.txt']);
Num = length(ListFiles(not([ListFiles.isdir]))); %number of files

%Do a loop for each folder data day
      for i=1:Num %go over each file to take the header
            fid=fopen([Folder_Data,'\',ListFiles(i).name]);
             %header=fgets(fid);
            % header=textscan(fid,'%s %s %s %s','delimiter',';','EmptyValue',NaN);
             header=textscan(fid,'%10s %s %s %s %s','delimiter',';','EmptyValue',NaN);
%              dataaux=header{4};
             header=header{1};

                 fclose(fid);
             if i==1 %couplint all the headers
                 headerAll=header;
%                  Alldata=dataaux;
             else
            headerAll=[headerAll; header];
            
%             Alldata=[Alldata;dataaux];
            end

        end
        %% for internal use

% AuxData=strcat('''',headerAll,'''');
% xlswrite('D:\AntennaInf2.xlsx',Alldata)
% xlswrite('D:\AntennaInf1.xlsx',AuxData)
%% 


index=find(strcmp(headerAll,'')==0);%different from''
headerAll=headerAll(index);
headerAll=unique(headerAll,'rows');

% AuxData=strcat('''',headerAll,'''');
% xlswrite('D:\AntennaInf3.xlsx',AuxData)
end
%% 
function GetData(src,event)
global h
global ChipsID

A=event.Indices; %what was selected 
% selected=h.table.Data(A(1),A(2));

Index=find(strcmp(ChipsID,h.table.Data(A(1),A(2)))==1);

ChipsID(1,find(strcmp(ChipsID,h.table.Data(A(1),A(2)))==1))={'xxxxxxxx'};

       % Create uiTable to enter mouse id
%Create the column and row names in cell arrays 
% 
% cnames = {'Chip 1-Head','Chip 2-Ribs','Chip3-Ribs','Sex','Genotype','Idah' };
% rnames = {'Mouse 1','Mouse 2','Mouse 3','Mouse 4','Mouse 5','Mouse 6','Mouse 7','Mouse 8','Mouse 9'};
% 
% handles.data=h.table.Data;
% % 
% % handles.data=cell(9,6); 
% % handles.data={[] [] [] [] [] [];[] [] [] [] [] []; [] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] [];[] [] [] [] [] []}
% 
% t= uitable(h.PanelParameters, 'ColumnName',cnames,'RowName',rnames,'ColumnWidth',{130},'Data',handles.data,'ColumnFormat',{ChipsIDNew ChipsIDNew ChipsIDNew  {'male' 'female' ' '} {'Wild type' 'knock-out' 'intruder' 'others' ' '} {'Wild mouse' 'Lab. mouse' ' '}},'ColumnEditable', [true true true true true true],'HandleVisibility','callback','Position',[10 90 780 300],'FontSize',14,'CellEditCallback',@GetData)
%  
% h.table=t;
set(h.table,'ColumnFormat',{ChipsID ChipsID ChipsID  {'male' 'female' ' '} {'Wild type' 'knock-out' 'intruder' 'others' ' '} {'Wild mouse' 'Lab. mouse' ' '}})

end

%% 
