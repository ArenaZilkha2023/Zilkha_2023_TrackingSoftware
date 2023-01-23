function [Im,fidelity]=CoordFromNonDefined(DeltaTimeRFID,distance,x,y,NoDetectionTime,ThresholdRFIDDistance)

%% ---Find the minimum distance----------------
       [~,Im]=min(distance);

%%  ---------If the detection time is less than 80 ms and minimum distance less than 57mm,  thus Iminimum is the correct index and fidelity is zero
    if (DeltaTimeRFID < NoDetectionTime) & (distance(Im) < ThresholdRFIDDistance)
        Im=Im;
        fidelity=0;

    else 

            Im=[];
            fidelity=1;

    end

end