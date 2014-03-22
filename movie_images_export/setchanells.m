function setchanells
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global timeLapse
global segmentation


 for i=1:length(timeLapse.list)
 timeLapse.list(i).setHighLevel=segmentation.colorData(i,5)*2^16; 
 timeLapse.list(i).setLowLevel=segmentation.colorData(i,4)*2^16;
 end

end

