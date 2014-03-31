function [celltfluo , cellcfluo , cellnfluo ,  cellnenrfluo , cellvolume , celltime] = nucfluointensity(resolution ,chanelfluo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


bgd=700;
difcyt=1;
inc=0;
global segmentation;
global dif;

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
for i=1:length(segmentation.tcells1)
    if ((segmentation.tcells1(i).mother>0) || (segmentation.tcells1(i).detectionFrame==1))&&(length(segmentation.tcells1(i).Obj)>1)&&(segmentation.tcells1(i).birthFrame<segmentation.tcells1(i).lastFrame)
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
  for j=celapp(ii):length(segmentation.tcells1(i).Obj)  

      x=[x , segmentation.tcells1(i).Obj(j).image.*resolution-resolution];
  end  
   celtime={celtime{:}, x};    
end;
%========================================

%celdoublets
%========================================
for i=goodcell   
 if isempty(segmentation.tcells1(i).daughterList)
    doublets={doublets{:} , zeros(1,length(segmentation.tcells1(i).Obj))}; 
 else
  q=[];
  for j=1:length(segmentation.tcells1(i).Obj)   
  t=segmentation.tcells1(i).Obj(j).image;
  y=0;
      for w=1:length(segmentation.tcells1(i).daughterList)
          a=segmentation.tcells1(i).daughterList(w);
          if (t>=segmentation.tcells1(a).detectionFrame)&&(t<segmentation.tcells1(a).birthFrame)
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
for i=goodcell
ii=ii+1;
tfluo=[];
cfluo=[];
nfluo=[];
volume=[];
test=[];
nenrfluo=[];
for j=celapp(ii):length(segmentation.tcells1(i).Obj)    
    if doublets{ii}(j)==0
    tot=segmentation.tcells1(i).Obj(j).fluoMean(cha)-bgd-segmentation.tcells1(i).Obj(j).image*inc; %%%
    totarea=segmentation.tcells1(i).Obj(j).area;
    totvolume=(4*sqrt(totarea*totarea*totarea/pi))/3;
         if segmentation.tcells1(i).Obj(j).Mean.n>0
             n=segmentation.tcells1(i).Obj(j).Mean.n;
             time=segmentation.tcells1(i).Obj(j).image;
             nt=time-segmentation.tnucleus(n).detectionFrame+1;
             nuc=segmentation.tnucleus(n).Obj(nt).fluoMean(cha)-bgd-segmentation.tnucleus(n).Obj(nt).image*inc;  %%%
             nucarea=segmentation.tnucleus(n).Obj(nt).area;
             cyt=(tot*totarea-nuc*nucarea)/(totarea-nucarea);
%              
%              R=sqrt(totarea/pi);
%              r=sqrt(nucarea/pi);
%              coefw=1-r/R;
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
tot=((segmentation.tcells1(i).Obj(j).fluoMean(cha)-bgd-segmentation.tcells1(i).Obj(j).image*inc)*segmentation.tcells1(i).Obj(j).area+(segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).fluoMean(cha)-bgd-segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).image*inc)*segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).area)/totarea; %%%
         if segmentation.tcells1(i).Obj(j).Mean.n>0
             n=segmentation.tcells1(i).Obj(j).Mean.n;
             time=segmentation.tcells1(i).Obj(j).image;
             nt=time-segmentation.tnucleus(n).detectionFrame+1;
             nucx=segmentation.tnucleus(n).Obj(nt).fluoMean(cha)-bgd-segmentation.tnucleus(n).Obj(nt).image*inc;  %%%
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
             nucy=segmentation.tnucleus(n).Obj(nt).fluoMean(cha)-bgd-segmentation.tnucleus(n).Obj(nt).image*inc;  %%%
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
%              tot1=segmentation.tcells1(i).Obj(j).fluoMean(cha)-bgd-segmentation.tcells1(i).Obj(j).image*inc;
%              tot2=segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).fluoMean(cha)-bgd-segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).image*inc;
%              cyt1=(tot1*xxx-nucx*nucareax)/(xxx-nucareax);
%              cyt2=(tot2*yyy-nucy*nucareay)/(yyy-nucareay);
%              nucer1=nucx-cyt1*coefw1;
%              nucer2=nucy-cyt2*coefw2;
%              nucer=(nucer1*nucareax+nucer2*nucareay)/(nucareax+nucareay);
             
             
             
              nucenr=(nuc-cyt*difcyt)/(tot);
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



end;
%========================================

%out
%========================================
celltfluo=celtfluo;
cellcfluo=celcfluo;
cellnfluo=celnfluo;
cellnenrfluo=celnenrfluo;
cellvolume=celvolume;
celltime=celtime;
b=[];
for i=1:length(celnenrfluo)
    if celtime{i}(1)<300
        b=[b , i];
    end;
end;
colorses=hsv(length(b));
figure;
ii=0;
for i=b
    ii=ii+1;
    plot(celtime{i} , celnenrfluo{i} , 'color' , colorses(ii,:));
    hold on
end;
figure;
ii=0;
for i=b
    ii=ii+1;
    plot(celtime{i} , celvolume{i} , 'color' , colorses(ii,:));
    hold on
end;

%plotnf(celtime , celtest , 300 , 8);


disp(['difcyt moyen : ' , num2str(mean(dif)) , '| ecartype : ' , num2str(std(dif)) , '| noyaux analysés : ' , num2str(length(dif))]);


end

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
    % disp(['BAD' , num2str(Idiffe/Imoyen)]);
else
dif=[dif , ((3*sqrt(1-pi*d*d/Sc))/2)-sqrt(Sn/Sc)];

    % disp(['goodi' , num2str(((3*sqrt(1-pi*d*d/Sc))/2)-sqrt(Sn/Sc))]);
end;


end

