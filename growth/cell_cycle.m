function [ output_args ] = cell_cycle( stresstiming , resolution , chanelfluo )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% declaration
framet=3;
filter=0;
global segmentation;
cha=chanelfluo;
stress=round(stresstiming/framet)+1;
%% cel duration estimation
if filter
    celobj=outlayers(resolution , cha);
else

cellengtha=[];
for i=1:length(segmentation.tcells1)   
    if segmentation.tcells1(i).N>0
    cellengtha=[cellengtha , length(segmentation.tcells1(i).Obj)];
    else
    cellengtha=[cellengtha , 0];
    end;
end;

     celobj=cellengtha;
end;
%% cel selection
goodcel=[];
for i=1:length(segmentation.tcells1)
    if (length(segmentation.tcells1(i).daughterList)>1)&&(segmentation.tcells1(i).birthFrame<stress)&&(segmentation.tcells1(i).divisionTimes(2)<=segmentation.tcells1(i).Obj(celobj(i)).image)&&(segmentation.tcells1(i).detectionFrame<stress)
        goodcel=[goodcel , i];
    end;
end;
%% calcule of the cell cycle durations
before_mothers1=[];
before_mlengths=[];
celid=[];
budid=[];
sizmother_before=[];
sizbud_before=[];
before_daughters1=[];
before_dlengths=[];
for i=goodcel
    for j=2:length(segmentation.tcells1(i).divisionTimes)
        if (segmentation.tcells1(i).divisionTimes(j)<stress)&&(segmentation.tcells1(i).divisionTimes(j)<=segmentation.tcells1(i).Obj(celobj(i)).image)
            before_mothers1=[before_mothers1 , segmentation.tcells1(i).divisionTimes(j-1)];
            before_mlengths=[before_mlengths , segmentation.tcells1(i).divisionTimes(j)-segmentation.tcells1(i).divisionTimes(j-1) ];
            frm=segmentation.tcells1(i).divisionTimes(j)-segmentation.tcells1(i).detectionFrame+1;
            sizmother_before=[sizmother_before , segmentation.tcells1(i).Obj(frm).area];
            celid=[celid , i];
        else
            break;
        end;
    end;
end;
dd=1:length(before_mothers1);
inthere=true;
while inthere
    inthere=false;
    for i=dd
        if before_mothers1(i)+mean(before_mlengths(dd))+3*std(before_mlengths(dd))>stress
            dd=dd(before_mothers1(dd)<max(before_mothers1(dd)));
            inthere=true;
            break;
        end;
    end;
end;
celid(1);
end
%% outlayers function
function [aut]=outlayers(resolution ,chanelfluo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%$$$$$$$$$$$$$$$$$$$$$$$$$

celimitn=300; % min number of events to be scored (window of time)
alpha=0.05; % p-value for testing mean and std between windows of min number of events
certitudegoods=0.1; % tolerated relative error for estimation of the good events

binseuil=0.0011; %   0.002 for 60x obj   ||   0.011 for 100x obj   et 0.0011
ratior=2; %   1000 for 60x obj   ||   2 for 100x obj

%$$$$$$$$$$$$$$$$$$$$$$$$$

global segmentation;

cha=chanelfluo;

totev=0;
totelmev=0;
maxier=0;
eler=0;
maxgd=0;
keegd=0;
cellength=[];

for i=1:length(segmentation.tcells1)   
    if segmentation.tcells1(i).N>0
    cellength=[cellength , length(segmentation.tcells1(i).Obj)];
    else
    cellength=[cellength , 0];
    end;
end;


%£££££££££££££££££££££££££


celnu000=[];
framnu000=[];
etime000=[];
efluo000=[];
esize000=[];


%======
dal=length(segmentation.tcells1);
sqi=0;
h11=waitbar(0 , 'estimation of the differences between frames');
%======





%=
%=
%=
for i=1:length(segmentation.tcells1)   
    if length(segmentation.tcells1(i).Obj)>1
        for j=2:length(segmentation.tcells1(i).Obj)
            esize000=[esize000 , (segmentation.tcells1(i).Obj(j).area-segmentation.tcells1(i).Obj(j-1).area)];
            efluo000=[efluo000 , (segmentation.tcells1(i).Obj(j).fluoMean(cha)-segmentation.tcells1(i).Obj(j-1).fluoMean(cha))];
            etime000=[etime000 , (segmentation.tcells1(i).Obj(j).image)];
            celnu000=[celnu000 , i];
            framnu000=[framnu000 , j];
            
            
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

%#########################################################################

temiii=1:length(etime000);
maxtim=max(etime000);
mmp=2;
nnp=2;
before=true;

while (sum((etime000>=mmp)&(etime000<=nnp))<celimitn)&&(nnp<maxtim)
    nnp=nnp+1;
end;
matcompx=(etime000>=mmp)&(etime000<=nnp);
comparex=temiii(matcompx);   

while before
efluo=[];
etime=[];
esize=[];
celnu=[];
framnu=[];

lo=[];
tlo=[];

k=[];
c=[];

signi=[];
x=[];
xr=[];

compare=comparex;

efluo=efluo000(compare);
esize=esize000(compare);

etime=etime000(compare);
celnu=celnu000(compare);
framnu=framnu000(compare);

if nnp==maxtim
   before=false; 
end;

if before
stillin=true;    
 while stillin   
    mmp=nnp+1;
    nnp=mmp;
    
    while (sum((etime000>=mmp)&(etime000<=nnp))<celimitn)&&(nnp<maxtim)
    nnp=nnp+1;
    end;
    matcompx=(etime000>=mmp)&(etime000<=nnp);
    comparex=temiii(matcompx);
    if (sum((etime000>=mmp)&(etime000<=nnp))>=celimitn)
        [dddd,ppt1]=ttest2(esize000(compare) , esize000(comparex));
        [dddd,ppv1]=vartest2(esize000(compare) , esize000(comparex));
        [dddd,ppt2]=ttest2(efluo000(compare) , efluo000(comparex));
        [dddd,ppv2]=vartest2(efluo000(compare) , efluo000(comparex));        
        
        
        if (ppt1>alpha)&&(ppv1>alpha)&&(ppt2>alpha)&&(ppv2>alpha)
            efluo=[efluo , efluo000(comparex)];
            esize=[esize , esize000(comparex)];
            etime=[etime , etime000(comparex)];
            celnu=[celnu , celnu000(comparex)];
            framnu=[framnu , framnu000(comparex)];
            
             if (nnp==maxtim)
                 before=false;
                 stillin=false;
             end;
        else     
            stillin=false;
        end;
    else
        efluo=[efluo , efluo000(comparex)];
        esize=[esize , esize000(comparex)];
        etime=[etime , etime000(comparex)];
        celnu=[celnu , celnu000(comparex)];
        framnu=[framnu , framnu000(comparex)];
        before=false;
        stillin=false;
    end;
    
    
 end; 
end;

[ddd , ppp1]=ttest(esize);
[ddd , ppp2]=ttest(efluo);

if ppp1<=alpha
    esize=abs(esize-mean(esize));
else
    esize=abs(esize);
end;

if ppp2<=alpha
    efluo=abs(efluo-mean(efluo));
else
    efluo=abs(efluo);
  
end;


%=
%=
%=
for i=1:length(esize)    
             produit=sum((esize>=esize(i))/length(esize))*(sum((efluo>=efluo(i))/length(efluo)));
             k=[k , produit];
             c=[c , produit*(1-log(produit))];
              

end;
%=
%=
%=


%++++++++++++++++
%++++++++++++++++

n=length(k);


%=
%=
%=
for i=1:n
    la=sum(k<=k(i));
    lo=[lo , la];
    tlo=[tlo , n*c(i)];
    if ((n-lo(i))>0)&&(sqrt(c(i)/(n-lo(i)))<certitudegoods)&&(1-c(i)>0)&&(lo(i)-tlo(i)>0)
        x=[x , (lo(i)-tlo(i))/(1-c(i))];
    else
        x=[x , 0];
    end;

    if 1-binocdf(la-1 , n , c(i))<=binseuil
        signi=[signi , i];
    end;

    
    
end;
%=
%=
%=


%++++++++++++++++
%++++++++++++++++

if ~isempty(signi)

maxx=max(x(signi));

if maxx>0

%=
%=
%=
for i=1:n
   if x(i)>0
    xr=[xr , lo(i)-c(i)*(n-maxx)];
   else
    xr=[xr , 0];    
   end;
end;
%=
%=
%=

opti1=0;
indic1=[];
indic2=[];
indic3=[];


for i=signi
  if (xr(i)>=lo(i)/ratior)
   if (xr(i)*((n-maxx)*(1-c(i)))>opti1)
       opti1=xr(i)*((n-maxx)*(1-c(i)));
       indic1=[];
       indic1=[indic1 , i];
   else
       if xr(i)*((n-maxx)*(1-c(i)))==opti1
           indic1=[indic1 , i];
       end;
   end;
  end; 
end;

if opti1>0

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

disp(' ');
disp('--------------------------------------');
disp(['Time from : ' , num2str(min(etime)*resolution-2*resolution) , 'min to ' , num2str(max(etime)*resolution-resolution) , 'min']);
disp(' ');
disp(['total events : ' , num2str(n)]);
disp(['total eliminated events : ' , num2str(sum(k<=k(realindic)))]);
disp(['maximum detectable errors : ' , num2str(maxx)]);
disp(['k seuil : ' , num2str(k(realindic))]);
disp(['eliminated errors : ' , num2str(xr(realindic))]);
disp(['ratio eliminated errors / maximum errors : ' , num2str(xr(realindic)/maxx)]);
disp(['maximum good data : ' , num2str((n-maxx))]);
disp(['conserved good data : ' , num2str((n-maxx)*(1-c(realindic)))]);
disp(['ratio conserved good data / maximum good data : ' , num2str((1-c(realindic)))]);
totev=totev+n;
totelmev=totelmev+sum(k<=k(realindic));
maxier=maxier+maxx;
eler=eler+xr(realindic);
maxgd=maxgd+(n-maxx);
keegd=keegd+(n-maxx)*(1-c(realindic));
disp('--------------------------------------');

else
 
    disp(' ');
    disp('--------------------------------------');
    totev=totev+n;
    maxgd=maxgd+n;
    keegd=keegd+n;
    disp(['Time from : ' , num2str(min(etime)*resolution-2*resolution) , 'min to ' , num2str(max(etime)*resolution-resolution) , 'min']);
    disp(' ');
    disp(['total events : ' , num2str(n)]);
    disp('can not remove errors efficiently');
    disp('--------------------------------------');
    
end;

else
    disp(' ');
    disp('--------------------------------------');
    totev=totev+n;
    maxgd=maxgd+n;
    keegd=keegd+n;
    disp(['Time from : ' , num2str(min(etime)*resolution-2*resolution) , 'min to ' , num2str(max(etime)*resolution-resolution) , 'min']);
    disp(' ');
    disp(['total events : ' , num2str(n)]);
    disp('no errors detected');
    disp('--------------------------------------');
end;


else

disp(' ');
disp('--------------------------------------');
totev=totev+n;
maxgd=maxgd+n;
keegd=keegd+n;
disp(['total events : ' , num2str(n)]);
disp(['Time from : ' , num2str(min(etime)*resolution-resolution) , 'min to ' , num2str(max(etime)*resolution-resolution) , 'min']);
disp(' ');
disp('no errors detected');
disp('--------------------------------------');

end;


%******************
%++++++++++++++++++
%==================



end;

%#########################################################################

disp(' ');
disp('#######################################');
disp(' ');
disp(['total events : ' , num2str(totev)]);
disp(['total eliminated events : ' , num2str(totelmev)]);
disp(['maximum detectable errors : ' , num2str(maxier)]);
disp(['eliminated errors : ' , num2str(eler)]);
if maxier>0
disp(['ratio eliminated errors / maximum errors : ' , num2str(eler/maxier)]);
else   
end;
disp(['maximum good data : ' , num2str(maxgd)]);
disp(['conserved good data : ' , num2str(keegd)]);
disp(['ratio conserved good data / maximum good data : ' , num2str(keegd/maxgd)]);
disp(' ');

aut=cellength;

end