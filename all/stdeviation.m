function out = stdeviation
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global segmentation
Xi={};
m=[];
l=[];
figure;
for i=1:length(segmentation.tcells1)
if segmentation.tcells1(i).Obj(1).n~=0
    for u=1:length(segmentation.tcells1(i).Obj)
        m=horzcat(m,segmentation.tcells1(i).Obj(u).image);
        l=horzcat(l,sqrt(segmentation.tcells1(i).Obj(u).fluoVar(2)));
    end

    plot(m,l);
    hold on
    m=[];
    l=[];
end

end

end

