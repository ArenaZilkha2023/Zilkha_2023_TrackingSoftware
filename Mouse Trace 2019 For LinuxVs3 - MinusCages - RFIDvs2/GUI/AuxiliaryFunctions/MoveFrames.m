function [ output_args ] = MoveFrames( ~,~ )

%% variables
global h
global v
global numFrames

% Read video
 %v=VideoReader(get(h.editLoadDirectoryChild,'string'));

 
%% ----------------------Determine event with the slider-------------------------


indSlide=get(h.sliderChild,'Value');

Value = round(get(h.sliderChild, 'Value'));
set(h.sliderChild, 'Value', Value);

i=round(indSlide);
%------------------Do the video from the saved movie------

 
  
 lastFrame = read(v, inf);

 if i<numFrames 
  Frame{i}= read(v,i);
 
  image( Frame{i} ,'Parent', h.hAxis);
 end
 
 
 
 
 %% ---------------Set the number of frame------------------
 
  set(h.editNumFrames,'string',num2str(i))
 
end


