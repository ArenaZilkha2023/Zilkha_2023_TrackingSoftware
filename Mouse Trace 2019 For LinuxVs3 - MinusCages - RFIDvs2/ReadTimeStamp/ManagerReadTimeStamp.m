
function ExpTime=ManagerReadTimeStamp(Iaux,rectBig,folder_name)

%function to read the time stamp of each frame/ and to create a movie
% rectBig to crop all the title
% folder_name is the Directory with the fonts
%% Load the fonts and variables

load(fullfile(folder_name,'Intensity.mat'));%load the fonts


%% Create a collection of intensities Array for each letter
for i=1:10
    switch(i)
        case 1
                    NumberTime(1,1)=0;
        case 2
                    NumberTime(1,2)=1;
        case 3
            
                    NumberTime(1,3)=2;
         case 4
                    
                    NumberTime(1,4)=3;
         case 5
           
                    NumberTime(1,5)=4;
         case 6
           
                    NumberTime(1,6)=5;  
         case 7
              
                    NumberTime(1,7)=6;     
        case 8
           
                    NumberTime(1,8)=7;
         case 9
           
                    NumberTime(1,9)=8;
         case 10
           
                    NumberTime(1,10)=9;  
        
                        
            
    end
end
       

%% --------------------------------Create an object of the video---------------------------------
     
        
      
      
                I2 = imcrop(Iaux,rectBig); %crop the timestamp
       
                I2=(rgb2gray(I2)); 
                I2=imresize(I2,4); %%conversion to gray scale and resize
        
           
        % imshow(I2)
        
        
        
     
        %% ---------------Compare each letter with the library-------------------
                            
                 ExpTime=ReadTimeStamp(I2,Intensity.IzeroM,Intensity.IoneF,Intensity.Itwo,Intensity.Ithree,Intensity.Ifour,Intensity.Ifive,Intensity.Isix,Intensity.Iseven,Intensity.Ieight,Intensity.Inine,NumberTime);
      
                           
      
    
  end
                           
      

      %% -------------Create a movie with approximate rate per frame----------
%    xlswrite('test1.xlsx',TimeExp)    
% 
%        v1 = VideoWriter(fullfile(PathName,file));
%        v1.FrameRate=12.8;
%        open(v1)
%        writeVideo(v1,mov)
%    close(v1)  
%        
%        
%        %% Create structure of values
%        
%        file=strcat('New8',FileName,'.avi');
%       load(fullfile(folder_name,'Intensity.mat'));%load the fonts
% 
% 
% DirectoryToSave=['D:\DataToBuildNewGui2\MatlabFiles\'];
%        Locomotion.ExperimentTime=TimeExp;
%       
%        save(strcat(DirectoryToSave,'timeReal.mat'),'TimeExp');
       
       
 


