function [ aut ] = branchgrowth( startingcells , lowborder , highborder )
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
checkrepeat=[cls];
i=1;
while filles
 i=i+1;
 k=[];
 for j=1:length(gen{i-1})
     
     if ~isempty(segmentation.tcells1(gen{i-1}(j)).daughterList)
         for h=1:length(segmentation.tcells1(gen{i-1}(j)).daughterList)
             if (segmentation.tcells1(segmentation.tcells1(gen{i-1}(j)).daughterList(h)).detectionFrame<=b)
                % k=[k , segmentation.tcells1(gen{i-1}(j)).daughterList(h)];
                 if sum(segmentation.tcells1(gen{i-1}(j)).daughterList(h)==checkrepeat)>0
                    disp(['loop with mother ' , num2str(gen{i-1}(j)) , ' and daugther ' , num2str(segmentation.tcells1(gen{i-1}(j)).daughterList(h))]); 
                    %segmentation.tcells1(gen{i-1}(j)).daughterList(h)
                 else
                      k=[k , segmentation.tcells1(gen{i-1}(j)).daughterList(h)];
                    %return
                 end;
             end;
         end;
     end;
 end;
 if ~isempty(k)
     gen{i}=k;
     checkrepeat=[checkrepeat , k];
 else
     filles=false;
 end;
    
end

all=[];
for i=1:length(gen)
    all=[all , gen{i}];
end;

time1=0:framet:(b-1)*framet;
m=0;
lm=zeros(1 , b);
for i=1:length(all)
    if segmentation.tcells1(all(i)).lastFrame<b
        lm(segmentation.tcells1(all(i)).lastFrame)=lm(segmentation.tcells1(all(i)).lastFrame)+1;
        m=m+1;
        disp(['cell ' , num2str(all(i)) , ' lost on frame ' , num2str(segmentation.tcells1(all(i)).lastFrame+1)]);
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

totvolum=zeros(1 , b-a+1);
numberofcells=zeros(1 , b-a+1);
for i=1:length(all)
    for j=1:length(segmentation.tcells1(all(i)).Obj)
        if (segmentation.tcells1(all(i)).Obj(j).image>=a)&&(segmentation.tcells1(all(i)).Obj(j).image<=b)
            sur=segmentation.tcells1(all(i)).Obj(j).area;
            totvolum(segmentation.tcells1(all(i)).Obj(j).image-a+1)=totvolum(segmentation.tcells1(all(i)).Obj(j).image-a+1)+4*sqrt(sur*sur*sur/pi)/3;
            numberofcells(segmentation.tcells1(all(i)).Obj(j).image-a+1)=numberofcells(segmentation.tcells1(all(i)).Obj(j).image-a+1)+1;
        end;
    end;
end;









time=(a-1)*framet:framet:(b-1)*framet;
%================
% f1=polyfit(time(1:111) , totvolum(1:111) , 2);
% f2=polyfit(time(112:end) , totvolum(112:end) , 2);
% newtotv=[time(1:111).*time(1:111)*f1(1)+time(1:111)*f1(2)+f1(3), time(112:end).*time(112:end)*f2(1)+time(112:end)*f2(2)+f2(3)];
%================
figure;
plot(time , (smooth((totvolum) , 20)));
hold on;
plot(time , [(smooth((totvolum(1:111)) , 50))' , (smooth((totvolum(112:150)) , 50))' , (smooth((totvolum(151:end)) , 50))'], 'color' , 'r');
figure;
plot(time , numberofcells);
figure;
% plot(time , smooth(log(totarea) , 15));
% figure;
nnn=(diff([(smooth((totvolum(1:111)) , 50))'  (smooth((totvolum(112:150)) , 50))' , (smooth((totvolum(151:end)) , 50))'])/3);
qqq=numberofcells(1:end-1);
www=nnn./qqq;
plot(time(2:end) , smooth(www , 7), 'color' , 'g');
figure;
plot(time(2:end) , smooth(diff(smooth(log([(smooth((totvolum(1:111)) , 50))'  (smooth((totvolum(112:150)) , 50))' , (smooth((totvolum(151:end)) , 50))']) , 1)) , 7)/3);
aut=smooth(log(totvolum) , 7);

end

