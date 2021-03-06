function stat=phy_extractCellCyclePhase(cellindex,display,born)
%cellindex : index of the nuclei to consider
% display=0 : no display
% display=1 : display histogram
% display=2 : display specific temporal trace

% to do : fix problems with position of division boundary

% plot sample traj using traj.
% plot mean traj using traj
% do a batch analysis modeto segment and map data
% make a movie with apparent cell cycle phases
% born= frame of the stress

global segmentation


minTraceDur=20; % frames

G1_M=[];
S_M=[];
G2_M=[];
T_M=[];

G1_D=[];
S_D=[];
G2_D=[];
T_D=[];


for i=1:length(cellindex)
    
    id=cellindex(i);
    
    % detect divisions based on decay of area x mean fluo
    if segmentation.tnucleus(id).N>0
    else
        continue;
    end
    
    
    
   
    
    
    
    
    [arrx ix]= sort([segmentation.tnucleus(id).Obj.image]); % time data for the cell
    fluo=[segmentation.tnucleus(id).Obj.fluoMean];% fluo data for the cel
    fluo=fluo(2:2:end); % select channel 2
    fluo=fluo(ix); % sort fluo data with increasing time
    
    fluo=fluo-600; % remove zero fo camera
    area=[segmentation.tnucleus(id).Obj.area];
    area=area(ix);
    fluo=fluo.*area/mean(area);
    
    if length(fluo)<minTraceDur
        continue
    end
    
    arrx=arrx(1:end-1);
    fluo=fluo(1:end-1);
    
    %figure, plot(arrx,fluo); hold on;
    
    fluo= smooth(fluo,3); % filter out noise
    dfluo=-diff(fluo);
    dfluo=[0 ; dfluo]; % add trailing zero to detect early events
    
    
    % Peak detection for division events
    
    %[pksmax locmax]=findpeaks(dfluo,'minpeakdistance',minTraceDur,'minpeakheight',70); % 20 frames min between peaks % min peak height 70
    
    
    peak=fpeak(1:1:length(dfluo),dfluo,20,[0 length(dfluo) 50 Inf]); % better function than matlab's fpeak
    
    %SlopeThreshold=0.01;
    %AmpThreshold=0.01;
    %P=findpeaks(1:1:length(dfluo),dfluo,SlopeThreshold,AmpThreshold,1,0) could
    %not make it to work properly !
    
   % figure, plot(dfluo); hold on; plot(peak(:,1)', peak(:,2)', 'Color', 'g');
    
    %plot(locmax, pksmax, 'Color', 'r');
    
    locmax=peak(:,1)';
    
    
    
    % make mother versus daughter distinction
    
    firstSeg=find(segmentation.nucleusSegmented,1,'first');
    
     if numel(locmax)==0
        continue
     end
    
    if segmentation.tnucleus(id).detectionFrame>firstSeg 
       if locmax(1)<20
          locmax=locmax(2:end); 
       end
    end
    
    if numel(locmax)==0
        continue
    end
    
    count=0;
    thr=2; % threshold applied to beginning and end of traces
    
    if display==2
        h=figure; plot(arrx,fluo,'Color','b','lineWidth',2); hold on
        title(['Cell:' num2str(id)])
        %locmax2=locmax+arrx(1)-1;
        %line([locmax2' locmax2']',[1330*ones(size(locmax2')) 2000*ones(size(locmax2'))]','Color','m');
    end
    
    
    firstFrame=arrx(1)-1; %segmentation.tnucleus(id).detectionFrame;
    
    if segmentation.tnucleus(id).detectionFrame>firstSeg 
        
       % locmax
        if locmax(1)>20 % first peak correspond to D division
            
            % figure, plot(fluo(1:locmax(1)));
            [t1 t2 level1 level2 curve]=fitCellCycle(fluo(1:locmax(1)-thr)');
            if level2>=level1
                
                
                if numel(t1)~=0 & t1>8
                    G1_D=[G1_D t1-1];
                    S_D=[S_D t2-t1];
                    G2_D=[G2_D locmax(1)-t2-1];
                    T_D=[T_D locmax(1)];
                    
                    for n=1:locmax(1)
                        if n<=t1
                            segmentation.tnucleus(id).Obj(n).Min=round(100*double(n)/double(t1));
                        end
                        
                        if n<=t2 & n>t1
                            segmentation.tnucleus(id).Obj(n).Min=200+round(100*double(n-t1)/double(t2-t1));
                        end
                        
                        if n>t2
                            segmentation.tnucleus(id).Obj(n).Min=400+round(100*double(n-t2)/double(locmax(1)-t2));
                        end
                    end
                    
                    if display==2
                        % locmax(1)
                        figure(h); line([firstFrame+locmax(1) firstFrame+locmax(1)],[min(fluo) max(fluo)],'Color','k','lineWidth',2,'lineStyle','--');
                        
                        % t1,t2
                        [xout,yout]=plotFit(1:locmax(1)-thr,fluo(1:locmax(1)-thr)',t1,t2,0);
                        plot(xout+firstFrame,yout,'Color','r','lineWidth',2,'lineStyle','--');
                        
                    end
                end
                
            end
        end
        
            
        if locmax(1)<5 % first peak correspond to D birth
            count=1;
            
            if numel(locmax)>=2
                
                % figure, plot(fluo(1:locmax(1)));
                [t1 t2 level1 level2 curve]=fitCellCycle(fluo(locmax(1)+thr:locmax(2)-thr)');
                if level2>=level1
                    
                    if numel(t1)~=0
                        G1_D=[G1_D t1+thr];
                        S_D=[S_D t2-t1];
                        G2_D=[G2_D locmax(2)-locmax(1)-t2+thr];
                        T_D=[T_D locmax(2)-locmax(1)];
                        
                        
                        for n=locmax(1)+1:locmax(2)
                            
                            if n<=locmax(1)+t1+thr
                                segmentation.tnucleus(id).Obj(n).Min=round(100*double(n-locmax(1))/double(t1+thr));
                            end
                            
                            if n<=locmax(1)+t2+thr & n>locmax(1)+t1+thr
                                segmentation.tnucleus(id).Obj(n).Min=200+round(100*double(n-t1-locmax(1)-thr)/double(t2-t1));
                            end
                            
                            if n>locmax(1)+t2+thr
                                segmentation.tnucleus(id).Obj(n).Min=400+round(100*double(n-locmax(1)-t2-thr)/double(locmax(2)-locmax(1)-t2-thr));
                            end
                            
                        end
                        
                        %n=1:1:t1;
                        %segmentation.tnucleus(id).Obj(firstframe+locmax(1):firstframe+locmax(2)).Min=round(100*double(n)/double(t1));
                        
                        if display==2
                            figure(h); line([firstFrame+locmax(1) firstFrame+locmax(1)],[min(fluo) max(fluo)],'Color','k','lineWidth',2,'lineStyle','--');
                            
                            cut=fluo(locmax(1)+thr:locmax(2)-thr)';
                            
                            [xout,yout]=plotFit(1:1:length(cut),cut,t1,t2,0);
                            plot(xout+firstFrame+locmax(1)-2,yout,'Color','r','lineWidth',2,'lineStyle','--');
                        end
                        
                    end
                    
                end
            end
        end
        
        
    end
    
    
    
    
    for i=2+count:length(locmax)
        
        di=locmax(i)-locmax(i-1);
        
        %T_M=[T_M di];
        
        
        cut=fluo(locmax(i-1):locmax(i)-thr);
        
        %figure, plot(cut);
        [t1 t2 level1 level2 curve]=fitCellCycle(cut');
        if level2<=level1
            continue
        end
        
        if numel(t1)~=0
            G1_M=[G1_M t1-1];
            S_M=[S_M t2-t1];
            G2_M=[G2_M locmax(i)-locmax(i-1)-t2+thr-1];
            T_M=[T_M di];
            
            
            for n=locmax(i-1)+1:locmax(i)
                % n
                if n<=locmax(i-1)+t1
                    segmentation.tnucleus(id).Obj(n).Min=round(100*double(n-locmax(i-1))/double(t1));
                end
                
                if n<=locmax(i-1)+t2 & n>locmax(i-1)+t1
                    segmentation.tnucleus(id).Obj(n).Min=200+round(100*double(n-t1-locmax(i-1))/double(t2-t1));
                end
                
                if n>locmax(i-1)+t2
                    segmentation.tnucleus(id).Obj(n).Min=400+round(100*double(n-locmax(i-1)-t2)/double(locmax(i)-locmax(i-1)-t2));
                end
                
            end
            
            if display==2
                figure(h); line([firstFrame+locmax(i-1) firstFrame+locmax(i-1)],[min(fluo) max(fluo)],'Color','k','lineWidth',2,'lineStyle','--');
                
                [xout,yout]=plotFit(1:1:length(cut),cut,t1,t2,0);
                plot(xout+firstFrame+locmax(i-1)-1,yout,'Color','r','lineWidth',2,'lineStyle','--');
                
            end
        end
        
    end
    
    if numel(locmax)
        if display==2
            figure(h); line([firstFrame+locmax(end) firstFrame+locmax(end)],[min(fluo) max(fluo)],'Color','k','lineWidth',2,'lineStyle','--');
        end
    end
    
    
    
    
    
    % remove aberrant traces % TO DO IN PARTICULAR FOR DAUGHTERS !!!
    % fit model of histone production during cell cycle regulation
    % remove aberrant timings
    
    
    if display==2
        figure(h); set(gcf,'Position',[200 200 1200 600]);
        xlabel('Time (frames)','FontSize',24);
        ylabel('HTB2-GFP fluo content (A.U.)','FontSize',24);
        set(gca,'FontSize',24);
    end
   
    
    
    
 
    
    
end









% construct histograms

if numel(T_D)==0
    T_D=0;
    G1_D=0;
    S_D=0;
    G2_D=0;
end


xT=0:10:3*(max(max(T_D),max(T_M)));
xG1=0:10:3*(max(max(G1_D),max(G1_M)));
xG2=0:5:3*(max(max(G2_D),max(G2_M)));
xS=0:5:3*(max(max(S_D),max(S_M)));

if T_D(1)==0
    T_D=[];
    G1_D=[];
    S_D=[];
    G2_D=[];
end

if display
    
    figure;
    subplot(2,4,1);
    
    %xT=[];
    if numel(T_D)
        %xT=0:10:3*max(T_D);
        y=hist(3*T_D,xT); bar(xT,y,'FaceColor','r'); xlim([0 max(xT)]);
        title(['T D: <>=' num2str(mean(3*T_D)) ' ; CV=' num2str(std(T_D)/mean(T_D)) '; n=' num2str(length(T_D))]);
        xlabel('Time (min)');
        ylabel('# of events');
    end
    
    subplot(2,4,2);
    
    %xG1=[];
    if numel(G1_D)
        %xG1=0:10:3*max(G1_D);
        y=hist(3*G1_D,xG1); bar(xG1,y,'FaceColor','r'); xlim([0 max(xG1)]);
        title(['G1 D: <>=' num2str(mean(3*G1_D)) ' ; CV=' num2str(std(G1_D)/mean(G1_D)) ]);
        xlabel('Time (min)');
        ylabel('# of events');
    end
    
    subplot(2,4,3);
    
    %xS=[];
    if numel(S_D)
        %xS=0:5:3*max(S_D);
        y=hist(3*S_D,xS); bar(xS,y,'FaceColor','r'); xlim([0 max(xS)]);
        title(['S D: <>=' num2str(mean(3*S_D)) ' ; CV=' num2str(std(S_D)/mean(S_D)) ]);
        xlabel('Time (min)');
        ylabel('# of events');
    end
    
    subplot(2,4,4);
    
    %xG2=[];
    if numel(G2_D)
        %xG2=0:5:3*max(G2_D);
        y=hist(3*G2_D,xG2); bar(xG2,y,'FaceColor','r'); xlim([0 max(xG2)]);
        title(['G2/M D: <>=' num2str(mean(3*G2_D)) ' ; CV=' num2str(std(G2_D)/mean(G2_D)) ]);
        xlabel('Time (min)');
        ylabel('# of events');
    end
    
    
    subplot(2,4,5);
    
    if numel(T_M)
        % if numel(xT)==0
        %    xT=0:10:3*max(T_M);
        %end
        
        y=hist(3*T_M,xT); bar(xT,y,'FaceColor','r'); xlim([0 max(xT)]);
        title(['T M: <>=' num2str(mean(3*T_M)) ' ; CV=' num2str(std(T_M)/mean(T_M)) '; n=' num2str(length(T_M))]);
        xlabel('Time (min)');
        ylabel('# of events');
    end
    
    subplot(2,4,6);
    if numel(G1_M)
        %if numel(xG1)==0
        %   xG1=0:10:3*max(G1_M);
        %end
        y=hist(3*G1_M,xG1); bar(xG1,y,'FaceColor','r'); xlim([0 max(xG1)]);
        title(['G1 M: <>=' num2str(mean(3*G1_M)) ' ; CV=' num2str(std(G1_M)/mean(G1_M)) ]);
        xlabel('Time (min)');
        ylabel('# of events');
    end
    
    subplot(2,4,7);
    if numel(S_M)
        %if numel(xS)==0
        %   xS=0:5:3*max(S_M);
        %end
        y=hist(3*S_M,xS); bar(xS,y,'FaceColor','r'); xlim([0 max(xS)]); %max(xS)
        title(['S M: <>=' num2str(mean(3*S_M)) ' ; CV=' num2str(std(S_M)/mean(S_M)) ]);
        xlabel('Time (min)');
        ylabel('# of events');
    end
    
    subplot(2,4,8);
    if numel(G2_M)
        %if numel(xS)==0
        %   xS=0:5:3*max(G2_M);
        %end
        y=hist(3*G2_M,xG2); bar(xG2,y,'FaceColor','r'); xlim([0 max(xG2)]);
        title(['G2/M M: <>=' num2str(mean(3*G2_M)) ' ; CV=' num2str(std(G2_M)/mean(G2_M)) ]);
        xlabel('Time (min)');
        ylabel('# of events');
    end
    
    
    % plot mean traj data
    
    % plot correlation between phase durations
    
    
    X_D=[T_D ; G1_D ; S_D ; G2_D];
    X_M=[T_M ; G1_M ; S_M ; G2_M];
    
    corrcoef(X_D'),corrcoef(X_M')
    
    
    
end

stat.T_D=T_D;
stat.T_M=T_M;
stat.G1_M=G1_M;
stat.G1_D=G1_D;
stat.G2_M=G2_M;
stat.G2_D=G2_D;
stat.S_M=S_M;
stat.S_D=S_D;


function [t1 t2 level1 level2 curve]=fitCellCycle(fdiv)

chi2=zeros(size(fdiv));

%fdiv(fdiv>0.2)=0.15;

for i=1:length(fdiv)-1
    for j=i+1:length(fdiv)
        %chi2=0;
        
        level1=mean(fdiv(1:i));
        level2=mean(fdiv(j:end));
        
        chi2(i,j)= sum((fdiv(1:i)-level1).^2)+sum((fdiv(j:end)-level2).^2);
        
        if j>i+1
            arrx=i:1:j;
            arry=(level1-level2)/(i-j)*arrx+(level2*i-level1*j)/(i-j);
            
            chi2(i,j)= chi2(i,j) + sum( (fdiv(i+1:j-1)- arry(2:end-1)).^2 );
            
            
        end
        
        %          if i>8
        %          plotFit(1:1:length(fdiv),fdiv,i,j);
        %         a=chi2(i,j),i,j
        %          pause
        %          close
        %          end
        
    end
end


pix=find(chi2==0);
chi2(pix)=max(max(chi2));

[m pix]=min(chi2(:));
%figure, plot(chi2(:));
[i j]=ind2sub(size(chi2),pix);

t1=i;
t2=j;

if numel(t1)==0
    level1=[];
    level2=[];
    curve=[];
    return;
end

if numel(t2)==0
    level1=[];
    level2=[];
    curve=[];
    return;
end


%[xt yt]=plotFit(1:1:length(fdiv),fdiv,i,j,1);

level1=mean(fdiv(1:i));
level2=mean(fdiv(j:end));

curve(1:i)=level1*ones(1,i);


%length(fdiv)-j

curve(j:length(fdiv))=level2*ones(1,length(fdiv)-j+1);

arrx=i:1:j;
arry=(level1-level2)/(i-j)*arrx+(level2*i-level1*j)/(i-j);
curve(i+1:j-1)=arry(2:end-1);




function [xout,yout]=plotFit(x,fdiv,i,j,display)

if display
    figure;
end

level1=mean(fdiv(1:i));
level2=mean(fdiv(j:end));

line1x=1:i; line1y=level1*ones(1,length(line1x));
line2x=j:length(fdiv); line2y=level2*ones(1,length(line2x));

if j>=i+1
    arrx=i:1:j;
    arry=(level1-level2)/(i-j)*arrx+(level2*i-level1*j)/(i-j);
end

if display
    plot(x,fdiv,'Marker','.','LineStyle','none','MarkerSize',20); hold on;
    
    plot(line1x+x(1)-1,line1y,'Color','r','LineStyle','--'); hold on;
    
    
    
    plot(line2x+x(1)-1,line2y,'Color','r','LineStyle','--');  hold on;
    
    
    if j>=i+1
        plot(arrx+x(1)-1,arry,'Color','r','LineStyle','--');
    end
end

xout=line1x+x(1)-1;
yout=line1y;
xout=[xout arrx+x(1)-1];
yout=[yout arry];
xout=[xout line2x+x(1)-1];
yout=[yout line2y];


