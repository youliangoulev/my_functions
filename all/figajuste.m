function [ output_args ] = figajuste( fig,a )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x={};
for i=1:500
    x{i}=[];
end
y=[];
ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');
colorses=hsv(length(c));
for i=1:length(c)
  for j=1:length(c{i})
      c{i}(j)=c{i}(j)+a;
  end
end
figure
for i=1:length(c)
plot(c{i},p{i},'color',colorses(i,:),'LineWidth',2);
hold on

end
end

