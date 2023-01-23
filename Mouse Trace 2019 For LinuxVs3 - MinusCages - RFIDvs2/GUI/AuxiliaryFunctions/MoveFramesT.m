function [ output_args ] = MoveFramesT( ~,~ )

%% variables
global h
global v
global numFrames

% Read video
 %v=VideoReader(get(h.editLoadDirectoryChild,'string'));

 
%% ----------------------Determine event with the slider-------------------------


indSlide=get(h.SetThreshold.sliderChild,'Value');

Value = round(get(h.SetThreshold.sliderChild, 'Value'));
set(h.SetThreshold.sliderChild, 'Value', Value);

i=round(indSlide);
%------------------Do the video from the saved movie------

 
  
 lastFrame = read(v, inf);

 if i<numFrames 
  Frame{i}= read(v,i);
 
  image( Frame{i} ,'Parent', h.SetThreshold.hAxisr);
 end
 
 
 
 
 %% ---------------Set the number of frame------------------
 
  set(h.SetThreshold.editNumFrames,'string',num2str(i))
 
end


