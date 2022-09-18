function [ grad ] = Gradient ( )
grad=0;
global w A b;
grad = (A'*(A * w) ) -  (A'*b);
end

