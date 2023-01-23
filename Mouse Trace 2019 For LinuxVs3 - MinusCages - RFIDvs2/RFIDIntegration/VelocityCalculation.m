function [velocity,velocityX,velocityY]=VelocityCalculation(Xfinal,Yfinal,Xinitial,Yinitial,Timeinitial,Timefinal)
                                      
%% This function calculates velocity from frame to frame. The times are in char format-The parameters are in mm
                                    

%% ------------------------Conversion of time------------------------
%translate TimeExp to vector

Timefinal=strrep(Timefinal,'''',''); %Remove double string before
Timeinitial=strrep(Timeinitial,'''','');
TimeVectorAfter=datevec(Timefinal,'HH:MM:SS.FFF');
TimeVectorBefore=datevec(Timeinitial,'HH:MM:SS.FFF');
ElapseTime=abs(etime(TimeVectorAfter,TimeVectorBefore));% elapsed time in seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ----------------------Calculate the distance between two frames ----------------
distance=sqrt((Xfinal'-Xinitial').^2+(Yfinal'-Yinitial').^2); %this is the distance in mm
% conversion distance to cm
distance=distance/10;
%%%%%
%% --------------------------Calculate velocity--------------------------

velocity=distance/ElapseTime;
velocityX=(Xfinal'-Xinitial')/ElapseTime; %in mm/sec


velocityY=(Yfinal'-Yinitial')/ElapseTime;%in mm/sec


%% ----------------------------Correction of velocity if xpos is 1e6 not defined---------------------------

if Xfinal==1e6 | Xinitial==1e6
   velocity(Xfinal==1e6 | Xinitial==1e6)=1e6; 
end













end