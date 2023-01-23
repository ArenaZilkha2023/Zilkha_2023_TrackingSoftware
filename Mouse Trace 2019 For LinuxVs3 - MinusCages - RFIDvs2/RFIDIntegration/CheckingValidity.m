
function    IindicateNoSureCoord=CheckingValidity(countFrames, IndexToCheck,XAssignment,YAssignment,.....
                      XLastFrame,YLastFrame,TimeInitial,TimeFinal,NoSureSignalLastFrame,....
                      VelocityThreshold,IindicateNoSureCoord,VelLastFrame,FactorAcceleration,....
                      OrientationLastFrame,OrientationAssignment,MinimumAngleTolerance)
                  
                  
% The idea is to check the validity of the results from rfid                  
 %% ------------------Begin calculation-----------------------
  if countFrames>1 & ~isempty(IndexToCheck)
         [velocityRFID,~]=VelocityCalculation(XAssignment,YAssignment,XLastFrame,YLastFrame,...
                                        TimeInitial,TimeFinal);
         angleChange=abs(abs(OrientationAssignment)-abs(OrientationLastFrame));                           
    % loop over the positions to be checked
      for count1=1:length(IndexToCheck)   
                                                 
             if  (NoSureSignalLastFrame(IndexToCheck(count1))==0)%only if sure if not it is considered as sure 
               %  if (velocityRFID((count1))> VelocityThreshold)|(acceleration > FactorAcceleration)|(angleChange > MinimumAngleTolerance);   %the position of last frame is defined
                  if (velocityRFID((count1))> VelocityThreshold)|(angleChange > MinimumAngleTolerance);   %the position of last frame is defined 
                     IindicateNoSureCoord(IndexToCheck(count1))=1;% Pass to be no sure the assignment
             
                 end                                
             end                                          
       end
  end
         
   
end