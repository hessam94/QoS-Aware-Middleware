%%%******************   begin use_rnn_gen1.m    *********************%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  Info  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   File Name       :     use_rnn_gen1.m                           %%%
%%%   Type            :     m script file                           %%%
%%%   Parent          :     None                                    %%%
%%%   External Calls  :     vardef.m                                %%% 
%%%                         initialize.m                            %%%
%%%                         train_rnn_ffm.m                         %%%
%%%                         test_rnn_ffm.m                          %%%  
%%%   Internal Calls  :     None                                    %%%  
%%%   Date            :     September, 1, 1999                      %%%
%%%   Author          :     Hossam Eldin Mostafa Abdelbaki          %%%
%%%   Address         :     University of Central Florida,          %%%
%%%                   :     School of Computer Science              %%%
%%%  Email            :     ahossam@cs.ucf.edu                      %%% 
%%%  Home Page        :     http://www.cs.ucf.edu/~ahossam/         %%% 
%%%  Help             :     read the manual file (rnnsimve.pdf)     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;  clear;  clear global; 

vardef;

%%%%%%%%%%%%Define the network file name %%%%%%%%%%%
Net_File_Name = 'rnn_gen_net1.m';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rr = input('Do you want to start from begining, load from disk or Test (S/L/T)   ','s');

if(rr == 'S' | rr == 's')
   LOAD_WEIGHTS = 0;
   TRAIN = 1;
elseif (rr == 'L' | rr == 'l')
   LOAD_WEIGHTS = 1;
   TRAIN = 1;
else 
   LOAD_WEIGHTS = 1;
   TRAIN = 0;
end

%initialize;

%N_Saved_Iterations = 30;
%N_Iterations = 100;


if(TRAIN == 1)
   %####### Input Training Patterns ################   
%    X = [        
%       -1   1  -1  -1   1   1   1
%        1  -1   1   1  -1  -1  -1]; 
% 4.41
% 4
% 3.43
% 2.75
% 2.75
% 3
% 2.59
% 2.44
% 1.68
% 1.57

%     X =[    0.1  0.1
%                0.1  0.3
%                0.1  0.5
%                0.2  0.1
%                0.2  0.3
%                0.2  0.5
%                0.4  0.1
%                0.4  0.3
%                0.4  0.5
%                0.7  0.1
%                0.7  0.3
%                0.7  0.5
%                0.9  0.1
%                0.9  0.3
%                0.9  0.5]; 
%    
%    Y = [0.44
%           0.36
%           0.37
%            0.40
%            0.30
%            0.34
%            0.27
%            0.25
%            0.23
%            0.24
%            0.15
%            0.15
%            0.15
%            0.10
%            0.10];

 X=       [0.1  0.1
               0.3 0.1
               0.5  0.1
               0.6  0.1
               0.8 0.1
               1.0  0.1
                ];
      
       Y= [     0.44
           0.34
           0.27
           0.30
           0.24
           0.15
               ];
%  X =[0.1  
%         0.3  
%          0.5
%          0.6 
%           0.8  ]; 
% %    
%    Y = [4.09
%       3.54
%           2.45
%         2.36
%          2.09];
%           Y = [0.15
%        0.22
%           0.31
%          0.32
%          0.41];
    
%      Y = [1   0
%    0 1     ];
initialize;
Wini(X,Y);
%%%%%%% you can also load the patterns from the traininig patterns file%%%%%
%%%Trn_File_Name ='';
%load_trn_file(Trn_File_Name);
%X = TRAIN_INPUT;
%Y = TARGET;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
flag =0;
if(flag==0)
   while(iter <= N_Iterations)
      t0 = clock;   
      
      %%%%%%%%%%%%%%%%%  Main Training Section Here  %%%%%%%%%%%%%%%%   
      ss = size(X);
      Z = 1:ss(1);   
      err_result = train_rnn_gen('1',X,Y); %train feed forward architecture
      %      qqq = test_rnn_gen('1',X,r);   %test feed forward architecture
    
      %%%%%%%%%%%%% or using multiple eposhes      
  % err_result = train_rnn_gen('1',X,Y,3);
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
      
      err(iter) = err_result;
      %err_result =0 ;
      if (err_result <= Mse_Threshold) 
         t1 = etime(clock,t0);
         elapsed_time = elapsed_time + t1;
         mess = sprintf('%d    %12.9f    %f    %f',iter, err_result, t1, elapsed_time);   
         disp(mess);
         
         last_iter = iter;
         last_elapsed_time = elapsed_time;   
         mess = sprintf('save %s %s ',Weights_File_Name,varnames);
         eval(mess);
         mess = sprintf('Weights are saved to file ( %s )',Weights_File_Name);
         disp(mess);
         disp('      STOP TRAINING       '); 
         disp('    Minimum Mean Squared Error is reached'); 
         disp(' --------------------------------------');
         break;
      end

      t1 = etime(clock,t0);
      elapsed_time = elapsed_time + t1;
      mess = sprintf('%d    %12.9f    %f    %f',iter, err_result, t1, elapsed_time);   
      disp(mess);
      if(SAVE_Weights == 1);
         if(mod(iter,N_Saved_Iterations) == 0)
            last_iter = iter; 
            last_elapsed_time = elapsed_time;   
            mess = sprintf('save %s %s ',Weights_File_Name,varnames);
            eval(mess);
            mess = sprintf('Weights are saved to file ( %s )',Weights_File_Name);
            disp(mess);      
         end
      end  
      last_iter = iter; 
      last_elapsed_time = elapsed_time;   
      iter = iter + 1;   
  end %while
end
   
   if(iter >= N_Iterations -1)
      last_elapsed_time = elapsed_time;   
      mess = sprintf('save %s %s ',Weights_File_Name,varnames);
      eval(mess);
      mess = sprintf('Weights are saved to file ( %s )',Weights_File_Name);
      disp(mess);      
      disp('      STOP TRAINING       '); 
      disp('   Maximum Iteration is reached');      
      disp(' -------------------------------------');
   end   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
end %if


if(TRAIN == 0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
      %%%%%%%%%%%%%%%%%  Main Testing Section Here  %%%%%%%%%%%%%%%%   
%    X = [        
%       -1   1  -1  -1   1   1   1
%        1  -1   1   1  -1  -1  -1]; 
      X = [ 0.1  
               0.2 
               0.4
               0.7 
               0.9]; 
    %%%%%%%%% you can also load the testing patterns for a file
    %%%Tst_File_Name = '';
    %load_tst_file(Tst_File_Name);
    %X = TEST_INPUT;
    
    qqq = test_rnn_gen('1',X)   %use feed forward testing model
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% all other argument possibilities %%%%%%%%%%%%%%%%%%5
    %%%%%Single testing vector
    %X1 =   X(1,:) + rand(1,7);
    %qqq = test_rnn_gen('1',X1)
    
    %%%%%%%pass the rate
    %qqq = test_rnn_gen('1',X,r)
    
    %%%%%%%pass the rate and the weigts file name
    %%%% Weights_File_Name='';
    %qqq = test_rnn_gen('1',X,r,Weights_File_Name);
    
    %pass the rate and the weigts file name and save response in a text file
    %%%% Weights_File_Name='';
    %%%% Log_File_Name = '';
    %qqq = test_rnn_gen('1',X,r,Weights_File_Name,Log_File_Name);
    
    %%%%pass the rate and the weigts file name and save response in a text file and an M file
    %%%% Weights_File_Name='';
    %%%% Log_File_Name = '';
    %%%% Temp_Log_File_Name = '';
       qqq = test_rnn_gen('1',X,r,Weights_File_Name,Log_File_Name,Temp_Log_File_Name );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    
 end %if
 %%%**********************   end use_rnn_gen1.m    **************************%%%
 
 