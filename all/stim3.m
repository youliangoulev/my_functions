function [out] = croissancetest( d1 , d2 , d3 , c1 , c2 , c3 , divbud , step , iteration)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


a(1)=1;
b(1)=0;
c(1)=0;
n=1;
nb(1)=1;
S(1)=0;
for i=1:iteration
    for j=1:n
        
        if a(n)=1
           if ((b(n)+step)>d1
           a(n)=2
           b(n)=b(n)+step-d1
           c(n)=(d1-b(n))*c1+(b(n)+step-d1)*c2
           a=[a , 1];
           b=[b , b(n)+step-d1];
           c=[c ,(b(n)+step-d1)*c1]
           else
            
           end
        end
        
        if a(n)=2
            
        end
            
        if a(n)=3
            
        end   
    end      
      
end


    
    
    


end

