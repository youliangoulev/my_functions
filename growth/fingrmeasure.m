function [] = fingrmeasure
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





%% time organisation of the cells an buds

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








%% tests
% ind=[];
% jdc=[];
% 
% ind2=[];
% jdc2=[];
% w=0;
% for i=1:length(segmentation.tcells1)
%     
%     if ~isempty(segmentation.tcells1(i).budTimes)
%         for j=1:length(segmentation.tcells1(i).budTimes)
%             if segmentation.tcells1(i).budTimes(j)>segmentation.tcells1(i).detectionFrame
%                 frm=segmentation.tcells1(i).budTimes(j)-segmentation.tcells1(i).detectionFrame+1;
%                 % calcule of the areabud (j) 
%                 surface3=segmentation.tcells1(segmentation.tcells1(i).daughterList(j)).Obj(1).area;
%                 volum3=4*sqrt(surface3*surface3*surface3/pi)/3;
%                 surface2=segmentation.tcells1(i).Obj(frm).area;
%                 volum2=4*sqrt(surface2*surface2*surface2/pi)/3;
%                 surface1=segmentation.tcells1(i).Obj(frm-1).area;
%                 volum1=4*sqrt(surface1*surface1*surface1/pi)/3;
%                 
%                 
%                 diff1=volum2-volum1;
%                 if (diff1>=low_be)&&(diff1<=high_be)       
%                     if volum3>high_mmb
%                         ind=[ind , i];
%                         jdc=[jdc , frm];
%                     end;
%                 else
%                     if (diff1<low_be)&&(diff1<0)
% 
%                         surface4=surface1-surface2;
%                         volum4=4*sqrt(surface4*surface4*surface4/pi)/3;
%                         diff2=volum3-volum4
%                         if (diff2<low_db)||(diff2>high_db) 
% 
%                                                     w=w+1;
%                         ind2=[ind2 , i];
%                         jdc2=[jdc2 , frm];
%                         end;
%                         
%                     end;
%                 end;
%             end;
%         end;
%     end;
%     
% 
%     
% end;
% high_db
% length(m_mb)
% a=ind2;
% b=jdc2;



end

