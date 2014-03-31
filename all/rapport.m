function rapport( R ,r )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a=((4*R^3)-6*r*r*sqrt(R*R-r*r))/(3*(R*R-r*r));
i=2*sqrt(R*R-r*r)-4*r/3;
disp(['i=' , num2str(i)]);
disp(['a=' , num2str(a)]);
disp(['ratio=' , num2str(i/a)]);

end

