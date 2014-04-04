function [a , b , c , d]=test1(resolution ,chanelfluo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global segmentation;

cha=chanelfluo;




esize=[];
lo=[];
efluo=[];
etime=[];
k=[];
xr=[];
choosec=[];
celnu=[];
framnu=[];
c=[];
tlo=[];
signi=[];
x=[];

for i=1:length(segmentation.tcells1)
    if length(segmentation.tcells1(i).Obj)>1
        choosec=[choosec , i];
        for j=2:length(segmentation.tcells1(i).Obj)
            esize=[esize , abs(segmentation.tcells1(i).Obj(j).area-segmentation.tcells1(i).Obj(j-1).area)];
            efluo=[efluo , abs(segmentation.tcells1(i).Obj(j).fluoMean(cha)-segmentation.tcells1(i).Obj(j-1).fluoMean(cha))];
            etime=[etime , abs(segmentation.tcells1(i).Obj(j).image*resolution-resolution)];
            celnu=[celnu , i];
            framnu=[framnu , j];
        end;
    end;
end;

for i=1:length(esize)    
             produit=sum((esize>=esize(i))/length(esize))*(sum((efluo>=efluo(i))/length(efluo)));
             k=[k , produit];
             c=[c , produit*(1-ln(produit))];
end;


n=length(k);

for i=1:n
    la=sum(k<=k(i));
    lo=[lo , la];
    tlo=[tlo , n*c(i)];
    if (c(i)>0)&&(lo(i)-tlo(i)>0)
        x=[x , (lo(i)-tlo(i))/(1-c(i))];
    else
        x=[x , 0];
    end;
    
    if 1-binocdf(la-1 , n , c(i))>=0.05
        signi=[signi , i];
    end;
end;

maxx=max(x(signi));

for i=1:n
    xr=[xr , lo(i)-c(i)*(n-maxx)];
end;
opti1=0;
indic1=[];
indic2=[];
indic3=[];
for i=signi
   if xr(i)*((n-maxx)*(1-c(i)))>opti1
       opti1=xr(i)*((n-maxx)*(1-c(i)));
       indic1=[];
       indic1=[indic1 , i];
   else
       if xr(i)*((n-maxx)*(1-c(i)))==opti1
           indic1=[indic1 , i];
       end;
   end;
end;

if length(indic1)>1
    
    opti2=1;
    
    for i=indic1
        if abs((xr(i)/maxx)-(1-c(i)))<opti2
            opti2=abs((xr(i)/maxx)-(1-c(i)));
            indic2=[];
            indic2=[indic2 , i];
        else    
            if abs((xr(i)/maxx)-(1-c(i)))==opti2
               indic2=[indic2 , i]; 
            end;
        end;
    end;
   
    if length(indic2)>1
    
    opti3=0;
    
    for i=indic2
        if xr(i)>opti3
            opti3=xr(i);
            indic3=[];
            indic3=[indic3 , i];
        else    
            if xr(i)==opti3
               indic3=[indic3 , i]; 
            end;
        end;
    end;
    
      if length(indic3)>1
          kfinde=min(k(indic3));
      else
          kfinde=k(indic3);
      end;
    else
        kfinde=k(indic2);
    end;
else
    kfinde=k(indic1);
    
end;
a=esize;
b=efluo;
c=etime;
d=k;

end
