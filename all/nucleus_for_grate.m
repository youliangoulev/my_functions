function nucleus_for_grate
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global segmentation;
for i=1:length(segmentation.tcells1)
    if segmentation.tcells1(i).N<=0
       continue; 
    end
    for j=1:length(segmentation.tcells1(i).Obj)
    segmentation.tcells1(i).Obj(j).fluoMean(2)= (segmentation.tcells1(i).Obj(j).fluoNuclMean(2)-segmentation.tcells1(i).Obj(j).fluoCytoMean(2))/segmentation.tcells1(i).Obj(j).fluoCytoMean(2) ;                                       
    end
    
    
end


% global segmentation;
% for i=1:length(segmentation.tcells1)
%     if segmentation.tcells1(i).N<=0
%        continue; 
%     end
%     for j=1:length(segmentation.tcells1(i).Obj)
%     segmentation.tcells1(i).Obj(j).fluoMean(2)=segmentation.tcells1(i).Obj(j).fluoCytoMean(2) ;                                       
%     end
%     
%     
% end




end

