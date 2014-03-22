function [celltfluo , cellcfluo , cellnfluo ,  cellnenrfluo , cellarea , celltime] = nucfluooverall(resolution ,chanelfluo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global segmentation

cha=chanelfluo;
celnfluo={};
celcfluo={};
celarea={};
celapp=[];
doublets={};
celtime={};
celtfluo={};
celnenrfluo={};
goodcell=[];
for i=1:length(segmentation.tcells1)
    if ((segmentation.tcells1(i).mother>0) || (segmentation.tcells1(i).detectionFrame==0))&&(length(segmentation.tcells1(i).Obj)>1)&&(segmentation.tcells1(i).birthFrame<segmentation.tcells1(i).lastFrame)
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
area=[];
nenrfluo=[];
for j=celapp(ii):length(segmentation.tcells1(i).Obj)    
    if doublets{ii}(j)==0  
    totarea=segmentation.tcells1(i).Obj(j).area;
    tot=segmentation.tcells1(i).Obj(j).fluoMean(cha)*totarea;

         if segmentation.tcells1(i).Obj(j).Mean.n>0
             n=segmentation.tcells1(i).Obj(j).Mean.n;
             time=segmentation.tcells1(i).Obj(j).image;
             nt=time-segmentation.tnucleus(n).detectionFrame+1;
             nucarea=segmentation.tnucleus(n).Obj(nt).area;
             nuc=segmentation.tnucleus(n).Obj(nt).fluoMean(cha)*nucarea;
             cyt=(tot-nuc)/(totarea-nucarea);
             nucenr=(nuc-cyt*nucarea)/tot;
         else
             nuc=0;
             nucarea=0;
             cyt=tot;
             nucenr=0;
         end;
    else
diff=segmentation.tcells1(doublets{ii}(j)).detectionFrame-segmentation.tcells1(i).detectionFrame;
totarea=segmentation.tcells1(i).Obj(j).area+segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).area;
tot=(segmentation.tcells1(i).Obj(j).fluoMean(cha)*segmentation.tcells1(i).Obj(j).area+segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).fluoMean(cha)*segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).area);
         if segmentation.tcells1(i).Obj(j).Mean.n>0
             n=segmentation.tcells1(i).Obj(j).Mean.n;
             time=segmentation.tcells1(i).Obj(j).image;
             nt=time-segmentation.tnucleus(n).detectionFrame+1;
             nucareax=segmentation.tnucleus(n).Obj(nt).area;
             nucx=segmentation.tnucleus(n).Obj(nt).fluoMean(cha)*nucareax;
             
         else
             nucx=0;
             nucareax=0;
         end;
         if segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).Mean.n>0
             n=segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).Mean.n;
             time=segmentation.tcells1(doublets{ii}(j)).Obj(j-diff).image;
             nt=time-segmentation.tnucleus(n).detectionFrame+1;
             nucareay=segmentation.tnucleus(n).Obj(nt).area;
             nucy=segmentation.tnucleus(n).Obj(nt).fluoMean(cha)*nucareay;
  
         else
             nucy=0;
             nucareay=0;
         end;
        if (nucareax>0)||(nucareay>0)
        nuc=nucx+nucy;
        nucarea=(nucareax+nucareay);
        cyt=(tot-nuc)/(totarea-nucarea);
        nucenr=(nuc-cyt*nucarea)/tot;
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
area=[area , totarea];
nenrfluo=[nenrfluo , nucenr];
end;

celnfluo={celnfluo{:} , nfluo};
celcfluo={celcfluo{:} , cfluo};
celarea={celarea{:} , area};
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
cellarea=celarea;
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
    plot(celtime{i} , celarea{i} , 'color' , colorses(ii,:));
    hold on
end;


end

