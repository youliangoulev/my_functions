function out = fitfig( fig,lengthmin, begin, endi )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


% Upload figure data
%===============================================

x=[];
y=[];
ch=get(fig,'Children');
l=get(ch,'Children');
c=get(l,'Xdata');
p=get(l,'Ydata');
for i=1:length(c)
    ez=1;
    while (ez<length(c{i}))&&(c{i}(ez)<begin)
        ez=ez+1;
    end
    if (c{i}(ez)>=begin)&&(c{i}(ez)<=endi)
        if (c{i}(end)>endi)
            if (endi-c{i}(ez)>=lengthmin)
                erz=ez;
                while (c{i}(erz+1)<=endi)
                    erz=erz+1;
                end
                x=horzcat(x,c{i}(ez:erz));
                y=horzcat(y,p{i}(ez:erz));
            end
        else
            if (c{i}(end)-c{i}(ez)>=lengthmin)
                x=horzcat(x,c{i}(ez:end)); 
                y=horzcat(y,p{i}(ez:end));
            end
        end
    end
end
%========================================================

%Fitting
%========================================================
warning off
Q1=-1;
dmolp=max(x)+1;
dolp=-1;
dolp1=-1;
for i=1:length(x)
    if (x(i)>dolp)&&(x(i)<max(x))
        dolp=x(i);
    end
    if (x(i)<dmolp)&&(x(i)>min(x))
        dmolp=x(i);
    end
end

for i=1:length(x)
    if (x(i)>dolp1)&&(x(i)<dolp)
        dolp1=x(i);
    end

end
Nt=((dolp-dmolp+1)*(dolp-dmolp))/2;
firstgap=0.01;
h=waitbar(0,'0%');
for t1=dmolp:dolp1
    rest=((dolp-t1+1)*(dolp-t1))/2;
    fraco=1-rest/Nt;
    if fraco>=firstgap
        while firstgap<=fraco
        firstgap=firstgap+0.01;
        end
        waitbar(fraco,h,strcat(int2str(round(fraco*100)),'%'));
    end
    for t2=t1+1:dolp
        Q=0;
        cx=[];
        cy=[];
        tx=[];
        ty=[];
        for i=1:length(x)
            if x(i)<=t1
                cx=horzcat(cx,x(i));
                cy=horzcat(cy,y(i));
            else
                if x(i)>=t2
                  tx=horzcat(tx,x(i));
                  ty=horzcat(ty,y(i));  
                end
            end
        end
        pc=polyfit(cx,cy,1);
        pt=polyfit(tx,ty,1);
        pm(1)=(pt(1)*t2+pt(2)-pc(1)*t1-pc(2))/(t2-t1);
        pm(2)=pc(1)*t1+pc(2)-pm(1)*t1;
        for i=1:length(x)  
            if x(i)<=t1
            Q=Q+(y(i)-pc(1)*x(i)-pc(2))*(y(i)-pc(1)*x(i)-pc(2));
            else
                if x(i)>=t2
                Q=Q+(y(i)-pt(1)*x(i)-pt(2))*(y(i)-pt(1)*x(i)-pt(2));
                else
                Q=Q+(y(i)-pm(1)*x(i)-pm(2))*(y(i)-pm(1)*x(i)-pm(2));
                end
            end
        end
        if Q<Q1||Q1==-1
            Q1=Q;
            t1g=t1;
            t2g=t2;
            pcg=pc;
            ptg=pt;
            pmg=pm;
        end
    end
end

l=[min(x):1:max(x)];
for i=1:length(l)
     if l(i)<=t1g
     m(i)=pcg(1)*l(i)+pcg(2);
     else
        if l(i)>=t2g
        m(i)=ptg(1)*l(i)+ptg(2);
        else
        m(i)=pmg(1)*l(i)+pmg(2);
        end
     end   
end

V.t1=t1g;
V.t2=t2g;
V.Amplitude=-pcg(1)*t1g-pcg(2)+ptg(1)*t2g+ptg(2);
V.Amplituderelative=V.Amplitude/(pcg(1)*t1g+pcg(2));
V.function1=pcg;
V.function2=pmg;
V.function3=ptg;
V.x=l;
V.y=m;
V.dots1=x;
V.dots2=y;
V.Qsquare=Q1;
V.Qmoyen=sqrt(Q1/length(x));
out=V;
close(h);
figure;
scatter(x,y,'.');
hold on
plot(l,m,'r','LineWidth',2.5);
hold off
warning on    
%===========================================================

end

