%%%******************   begin train_rnn_gen.m  *********************%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  Info  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   File Name       :     train_rnn_gen.m                         %%%
%%%   Type            :     m function file                         %%%
%%%   Parent          :     use_rnn_gen.m                           %%%
%%%   External Calls  :     vardef.m                                %%%  
%%%   Internal Calls  :     prepare_trn_patterns                    %%%
%%%                         calculate_rate                          %%%
%%%                         calculate_ffm_output                    %%%
%%%                         calculate_mse                           %%%
%%%                         Calculate_inv                           %%%
%%%                         update_wplus_1                          %%%
%%%                         update_wpminus_1                        %%%
%%%   Date            :     September, 1, 1999                      %%%
%%%   Author          :     Hossam Eldin Mostafa Abdelbaki          %%%
%%%   Address         :     University of Central Florida,          %%%
%%%                   :     School of Computer Science              %%%
%%%  Email            :     ahossam@cs.ucf.edu                      %%% 
%%%  Home Page        :     http://www.cs.ucf.edu/~ahossam/         %%% 
%%%  Help             :     read the manual file (rnnsimv2.pdf)     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function MSE_RESULT = train_rnn_gen(kind,TRAIN_INPUT_1,TARGET_1,num_iter)

if(nargin == 3)
   num_iter = 1;   
end

vardef;                     %load the global variables 

TRAIN_INPUT = TRAIN_INPUT_1;
TARGET = TARGET_1;
sz = size(TRAIN_INPUT);
N_Train_Patterns = sz(1);
prepare_trn_patterns;

MSEaveg = 0.0;
for iii = 1:num_iter
   MSEaveg = 0.0;   
   for ppp = 1:N_Train_Patterns    
      
      k = Z(ppp);
      r = calculate_rate;                   %Calculate Rate
      if(kind == '1')
         q = calculate_ffm_output(k);           %Solve for q
      end
      if(kind == '2')
         q = solve_nonlinear_equations_1(k);   %Solve for q
      end
      MSEaveg = calculate_mse(k);           %Calculate MSE
      Winv = calculate_inv;                 %Calculate MSE 
      wplus =  update_wplus_1(k);
      wminus =  update_wminus_1(k);
      
   end %ppp
end %num_iter

MSEaveg = MSEaveg/N_Train_Patterns;
MSE_RESULT =  MSEaveg;

%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% prepare_trn_patterns  %%%%%%%%%%%%%%%%%%%%%%%%%
function prepare_trn_patterns()

global N_Train_Patterns TARGET TRAIN_INPUT N_Input LAMBDA lambda y  N_Total
global wplus wplus_index wplus_conn RAND_RANGE N_Output
global wminus wminus_index wminus_conn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%####### Setting the Excitatory and Inhibitatory Training Patterns ########
%Applied_lambda = zeros(N_Train_Patterns,N_Input);             
for i = 1:N_Train_Patterns
   for j = 1:N_Input
      Applied_lambda(i,j) = 0.0;
   end
end

%Applied_LAMBDA = zeros(N_Train_Patterns,N_Input);
for i = 1:N_Train_Patterns
   for j = 1:N_Input
      Applied_LAMBDA(i,j) = 0.0;
   end
end

Applied_y = TARGET;
%yyy = size(TRAIN_INPUT);
%N_Train_Patterns = yyy(1);
for i = 1:N_Train_Patterns
   for j = 1:N_Input
      if (TRAIN_INPUT(i,j) >= 0)
         Applied_LAMBDA(i,j) = TRAIN_INPUT(i,j);
      elseif(TRAIN_INPUT(i,j) < 0)
         Applied_lambda(i,j)= -TRAIN_INPUT(i,j);
      end
   end
end  

%##### Preparing LAMBDA #################
%fill = zeros(N_Train_Patterns , N_Total - N_Input);
%LAMBDA = [Applied_LAMBDA fill];
for k = 1:N_Train_Patterns
   for i = 1:N_Input
      LAMBDA(k,i) = Applied_LAMBDA(k,i) ;
   end
   for i = (N_Input+1):N_Total
      LAMBDA(k,i) = 0.0;
   end
end

%##### Preparing lambda #################
%Applied_lambda=zeros(N_Train_Patterns,N_Input);
%fill = zeros(N_Train_Patterns , N_Total - N_Input);
%lambda=[Applied_lambda fill];
for k = 1:N_Train_Patterns
   for i = 1:N_Input
      lambda(k,i) = Applied_lambda(k,i) ;
   end
   for i = (N_Input+1):N_Total
      lambda(k,i) = 0.0;
   end
end

%##### Preparing y #################
%fill = zeros(N_Train_Patterns , N_Total-N_Output);
%y=[fill Applied_y];       
for k = 1:N_Train_Patterns
   for i = 1:(N_Total - N_Output)
      y(k,i) = 0.0;
   end
   j=1;
   for i = (N_Total - N_Output+1):N_Total
      y(k,i) = Applied_y(k,j);
      j = j+1;   
   end
end
%%%%%%%%%%%%%%%%%%%%% end prepare_trn_patterns  %%%%%%%%%%%%%%%%%%%%%%%%%  

%%%%%%%%%%%%%%%%%%%%  calculate_rate  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
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
%%%%%%%%%%%%%%%%%%%%  end calculate_rate  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%%%%%%%%%%%%%%%%%%%%  calculate_ffm_output  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function q_result = calculate_ffm_output(k)

global wplus wminus;
global r;
global N_Total N_Input N_Output;
global R_Out;
global output_index LAMBDA lambda y D  Res;

%N_Hidden = 8;
%   for i = 1:N_Input
%         N(i) = LAMBDA(k,i);
%         D(i) = lambda(k,i) + r(i);    
%         q(i) = N(i)/D(i);
%         if (q(i) > 1.0) 
%            q(i) = 1.0;
%         end
%      end
     
%     for i = (N_Input+1):(N_Input+N_Hidden)
%        N(i) = 0.0;
%        D(i) = 0.0;
%        for j = 1:N_Input
%          N(i) = N(i) + q(j) * wplus(j,i);
%          D(i) = D(i) + q(j) * wminus(j,i);
%        end
%        N(i) = N(i)+LAMBDA(k,i);
%        D(i) = D(i) + r(i)+lambda(k,i);
%        q(i) = N(i)/D(i);
%        if(q(i) > 1.0) 
%           q(i) = 1.0;
%        end
%     end
        
%     for i = (N_Input+N_Hidden+1):N_Total
%        N(i) = 0.0;
%        D(i) = 0.0;
%         for j = (N_Input+1):(N_Input+N_Hidden)
%            N(i) = N(i) + q(j) * wplus(j,i);
%            D(i) = D(i) + q(j) * wminus(j,i);
%         end
%         N(i) = N(i)+LAMBDA(k,i);        
%         D(i) = D(i) + r(i) +lambda(k,i);
%         q(i) = N(i)/D(i);
%         if(q(i) > 1.0) 
%            q(i) = 1.0;
%         end
%     end
q = zeros(1,N_Total); 
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
q_result = q;     
%%%%%%%%%%%%%%%%%%%  end calculate_ffm_output  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%  solve_nonlinear_equations_1 %%%%%%%%%%%%%%%%%%%%%%%%%%%
function q_result = solve_nonlinear_equations_1(k)

global wplus wminus;
global r;
global N_Total;
global R_Out;
global output_index LAMBDA lambda y D  Res;

lambda_minus = .2*rand(1,N_Total);
for i = 1:N_Total
   for j = 1:N_Total
      if(r(i) ~= 0)
         Pplus(i,j) = wplus(i,j)/r(i);
         Pminus(i,j) = wminus(i,j)/r(i);
      else
         Pplus(i,j) = 0;
         Pminus(i,j) = 0;
      end
   end
end

for llll = 1:200
   for i = 1:N_Total
      for j = 1:N_Total
         if(i == j)
            F(i,j) = r(i)/(r(i) + lambda_minus(i));
         else
            F(i,j)=0;
         end
      end
   end
   lambda_plus = LAMBDA(k,:)*inv(eye(N_Total,N_Total)-F*Pplus);
   G = lambda_plus*F*Pminus + lambda(k,:);
   %  abs(lambda_minus - G)
   %  llll
   %  pause
   iii = 0;
   for ll = 1:length(lambda_minus)
      if(abs(lambda_minus(i) - G(i)) > .001 | lambda_minus(i) < 0)
         iii = iii + 1;
      end
   end
   if(iii > 0)
      lambda_minus = G;
   else 
      break;
   end
end

for i = 1:N_Total
   for j = 1:N_Total
      if(i == j)
         F(i,j) = r(i)/(r(i) + lambda_minus(i));
      end
      if(i ~= j)
         F(i,j)=0;
      end
   end
end

lambda_plus = LAMBDA(k,:)*inv(eye(N_Total,N_Total)-F*Pplus);
for i = 1:N_Total
   q(i) = lambda_plus(i)/(r(i)+lambda_minus(i));
   if q(i) > 1
      q(i) = 1;
   end
   if(q(i) < 0)
      q(i) = 0;
   end
   
   D(i) = lambda_minus(i)+r(i);   
end
q_result = q;     
%%%%%%%%%%%%%%%%%%%%% end solve_nonlinear_equations_1 %%%%%%%%%%%%%%%%%%%%%%%%   

%%%%%%%%%%%%%%%%%%%%% calculate_mse %%%%%%%%%%%%%%%%%%%%%%%% 
function  MSEaveg = calculate_mse(k)

global  N_Output output_index q y  MSEaveg  

MSE = 0.0;
for i = 1:N_Output
   a = q(output_index(i)) - y(k,output_index(i));
   MSE = MSE + a*a;
end
MSEaveg = MSEaveg + MSE;
%%%%%%%%%%%%%%%%%%%%% end Calculate_MSE %%%%%%%%%%%%%%%%%%%%%%%%   

%%%%%%%%%%%% Calculate_inv %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Winv_result = calculate_inv()

global N_Total W wplus wminus q D
   for j = 1:N_Total
      for i = 1:N_Total
         W(j,i) = (wplus(j,i) - (wminus(j,i)*q(i)))/D(i);
      end
   end
   inverse2 = inv(eye(N_Total,N_Total)-W);
   Winv = inverse2;
   
Winv_result = Winv; 
%%%%%%%%%%%% end Calculate_inv %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% update_wplus_1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
function wplus_result = update_wplus_1(k)

global N_Total wplus wplus_index wplus_conn N_Output output_index q D Winv y Eta

wplus_result = zeros(N_Total,N_Total);
for u = 1:N_Total
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
         sum1 = sum1 + vmplus * (q(i) - y(k,i)) * q(u);
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
%%%%%%%%%%%%%%%%%%%%% end update_wplus_1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%% update_wminus_1   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
function wminus_result = update_wminus_1(k) 

global N_Total wminus wminus_index wminus_conn N_Output output_index q D Winv y Eta

wminus_result = zeros(N_Total,N_Total);
% updating the negative weights 
for u = 1:N_Total
   for vv = 1:wminus_index(u)
      v = wminus_conn(u,vv);
      for i = 1:N_Total
         gammaminus(i) = 0.0;
         if ((u ~= i) & (v == i))
            gammaminus(i) = -q(i)/D(i);
         end
         if ((u == i) & (v ~= i))
            gammaminus(i) = -1.0/D(i);
         end  
         if ((u == i) & (v == i))
            gammaminus(i) = -(1.0 + q(i))/D(i);
         end
      end
      sum2 = 0;
      for jj = 1:N_Output
         i = output_index(jj);
         vmminus = gammaminus(u) * Winv(u,i) + gammaminus(v) * Winv(v,i);
         sum2 = sum2 + vmminus * (q(i) - y(k,i)) * q(u);
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
%%%%%%%%%%%%%%%%%%%%% end update_wminus_1   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%*************************   end train_rnn_gen.m  ***************************%%%