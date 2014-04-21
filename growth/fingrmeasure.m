function [ ] = fingrmeasure
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here






%% Declarations & constantes


global segmentation;
filter_area_diff=1.5; % 1.5 ~ 2.7 sigma ~ 99.3 %
filter_area_bud=0.993; % 1 - p value







%% Filters building


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



end

