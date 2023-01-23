function  [xposToassign2, yposToassign2,xposPixelToassign2,yposPixelToassign2,OrientationToassign2]=DetectNoAssignedPositions(XassignStep1,YassignStep1,xpos,ypos,xposPixel,yposPixel,Orientation)

              indexX=ismember(xpos,XassignStep1); % return the xpos which are in Xassignment- The index is logical
              indexY=ismember(ypos,YassignStep1); % return the ypos which are in Yassignment-the index is logical
             if length(unique(xpos))<length(xpos) %without doubles %then must add the double position
                 [n, bin] = histc(xpos, unique(xpos));
                  multiple = find(n > 1);
                 indexaux1 = find(ismember(bin, multiple));
               
                 indexX(indexaux1(2:length(indexaux1)))=0;
                 indexY(indexaux1(2:length(indexaux1)))=0;
             end
              xposToassign2=xpos(~indexX & ~indexY); %only take nonassign positions
              yposToassign2=ypos(~indexX & ~indexY);
              xposPixelToassign2=xposPixel(~indexX & ~indexY);
              yposPixelToassign2=yposPixel(~indexX & ~indexY);
              OrientationToassign2=(Orientation(~indexX & ~indexY));

end