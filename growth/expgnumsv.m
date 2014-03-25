function expgnumsv
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global segmentation

a=[1 25 50 75 100];
b=[0 72 147 222 297];

n=[];
s=[];
v=[];

for i=a
    nn=0;
    ss=0;
    vvv=0;
 for j=1:length(segmentation.cells1(i,:))
     if segmentation.cells1(i,j).area>0
         nn=nn+1;
         ss=ss+segmentation.cells1(i,j).area;
         vvv=vvv+(4*sqrt(segmentation.cells1(i,j).area*segmentation.cells1(i,j).area*segmentation.cells1(i,j).area/pi))/3;
     end;
 end;
 n=[n nn];
 s=[s ss];
 v=[v vvv];
end;

for i=1:4
    for j=i+1:5
        t=b(j)-b(i);
        d=t*(log(2)/(log(n(j))-log(n(i))));
        ['divn(' , num2str(b(i)) ,'->' , num2str(b(j)) , ')=' , num2str(d)]
                d=t*(log(2)/(log(s(j))-log(s(i))));
        ['divs(' , num2str(b(i)) ,'->' , num2str(b(j)) , ')=' , num2str(d)]
                d=t*(log(2)/(log(v(j))-log(v(i))));
        ['divv(' , num2str(b(i)) ,'->' , num2str(b(j)) , ')=' , num2str(d)]
        ''
    end;
    
end;

end

