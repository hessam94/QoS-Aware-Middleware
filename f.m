function [ sum ] = f( wtemp )
global A N_Total b patterncount 
  sum=0;
             temp = A * wtemp;
%              for i = 1:  N_Total*patterncount 
%              
%                  sum =sum +  temp(i) - b(i);
%              end
%              sum = sum^2;
%              sum = sum / 2;
             
sum = norm( temp - b,'fro');
%sum = norm( temp - b);

end

