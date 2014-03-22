function out = figmodality( fig )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


u=[];
z=[]; 
m=[];
f1=[];
h{2000}=[];
for i=1:1000
    x{i}=[];
end
y=[];
ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');
for i=1:length(c)
  for j=1:length(c{i})
      h{c{i}(j)+1}=[h{c{i}(j)+1},p{i}(j)];
  end
out=h;
end

