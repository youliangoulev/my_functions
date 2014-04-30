function [  size , delta , track ] = deltasizetrack_fusion( size1 , delta1 , track1 , size2 , delta2 , track2 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes her
maxcel=0;
time=min(length(size1.all) , length(size2.all ) );
for i=1:length(track1.mother)
    if max(track1.mother{i})>maxcel
        maxcel=max(track1.mother{i}) ;
    end;
    if max(track1.self{i})>maxcel
        maxcel=max(track1.self{i}) ;
    end;
    if max(track1.child{i})>maxcel
        maxcel=max(track1.child{i}) ;
    end;
end;
maxcel=maxcel+100;
for i=1:length(track2.mother)
    track2.mother{i}=track2.mother{i}+maxcel;
    track2.self{i}=track2.self{i}+maxcel;
    track2.child{i}=track2.child{i}+maxcel;
end;
for i=1:time
    newsize.self{i}=[size1.self{i} , size2.self{i} ];
    newdelta.self{i}=[delta1.self{i} , delta2.self{i} ];
    newsize.mother{i}=[size1.mother{i} , size2.mother{i} ];
    newdelta.mother{i}=[delta1.mother{i} , delta2.mother{i} ];
    newsize.child{i}=[size1.child{i} , size2.child{i} ];
    newdelta.child{i}=[delta1.child{i} , delta2.child{i} ];
    newsize.all{i}=[size1.all{i} , size2.all{i} ];
    newdelta.all{i}=[delta1.all{i} , delta2.all{i} ];
    newtrack.self{i}=[track1.self{i} , track2.self{i} ];
    newtrack.mother{i}=[track1.mother{i} , track2.mother{i} ];
    newtrack.child{i}=[track1.child{i} , track2.child{i} ];
    newtrack.generation{i}=[track1.generation{i} , track2.generation{i} ];
    newtrack.birth{i}=[track1.birth{i} , track2.birth{i} ];
end;
delta=newdelta;
size=newsize;
track=newtrack;
end

