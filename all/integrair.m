function out = integrair( fig )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


x={};
for u=1:80
    x{u}=[];
end

m=0;
y=0;
ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');
for i=1:length(c)
    
    for j=1:length(c{i})

        x{c{i}(j)}=[x{c{i}(j)},p{i}(j)];
    end
end    
for i=1:11
    m=m+mean(x{i});
end
m=m/11;
for i=12:28
    y=y+(mean(x{i})-m)*3;
end

out=y;

m;
%===========================================================
end