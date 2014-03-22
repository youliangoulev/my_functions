function [ al klopm] = segmcorr1( segmentation , temps)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x={};
for i=1:length(segmentation.cells1)
liopm(i).fluo=[];
liopm(i).area=[];
liopm(i).mere=[];
end
for i=1:length(segmentation.tcells1)
   if segmentation.tcells1(i).lastFrame>temps && segmentation.tcells1(i).Obj(1).image<temps
    wad=[];
    m=[];
    y=[];
    
        if segmentation.tcells1(i).Obj(1).image>120
        lmp=10;
        else 
        lmp=100;
        end
    
    for j=1:length(segmentation.tcells1(i).Obj)
        wad=[wad,segmentation.tcells1(i).Obj(j).fluoMean(2)];
        m=[m,segmentation.tcells1(i).Obj(j).image];
        y=[y,segmentation.tcells1(i).Obj(j).area];
        liopm(segmentation.tcells1(i).Obj(j).image).fluo=[liopm(segmentation.tcells1(i).Obj(j).image).fluo , segmentation.tcells1(i).Obj(j).fluoMean(2)];
         liopm(segmentation.tcells1(i).Obj(j).image).area=[liopm(segmentation.tcells1(i).Obj(j).image).area , segmentation.tcells1(i).Obj(j).area];
             liopm(segmentation.tcells1(i).Obj(j).image).mere=[liopm(segmentation.tcells1(i).Obj(j).image).mere , lmp];
    end
    k.fluo=wad;
    k.frame=m;
    k.b=segmentation.tcells1(i).Obj(1).image;
    if segmentation.tcells1(i).Obj(1).image>120
        k.mere=10;
    else 
        k.mere=100;
    end
    k.area=y;
    
    x={x{:},k};

       
   end
end
al=x;
klopm=liopm;

end

