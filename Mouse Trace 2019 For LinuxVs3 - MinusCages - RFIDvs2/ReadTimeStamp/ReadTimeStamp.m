function  ExpTime=ReadTimeStamp(Iimage,Izero,Ione,Itwo,Ithree,Ifour,Ifive,Isix,Iseven,Ieight,Inine,NumberTime)
%Create a script which reads the time of the stamp time
%% 
%Variables rectangle to crop each time
%For hours

rectNumber(1,:)=[362.5100   14.5100    32.9800   47.9800];
rectNumber(2,:)=[(362.5100+30)   14.5100   32.9800   47.9800];

%For minutes

rectNumber(3,:)=[(362.5100+30+30+13)   14.5100   32.9800   47.9800];
rectNumber(4,:)=[(362.5100+30+30+30+13)   14.5100   32.9800   47.9800];

%For seconds

rectNumber(5,:)=[(362.5100+30+30+30+13+30+13)   14.5100   32.9800   47.9800];
rectNumber(6,:)=[(362.5100+30+30+30+13+30+13+30)   14.5100   32.9800   47.9800];

%For  milliseconds
rectNumber(7,:)=[(362.5100+30+30+30+13+30+13+30+30+13)   14.5100   32.9800   47.9800];
rectNumber(8,:)=[(362.5100+30+30+30+13+30+13+30+30+13+30)   14.5100   32.9800   47.9800];
rectNumber(9,:)=[(362.5100+30+30+30+13+30+13+30+30+13+30+30)   14.5100   32.9800   47.9800];


rectBlank =[424.5100   14.5100   10.9800   49.9800];

%% 
%Loop over each letter of the time  nine times.
%Inside the loop:do another loop and correlate with each letter.Create a
%vector with the maximum of correlation.
%then choice the letter
clear Time
for i=1:9 %loop over each letter
     Icrop= imcrop(Iimage,rectNumber(i,:));
     
     %% 
     
        for  j=1:10   %loop over the numbers of the library
            switch(j)
                case 1
                     clear C1
                     C1 = normxcorr2(Izero,Icrop);
                     Correl(j)=max(C1(:));
                 case 2
                     clear C1
                     C1 = normxcorr2(Ione,Icrop);
                     Correl(j)=max(C1(:));
                 case 3
                     clear C1
                     C1 = normxcorr2(Itwo,Icrop);
                     Correl(j)=max(C1(:));     
                 case 4
                     clear C1
                     C1 = normxcorr2(Ithree,Icrop);
                     Correl(j)=max(C1(:));    
                 case 5
                     clear C1
                     C1 = normxcorr2(Ifour,Icrop);
                     Correl(j)=max(C1(:));    
                 case 6
                     clear C1
                     C1 = normxcorr2(Ifive,Icrop);
                     Correl(j)=max(C1(:));     
                 case 7
                     clear C1
                     C1 = normxcorr2(Isix,Icrop);
                     Correl(j)=max(C1(:));    
                 case 8
                     clear C1
                     C1 = normxcorr2(Iseven,Icrop);
                     Correl(j)=max(C1(:));   
                 case 9
                     clear C1
                     C1 = normxcorr2(Ieight,Icrop);
                     Correl(j)=max(C1(:));    
                 case 10
                     clear C1
                     C1 = normxcorr2(Inine,Icrop);
                     Correl(j)=max(C1(:));     
                 
            
        end
        
        %% 
        %Check which letter is the adequate
        
        
        
     
    
    
    
        end

        [M,Ind]=max(Correl);
        Time(1,i)=NumberTime(1,Ind);






end
%Create the experiment Time
ExpTime=strcat('''',num2str(Time(1,1)),num2str(Time(1,2)),':',num2str(Time(1,3)),num2str(Time(1,4)),':',num2str(Time(1,5)),num2str(Time(1,6)),'.',num2str(Time(1,7)),num2str(Time(1,8)),num2str(Time(1,9)),'''');

end

