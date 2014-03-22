function out = fitficroissance( fig,lengthmin, begin, endi )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Upload figure data
%===============================================

x=[];
y=[];
ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');

for i=1:length(c)
    
    p(i)=log(p(i));
    
end

mmi=polyfit(c,p,1);

l=[min(c):1:max(c)];
for i=1:length(l)
     m(i)=mmi(1)*l(i)+mmi(2);
 
end

figure;
scatter(c,p,'.');
hold on
plot(l,m,'r','LineWidth',2.5);
hold off

%     ez=1;
%     while (ez<length(c))&&(c(ez)<begin)
%         ez=ez+1;
%     end
%     if (c(ez)>=begin)&&(c(ez)<=endi)
%         if (c(end)>endi)
%             if (endi-c(ez)>=lengthmin)
%                 erz=ez;
%                 while (c(erz+1)<=endi)
%                     erz=erz+1;
%                 end
%                 x=horzcat(x,c(ez:erz));
%                 y=horzcat(y,p(ez:erz));
%             end
%         else
%             if (c{i}(end)-c{i}(ez)>=lengthmin)
%                 x=horzcat(x,c{i}(ez:end)); 
%                 y=horzcat(y,p{i}(ez:end));
%             end
%         end
%     end

out=mmi(1);




%========================================================

%Fitting
%========================================================






end

