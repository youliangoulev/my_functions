function [ out1 out2 out3 out4 out5 out6] = growthrate( aam , dzi )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global segmentation

%amm:mean round frame
%dzi:fluo lvl measure time point

x={};
z={};
q={};
size={};
i=0;
for c=1:length(segmentation.tcells1)
    
if segmentation.tcells1(c).N~=0 && length(segmentation.tcells1(c).Obj)>1 && segmentation.tcells1(c).detectionFrame*3-3<dzi-20
    rrr=length(segmentation.cells1);
                  if  segmentation.tcells1(c).mother==0 
                      rrr=1 ;

                  else
                      
                    %  if c==31 %
                        %  rrr=175  %
                     %else%
              %=========
                      for u=1:length(segmentation.tcells1(segmentation.tcells1(c).mother).daughterList)
                          if c==segmentation.tcells1(segmentation.tcells1(c).mother).daughterList(u)
                              if u<length(segmentation.tcells1(segmentation.tcells1(c).mother).daughterList)

                                 rrr=segmentation.tcells1(segmentation.tcells1(segmentation.tcells1(c).mother).daughterList(u+1)).detectionFrame;
                              end
                          end
                          
                      end
                      
                      if ~isempty(segmentation.tcells1(c).daughterList)
                          if segmentation.tcells1((segmentation.tcells1(c).daughterList(1))).detectionFrame<rrr
                          rrr=segmentation.tcells1((segmentation.tcells1(c).daughterList(1))).detectionFrame;
                          end
                          
                      end
                %=============         
                    % end  %                                                     %
                      
                      
                  end
                  
                  
      if length(segmentation.cells1)-rrr>=1
    
    
    
i=i+1;   
    x{i}=[];
    z{i}=[];
    q{i}=rrr*3-3:3:segmentation.tcells1(c).lastFrame*3-6;
    size{i}=[];
     
  for j=rrr-segmentation.tcells1(c).detectionFrame+1:length(segmentation.tcells1(c).Obj)-1
      m=0;
      p=0;
      if ~isempty(segmentation.tcells1(c).budTimes)
          y=0;
          for o=1:length(segmentation.tcells1(c).budTimes)
            if j+segmentation.tcells1(c).detectionFrame-1>=segmentation.tcells1(c).budTimes(o)-1     
               y=segmentation.tcells1(c).daughterList(o); 
            end
          end
          if y~=0 && j-(segmentation.tcells1(y).detectionFrame-segmentation.tcells1(c).detectionFrame)+1<=length(segmentation.tcells1(y).Obj)
             if isempty(segmentation.tcells1(y).budTimes)
             if  j-(segmentation.tcells1(y).detectionFrame-segmentation.tcells1(c).detectionFrame)>0   
                 m=segmentation.tcells1(y).Obj(j-(segmentation.tcells1(y).detectionFrame-segmentation.tcells1(c).detectionFrame)).area;
             end
                 p=segmentation.tcells1(y).Obj(j-(segmentation.tcells1(y).detectionFrame-segmentation.tcells1(c).detectionFrame)+1).area;

                 
                 
             else
                 if      j+segmentation.tcells1(c).detectionFrame-1<segmentation.tcells1(y).budTimes(1)
          if  j-(segmentation.tcells1(y).detectionFrame-segmentation.tcells1(c).detectionFrame)>0             
                    m=segmentation.tcells1(y).Obj(j-(segmentation.tcells1(y).detectionFrame-segmentation.tcells1(c).detectionFrame)).area;
          end

                    p=segmentation.tcells1(y).Obj(j-(segmentation.tcells1(y).detectionFrame-segmentation.tcells1(c).detectionFrame)+1).area;
                 end
             end
          end
      end
      
     
      c
      j
      j+1
      l=(segmentation.tcells1(c).Obj(j+1).area+p-segmentation.tcells1(c).Obj(j).area-m)/(segmentation.tcells1(c).Obj(j).area+m);
      x{i}=[x{i} l];
      z{i}=[z{i} segmentation.tcells1(c).Obj(j).fluoMean(2)];
      size{i}=[size{i} segmentation.tcells1(c).Obj(j).area];
  end
  
  
  
      end  
  
  
end
end
out1=x;
out2=q;
out3=z;

t={};
k={};
s={};
sms={};
figure;
lll=[];
kkkkk=[];
for i=1:length(x)
    t{i}=[];
    k{i}=[];
    s{i}=[];
    sms{i}=[];
    w=1;
    t{i}(w)=0;
    k{i}(w)=0;
    s{i}(w)=0;
    sms{i}(w)=0;
    b=0;
    alpha=0;
    lll(i)=0;
    kkkkk(i)=0;
    for j=1:length(x{i})
                t{i}(w)=t{i}(w)*b;
                  s{i}(w)=s{i}(w)*b;
                    sms{i}(w)=sms{i}(w)*b;
        b=b+1;
        t{i}(w)=(t{i}(w)+x{i}(j))/b;
                k{i}(w)=q{i}(j)-(b-1)*3;
                        s{i}(w)=(s{i}(w)+z{i}(j))/b;
sms{i}(w)=(s{i}(w)+size{i}(j))/b;
                        
                        
        if b==aam
                                    
                        if k{i}(w)>=dzi && k{i}(1)<dzi && alpha==0
                            alpha=1;
                            lll(i)=s{i}(w);
                            kkkkk(i)=sms{i}(w);
                        end
           b=0;
           w=w+1;
           if j~=length(x{i})
           t{i}(w)=0;
           k{i}(w)=0;
           s{i}(w)=0;
           sms{i}(w)=0;
           end
        end
        
    end

end

out4=t;
out5=k;
out6=s;
mow=0;
mmm=[];
for i=1:length(x)
if lll(i)>0
    mow=mow+1;
   mmm(mow)=lll(i);
end
    
end

col=colormap(jet(256));

for i=1:length(x)
    if lll(i)>0
    ttt=(lll(i)-min(mmm))/(max(lll)-min(mmm));
    ttt=255*ttt+1;
    ttt=round(ttt);
    plot(k{i},t{i} , 'color' , col(ttt,:));
    hold on    
    end
    
end

figure;

for i=1:length(x)
    if lll(i)>0
    ttt=(lll(i)-min(mmm))/(max(lll)-min(mmm));
    ttt=255*ttt+1;
    ttt=round(ttt);
    plot(k{i},s{i} , 'color' , col(ttt,:));
    hold on    
    end
    
end

%======================================================

figure

mow=0;
mmm=[];
for i=1:length(x)
if kkkkk(i)>0
    mow=mow+1;
   mmm(mow)=kkkkk(i);
end
    
end

col=colormap(jet(256));

for i=1:length(x)
    if kkkkk(i)>0
    ttt=(kkkkk(i)-min(mmm))/(max(kkkkk)-min(mmm));
    ttt=255*ttt+1;
    ttt=round(ttt);
    plot(k{i},t{i} , 'color' , col(ttt,:));
    hold on    
    end
    
end

figure;

for i=1:length(x)
    if kkkkk(i)>0
    ttt=(kkkkk(i)-min(mmm))/(max(kkkkk)-min(mmm));
    ttt=255*ttt+1;
    ttt=round(ttt);
    plot(k{i},s{i} , 'color' , col(ttt,:));
    hold on    
    end
    
end


%======================================================





gtma=[];
gtmn=[];
tcl1=[];
arae=[];

for i=1:length(x)
   if q{i}(1)<239  % cells born left limit !!!
       beta=0;
        betaw=0;
       qed=[];
       med=[];
       for j=1:length(q{i})
           if q{i}(j)<240    % stress begining start  !!!
               qed=[qed , x{i}(j)]
           else
                if q{i}(j)>240 && q{i}(j)<340   % limite of after stress window   !!!             
               med=[med , x{i}(j)]
           end
           end
           
           if q{i}(j)>=340  % fluo measure lvl time point 
               if beta==0
                  beta=1;
                 % lollm=mean(size{i}((j):(j+2)));
                  loll=mean(z{i}(j:(j+2)));
               end
           end
           
           if q{i}(j)>=dzi-10  % size measure lvl time point 
               if betaw==0
                  betaw=1;
                  lollm=mean(size{i}((j):(j+2)));
                 % loll=mean(z{i}(j:(j+2)));
               end
           end
           
       end
   gtma=[gtma , mean(qed)];
   gtmn=[gtmn , mean(med)];
   tcl1=[tcl1 , loll];
   arae=[arae , lollm];

       
   end
   
end

ratio=gtmn./gtma;

fun=tcl1.*arae;
figure;
scatter(gtmn ,tcl1);
hold on
lsline; 
'growth rate after stress vs. fluo lvl before stress'
  
l=[];
l(:,1)=gtmn;
l(:,2)=tcl1;
[a p]=corrcoef(l)


figure;
scatter(ratio ,tcl1);
hold on
lsline; 
'ratio growth rate before / after stress vs. fluo lvl before stress'


l=[];
l(:,1)=ratio;
l(:,2)=tcl1;
[a p]=corrcoef(l)


figure;
scatter(gtma ,tcl1);
hold on
lsline;  
'growth rate before stress vs. fluo lvl before stress'


l=[];
l(:,1)=gtma;
l(:,2)=tcl1;
[a p]=corrcoef(l)

figure;
scatter(gtma ,gtmn);
hold on
lsline;  
'growth rate before stress vs. %growth rate after stress'

l=[];
l(:,1)=gtma;
l(:,2)=gtmn;
[a p]=corrcoef(l)


figure;
scatter(gtmn ,arae);
hold on
lsline; 
'growth rate after stress vs. cell area before stress'


l=[];
l(:,1)=gtmn;
l(:,2)=arae;
[a p]=corrcoef(l)

figure;
scatter(tcl1 ,arae);
hold on
lsline; 
'fluo lvl before stress vs. cell area before stress'

l=[];
l(:,1)=tcl1;
l(:,2)=arae;
[a p]=corrcoef(l)


figure;
scatter(fun ,gtmn);
hold on
lsline; 
'fluo lvl before stress area before stress vs. growth rate after stress'


l=[];
l(:,1)=fun;
l(:,2)=gtmn;
[a p]=corrcoef(l)

figure;
scatter(gtma ,arae);
hold on
lsline; 
'growth rate before stress vs. cell area before stress'

l=[];
l(:,1)=gtma;
l(:,2)=arae;
[a p]=corrcoef(l)

figure;
hist(gtma);
figure;
hist(tcl1);





end

