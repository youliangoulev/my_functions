function [ a ] = firstcells
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global segmentation;
z=[];
for i=1:length(segmentation.tcells1)
   if segmentation.tcells1(i).detectionFrame==1
       z=[z , i];
   end;
end;
a=z;
end

