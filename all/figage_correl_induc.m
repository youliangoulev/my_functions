function [ output_args ] = figage_correl_induc( fig,a )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


u=[];
z=[]; 
m=[];
f1=[];
x={};
for i=1:10000
    x{i}=[];
end
y=[];
ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');

for i=1:length(c)

u=[u,a-c{i}(1)];
for j=1:length(c{i})
    if c{i}(j)==a
        z=[z,p{i}(j)]
    end
end

end
figure

scatter(u,z);

end

