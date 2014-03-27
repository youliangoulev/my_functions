function renommer( target , initial )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

cd(target);
a1=dir('*pos*');

t=a1;
r=[];
for g=1:length(t)
    if t(g).isdir==1
        r=[r , g];
    end;
end;
a1=t(r);

aa1={};
bb1={};
for i=1:length(a1)
    aa1{i}=a1(i).name;  
end;
    cd(a1(1).name);
    b1=dir('*pos*');
for i=1:length(b1)
    bb1{i}=b1(i).name(end-5:end);   
end;
    cd(b1(1).name);
    qq=dir('*.jpg');
    lm=length(qq);

cd(initial);
a2=dir('*pos*');

t=a2;
r=[];
for g=1:length(t)
    if t(g).isdir==1
        r=[r , g];
    end;
end;
a2=t(r);

for i=1:length(a2)
    disp('%===========================================================================');
    cd(fullfile( initial , a2(i).name) );
    b2=dir('*pos*');
    for j=1:length(b2)
        cd(fullfile ( initial , a2(i).name , b2(j).name) );
        l=dir('*.jpg');
        for k=1:length(l)
            disp(fullfile(initial , a2(i).name , b2(j).name , l(k).name ));
            disp(fullfile(target , aa1{i} , bb1{j} , [bb1{j} ,'-' , num2str( lm+k, '%03d' ) , '.jpg']));
            disp('');
           copyfile(fullfile(initial , a2(i).name , b2(j).name , l(k).name ) , fullfile(target , aa1{i} , [aa1{i} , bb1{j}] , [[aa1{i} , bb1{j}] ,'-' , num2str( lm+k, '%03d' ) , '.jpg']))
        end;
    end;
end;

end

