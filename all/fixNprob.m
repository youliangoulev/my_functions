function fixNprob
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global segmentation
p=size(segmentation.cells1);
for i=1:p(1)
    
    for j=1:p(2)
       segmentation.cells1(i,j).n=j; 
    end
    
end
end

