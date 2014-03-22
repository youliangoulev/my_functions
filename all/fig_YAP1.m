function [ out ] = fig_YAP1( fig,a )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x=[];

ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');

for i=1:length(c)
m=0;
for j=1:length(c{i})
    if c{i}(j)>a
       if p{i}(j)>0.1
       m=m+p{i}(j)-0.1;    
       end
    end
end
x=[x , m];
end
out=x;

end

