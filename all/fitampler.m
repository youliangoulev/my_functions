function out = fitampler ( fig,a,b )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

y1=[];
y2=[];
mlop=[];
ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');
plom=0;
for i=1:length(c)

  if (c{i}(1)<=a)&&(c{i}(length(c{i}))>=b)
      for z=1:length(c{i})
          if c{i}(z)==a
              a1=z;
          else
              if c{i}(z)==b
              b1=z;
              end
          end
      end
      plom=plom+1;
      mlop=horzcat(mlop,(p{i}(b1)-p{i}(a1))/p{i}(a1));
  end

end
w=std(mlop)/sqrt(plom);
out=w
end

