function minusbg( a )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global segmentation;

for i=1:length(segmentation.tcells1)
   if segmentation.tcells1(i).N>0
       for j=1:length(segmentation.tcells1(i).Obj)

           segmentation.tcells1(i).Obj(j).fluoMean(2)=segmentation.tcells1(i).Obj(j).fluoMean(2)- segmentation.tcells1(a).Obj(j+(segmentation.tcells1(i).detectionFrame-segmentation.tcells1(a).detectionFrame)).fluoMean(2);
       end
   end
end

end

