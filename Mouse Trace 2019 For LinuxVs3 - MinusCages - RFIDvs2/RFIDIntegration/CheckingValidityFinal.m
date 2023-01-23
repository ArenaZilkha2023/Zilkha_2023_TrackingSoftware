function   [IindicateNoSureCoord,velocityFinal,velocityX,velocityY]=CheckingValidityFinal(countFrames,XAssignment,YAssignment,.....
                      XLastFrame,YLastFrame,TimeInitial,TimeFinal,NoSureSignalLastFrame,....
                      VelocityThreshold,IindicateNoSureCoord,VelLastFrame,FactorAcceleration,IndexRightWithRFID,...
                      OrientationLastFrame,OrientationAssignment,MinimumAngleTolerance)
                  
                  
% The idea is to check the validity of the results after all the manipulation                
 %% ------------------Begin calculation-----------------------

  if countFrames>2 
      [velocityFinal,velocityX,velocityY]=VelocityCalculation(XAssignment,....
                                       YAssignment,.....
                                        XLastFrame,YLastFrame,...
                                        TimeInitial,TimeFinal);
                                    
       [acceleration,elapsetime]=AccelerationCalculation(velocityFinal,VelLastFrame',....
                                                                 TimeInitial,TimeFinal);  
        angleChange=abs(abs(OrientationAssignment)-abs(OrientationLastFrame));                                                      
      % Ivelacel=(velocityFinal > VelocityThreshold)| (acceleration > FactorAcceleration);
       Ivelacel=(velocityFinal > VelocityThreshold)| (angleChange'> MinimumAngleTolerance);
       IindicateNoSureCoord(Ivelacel)=1;%No sure the position
       
   elseif countFrames==2
       [velocityFinal,velocityX,velocityY]=VelocityCalculation(XAssignment,....
                                       YAssignment,.....
                                        XLastFrame,YLastFrame,...
                                        TimeInitial,TimeFinal);
       angleChange=abs(abs(OrientationAssignment)-abs(OrientationLastFrame)); 
       Ivelocity=(velocityFinal > VelocityThreshold)| (angleChange'> MinimumAngleTolerance);
       IindicateNoSureCoord(Ivelocity)=1;%No sure the position
       
   else
       velocityFinal=zeros(size(IndexArena,1),1);
   end
         
   %% Add as no sure if the last position  was wrong 
    IindicateNoSureCoord(find(NoSureSignalLastFrame==1))=1;
    % But if the last frame is not defined but the detection is right with
    % rfdi
    IindicateNoSureCoord(IndexRightWithRFID)=0;
   % Add when the RFID and the location are sure
   % IindicateNoSureCoord(IndexCoincidenceRFIDLastFrame)=0;
end


