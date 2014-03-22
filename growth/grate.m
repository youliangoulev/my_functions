function [out ]=grate( seg , time_bin , keep_cells_before , stress_time)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%=================================
mpf=3;  %minutes per frame
mean_bin=10; %how many time points we use for mean_fluo and mean_grate g
%=================================


if keep_cells_before>stress_time
   
    keep_cells_before=stress_time;
    
end
mbn=mean_bin;
xxx=round(time_bin/mpf);
mmm=keep_cells_before/mpf;
segmentation=seg;

msize={};
bsize={};
isfirst={};
mtime={};
mfluo={};
grate={};
moderbieze={};
age_on_str=[];
nb_buds=[];
first_fluo=[];
age_bud=[];

%==============================================

stress=stress_time;



for i=1:length(segmentation.tcells1)
   if segmentation.tcells1(i).N<=0
   continue;
   end
   if length(segmentation.tcells1(i).Obj)<2
   continue;
   end
   if segmentation.tcells1(i).detectionFrame>=mmm
   continue;
   end
   size1=[];
   time=[];
   fluo=[];
   bieze=[];
      first_fluo=[first_fluo , segmentation.tcells1(i).Obj(round((stress/mpf)+1)-segmentation.tcells1(i).detectionFrame+1).fluoMean(2)];
   age_on_str=[age_on_str , (round((stress/mpf)+1)-segmentation.tcells1(i).detectionFrame+1)*mpf];
   modif=(floor(rand*2.999999999999)-1)*0.03*0;      % modif à set to 0 si besoin pour calculation
   if isempty(segmentation.tcells1(i).daughterList)
   nb_buds=[nb_buds , 0+modif];       
   age_bud=[age_bud , 1];
   else
   ggggg=0;
   ttttt=1;
      for t=1:length(segmentation.tcells1(i).daughterList)
       if segmentation.tcells1(segmentation.tcells1(i).daughterList(t)).detectionFrame>round(((stress)/mpf)+1)
          ggggg=ggggg+1;
       else
           
          ttttt=ttttt+1;

       end
       
      end
   age_bud=[age_bud , ttttt];
   nb_buds=[nb_buds , ggggg+modif];
   end
   
   
   
   
   
   
   for j=1:length(segmentation.tcells1(i).Obj)
       
  
   size1=[size1 , segmentation.tcells1(i).Obj(j).area];
   if segmentation.tcells1(i).mother==0
        bieze=[bieze , 0];
   else
       lop=0;
       for iii=1:length(segmentation.tcells1(segmentation.tcells1(i).mother).daughterList)
        if segmentation.tcells1(segmentation.tcells1(segmentation.tcells1(i).mother).daughterList(iii)).detectionFrame>segmentation.tcells1(i).detectionFrame && segmentation.tcells1(segmentation.tcells1(segmentation.tcells1(i).mother).daughterList(iii)).detectionFrame<=segmentation.tcells1(i).Obj(j).image
            lop=1;
        end
       end
       if ~isempty(segmentation.tcells1(i).daughterList)
        if segmentation.tcells1(segmentation.tcells1(i).daughterList(1)).detectionFrame<=segmentation.tcells1(i).Obj(j).image
            lop=1;
        end
       end
       if lop==0
           
          if segmentation.tcells1(i).Obj(j).image-segmentation.tcells1(segmentation.tcells1(i).mother).detectionFrame+1<=length(segmentation.tcells1(segmentation.tcells1(i).mother).Obj)
       
           
          
           
           bieze=[bieze , segmentation.tcells1(segmentation.tcells1(i).mother).Obj(segmentation.tcells1(i).Obj(j).image-segmentation.tcells1(segmentation.tcells1(i).mother).detectionFrame+1).area];    
       
       
       else
           
           
         bieze=[bieze , 0];   
       
       end
       else
           
       bieze=[bieze , 0];    
       end
   end
   
   time=[time , segmentation.tcells1(i).Obj(j).image*mpf-mpf];
   fluo=[fluo , segmentation.tcells1(i).Obj(j).fluoMean(2)];
   end
   msize={msize{:} , size1};
   mtime={mtime{:} , time};
   mfluo={mfluo{:} , fluo};  
   moderbieze=   {moderbieze{:} , bieze};  
end

%find mother : size,time,fluo
%============================================== 

%==============================================
for i=1:length(segmentation.tcells1)
   if segmentation.tcells1(i).N<=0
   continue;
   end
   size2=[];
   first=[];
   for j=1:length(segmentation.tcells1(i).Obj)
    if isempty(segmentation.tcells1(i).daughterList)
    size2=[size2 , 0];
    first=[first , 0];
    else
    kompteur=0;
     for m=1:length(segmentation.tcells1(i).daughterList)
         if segmentation.tcells1(segmentation.tcells1(i).daughterList(m)).N==0
             continue
         end
      if segmentation.tcells1(segmentation.tcells1(i).daughterList(m)).detectionFrame<=segmentation.tcells1(i).Obj(j).image
      kompteur=m;    
      end
     end
     if kompteur==0
     size2=[size2 , 0];
     first=[first , 0];        
     else
        if segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).lastFrame<segmentation.tcells1(i).Obj(j).image
                 size2=[size2 , 0];
        if segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).lastFrame==segmentation.tcells1(i).Obj(j).image-1
        first=[first , -1]; 
        else
        first=[first , 0];  
        end                  
        continue;    
        end
         
      if isempty(segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).daughterList)
          
          

      size2=[size2 , segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).Obj(segmentation.tcells1(i).Obj(j).image-segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).detectionFrame + 1).area];   
        if (segmentation.tcells1(i).Obj(j).image-segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).detectionFrame)==0
        first=[first , 1]; 
        else
        first=[first , 0];  
        end
        
      else
        if segmentation.tcells1(segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).daughterList(1)).detectionFrame <=segmentation.tcells1(i).Obj(j).image  
        size2=[size2 , 0];
         first=[first , -1];
        else
           
                  size2=[size2 , segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).Obj(segmentation.tcells1(i).Obj(j).image-segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).detectionFrame + 1).area];   
         if (segmentation.tcells1(i).Obj(j).image-segmentation.tcells1(segmentation.tcells1(i).daughterList(kompteur)).detectionFrame)==0
         first=[first , 1]; 
         else
         first=[first , 0];  
         end
            
        end
          
      end
     end     
   end
       


   end
   bsize={bsize{:} , size2};
      isfirst={isfirst{:} , first};     
end

%find bud : size,isfirst  (isfirst mean: is the first time that this bud is
%      associated with this mother)
%============================================== 

%============================================

for i=1:length(msize)

    rate=[];
    for j=1:(length(msize{i})-1)  % no growth rate for last time point
        if isfirst{i}(j+1)==0
     rate=[rate , (msize{i}(j+1)+bsize{i}(j+1)-msize{i}(j)-bsize{i}(j))/(msize{i}(j)+bsize{i}(j) + moderbieze{i}(j))];    
     else
        if isfirst{i}(j+1)==1
        rate=[rate , (msize{i}(j+1)+bsize{i}(j+1)/5-msize{i}(j))/(msize{i}(j) + moderbieze{i}(j) )];    
        else
        rate=[rate , (msize{i}(j+1)-msize{i}(j))/msize{i}(j)];     
        end  
     end
    end
 
grate={grate{:} , rate}; 
end



% calculating grate
%============================================

for i=1:length(mtime)
mtime{i}=mtime{i}(1:length(mtime{i})-1);  % equlibrium -  no growth rate for last time point
mfluo{i}=mfluo{i}(1:length(mfluo{i})-1);    % equlibrium -  no growth rate for last time point
msize{i}=msize{i}(1:length(msize{i})-1); 
end
maxo=[];     
for i=1:length(grate) 
    maxo=[maxo , mtime{i}(end)];
end
maxiii=max(maxo);
for i=1:length(grate)
    if mtime{i}(end)<maxiii
        
     kkkkk=length(mtime{i});
     ppp=mtime{i}(end);
     for j=kkkkk+1:kkkkk+(maxiii-ppp)/mpf
        grate{i}(j)=0;
        mtime{i}(j)=ppp+(j-kkkkk)*mpf;
        mfluo{i}(j)=mfluo{i}(kkkkk);
        msize{i}(j)=msize{i}(kkkkk);
     end
    end
end

if maxiii<=stress
    disp('no cells while stress is applied');
    return
end



brute.size=msize;
brute.grate=grate;
brute.time=mtime;
brute.fluo=mfluo;

%========================================== fine tuning

max_fluo=[];

max_time=[];

mean_fluo={};

mean_grate={};

mean_time={};

 for i=1:length(brute.time)

      for j=1:length(brute.time{i})
         if brute.time{i}(j)>=stress
             
             ped=0;
             
              for ij=j:length(brute.fluo{i}) 
              
                  if ped<brute.fluo{i}(ij)
                     ped=brute.fluo{i}(ij);
                     mtimeee=brute.time{i}(ij)-stress;
                  end
                  
              end
            
             
            max_fluo=[max_fluo , ped-brute.fluo{i}(j)]; 
                        max_time=[max_time , mtimeee]; 
            break; 
         end
      end
 
      
      mean_fluo{i}=[];
       mean_grate{i}=[];
         mean_time{i}=[];
        mf=[];
        mg=[];
 
       lll=0;  
       on=1;
      for j=1:length(brute.time{i})
          
         if length(brute.time{i})-j<mbn
             break;
         end
         
         if brute.time{i}(j)>=stress
            if on==1
                on=0;
                stresstime=j;
            end
           mf=[mf , brute.fluo{i}(j)-brute.fluo{i}(stresstime)];
           mg=[mg , brute.grate{i}(j)];
          
           lll=lll+1;
              if lll==mbn
                  lll=0;
                  
                if   isempty(mean_fluo{i})
                  mean_fluo{i}=[mean_fluo{i} , mean(mf)];
                  mean_grate{i}=[mean_grate{i} , mean(mg)];
                  mean_time{i}=[mean_time{i} ,brute.time{i}(j)];  
                else
                  
                  
                  
                  mean_fluo{i}=[mean_fluo{i} ,(mean_fluo{i}(end)*length(mean_fluo{i})+mean(mf))/(1+length(mean_fluo{i}))];
                  mean_grate{i}=[mean_grate{i} ,(mean_grate{i}(end)*length(mean_grate{i})+mean(mg))/(1+length(mean_grate{i}))];
                  mean_time{i}=[mean_time{i} ,brute.time{i}(j)];
                  
                end
                         mf=[];
        mg=[]; 
              end
             
             
             
             
             
         end
      end
      
 end

 test=[];
 for i=1:length(mean_fluo)
    test=[test , length(mean_fluo{i})]; 
 end
 test=min(test);
 
 
 
      lmean_fluo={};
     lmean_grate={};
     lmean_time=[];
 for i=1:test
     lmean_fluo{i}=[];
     lmean_grate{i}=[];
     lmean_time(i)=mean_time{1}(i);
     for    j=1:length(brute.time)
         lmean_fluo{i}=[lmean_fluo{i} , mean_fluo{j}(i)];
          lmean_grate{i}=[lmean_grate{i} , mean_grate{j}(i)];
     end
     
     
     
 end
 last_size=[];
 first_size=[];
 for i=1:length(brute.size)
    last_size=[last_size , brute.size{i}(end)]; 
    
    for j=1:length(brute.size{i})
     if brute.time{i}(j)>=stress
     
     first_size=[first_size , brute.size{i}(j)];    
     break;
     end
    end
    
    
    
 end
Grate_before=[]; 
 
 for i=1:length(brute.time)
     meanto=[];
      for j=1:length(brute.time{i})
       if brute.time{i}(j)<stress
         meanto=[meanto , brute.grate{i}(j)];
       end
      end
     Grate_before=[Grate_before , mean(meanto)]; 
 end
 
%==========================================
% first_fluo; [cell]
% Grate_before; [cell]
% nb_buds; [cell]
% lmean_fluo;{time}[cell]
% lmean_grate;{time}[cell]
% lmean_time;[time]
% max_fluo;  [cell]
% last_size; [cell]
% first_size; [cell]
% age_on_str; [cell]
% age_bud; [cell]
%==========================================
 for i=1:length(mtime)
     if length(mtime{i})<xxx
     continue;
     end
     rgrate{i}=[];
     rfluo{i}=[];
     rtime{i}=[];
     k=0;
     gratetem=[];
     fluotem=[];
     
     
     for j=1:length(mtime{i})
        gratetem=[gratetem , grate{i}(j)];
          fluotem=[fluotem , mfluo{i}(j)];
          k=k+1;
        if k==xxx
           k=0;
           rgrate{i}=[rgrate{i} , mean(gratetem)];
           rfluo{i}=[rfluo{i} , mean(fluotem)];
           rtime{i}=[rtime{i} , mtime{i}(j-xxx+1)];
             gratetem=[];
               fluotem=[];
               if length(mtime{i})-j<xxx
                   break;
               end
        end
         
         
         
     end
 end
 
 meandone.grate=rgrate;
 meandone.time=rtime;
 meandone.fluo=rfluo;
 
 
 
 figure;
 hold on;
 clrs=colormap(jet(length(meandone.grate)));
 
for i=1:length(meandone.grate)
    
    plot(meandone.time{i} , meandone.fluo{i} , 'color' , clrs(i , :));
    hold on;
    
end



aaa=[];
 bbb=[];
 zzz=[];
 qqq=[];

 for i=1:length(max_fluo)
    if max_fluo(i)>8000
        aaa=[aaa ; [0 0 1]];
        bbb=[bbb , max_fluo(i)];
        
        
    else
        
        
        aaa=[aaa ; [1 0 0]];
        qqq=[qqq , max_fluo(i)];
          
        
        
        
        
    end
 end



 figure;
 hold on;
  clrs=colormap(jet(length(meandone.grate)));
for i=1:length(meandone.grate)
    
    plot(meandone.time{i} , meandone.fluo{i} , 'color' , clrs(i , :));
    hold on;
    
end


 figure;
scatter(lmean_grate{end} , max_fluo , 50 , 'b' , 'filled');
% 
% 
% 
% polm=last_size/30;
% 
% figure;
% scatter(lmean_grate{end} , max_fluo , polm);
% 
% % for i=1:test
% %  figure;
% % scatter(lmean_grate{i} , max_fluo);
% % end
% 
% polm=(lmean_fluo{end}.*(lmean_time(end)-stress)-lmean_fluo{end-1}.*(lmean_time(end-1)-stress))./(10*mpf);
%  
figure;
 hold on;
%  clrs=colormap(jet(round(max(polm)-min(polm))));
polms=last_size/30;
 scatter(lmean_fluo{2} , max_fluo , 50 , aaa, 'filled');
 aaa=polyfit(lmean_fluo{2} , max_fluo  , 3);
 refcurve(aaa);
%  
% figure;
%  hold on;
%  clrs=colormap(jet(round(max(polm)-min(polm))));
% polms=last_size/30;
%  scatter(lmean_grate{end} , max_fluo , polms , polm , 'filled');
% 
% figure;
%  hold on;
%  clrs=colormap(jet(round(max(polm)-min(polm))));
% polms=last_size/30;
%  scatter(lmean_grate{end} , max_fluo , 50 , 'b' , 'filled');
% 
% 
% figure;
%  hold on;
%  clrs=colormap(jet(round(max(polm)-min(polm))));
% polms=last_size/30;
%  scatter(nb_buds , max_fluo , 50 , 'b' );
% 
%  
% figure;
%  hold on;
%  clrs=colormap(jet(round(max(polm)-min(polm))));
% polms=last_size/30;
%  scatter(first_size , lmean_grate{end} , 50 , 'b' , 'filled');
%  
%  figure;
%  hold on;
%  clrs=colormap(jet(round(max(polm)-min(polm))));
% polms=last_size/30;
%  scatter(age_on_str , lmean_grate{2} , 50 , 'b' , 'filled');
%  
%  
%  figure;
%  hold on;
%  clrs=colormap(jet(round(max(polm)-min(polm))));
% polms=last_size/30;
%  scatter(age_on_str , nb_buds , 50 , 'b' , 'filled'); 
 
 

 max_fluo
   out=max_fluo;
%  out2=bbb;
%  out3=zzz;
%  out4=qqq;






%  for i=1:length(lmean_fluo)
 figure;
 hold on;
% clrs=colormap(jet(round(max(polm)-min(polm))));
polms=last_size/30;
 scatter(first_size , lmean_grate{end}, 50 , 'b', 'filled');
%  end
%  
%  
%   for i=1:length(lmean_fluo)
%  figure;
%  hold on;
% %  clrs=colormap(jet(round(max(polm)-min(polm))));
% polms=last_size/30;
%  scatter(lmean_fluo{i} , nb_buds, 50 , 'b', 'filled');
%   end
 
  
  
  

  
  
 
%  
% out=lmean_fluo{2};
% 
%  figure;
%  hold on;
%  clrs=colormap(jet(round(max(polm)-min(polm))));
%  polms=last_size/30;
%  scatter(first_size , lmean_grate{end} , 50 , 'b' , 'filled'); 
 
  
%  figure;
%  hold on;
%  clrs=colormap(jet(round(max(polm)-min(polm))));
%  polms=last_size/30;
%  scatter(age_bud , nb_buds , 50 , 'b' , 'filled'); 

% out=Grate_before;
% out2=lmean_grate{end};
% out3=max_fluo;
% out4=lmean_fluo{2};

xli=[lmean_fluo{6}' , lmean_grate{end}'];
%out=xli;

end

