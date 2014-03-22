function [ out1 , out2 , out3] = modtodot( a , g , k , t , segmentation)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=[];
n=0;
g1=[];
for i=1:length(segmentation.tcells1)
    if (segmentation.tcells1(i).N>0)&&(segmentation.tcells1(i).lastFrame>=t)
       if segmentation.tcells1(i).detectionFrame<a
           if ~isempty(segmentation.tcells1(i).daughterList)
               for j=1:length(segmentation.tcells1(i).daughterList)
                   if (segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame<k)&&(segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame>g)&&(segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).lastFrame>=t)
                       x=[x , segmentation.tcells1(i).Obj(t-segmentation.tcells1(i).detectionFrame+1).fluoMean(2)-segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).Obj(t-segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame+1).fluoMean(2)];
                       n=n+1;
                       g1=[g1 ; segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame];
                   end
               end
       end
    end
    end
out1=x;
out2=g1;
out3=n;
end

