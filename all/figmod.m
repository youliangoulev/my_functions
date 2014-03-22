function out = figmod( fig )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=[];
y=[];
ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');

out=p;

end

