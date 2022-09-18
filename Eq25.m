function [ out ] = Eq25(  )
global wcand w sigma 
x1 = Gradient();
%x2 = inv(x1);
x2 = x1';
x3 = sigma*x2;
x4 = wcand - w;
x5 = f(wcand); 
x6 = f(w);
x7 = x3*x4;
if( x5 - x6<= x7)
             out = true;
else
             out= false;


end

