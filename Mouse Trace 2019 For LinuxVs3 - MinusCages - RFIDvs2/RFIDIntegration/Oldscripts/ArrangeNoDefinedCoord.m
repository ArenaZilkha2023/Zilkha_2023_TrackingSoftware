function SubsetAntennaNumberUnique=ArrangeNoDefinedCoord(SubsetAntennaNumberUnique,AntennaNumber,CoordinatesFinalMiceMM,countFrames)
%this function is to arrange the non defined data

% Separate x and y 
for i=1:length(AntennaNumber)
x(i)=CoordinatesFinalMiceMM(countFrames-1,2*i-1);
y(i)=CoordinatesFinalMiceMM(countFrames-1,2*i);
end    
    
    
INonDefined=find(x==1e6);

if ~isempty(INonDefined)
    AntennaNonDefined=AntennaNumber(INonDefined);

     AntennaDefined=setdiff(SubsetAntennaNumberUnique,AntennaNonDefined,'stable');

     SubsetAntennaNumberUnique=[AntennaDefined;AntennaNonDefined];
end



end