classdef FilesTreat
    %For the file treatment as reorder
    %   Detailed explanation goes here
    
    properties
        directory
        extension
        numberfile
      
        
    
    end
    
    methods
        %%-----------------------Open the list of files---------------- 
        function ListFiles=ListFiles(obj) %list the files
           ListFiles= dir([obj.directory,'/*',obj.extension])
        end
        %% ----------------------Number the files-------------
        
        function NumFiles=NumFiles(obj,ListFiles)%Number of files
            NumFiles=length(ListFiles(not([ListFiles.isdir])));
        end
        
        %% ------------------------Information about date of RFID-------------------
         function DateFiles=DateFiles(obj,ListFiles,NumFiles)%list the files
               for i=1:NumFiles
                   A=char(ListFiles(i).name);
                   Lim=strfind(A,'-');
                DateFiles(i,1)=datenum(A(1:Lim-1),'mm_dd_yyyy'); 
                
               end
           
        end
                   
        %% -------------------Order the files according to the date-----------------
       
        function  idx=SortFiles(obj,ListFiles) %Order the files according to the date
            [~,idx] = sort([ListFiles.datenum]);
        end
        %% ----------------Read only one RFID files----------------------
        function ReadFiles=ReadFiles(obj,ListFiles) %Read the files
           fid=fopen([obj.directory,'\',ListFiles(obj.numberfile).name]);
           ReadFiles=textscan(fid,'%s %s %s %s','delimiter',';','EmptyValue',NaN);
           fclose(fid);
        end
        %% -------------------------Read all RFID files and concatenate-------------
        function ReadFilesAll=ReadFilesAll(obj,ListFiles,NumFiles) %Read  all the files and concatenate
           ReadFilesAll=[];    
           for i=3:NumFiles
               
           fid=fopen([obj.directory,'\',ListFiles(i).name]);
           ReadFiles=textscan(fid,'%s %s %s %s','delimiter',';','EmptyValue',NaN);
           %ReadFilesAll=[ReadFilesAll; ReadFiles];
           ReadFilesAll=cat(1,ReadFilesAll,ReadFiles);
           fclose(fid);
          
           end
           
         end
          %% -------------------------Read all RFID files and concatenate-------------
        function ReadFilesAllDate=ReadFilesAllDate(obj,ListFiles,IndexFiles) %Read  all the files and concatenate
           ReadFilesAllDate=[];    
           for i=IndexFiles'
           
           fid=fopen([obj.directory,'/',ListFiles(i).name]);
           ReadFiles=textscan(fid,'%s %s %s %s','delimiter',';','EmptyValue',NaN);
           ReadFilesAllDate=[ReadFilesAllDate; ReadFiles];
           fclose(fid);
          
           end
           
        end  
        
        %% -------------------Read the csv file
        
        function ReadFilesAllCSV=ReadFilesAllCSV(obj,ListFiles,n) %n is number of file
          fid=fopen([obj.directory,'\',ListFiles(n).name]);
          header=fgets(fid);%GET FIRST HEADER
          %numOfMice=length(strfind(header,'000')); %THIS COULD BE A PROBLEM IF THE 000 DISSAPEAR!!!!
          numOfMice=length(strfind(header,',,,'))+1;           

          FORMAT1=[];
          FORMAT2=[];
% 
       for i=1:numOfMice*3+2 %For each mouse x, y and velocity.The first 2 columns are the date and the time.
         FORMAT1 = [FORMAT1 ' %s'];
         if i>2
        FORMAT2 = [FORMAT2 ' %f'];
        else
         FORMAT2= [FORMAT2 ' %s'];
         end
         end
         header = textscan(header,FORMAT1,'delimiter', ',','EmptyValue', NaN);%GETS XY VELO
% 
% %% 
% 
         for i=1:numOfMice %COULD BRING DATA NUM OF MICE FROM PARAMS!!!!!!!!!
          miceIDs(i)=header{3*i+1};
        end
        
        header=fgets(fid);
% 
        ReadFilesAllCSV = textscan(fid,FORMAT2,'delimiter', ',','EmptyValue', NaN);  %data values
        
       fclose(fid);
       
        end
         
        %% -----------------Read the csv file with missing position (output from Eran's program)--------------
        
        function ReadTimeMissingPosition=ReadTimeMissingPosition(obj,ListFiles,n,numOfMice) %n is number of file
         %modify original file name
         OriginalName=ListFiles(n).name;
         OriginalName=char(OriginalName);
         k=strfind(OriginalName,'.csv');
         ActualName= strcat(OriginalName(1:k-1),'fm.csv');
         
          fid=fopen([obj.directory,'\',ActualName]);
          FORMAT2=[];
% 
            for i=1:numOfMice*2+2 %For each mouse x, y and velocity.The first 2 columns are the date and the time.
                if i>2
                     FORMAT2 = [FORMAT2 ' %f'];
                else
                     FORMAT2= [FORMAT2 ' %s'];
                end
            end
            
          RawAux = textscan(fid,FORMAT2,'delimiter', ',','EmptyValue', NaN);  %data values
        
          fclose(fid);   
          
           ReadTimeMissingPosition=RawAux{1,2};
        end
        
        %% -----------------Read csv for coord--------------
        function ReadPositionMissingPosition=ReadPositionMissingPosition(obj,ListFiles,n,numOfMice)
           %modify original file name
         OriginalName=ListFiles(n).name;
         OriginalName=char(OriginalName);
         k=strfind(OriginalName,'.csv');
         ActualName= strcat(OriginalName(1:k-1),'fm.csv');
           
        [num,txt,ReadPositionMissingPosition]=xlsread([obj.directory,'\',ActualName]);
        
        end
          
        
         %% -------------------- Take the miceIDS of the csv---------------
        function miceIDs=miceIDs(obj,ListFiles,n)
         fid=fopen([obj.directory,'\',ListFiles(n).name]);
         header=fgets(fid);%GET FIRST HEADER
         numOfMice=length(strfind(header,',,,'))+1;

          FORMAT1=[];
          FORMAT2=[];
% 
       for i=1:numOfMice*3+2 %For each mouse x, y and velocity.The first 2 columns are the date and the time.
         FORMAT1 = [FORMAT1 ' %s'];
         if i>2
        FORMAT2 = [FORMAT2 ' %f'];
        else
         FORMAT2= [FORMAT2 ' %s'];
         end
         end
         header = textscan(header,FORMAT1,'delimiter', ',','EmptyValue', NaN);%GETS XY VELO
% 
% %% 
% 
         for i=1:numOfMice %COULD BRING DATA NUM OF MICE FROM PARAMS!!!!!!!!!
          miceIDs(i)=header{3*i+1};
        end
        
        end
        %% ---------------------Remove duplicates from the list--------------------------
        function RemoveDuplicFrame=RemoveDuplicFrame(obj,ReadFilesAllCSV)  %find duplicate frame
            
          [CoorDataWithouD,frames,ic]=unique(ReadFilesAllCSV,'rows','stable');  
            RemoveDuplicFrame=frames;
           
        end
        
        
        
             
end
end
