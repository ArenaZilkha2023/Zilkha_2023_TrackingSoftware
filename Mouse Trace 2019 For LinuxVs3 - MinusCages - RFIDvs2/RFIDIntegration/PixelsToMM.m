%Convert pixel to mm 

function X=PixelsToMM(XPixel,Corn0,Corn1,max_width)
X=(XPixel-Corn0)*(max_width/(Corn1-Corn0)); 

end 