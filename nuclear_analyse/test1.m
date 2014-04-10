function [a]=test1(resolution ,chanelfluo)
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
celnu=[];
framnu=[];
c=[];
tlo=[];
signi=[];
x=[];
cellength=[];

%======
dal=length(segmentation.tcells1);
sqi=0;
h11=waitbar(0 , 'estimation of the distributions of the differences between frames');
%======

%=
%=
%=
for i=1:length(segmentation.tcells1)   
    if segmentation.tcells1(i).N>0
    cellength=[cellength , length(segmentation.tcells1(i).Obj)];
    else
    cellength=[cellength , 0];
    end;
    if length(segmentation.tcells1(i).Obj)>1
        for j=2:length(segmentation.tcells1(i).Obj)
            esize=[esize , abs(segmentation.tcells1(i).Obj(j).area-segmentation.tcells1(i).Obj(j-1).area)];
            efluo=[efluo , abs(segmentation.tcells1(i).Obj(j).fluoMean(cha)-segmentation.tcells1(i).Obj(j-1).fluoMean(cha))];
            etime=[etime , abs(segmentation.tcells1(i).Obj(j).image*resolution-resolution)];
            celnu=[celnu , i];
            framnu=[framnu , j];
            
            
        end;
    end;
    
%==========    
sqi=sqi+1;    
if (sqi/dal>=0.01)||(i/dal==1)
    sqi=0;
    waitbar(i/dal, h11);
end;
%==========

end;
%=
%=
%=


%==========
close(h11);
drawnow;
%==========

%++++++++++++++++
%++++++++++++++++


%==========
dal=length(esize);
sqi=0;
h11=waitbar(0 , 'probabilities calculation');
%==========

%=
%=
%=
for i=1:length(esize)    
             produit=sum((esize>=esize(i))/length(esize))*(sum((efluo>=efluo(i))/length(efluo)));
             k=[k , produit];
             c=[c , produit*(1-log(produit))];
             
%==========             
sqi=sqi+1;    
if (sqi/dal>=0.01)||(i/dal==1)
    sqi=0;
    waitbar(i/dal, h11);
end;
%==========  

end;
%=
%=
%=

%==========
close(h11);
drawnow;
%==========

%++++++++++++++++
%++++++++++++++++

n=length(k);

%==========
dal=n;
sqi=0;
h11=waitbar(0 , 'outlayers number estimation');
%==========

%=
%=
%=
for i=1:n
    la=sum(k<=k(i));
    lo=[lo , la];
    tlo=[tlo , n*c(i)];
    if (1-c(i)>0)&&(lo(i)-tlo(i)>0)
        x=[x , (lo(i)-tlo(i))/(1-c(i))];
    else
        x=[x , 0];
    end;

    if 1-binocdf(la-1 , n , c(i))<=0.05
        signi=[signi , i];
    end;
    
%==========             
sqi=sqi+1;    
if (sqi/dal>=0.01)||(i/dal==1)
    sqi=0;
    waitbar(i/dal, h11);
end;
%========== 
    
    
end;
%=
%=
%=

%==========
close(h11);
drawnow;
%==========

%++++++++++++++++
%++++++++++++++++

if ~isempty(signi)

maxx=max(x(signi));

%=
%=
%=
for i=1:n
    xr=[xr , lo(i)-c(i)*(n-maxx)];
end;
%=
%=
%=

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
          for amw=indic3
              if k(amw)==min(k(indic3))
                  realindic=amw;
              end;
          end;
      else
          kfinde=k(indic3);
          realindic=indic3;
      end;
    else
        kfinde=k(indic2);
        realindic=indic2;
    end;
else
    kfinde=k(indic1);
    realindic=indic1;
    
end;

for i=1:length(k)
    if k(i)<=kfinde
        if cellength(celnu(i))>framnu(i)-1           
           cellength(celnu(i))=framnu(i)-1;
        end;
    end;
end;

disp('total events : ' , num2str(n));
disp('maximum detectable errors : ' , num2str(maxx));
disp('k seuil : ' , num2str(k(realinduc)));
disp('eliminated errors : ' , num2str(xr(realindic)));
disp('ratio eliminated errors / maximum errors : ' , num2str(xr(realinduc)/maxx));
disp('maximum good data : ' , num2str((n-maxx)));
disp('keeped good data : ' , num2str((n-maxx)*(1-c(realinduc))));
disp('ratio keeped good data / maximum good data : ' , num2str((1-c(realinduc))));
disp('total eliminated events : ' , num2str(sum(k<=k(realinduc))));
else
disp('no errors detected');

end;



%******************
%++++++++++++++++++
%==================
a=cellength;

end

