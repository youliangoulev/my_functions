function [ out1 , out2 , out3 , out4] = modtodot2( a , g , k , t , segmentation)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=[];
y=[];
g1=[];
n=0;
l1=[];
for i=1:length(segmentation.tcells1)
    if (segmentation.tcells1(i).N>0)&&(segmentation.tcells1(i).lastFrame>=t)
       if segmentation.tcells1(i).detectionFrame<a
           if ~isempty(segmentation.tcells1(i).daughterList)
               for j=1:length(segmentation.tcells1(i).daughterList)
%                    i
%                    j
%                    segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame
%                    segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame
%                    segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).lastFrame
%                    k
%                    g
%                    t
                   if ((segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame<k)&&(segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame>g)&&(segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).lastFrame>=t))
                       x=[x ; segmentation.tcells1(i).Obj(t-segmentation.tcells1(i).detectionFrame+1).fluoMean(2)];
                       y=[y ; segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).Obj(t-segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame+1).fluoMean(2)];
                       g1=[g1 ; segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).detectionFrame];
                       n=n+1;
                   end
               end
       end
    end
    end
out2=y;
out3=g1;
out1=x;
out4=n;
end

