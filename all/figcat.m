function out = figcat( fig1,fig2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=[];
y=[];
ch1=get(fig1,'Children');
l1=get(ch1,'Children');
c1=get(l1,'Xdata');
p1=get(l1,'Ydata');
ch2=get(fig2,'Children');
l2=get(ch2,'Children');
c2=get(l2,'Xdata');
p2=get(l2,'Ydata');
c3={c1{:},c2{:}};
p3={p1{:},p2{:}};
colorses=hsv(length(c3));
figure
for i=1:length(c3)
plot(c3{i},p3{i},'color',colorses(i,:),'LineWidth',2);
hold on
end


% for i=1:length(c)
%     ez=1;
%     while (ez<length(c{i}))&&(c{i}(ez)<begin)
%         ez=ez+1;
%     end
%     if (c{i}(ez)>=begin)&&(c{i}(ez)<=endi)
%         if (c{i}(end)>endi)
%             if (endi-c{i}(ez)>=lengthmin)
%                 erz=ez;
%                 while (c{i}(erz+1)<=endi)
%                     erz=erz+1;
%                 end
%                 x=horzcat(x,c{i}(ez:erz));
%                 y=horzcat(y,p{i}(ez:erz));
%             end
%         else
%             if (c{i}(end)-c{i}(ez)>=lengthmin)
%                 x=horzcat(x,c{i}(ez:end)); 
%                 y=horzcat(y,p{i}(ez:end));
%             end
%         end
%     end
% end

end

