function [out ] = Wini( in,pat )
global patterncount , global N_Total,global  output_index input_index b q2 A w r qtemp  MSEaveg wplus wminus  Winv qinv
global  y 
global TR_in ,global outpat
TR_in = in;
outpat = pat;
prepare_trn_patterns2;
NIint = 100;
k = size(y);
q2= zeros(k(1)*N_Total,1);
patterncount = k(1);
ss = size(output_index);
for kk=1:patterncount
    for i=1:ss(2)
     q2(kk*output_index(i)) = y(kk,output_index(i));
   end
end
%sin = size(input_index);
sin = size(output_index);
%sin(2) number of out put nodes
%N_total - sin(2) = number of non out put nodes
for k=1:patterncount 
 for i=1:N_Total-sin(2)
 %    ro = (k-1)*output_index +i;
  ro = (k-1)*N_Total +i;
q2(ro) = rand(1);
 end
  

end

   
    msemin=1000;
wplus = zeros(N_Total,N_Total);
wminus = zeros(N_Total,N_Total);
for m=1:NIint
    if(m~=1)
    prepare_trn_patterns2;
    end
    Update_A;
     MSEaveg =0.0;
        Update_b;
       w = NNLS();
       Update_W;
 
   
    %for all k obtain qik
    for k=1: patterncount
         r=  calculate_rate;
       qtemp= calculate_ffm_output(k);
       qinv = qtemp;
       for i=1:output_index-1
         %  ro = (k-1)*output_index +i;
          ro = (k-1)*N_Total +i;
           q2(ro) = qtemp(i);
       end
      
%        ro = (k-1)*output_index;
% for i=1:output_index       
%            qinv(i) = q2(ro+i);
% 
% end
       
    MSEaveg = calculate_mse(k);
     Winv =  calculate_inv();
      wplus =  update_wplus_1(k);
       wminus =  update_wminus_1(k);
       
    end
    %update the q for i = non out put
   % compute mean err and variance of
       
  MSEaveg = MSEaveg/patterncount;
    if ( MSEaveg<= msemin)
         msemin =  MSEaveg;
       Update_Wtemp;
        end
MSE_RESULT =  MSEaveg;
end
Update_Wgoal;
%Normal_W;

end

function  MSEaveg = calculate_mse(k)

global  N_Output output_index q y     qtemp  MSEaveg
 
MSE = 0.0;
for i = 1:N_Output  
   a = qtemp(output_index(i)) - y(k,output_index(i));
   MSE = MSE + a*a;
end
MSEaveg = MSEaveg + MSE;
end


function [] = Normal_W
global input_index N_Total wplus wminus max N_Input N_Output RAND_RANGE

for i=1:N_Input
    max=0;
    for j=1: N_Total
        if(wplus(i,j)>max)
            max = wplus(i,j);
        end
    end
    
    for j=1: N_Total
       wplus(i,j) =  RAND_RANGE * wplus(i,j) /max; 
    end 
    
     max=0;
    for j=1: N_Total
        if(wminus(i,j)>max)
            max = wminus(i,j);
        end
    end
    
    for j=1: N_Total
       wminus(i,j) = RAND_RANGE *  wminus(i,j) /max; 
    end 
    
end



end

function []= Update_Wgoal()
global N_Total w  wplustemp wminustemp wplus wminus wplus_conn wplus_index wminus_conn wminus_index 

  for i=1:N_Total
       for j=1:wplus_index(i)      
      wplus(i,wplus_conn(i,j))    =  wplustemp(i,wplus_conn(i,j)) ;
            end
       end

  
  for i=1:N_Total
       for j=1:wminus_index(i)      
      wminus(i,wminus_conn(i,j))    =  wminustemp(i,wminus_conn(i,j)) ;
            end
       end
end



function []= Update_Wtemp()
global N_Total w  wplustemp wminustemp wplus_conn wplus_index wminus_conn wminus_index 

  for i=1:N_Total
       for j=1:wplus_index(i)
           k=(i-1)*N_Total + wplus_conn(i,j);
            if(wplus_conn(i,j)~=0)
      wplustemp(i,wplus_conn(i,j)) = w(k);
            end
       end
  end
  
  for i=1:N_Total
       for j=1:wminus_index(i)
             k=(i-1)*N_Total + wminus_conn(i,j) + N_Total*N_Total;
             if(wminus_conn(i,j)~=0)
      wminustemp(i,wminus_conn(i,j)) = w(k);
             end
       end
  end
end



function []= Update_W()
global N_Total w  wplus wminus wplus_conn wplus_index wminus_conn wminus_index 
% for i=1:N_Total
%     k=(i-1)*N_Total;
%   for j=1:N_Total
%       k=k+1;
% wplus(i,j) = w(k);
%  end
% end
%  
%        
% for i=1:N_Total
%     k=(i-1)*N_Total;
%   for j=1:N_Total
%       k=k+1;
% wminus(i,j) = w(k);
%  end
%        end
 

  for i=1:N_Total
      for j=1:wplus_index(i)
    
           k=(i-1)*N_Total + wplus_conn(i,j);
     
           if(wplus_conn(i,j)~=0)
      wplus(i,wplus_conn(i,j)) = w(k);
   
            end
       end
  end
  
  for i=1:N_Total
     for j=1:wminus_index(i)
        
            if(wminus_conn(i,j)~=0)
     wminus(i,wminus_conn(i,j)) = w(k);

            end
       end
  end
 
%   for i=1:N_Total 
%       for j=1:N_Total 
%           if (wplus(i,j)==0)
%               w((i-1)*N_Total + j) =0;
%           end    
%       end
%   end
%   
%   
%    for i=1:N_Total 
%       for j=1:N_Total 
%           if (wplus(i,j)==0)
%               w((i-1)*N_Total + j + N_Total*N_Total) =0;
%           end    
%       end
%   end
  
end


function Update_A()
global   N_Train_Patterns   N_Total A q output_index q2
for k1=1: N_Train_Patterns

    
    for i=1:N_Total
   for j=1:N_Total
  %  ro = (k1-1)*output_index +i;
     ro = (k1-1)*N_Total +i;
           if (i~=j)
              A(ro,(i-1)*N_Total +j)= q2(ro);    
           end
   end 
   
    for j=1:N_Total
           if (i~=j)
%                 ro = (k1-1)*output_index +i;
%                 col = (k1-1)*output_index +j;
                 ro = (k1-1)*N_Total +i;
                  col = (k1-1)*N_Total+j;
                
              A(ro,(j-1)*N_Total +i)= -q2(col);    
           end
   end 
      
   for j=1:N_Total
           if (i~=j)
               % ro = (k1-1)*output_index +i;
                 ro = (k1-1)*N_Total +i;
              A(ro,(i-1)*N_Total +(N_Total^2)+ j)= q2(ro);    
           end
   end 
   
    for j=1:N_Total
           if (i~=j)
%                 ro = (k1-1)*output_index +i;
%                 col = (k1-1)*output_index +j;
                
                 ro = (k1-1)*N_Total +i;
                  col = (k1-1)*N_Total+j;
              A(ro,(j-1)*N_Total + (N_Total^2)+i) = q2(ro)*q2(col);    
           else
              %  ro = (k1-1)*output_index +i;
                 ro = (k1-1)*N_Total +i;
              A(ro,(j-1)*N_Total + (N_Total^2)+i) =  q2(ro) +q2(ro) *q2(ro) ; 
           end
   end 

    end

end
end

function Update_b()
global TR_in  N_Train_Patterns  y  N_Total  b lambda  LAMBDA q2
k = size(y);
b  = zeros(k(1)*N_Total,1);
sz = size(TR_in);
N_Train_Patterns = sz(1);
for kk = 1:N_Train_Patterns
   for i = 1:N_Total
     b(kk*i) = LAMBDA(kk,i) - q2(kk*i)*lambda(kk,i);
   end
end

end


function prepare_trn_patterns2()
global TR_in outpat N_Train_Patterns  y  N_Total N_Output  N_Input LAMBDA lambda q2 output_index patterncount
sz = size(TR_in);
N_Train_Patterns = sz(1);
Applied_y = outpat ;
for k = 1:N_Train_Patterns
   for i = 1:(N_Total - N_Output)
      y(k,i) = 0.0;
   end
   j=1;
   for i = (N_Total - N_Output+1):N_Total
      y(k,i) = Applied_y(k*j);
      j = j+1;   
   end
end

% for i = 1:N_Train_Patterns
%    for j = 1:N_Input
%     TR_in(i,j) = TR_in(i,j) - 0.5;
%    end
% end 


 Applied_lambda = zeros(N_Train_Patterns,N_Total);
 Applied_LAMBDA = zeros(N_Train_Patterns,N_Total);

for i = 1:N_Train_Patterns
   for j = 1:N_Input
     Applied_lambda(i,j) = 0.0;
   end
end

for i = 1:N_Train_Patterns
   for j = 1:N_Input
      Applied_LAMBDA(i,j) = 0.0;
   end
end

for i = 1:N_Train_Patterns
   for j = 1:N_Input
      if (TR_in(i,j) >= 0)
         Applied_LAMBDA(i,j) = TR_in(i,j);
           elseif(TR_in(i,j) < 0)
         Applied_lambda(i,j)= -TR_in(i,j);
      end
     end
end
for k = 1:N_Train_Patterns
   for i = 1:N_Input
      LAMBDA(k,i) = Applied_LAMBDA(k,i) ;
   end
   for i = (N_Input+1):N_Total
      LAMBDA(k,i) = 0.0;
   end
end

for k = 1:N_Train_Patterns
   for i = 1:N_Input
      lambda(k,i) = Applied_lambda(k,i) ;
   end
   for i = (N_Input+1):N_Total
      lambda(k,i) = 0.0;
   end
end

end  

function r_result = calculate_rate()     

global N_Total wplus wminus R_IN R_Out FIX_RIN N_Output output_index AUTO_MAPPING;
global N_Input

for i = 1:N_Total
   r_result(i) = 0.0;
end
if(FIX_RIN == 1 )
   for i = 1:N_Input
      r_result(i) = R_IN;
   end
   
   for i = (N_Input+1):N_Total
      for j = 1:N_Total
         r_result(i) = r_result(i) + wplus(i,j) + wminus(i,j);
      end
   end
end

if(FIX_RIN == 0 )
   for i = 1:N_Total
      for j = 1:N_Total
         r_result(i) = r_result(i) + wplus(i,j) + wminus(i,j);
      end
   end
end
if(AUTO_MAPPING == 0)
   for i = 1:N_Output
      r_result(output_index(i)) = R_Out;   
   end
end
end

function q_result = calculate_ffm_output(k)

global wplus wminus  ;
global r;
global N_Total N_Input q2 N_Output;
global R_Out;
global output_index LAMBDA lambda y D  Res;

% N_Hidden = 5;
%   for i = 1:N_Input
%         N(i) = LAMBDA(k,i);
%         D(i) = lambda(k,i) + r(i);    
%         q2(k*i) = N(i)/D(i);
%         if (q2(k*i) > 1.0) 
%            q2(k*i) = 1.0;
%         end
%      end
%      
%     for i = (N_Input+1):(N_Input+N_Hidden)
%        N(i) = 0.0;
%        D(i) = 0.0;
%        for j = 1:N_Input
%          N(i) = N(i) + q2(k*j) * wplus(j,i);
%          D(i) = D(i) + q2(k*j) * wminus(j,i);
%        end
%        N(i) = N(i)+LAMBDA(k,i);
%        D(i) = D(i) + r(i)+lambda(k,i);
%        q2(k*i) = N(i)/D(i);
%        if(q2(k*i) > 1.0) 
%           q2(k*i) = 1.0;
%        end
%     end
%         
%     for i = (N_Input+N_Hidden+1):N_Total
%        N(i) = 0.0;
%        D(i) = 0.0;
%         for j = (N_Input+1):(N_Input+N_Hidden)
%            N(i) = N(i) + q2(k*j) * wplus(j,i);
%            D(i) = D(i) + q2(k*j) * wminus(j,i);
%         end
%         N(i) = N(i)+LAMBDA(k,i);        
%         D(i) = D(i) + r(i) +lambda(k,i);
%         q2(k*i) = N(i)/D(i);
%         if(q2(k*i) > 1.0) 
%            q2(k*i) = 1.0;
%         end
%     end


%q = zeros(1,N_Total);
 %ro = (k-1)*output_index;
 ro = (k-1)*N_Total;
%for i=1:output_index
    for i=1:N_Total
            
           q(i) = q2(ro+i);

end
     for i = 1:N_Total      
        N(i) = 0.0;
        D(i) = 0.0;
        for j = 1:N_Total
          N(i) = N(i) + q(j) * wplus(j,i);
          D(i) = D(i) + q(j) * wminus(j,i);
        end
        N(i) = N(i) + LAMBDA(k,i);
        D(i) = D(i) + r(i) + lambda(k,i);
        if(D(i) ~= 0)
           q(i) = N(i)/D(i);
        end
        if(D(i) == 0)
           q(i) = 1.0;
        end
        if(q(i) > 1.0) 
           q(i) = 1.0;
        end
        if(q(i) < 0.0) 
           q(i) = 0.0;
        end
     end
% q_result = q2;    
q_result = q;
end

function Winv_result = calculate_inv()

global N_Total W wplus wminus q D qinv
   for j = 1:N_Total
      for i = 1:N_Total
         W(j,i) = (wplus(j,i) - (wminus(j,i)*qinv(i)))/D(i);
      end
   end
   inverse2 = inv(eye(N_Total,N_Total)-W);
   Winv = inverse2;
   
Winv_result = Winv; 
end

function wplus_result = update_wplus_1(k)

global N_Total wplus wplus_index wplus_conn N_Output output_index q D Winv y Eta qinv

wplus_result = zeros(N_Total,N_Total);
for u = 1:N_Total
  % for vv = 1:N_Total
   for vv = 1:wplus_index(u)
      v = wplus_conn(u,vv);
      for i = 1:N_Total
         gammaplus(i) = 0.0;
         if ((u ~= i) & (v == i))
            gammaplus(i) = 1.0/D(i);
         end
         if ((u == i) & (v ~= i))
            gammaplus(i) = -1.0/D(i);
         end  
      end
      sum1 = 0;
      for jj = 1:N_Output
         i = output_index(jj);
         vmplus = gammaplus(u) * Winv(u,i) + gammaplus(v) * Winv(v,i);
         sum1 = sum1 + vmplus * (qinv(i) - y(k,i)) * qinv(u);
      end
      
      wplus_result(u,v) = wplus(u,v) - Eta * sum1  ; 
      
      %        if (u == v) 
      %            wplus(u,v) = 0.0; 
      %          end
      if (wplus_result(u,v) < 0)
         wplus_result(u,v) = 0.0;
      end
   end
end
end

function wminus_result = update_wminus_1(k) 

global N_Total wminus wminus_index wminus_conn N_Output output_index q D Winv y Eta qinv 

wminus_result = zeros(N_Total,N_Total);
% updating the negative weights 
for u = 1:N_Total
   for vv = 1:wminus_index(u)
      v = wminus_conn(u,vv);
      for i = 1:N_Total
         gammaminus(i) = 0.0;
         if ((u ~= i) & (v == i))
            gammaminus(i) = -qinv(i)/D(i);
         end
         if ((u == i) & (v ~= i))
            gammaminus(i) = -1.0/D(i);
         end  
         if ((u == i) & (v == i))
            gammaminus(i) = -(1.0 + qinv(i))/D(i);
         end
      end
      sum2 = 0;
      for jj = 1:N_Output
         i = output_index(jj);
         vmminus = gammaminus(u) * Winv(u,i) + gammaminus(v) * Winv(v,i);
         sum2 = sum2 + vmminus * (qinv(i) - y(k,i)) * qinv(u);
      end
      
      wminus_result(u,v) = wminus(u,v) - Eta * sum2 ;
      
      %          if (u == v) 
      %             wminus(u,v) = 0.0; 
      %          end
      if (wminus_result(u,v) < 0)
         wminus_result(u,v) = 0.0;  
      end
   end
end
end

