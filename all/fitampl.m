function out = fitampl( fig )
%UNTITLED2 Summary of this function goes here



%   Detailed explanation goes here
% Upload figure data
%===============================================

y1=[];
y2=[];
mlop=[];
ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');
plom=0;
for i=1:length(p)
      for z=1:length(c{i})
          if c{i}(z)==9
              l=z;
          end
      end
  if (c{i}(1)<=2)&&(c{i}(length(c{i}))>=7)
      plom=plom+1;
   mlop=horzcat(mlop,mean(p{i}(l+3:l+5))-mean(p{i}(l:l+2)));
                y1=horzcat(y1,p{i}(l:l+2));
                y2=horzcat(y2,p{i}(l+3:l+5));
  end                
end
m(1)=mean(mlop);
m(2)=std(mlop)/sqrt(plom);
m(3)=mean(y2)-mean(y1);
out=m;

end

