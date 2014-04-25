function [selfo , selfdeltao , mothero , motherdeltao , childo , childeltao , motherchildo , motherchildeltao] = fingrmeasure
% calcule du growth rate en fonction du time

% basé sur les differnces dans l'air d'une sous-population entre j et j-1
% frames . La sous-population peut changer d'un couple de frame à une autre
% !





%% declarations & constantes


global segmentation;
filter_area_diff=1.5; % 1.5 ~ 2.7 sigma ~ 99.3 %
filter_area_bud=0.993; % 1 - p value







%% filters building


d_b=[]; % detection to birth
b_e=[]; % birth to end
m_mb=[]; % mother to mother + bud


% waitbar during first filter building
daljina=length(segmentation.tcells1);
compt=1;
hwbar=waitbar(0 , 'area differences estimation');


for i=1:length(segmentation.tcells1)
    
    if length(segmentation.tcells1(i).Obj)>1
        for j=2:length(segmentation.tcells1(i).Obj)
            
            % calcule of the difference area(j) - area(j-1)
            surface2=segmentation.tcells1(i).Obj(j).area;
            volum2=4*sqrt(surface2*surface2*surface2/pi)/3;
            surface1=segmentation.tcells1(i).Obj(j-1).area;
            volum1=4*sqrt(surface1*surface1*surface1/pi)/3;
            diff=volum2-volum1;
            
            % assignement of the difference (d_b or b_e)
            if segmentation.tcells1(i).Obj(j).image<=segmentation.tcells1(i).birthFrame
                d_b=[d_b , diff];
            else
                b_e=[b_e , diff];
            end;
        end;
    end;
    
    % waitbar updating
    if i>=compt*daljina/20
        compt=compt+1;
        waitbar(i/daljina, hwbar);
    end;
    
end;

% close waitbar
close(hwbar);
drawnow;


% waitbar during second filter building
daljina=length(segmentation.tcells1);  
compt=1;
hwbar=waitbar(0 , 'budsize differences estimation');

for i=1:length(segmentation.tcells1)
    
    if ~isempty(segmentation.tcells1(i).budTimes)
        for j=1:length(segmentation.tcells1(i).budTimes)
            if segmentation.tcells1(i).budTimes(j)>segmentation.tcells1(i).detectionFrame

                % calcule of the areabud (j) 
                surface3=segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).Obj(1).area;
                volum3=4*sqrt(surface3*surface3*surface3/pi)/3;
                m_mb=[m_mb , volum3];
            end;
        end;
    end;
    
    % waitbar updating
    if i>=compt*daljina/20
        compt=compt+1;
        waitbar(i/daljina, hwbar);
    end;
    
end;

% close waitbar
close(hwbar);
drawnow;


% limits calculation
high_db=prctile(d_b , 75)+(prctile(d_b , 75)-prctile(d_b , 25))*filter_area_diff;
low_db=prctile(d_b , 25)-(prctile(d_b , 75)-prctile(d_b , 25))*filter_area_diff;

high_be=prctile(b_e , 75)+(prctile(b_e , 75)-prctile(b_e , 25))*filter_area_diff;
low_be=prctile(b_e , 25)-(prctile(b_e , 75)-prctile(b_e , 25))*filter_area_diff;

lambdammb=log(2)/(median(m_mb)-min(m_mb));
high_mmb=min(m_mb)-log(1-filter_area_bud)/lambdammb;





%% time organisation of the cells and buds

% determination of the time-lapse duration
maxtime=0;
for i=1:length(segmentation.tcells1)
    if segmentation.tcells1(i).lastFrame>maxtime
    maxtime=segmentation.tcells1(i).lastFrame;
    end;
end;

% declaration of the variables linking time to cells and buds
for i=1:maxtime
celtnumber{i}=[];
celtframe{i}=[];
budtnumber{i}=[];
budtframe{i}=[];    
end;
% waitbar during second filter building
daljina=length(segmentation.tcells1);  
compt=1;
hwbar=waitbar(0 , 'time organisation');

% organisation of born cells and their buds in the time
for i=1:length(segmentation.tcells1)
    if ~isempty(segmentation.tcells1(i).Obj)
       for j=1:length(segmentation.tcells1(i).Obj)
           if (segmentation.tcells1(i).Obj(j).image>=segmentation.tcells1(i).birthFrame)
               frtime=segmentation.tcells1(i).Obj(j).image;
               celtnumber{frtime}=[celtnumber{frtime} , i];
               celtframe{frtime}=[celtframe{frtime} , j];
               budtnumber{frtime}=[budtnumber{frtime} , 0];
               budtframe{frtime}=[budtframe{frtime} , 0]; 
               if ~isempty(segmentation.tcells1(i).budTimes)
                   for z=1:length(segmentation.tcells1(i).budTimes)
                       if (frtime>=segmentation.tcells1(i).budTimes(z))&&(frtime<=segmentation.tcells1(i).divisionTimes(z))
                           i1=segmentation.tcells1(i).daughterList(z);
                           budtnumber{frtime}(end)=i1;
                           j1=frtime-segmentation.tcells1(i1).detectionFrame+1;
                           budtframe{frtime}(end)=j1;
                           break;
                       end;
                   end;
               end;
           end;
       end;
    end;
    
    % waitbar updating
    if i>=compt*daljina/20
        compt=compt+1;
        waitbar(i/daljina, hwbar);
    end;
    
end;

% close waitbar
close(hwbar);
drawnow;
%% calcule of the differences in the time
% initialisation for delta
for i=1:maxtime-1
selfsize{i}=[];
selfdelta{i}=[]; 
childsize{i}=[]; 
childelta{i}=[]; 
mothersize{i}=[];
motherdelta{i}=[];
motherchildsize{i}=[]; 
motherchildelta{i}=[];  
end;
generation=[];
grgen=[];
% waitbar during second filter building
daljina=maxtime-1;  
compt=1;
hwbar=waitbar(0 , 'delta estimation');
% delta calculation
nobud=0;
for i=1:maxtime-1
 if (~isempty(celtnumber{i}))&&(~isempty(celtnumber{i+1}))     
     for j=1:length(celtnumber{i})
         if sum(celtnumber{i+1}==celtnumber{i}(j)) % && (min(segmentation.tcells1(celtnumber{i}(j)).Obj(celtframe{i}(j)).x)>=200)&&(max(segmentation.tcells1(celtnumber{i}(j)).Obj(celtframe{i}(j)).x)<=800)&&(min(segmentation.tcells1(celtnumber{i}(j)).Obj(celtframe{i}(j)+1).x)>=200)&&(max(segmentation.tcells1(celtnumber{i}(j)).Obj(celtframe{i}(j)+1).x)<=800)&&(min(segmentation.tcells1(celtnumber{i}(j)).Obj(celtframe{i}(j)).y)>=200)&&(max(segmentation.tcells1(celtnumber{i}(j)).Obj(celtframe{i}(j)).y)<=800)&&(min(segmentation.tcells1(celtnumber{i}(j)).Obj(celtframe{i}(j)+1).y)>=200)&&(max(segmentation.tcells1(celtnumber{i}(j)).Obj(celtframe{i}(j)+1).y)<=800)
             j1=celtnumber{i+1}==celtnumber{i}(j);
             cid=celtnumber{i}(j);
             cfr=celtframe{i}(j);
             surface1=segmentation.tcells1(cid).Obj(cfr).area;
             volum1=4*sqrt(surface1*surface1*surface1/pi)/3;
             surface2=segmentation.tcells1(cid).Obj(cfr+1).area;
             volum2=4*sqrt(surface2*surface2*surface2/pi)/3; 
             diff1=volum2-volum1;

             if (diff1>=low_be)&&(diff1<=high_be) &&(segmentation.tcells1(cid).birthFrame>0 ) % &&(i>=segmentation.tcells1(cid).birthFrame)
                 selfsize{i}=[selfsize{i} , volum1];
                 selfdelta{i}=[selfdelta{i} , diff1];
             end;   

             if budtnumber{i+1}(j1)>0
                 if budtnumber{i+1}(j1)==budtnumber{i}(j)
                     bid=budtnumber{i}(j);
                     bfr=budtframe{i}(j);
                     surface3=segmentation.tcells1(bid).Obj(bfr).area;
                     volum3=4*sqrt(surface3*surface3*surface3/pi)/3;
                     surface4=segmentation.tcells1(bid).Obj(bfr+1).area;
                     volum4=4*sqrt(surface4*surface4*surface4/pi)/3;
                     diff2=volum4-volum3;
                     if (diff1>=low_be)&&(diff1<=high_be)&&(diff2>=low_db)&&(diff2<=high_db)
                         mothersize{i}=[mothersize{i} , volum1];
                         childsize{i}=[childsize{i} , volum3];  
                         motherdelta{i}=[motherdelta{i} , diff1 ];
                         childelta{i}=[childelta{i} , diff2 ] ; 
                         motherchildsize{i}=[motherchildsize{i} , volum1+volum3];
                         motherchildelta{i}=[motherchildelta{i} , diff1+diff2 ];
                         if (segmentation.tcells1(cid).birthFrame>0 )
                             generation=[generation , find(segmentation.tcells1(cid).daughterList==bid)];
                             grgen=[grgen , diff1 + diff2];
                         end;
                     end;
                 else
                     bid=budtnumber{i+1}(j1);
                     bfr=budtframe{i+1}(j1);
                     surface3=segmentation.tcells1(bid).Obj(bfr).area;
                     volum3=4*sqrt(surface3*surface3*surface3/pi)/3;
%  a faire si seuil de taille de detecton << croissance par frame 
%                      if (diff1>=low_be)&&(diff1<=high_be)
%                          if volum3<=high_mmb
%                              mothersize{i}=[mothersize{i} , volum1];
%                              childsize{i}=[childsize{i} ,            0   ];  
%                              motherdelta{i}=[motherdelta{i} , diff1 ];
%                              childelta{i}=[childelta{i} , volum3 ] ; 
%                              motherchildsize{i}=[motherchildsize{i} , volum1];
%                              motherchildelta{i}=[motherchildelta{i} , diff1+volum3 ];
%                          end;
%                      else
                         if (diff1<low_be)&&(diff1<=0)
                            surface4=surface1-surface2;
                            volum4=4*sqrt(surface4*surface4*surface4/pi)/3;
                            diff2=volum3-volum4;
                            if (diff2>=low_db)&&(diff2<=high_db)
                                mothersize{i}=[mothersize{i} , volum2];
                                childsize{i}=[childsize{i} , volum4];  
                                motherdelta{i}=[motherdelta{i} , 0 ];
                                childelta{i}=[childelta{i} , diff2 ] ;
                                motherchildsize{i}=[motherchildsize{i} , volum2+volum4];
                                motherchildelta{i}=[motherchildelta{i} , diff2 ];
                                if (segmentation.tcells1(cid).birthFrame>0 )
                                    generation=[generation , find(segmentation.tcells1(cid).daughterList==bid)];
                                    grgen=[grgen , diff2];
                                end;
                            end;
                         end;
                     % end;
                 end;
             end;
         end;    
     end;
 end;
     % waitbar updating
    if i>=compt*daljina/20
        compt=compt+1;
        waitbar(i/daljina, hwbar);
    end;
end;
% close waitbar
close(hwbar);
drawnow;
figure;
axgen=1:max(generation);
for i=axgen
    meangrgen(i)=mean(grgen(i==generation));
    errorgrgen(i)=std(grgen(i==generation))/sqrt(sum(i==generation));
end;
errorbar(axgen , meangrgen , errorgrgen ,'LineStyle' , 'none' , 'MarkerSize', 6 , 'MarkerEdgeColor','k' , 'MarkerFaceColor','g' , 'Marker' , 's' , 'color' , 'k');
 set(gca,'FontSize',20)
        xlabel('Generation');
        ylabel('Mean cell growth (au)');
        title('Cell growth during aging');
%% out
selfo=selfsize;
selfdeltao=selfdelta;
mothero=mothersize;
motherdeltao=motherdelta;
childo=childsize;
childeltao=childelta;
motherchildo=motherchildsize;
motherchildeltao=motherchildelta;
end

