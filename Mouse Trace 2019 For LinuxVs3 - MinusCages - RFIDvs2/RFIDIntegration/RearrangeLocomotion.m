function Locomotion=RearrangeLocomotion(Locomotion,Index1Main,IndexSecondary,frameInitial,frameFinal)

%%
A1=Locomotion.AssigRFID.XcoordMM(frameInitial:frameFinal,IndexSecondary);
B1=Locomotion.AssigRFID.YcoordMM(frameInitial:frameFinal,IndexSecondary);

C1=Locomotion.AssigRFID.XcoordPixel(frameInitial:frameFinal,IndexSecondary);
D1=Locomotion.AssigRFID.YcoordPixel(frameInitial:frameFinal,IndexSecondary);

E1=Locomotion.AssigRFID.MouseOrientation(frameInitial:frameFinal,IndexSecondary);


A2=Locomotion.AssigRFID.XcoordMM(frameInitial:frameFinal,Index1Main);
B2=Locomotion.AssigRFID.YcoordMM(frameInitial:frameFinal,Index1Main);

C2=Locomotion.AssigRFID.XcoordPixel(frameInitial:frameFinal,Index1Main);
D2=Locomotion.AssigRFID.YcoordPixel(frameInitial:frameFinal,Index1Main);

E2=Locomotion.AssigRFID.MouseOrientation(frameInitial:frameFinal,Index1Main);




%%
Locomotion.AssigRFID.XcoordMM(frameInitial:frameFinal,Index1Main)=A1;
Locomotion.AssigRFID.YcoordMM(frameInitial:frameFinal,Index1Main)=B1;

Locomotion.AssigRFID.XcoordPixel(frameInitial:frameFinal,Index1Main)=C1;
Locomotion.AssigRFID.YcoordPixel(frameInitial:frameFinal,Index1Main)=D1;

Locomotion.AssigRFID.MouseOrientation(frameInitial:frameFinal,Index1Main)=E1;


Locomotion.AssigRFID.XcoordMM(frameInitial:frameFinal,IndexSecondary)=A2;
Locomotion.AssigRFID.YcoordMM(frameInitial:frameFinal,IndexSecondary)=B2;
Locomotion.AssigRFID.XcoordPixel(frameInitial:frameFinal,IndexSecondary)=C2;
Locomotion.AssigRFID.YcoordPixel(frameInitial:frameFinal,IndexSecondary)=D2;

Locomotion.AssigRFID.MouseOrientation(frameInitial:frameFinal,IndexSecondary)=E2;






end
