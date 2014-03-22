function [ divtm , divtf ] = segmcorr4( segmentation )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

xmm=[];
y=[];

for i=1:length(segmentation.tcells1)
   if segmentation.tcells1(i).detectionFrame>0
       lmp=segmentation.tcells1(i).detectionFrame;
       if ~isempty(segmentation.tcells1(i).budTimes)
           if segmentation.tcells1(i).detectionFrame>1
               y=[y , segmentation.tcells1(i).budTimes(1)-segmentation.tcells1(i).detectionFrame];
           end
           if length(segmentation.tcells1(i).budTimes)>1
          
           for j=2:length(segmentation.tcells1(i).budTimes)
               xmm=[xmm , segmentation.tcells1(i).budTimes(j)-segmentation.tcells1(i).budTimes(j-1) ];
           end
           end
      
       end
      
   end
end

divtm=xmm;
divtf=y;

end

