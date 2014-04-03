function [a , b , c , d]=test1(resolution ,chanelfluo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global segmentation;

cha=chanelfluo;




esize=[];
efluo=[];
etime=[];
k=[];

for i=1:length(segmentation.tcells1)
    if length(segmentation.tcells1(i).Obj)>1
        for j=2:length(segmentation.tcells1(i).Obj)
            esize=[esize , abs(segmentation.tcells1(i).Obj(j).area-segmentation.tcells1(i).Obj(j-1).area)];
            efluo=[efluo , abs(segmentation.tcells1(i).Obj(j).fluoMean(cha)-segmentation.tcells1(i).Obj(j-1).fluoMean(cha))];
            etime=[etime , abs(segmentation.tcells1(i).Obj(j).image*resolution-resolution)];
        end;
    end;
end;

for i=1:length(segmentation.tcells1)
    if length(segmentation.tcells1(i).Obj)>1
        for j=2:length(segmentation.tcells1(i).Obj)
             siz=abs(segmentation.tcells1(i).Obj(j).area-segmentation.tcells1(i).Obj(j-1).area);
             flu=abs(segmentation.tcells1(i).Obj(j).fluoMean(cha)-segmentation.tcells1(i).Obj(j-1).fluoMean(cha));
             produit=(sum(esize>=siz)/length(esize))*(sum((efluo>=flu)/length(efluo)));
             k=[k , produit];
        end;
    end;
end;

n=length(k);


a=esize;
b=efluo;
c=etime;
d=k;

end

