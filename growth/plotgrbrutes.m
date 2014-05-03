function plotgrbrutes(bud_before_frame , bud_after_frame , lost_after_frame)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global segmentation
ming1dur=3;
time={};
volum={};
div={};
bud={};
framet=3;
for i=1:length(segmentation.tcells1)
    if (segmentation.tcells1(i).lastFrame>lost_after_frame)&&(~isempty(segmentation.tcells1(i).budTimes))&&(segmentation.tcells1(i).budTimes(1)<bud_before_frame)&&(segmentation.tcells1(i).budTimes(1)>bud_after_frame)
        time{i}=[];
        volum{i}=[];
        div{i}=segmentation.tcells1(i).divisionTimes;
        bud{i}=segmentation.tcells1(i).budTimes;
        for j=1:length(segmentation.tcells1(i).Obj)
            if ((segmentation.tcells1(i).Obj(j).image>=segmentation.tcells1(i).birthFrame)&&(segmentation.tcells1(i).birthFrame>0))||(segmentation.tcells1(i).detectionFrame==1)
            are=segmentation.tcells1(i).Obj(j).area;
            vol=4*sqrt(are*are*are/pi)/3;
            time{i}=[time{i} , segmentation.tcells1(i).Obj(j).image ];
            for c=1:length(segmentation.tcells1(i).budTimes)
                if (segmentation.tcells1(i).Obj(j).image>=segmentation.tcells1(i).budTimes(c))&&(segmentation.tcells1(i).Obj(j).image<=segmentation.tcells1(i).divisionTimes(c))
                    frm=segmentation.tcells1(i).Obj(j).image-segmentation.tcells1(segmentation.tcells1(i).daughterList(c)).detectionFrame+1;
                    are=segmentation.tcells1(segmentation.tcells1(i).daughterList(c)).Obj(frm).area;
                    vol=vol+4*sqrt(are*are*are/pi)/3;
                    break
                end;
            end;
            volum{i}=[volum{i} , vol];
            end;
        end;
    end;
end;
a1={};
a2={};
a3={};
a4={};
for i=1:length(time)
    if ~isempty(time{i})
    a1={a1{:} ,time{i} };
    a2={a2{:} ,volum{i} };
    a3={a3{:} ,div{i} };
    a4={a4{:} ,bud{i} };
    end;
end;
time=a1;
volum=a2;
div=a3;
bud=a4;
for i=1:length(time)
    if ~isempty(div{i})
        fin{i}=[];
        beg{i}=[];
        for c=1:length(div{i})
            if c==1
                beg{i}=[beg{i} , 1];
            else
                beg{i}=[beg{i} , fin{i}(c-1)+1];
            end;
            if find(time{i}==div{i}(c))
                fin{i}=[fin{i} , find(time{i}==div{i}(c))];
            else
                fin{i}=[fin{i} , length(time{i})];
            end;
        end;
    else
        beg{i}=1;
        fin{i}=length(time{i});
    end;
    if fin{i}(end)<length(time{i})
        beg{i}=[beg{i} , fin{i}(end)+1];
        fin{i}=[fin{i} , length(time{i})];
    end;
    smoothbud{i}=[];
    for c=1:length(beg{i})
        if beg{i}(c)+ming1dur<fin{i}(c)
        tem=beg{i}(c)+ming1dur;
        else
        tem=fin{i}(c)-1;
        end;
%         for zzz=1:length(bud{i})
%             if sum(time{i}(beg{i}(c):fin{i}(c))==bud{i}(zzz))
%                 tem=find(time{i}==bud{i}(zzz));
%                 break;
%             end;
%         end;
            if (length(bud{i})>=c)&&(sum(time{i}(beg{i}(c):fin{i}(c))==bud{i}(c)))
                tem=find(time{i}==bud{i}(c));
            end;
        smoothbud{i}=[smoothbud{i} , tem ];
    end;
end;
colorses=hsv(length(time));
    figure;
for i=1:length(time)
    tot=length(beg{i});
    for j=1:length(beg{i})
        qqq=[smooth(volum{i}(beg{i}(j):smoothbud{i}(j)) , 10)' , smooth(volum{i}(smoothbud{i}(j)+1:fin{i}(j)) , 10)'];
        if length(time{i}(beg{i}(j):fin{i}(j)))~=length(qqq)
            tot=j-1;
            break;
        end;
        plot(time{i}(beg{i}(j):fin{i}(j))*framet , qqq , 'color' , colorses(i , :) , 'linewidth' , 1.1 );
        hold on;
    end;
    if tot>0
        if smoothbud{i}(1)==0
            smoothbud{i}(1)=1;
        end;
    plot(time{i}(smoothbud{i}(1:tot))*framet , volum{i}(smoothbud{i}(1:tot)) , 'line' , 'none' , 'Marker' , 'o' , 'MarkerEdgeColor' , colorses(i , :) , 'MarkerFaceColor' , colorses(i , :) );
    hold on;
    end;
%     plot(time{i}(fin{i}) , volum{i}(fin{i}) , 'line' , 'none' , 'Marker' , 'o' , 'color' , 'b' , 'markersize' , 3);
%     hold on;
end;
 set(gca,'FontSize',20)
        xlabel('Time (min)');
        ylabel('Cell and bud volume (au)');
%         title('Cell growth during aging');
end

