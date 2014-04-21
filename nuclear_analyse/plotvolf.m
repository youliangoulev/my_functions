function plotvolf( time , v , smsp)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

differ=[];
goodscel=[];
limits=1;

for i=1:length(v)
    differ=[ differ , diff(v{i})];
end;

born1=(prctile(differ , 75)-prctile(differ , 25))*limits+prctile(differ , 75);
born2=-(prctile(differ , 75)-prctile(differ , 25))*limits+prctile(differ , 25);

for i=1:length(v)    
    if length(v{i})>1
    for j=2:length(v{i})
 
        if (v{i}(j)-v{i}(j-1)<born2)||(v{i}(j)-v{i}(j-1)>born1)
            v{i}=v{i}(1:j-1);
            time{i}=time{i}(1:j-1);
            break;
        end;
        
    end;
    end;
    if length(v{i})>1
        goodscel=[goodscel , i];
    end;
end;



colorses=hsv(length(goodscel));
fi=figure;
set(fi,'Position',[251 , 451 , 679 , 346]);
ii=0;
for i=goodscel
    ii=ii+1;
    plot(time{i} , smooth(v{i} , 10) , 'color' , colorses(ii,:) , 'LineWidth', 1.3);
    hold on
end;

gr={};
tim={};
for i=goodscel
    gr={gr{:} , smooth(diff(smooth(v{i} , smsp)) , smsp)'};
    tim={tim{:} , time{i}(2:end)};
end;
zt=[];
zgr=[];
colorses=hsv(length(gr));
fii=figure;
set(fii,'Position',[251 , 451 , 679 , 346]);
for i=1:length(gr)
    plot(tim{i} , gr{i} , 'color' , colorses(i,:) , 'LineWidth', 1.3);
    hold on
    
    zt=[zt , tim{i}];
    zgr=[zgr , gr{i}];
end;
minim=min(zt);
maxim=max(zt);

t(1)=minim;

i=1;

while t(i)<maxim
    i=i+1;
    t(i)=min(zt(zt>t(i-1)));
end;

grt={};
meangr=[];
stdgr=[];
for i=1:length(t)
    grt{i}=zgr(zt==t(i));
    meangr=[meangr , mean(grt{i})];
    stdgr=[stdgr , std(grt{i})/sqrt(length(grt{i}))];
end;
figure;
errorbar(t , meangr , stdgr);
m1=zgr(zt<315);
m2=zgr((zt>=315)&(zt<600));
m3=zgr(zt>=600);

figure;
errorbar([1 , 2 , 3] , [mean(m1) , mean(m2) , mean(m3)] , [std(m1)/sqrt(length(m1)) , std(m2)/sqrt(length(m2)) , std(m3)/sqrt(length(m3))]);

% figure;
% boxplot(m1);
% hold on;
% boxplot(m2 , 'axes' , 2);
% hold on;
% boxplot(m3 , 'axes' , 3);

% figure;
% 
% x=-500000:1000:500000;
% hist(differ , x);
% hold on;
% disp(mean(num2str(differ)));
% 
% 
% mu=mean(differ);
% su=std(differ);
% y=mu+su*randn(1, length(differ));
% 
% nnn=hist(y , x);
% 
% plot(x , nnn , 'color' , 'r');
% figure;
% boxplot(differ);


end

