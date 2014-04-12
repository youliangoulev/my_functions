function [celltfluo , celltime , cellnenrfluo , cellvolume] = nucfluointensity(resolution ,chanelfluo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



%============================================

filter=1; % 0 = no filter  ||  1 = filter

bgd=700; % backgrownd level (700 en general)
difcyt=1; % cyt fluorescence ratio cut (cf. the estimation of this at the end of the function)
inc=0; % increasing backgrownd level per frame (reasonnably 0.5)

%============================================


global segmentation;
global dif;

disp(' ');
prob=false;
cha=chanelfluo;
celnfluo={};
celcfluo={};
celvolume={};
celapp=[];
doublets={};
celtime={};
celtfluo={};
celnenrfluo={};
celtest={};
goodcell=[];

%=======================================

%=======================================
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
%=======================================

%=======================================


for i=1:length(segmentation.tcells1)
    if ((segmentation.tcells1(i).mother>0) || (segmentation.tcells1(i).detectionFrame==1))&&(celobj(i)>1)&&(segmentation.tcells1(i).birthFrame<segmentation.tcells1(i).Obj(celobj(i)).image)
        
        goodcell=[goodcell , i];
    end;
end;

%celapp
%========================================
for i=goodcell
    if segmentation.tcells1(i).birthFrame== 0
        celapp=[celapp , 1];
    else
    celapp=[celapp , segmentation.tcells1(i).birthFrame-segmentation.tcells1(i).detectionFrame+1];
    end;
end;

%========================================

%celtime
%========================================
ii=0;
for i=goodcell 
  ii=ii+1;
  x=[];
  for j=celapp(ii):celobj(i)  

      x=[x , segmentation.tcells1(i).Obj(j).image.*resolution-resolution];
  end  
   celtime={celtime{:}, x};    
end;
%========================================

%celdoublets + %filter
%========================================
for i=goodcell   
 if isempty(segmentation.tcells1(i).daughterList)
    doublets={doublets{:} , zeros(1,celobj(i))}; 
 else
  q=[];
  for j=1:celobj(i)   
  t=segmentation.tcells1(i).Obj(j).image;
  y=0;
      for w=1:length(segmentation.tcells1(i).daughterList)
          a=segmentation.tcells1(i).daughterList(w);
          if (t>=segmentation.tcells1(a).detectionFrame)&&(t<segmentation.tcells1(a).birthFrame)&&(t<=segmentation.tcells1(a).Obj(celobj(a)).image) %%%test
               y=a;   
          end;
      end;
  q=[q y];
  end;
 doublets={doublets{:} , q};
 end;
end;
%========================================

% celnfluo={};
% celcfluo={};
% celarea={};
% celtfluo={};
% celnenrfluo={};
%========================================
ii=0;

    
%======
dal=length(goodcell);
sqi=0;
h11=waitbar(0 , 'fluorescence dynamic processing');
%======  


for i=goodcell  
    
       
    
ii=ii+1;
tfluo=[];
cfluo=[];
nfluo=[];
volume=[];
test=[];
nenrfluo=[];
for j=celapp(ii):celobj(i)    
    if doublets{ii}(j)==0
        

        
        
    tot=segmentation.tcells1(i).Obj(j).fluoMean(cha)-bgd-(segmentation.tcells1(i).Obj(j).image)*inc; %%%
    totarea=segmentation.tcells1(i).Obj(j).area;
    totvolume=(4*sqrt(totarea*totarea*totarea/pi))/3;
         if segmentation.tcells1(i).Obj(j).Mean.n>0
             n=segmentation.tcells1(i).Obj(j).Mean.n;
             time=segmentation.tcells1(i).Obj(j).image;
             nt=time-segmentation.tnucleus(n).detectionFrame+1;
             nuc=segmentation.tnucleus(n).Obj(nt).fluoMean(cha)-bgd-(segmentation.tnucleus(n).Obj(nt).image)*inc;  %%%
             nucarea=segmentation.tnucleus(n).Obj(nt).area;
             cyt=(tot*totarea-nuc*nucarea)/(totarea-nucarea);
%              
%              R=sqrt(totarea/pi);
%              r=sqrt(nucarea/pi);
%              coefw=1-r/R;

if tot<0
    prob=true;
    disp(['attention !!! cell ' , num2str(i) , 'not present or negative fluorescence at frame ' , num2str(segmentation.tcells1(i).Obj(j).image)]);
end;

             calcoef( i , n , j , nt);
             nucenr=(nuc-cyt*difcyt)/(tot); % difcyt
         else
             nuc=0;
             nucarea=0;
             cyt=tot;
             nucenr=0;
         end;
    else
diff=segmentation.tcells1(doublets{ii}(j)).detectionFrame-segmentation.tcells1(i).detectionFrame;
xxx=segmentation.tcells1(i).Obj(j).area;
yyy=segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).area;
totvolume=((4*sqrt(xxx*xxx*xxx/pi))/3)+(4*sqrt(yyy*yyy*yyy/pi))/3;
totarea=segmentation.tcells1(i).Obj(j).area+segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).area;
tot=((segmentation.tcells1(i).Obj(j).fluoMean(cha)-bgd-(segmentation.tcells1(i).Obj(j).image)*inc)*segmentation.tcells1(i).Obj(j).area+(segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).fluoMean(cha)-bgd-(segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).image)*inc)*segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).area)/totarea; %%%
         if segmentation.tcells1(i).Obj(j).Mean.n>0
             n=segmentation.tcells1(i).Obj(j).Mean.n;
             time=segmentation.tcells1(i).Obj(j).image;
             nt=time-segmentation.tnucleus(n).detectionFrame+1;
             nucx=segmentation.tnucleus(n).Obj(nt).fluoMean(cha)-bgd-(segmentation.tnucleus(n).Obj(nt).image)*inc;  %%%
             nucareax=segmentation.tnucleus(n).Obj(nt).area;
             calcoef( i , n , j , nt);
         else
             nucx=0;
             nucareax=0;
         end;
         if segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).Mean.n>0
             n=segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).Mean.n;
             time=segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).image;
             nt=time-segmentation.tnucleus(n).detectionFrame+1;
             nucy=segmentation.tnucleus(n).Obj(nt).fluoMean(cha)-bgd-(segmentation.tnucleus(n).Obj(nt).image)*inc;  %%%
             nucareay=segmentation.tnucleus(n).Obj(nt).area;
             calcoef( doublets{ii}(j) , n , j-diff , nt);
         else
             nucy=0;
             nucareay=0;
         end;
        if (nucareax>0)||(nucareay>0)
        nuc=(nucx*nucareax+nucy*nucareay)/(nucareax+nucareay);
        nucarea=(nucareax+nucareay);
        cyt=(tot*totarea-nuc*nucarea)/(totarea-nucarea);
        
%              R1=sqrt(xxx/pi);
%              R2=sqrt(yyy/pi);
%              r1=sqrt(nucareax/pi);
%              r2=sqrt(nucareay/pi);
%              coefw1=1-r1/R1;
%              coefw2=1-r2/R2;
             tot1=segmentation.tcells1(i).Obj(j).fluoMean(cha)-bgd-(segmentation.tcells1(i).Obj(j).image)*inc;
             tot2=segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).fluoMean(cha)-bgd-(segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).image)*inc;
             cyt1=(tot1*xxx-nucx*nucareax)/(xxx-nucareax);
             cyt2=(tot2*yyy-nucy*nucareay)/(yyy-nucareay);
%              nucer1=nucx-cyt1*coefw1;
%              nucer2=nucy-cyt2*coefw2;
%              nucer=(nucer1*nucareax+nucer2*nucareay)/(nucareax+nucareay);
             
  if tot1<0
      prob=true;
      disp(['attention !!! cell ' , num2str(i) , 'not present or negative fluorescence at frame ' , num2str(segmentation.tcells1(i).Obj(j).image)]);
  end;

  if tot2<0
      prob=true;
      disp(['attention !!! cell ' , num2str(doublets{ii}(j)) , 'not present or negative fluorescence at frame ' , num2str(segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).image)]);
  end;
              nucstep=((nucx-cyt1*difcyt)*nucareax+(nucy-cyt2*difcyt)*nucareay)/(nucareax+nucareay); 
              nucenr=(nucstep)/(tot);
        else
             nuc=0;
             nucarea=0;
             cyt=tot;
             nucenr=0;
        end;
    end;
tfluo=[tfluo , tot];
cfluo=[cfluo , cyt];
nfluo=[nfluo , nuc];
volume=[volume , totvolume];
nenrfluo=[nenrfluo , nucenr];
test=[test , cyt./tot];

end;
celtest={celtest{:} , test};
celnfluo={celnfluo{:} , nfluo};
celcfluo={celcfluo{:} , cfluo};
celvolume={celvolume{:} , volume};
celtfluo={celtfluo{:} , tfluo};
celnenrfluo={celnenrfluo{:} , nenrfluo};

%==========    
sqi=sqi+1;    
if (sqi/dal>=0.01)||(ii/dal==1)
    sqi=0;
    waitbar(ii/dal, h11);

end;
%==========

end;

%==========
close(h11);
drawnow;
%==========


%========================================

%out
%========================================
celltfluo=celtfluo;  %total fluorescence
cellcfluo=celcfluo;  %cytoplasmic fluorescence
cellnfluo=celnfluo;  %nuclear fluorescence
cellnenrfluo=celnenrfluo;  %nuclear fluorescence enrichment
cellvolume=celvolume;
celltime=celtime;


disp(['difcyt moyen : ' , num2str(mean(dif)) , '| ecartype : ' , num2str(std(dif)) , '| noyaux analysés : ' , num2str(length(dif))]);

disp(' ');

end





%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%===============================================================================================================================================
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






function calcoef(celln , nucle , framec , framen)

global segmentation;
global dif;

x1=segmentation.tcells1(celln).Obj(framec).ox;
x2=segmentation.tnucleus(nucle).Obj(framen).ox;
y1=segmentation.tcells1(celln).Obj(framec).oy;
y2=segmentation.tnucleus(nucle).Obj(framen).oy;
Sn=segmentation.tnucleus(nucle).Obj(framen).area;
Sc=segmentation.tcells1(celln).Obj(framec).area;
d=sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
if sqrt(Sc/pi)<d+sqrt(Sn/pi)
    R=d+sqrt(Sn/pi);
    Vconus=2*Sn*sqrt(R*R-d*d);
    Vdiffe=Vconus-4*sqrt(Sn*Sn*Sn/pi)/3;
    Idiffe=Vdiffe/Sn;
    Imoyen=4*sqrt(Sc/pi)/3;
    dif=[dif , Idiffe/Imoyen];

else
dif=[dif , ((3*sqrt(1-pi*d*d/Sc))/2)-sqrt(Sn/Sc)];
end;


end






%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%===============================================================================================================================================
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






function [aut]=outlayers(resolution ,chanelfluo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%$$$$$$$$$$$$$$$$$$$$$$$$$

celimitn=300; % min number of events to be scored (window of time)
alpha=0.05; % p-value for testing mean and std between windows of min number of events
certitudegoods=0.1; % tolerated relative error for estimation of the good events

binseuil=0.011; %   0.002 for 60x obj   ||   0.011 for 100x obj
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
disp(['ratio eliminated errors / maximum errors : ' , num2str(eler/maxier)]);
disp(['maximum good data : ' , num2str(maxgd)]);
disp(['conserved good data : ' , num2str(keegd)]);
disp(['ratio conserved good data / maximum good data : ' , num2str(keegd/maxgd)]);
disp(' ');

aut=cellength;

end

