function [ output_args ] = branchgrowth( startingcells , lowborder , highborder )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%====================================

global segmentation;
framet=3; %3 min

%====================================

cls=startingcells;
a=round(((lowborder)/framet)+1);
b=round(((highborder)/framet)+1);
filles=true;
gen{1}=cls;
i=1;
while filles
 i=i+1;
 k=[];
 for j=1:length(gen{i-1})
     if ~isempty(segmentation.tcells1(gen{i-1}(j)).daughterList)
         for h=1:length(segmentation.tcells1(gen{i-1}(j)).daughterList)
             if (segmentation.tcells1(segmentation.tcells1(gen{i-1}(j)).daughterList(h)).detectionFrame<=b)
                 k=[k , segmentation.tcells1(gen{i-1}(j)).daughterList(h)];
             end;
         end;
     end;
 end;
 if ~isempty(k)
     gen{i}=k;
 else
     filles=false;
 end;
    
end

all=[];
for i=1:length(gen)
    all=[all , gen{i}];
end;

time1=0:framet:(b-1)*framet;m=0;
lm=zeros(1 , b);
for i=1:length(all)
    if segmentation.tcells1(all(i)).lastFrame<=b
        lm(segmentation.tcells1(all(i)).lastFrame)=lm(segmentation.tcells1(all(i)).lastFrame)+1;
        m=m+1;
    end;
end;

disp(['total cells = ' num2str(length(all))]);
disp(['lost cells = ' num2str(m)]);
disp(['ratio lost/total= ' num2str(m/length(all))]);
figure;
bar(time1 , lm);

%========================================================


nom=zeros(1 , b);
nomt=0;
for i=1:length(segmentation.tcells1)
    if (segmentation.tcells1(i).mother==0)&&(segmentation.tcells1(i).detectionFrame<=b)
        
        nom(segmentation.tcells1(i).detectionFrame)=nom(segmentation.tcells1(i).detectionFrame)+1;
        nomt=nomt+1;
    end;
end;
%========================================================
disp(['no mother cells = ' num2str(nomt)]);
disp(['ratio no mother/total = ' num2str(nomt/length(all))]);
figure;
bar(time1 , nom);

totarea=zeros(1 , b-a+1);

for i=1:length(all)
    for j=1:length(segmentation.tcells1(all(i)).Obj)
        if (segmentation.tcells1(all(i)).Obj(j).image>=a)&&(segmentation.tcells1(all(i)).Obj(j).image<=b)
            totarea(segmentation.tcells1(all(i)).Obj(j).image-a+1)=totarea(segmentation.tcells1(all(i)).Obj(j).image-a+1)+segmentation.tcells1(all(i)).Obj(j).area;
        end;
    end;
end;

time=(a-1)*framet:framet:(b-1)*framet;
figure;
plot(time , totarea);
figure;
plot(time , log(totarea));

end

