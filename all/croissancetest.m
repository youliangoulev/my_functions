function [o] = croissancetest( d1 , d2 , d3 , c1 , c2 , c3 , step , iteration)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


a(1)=1;
b(1)=0;
c(1)=0;
n=1;
nb(1)=1;
S(1)=0;
time(1)=0;
for i=1:iteration
    for j=1:n
        
        if a(j)==1
           if ((b(j)+step)>d1)
           a=[a , 1];
           b=[b , b(j)+step-d1];
           c=[c ,(b(j)+step-d1)*c1];
           a(j)=2;
           c(j)=c(j)+(d1-b(j))*c1+(b(j)+step-d1)*c2;
           b(j)=b(j)+step-d1;
           else
           c(j)=c(j)+step*c1;
           b(j)=b(j)+step;
           end
        end
        
        if a(j)==2
           if ((b(j)+step)>d2)
           a(j)=3;   
           c(j)=c(j)+(d2-b(j))*c2+(b(j)+step-d2)*c3;
           b(j)=b(j)+step-d2;
           else
           c(j)=c(j)+step*c2;
           b(j)=b(j)+step;
           end 
        end
            
        if a(j)==3      
           if ((b(j)+step)>d3)
           a=[a , 1];
           c=[c ,(b(j)+step-d3)*c1];  
           b=[b , b(j)+step-d3];
           a(j)=2;
           c(j)=c(j)+(d3-b(j))*c3+(b(j)+step-d3)*c2;
           b(j)=b(j)+step-d3;
           else
           c(j)=c(j)+step*c3;
           b(j)=b(j)+step;
           end
        end   
    end
    n=size(b,2);
    nb=[nb , size(a,2)];
    S=[S , sum(c)]; 
    time=[time   , i*step];  
end


 g.nb=nb;
 g.S=S;
 g.time=time;
 g.rap=S./nb;
 o=g;
    
 plot(time,g.rap);   


end

