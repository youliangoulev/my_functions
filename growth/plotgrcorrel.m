function [ output_args ] = plotgrcorrel( delta , track , x2 , x4)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[meandelta1 , totdelta1 , birth1 , gen1 ]=build(delta , track , 1 , x2);
[meandelta2 , totdelta2 , birth2 , gen2 ]=build(delta , track , x4 , length(delta));
[meandelta3 , totdelta3 , birth3 , gen3 ]=build(delta , track , 1 , length(delta));
meandelta4=[meandelta2{:}];
birth4=[];
for i=1:length(birth2)
    birth4=[birth4 , zeros(1,length (meandelta2{i}))+birth2(i)];
end;
meandelta4=meandelta4(birth4>-1);
birth4=birth4(birth4>-1);
meandelta5=[meandelta3{:}];
gen5=[gen3{:}];
meandelta5=meandelta5(gen5>-1);
gen5=gen5(gen5>-1);
figure;
scatter(birth4 , meandelta4);
[ddddd , ppppp]=corrcoef(birth4 , meandelta4)
end

function [mean_delta , all_delta , c_birth , c_gen]=build(delta , track , frame1 , frame2)
celid=[];
budid={};
meandelta={};
totdelta={};
birth=[];
generation={};
cel=[]; 
bud=[];
del=[];
bir=[];
gen=[];
for i=1:length(delta)
    if (i>=frame1)&&(i<=frame2)
        cel=[cel , track.mother{i}];
        bud=[bud , track.child{i}];
        del=[del , delta{i}];
        bir=[bir , track.birth{i}];
        gen=[gen , track.generation{i}];
    end;
end;
celid=[celid , min(cel)];
while celid(end)<max(cel)
    celid=[celid , min(cel(cel>celid(end)))];
end;
for i=1:length(celid)
    bud1=bud(cel==celid(i));
    budid{i}=[min(bud1)];
    while budid{i}(end)<max(bud1)
       budid{i}=[budid{i} , min(bud1(bud1>budid{i}(end)))];
    end;
    generation{i}=[];
    meandelta{i}=[];
    totdelta{i}=[];
    for j=1:length(budid{i})
        generation{i}=[generation{i} , gen(find( ( cel == celid(i) ) & ( bud == budid{i}(j) ) , 1) )];
        meandelta{i}=[meandelta{i} , mean(del(( cel == celid(i) ) & ( bud == budid{i}(j) )))];
       totdelta{i}=[totdelta{i} , del(( cel == celid(i) ) & ( bud == budid{i}(j) ))];
    end;
    birth(i)=bir(find( cel==celid(i) , 1 ));
end;
mean_delta=meandelta;
all_delta=totdelta;
c_birth=birth;
c_gen=generation;
end

