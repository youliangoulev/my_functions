function [out] = stim1( input, permeability, yap, yapox, ysort, promon1, promof1, arnmg, arnmdeg, protg, protdeg, H2O2iedeg , nbstep)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here




    
    
    
    
H202=input;
perm=permeability;
H202i=0;
arnmok=arnmg;
H2O2deg=H2O2iedeg;
arndeg=arnmdeg;
arnm=0;
protok=protg;
protmdeg=protdeg;
yox=yapox;
pron=promon1;
Yap1c=yap;
Yap1n=0;
promon=0;
promof=promof1;
prot=0;
nstep=nbstep;
protv=[];
yapne=[];
ARNm=[];
h2o2=[];


for jjj=1:nstep;
% one step

for i=1:H202

   if rand<=perm
       H202i=H202i+1;
   end
end

if prot>0 && H202i>0

    for i=1:prot

        x=0;
        go=0;
          while x<H202i && go==0
          x=x+1;  
            if rand<=H2O2deg
            H202i=H202i-1;
            go=1;
            end
          end  
          
         
    end
end

if H202i>0 && Yap1c>0
lol=H202i;
    for i=1:lol 

        x=0;
        go=0;
          while x<Yap1c && go==0
          x=x+1;  
            if rand<=yox
            H202i=H202i-1;
            Yap1c=Yap1c-1;
            Yap1n=Yap1n+1;
            go=1;
            end
          end  
          
         
    end
end

if Yap1n>0 
    lon=Yap1n;
    
    for i=1:lon
       if rand<=ysort
       Yap1n=Yap1n-1;
       Yap1c=Yap1c+1;
       end
    end
    
end

if Yap1n>0 && promon==0
    
    for i=1:Yap1n
       if rand<=pron;
       promon=1;
       end
    end
     
end

if promon==1
    
       if rand<=promof;
       promon=0;
       end
       
       if rand<=arnmok;
       arnm = arnm+1;
       end
       
end

if arnm>0
 for i=1:arnm   
       if rand<=arndeg;
       arnm = arnm-1;
       end
 end  
end

if arnm>0
    
    for i=1:arnm
         if rand<=protok
         prot=prot+1;
         end
    end
end
    
if prot>0
    
    for i=1:prot
         if rand<=protmdeg
         prot=prot-1;
         end
    end
end




protv=[protv, prot];
yapne=[yapne, Yap1n];
h2o2=[h2o2, H202i];
ARNm=[ARNm, arnm];   

% 1step
end

h=1:1:nstep;
plot (h  ,   protv, 'LineWidth',2);
 hold on
 plot (h  , yapne, 'r','LineWidth',2.5);
 hold on
 plot (h  , ARNm, 'g','LineWidth',2.5);
 hold on
 plot (h  , h2o2, 'c','LineWidth',2.5);
hold on



end

