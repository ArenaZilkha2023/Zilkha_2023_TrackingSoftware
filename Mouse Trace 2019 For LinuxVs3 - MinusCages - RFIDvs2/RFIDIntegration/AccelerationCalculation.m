function  [acceleration,ElapseTime]=AccelerationCalculation(velFinal,velInitial,....
                                                   Timeinitial,Timefinal); 

%% ------------------------Conversion of time------------------------
%translate TimeExp to vector

Timefinal=strrep(Timefinal,'''',''); %Remove double string before
Timeinitial=strrep(Timeinitial,'''','');
TimeVectorAfter=datevec(Timefinal,'HH:MM:SS.FFF');
TimeVectorBefore=datevec(Timeinitial,'HH:MM:SS.FFF');
ElapseTime=abs(etime(TimeVectorAfter,TimeVectorBefore));% elapsed time in seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

acceleration=abs(velFinal-velInitial)/ElapseTime;





end