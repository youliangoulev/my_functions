function plotnf( w , a , limit , smsp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


b=[];
for i=1:length(w)
    if w{i}(1)<limit
        b=[b , i];
    end;
end;
colorses=hsv(length(b));
figure;
ii=0;
for i=b
    ii=ii+1;
    plot(w{i} , smooth(a{i} , smsp) , 'color' , colorses(ii,:));
    hold on
end;


end

