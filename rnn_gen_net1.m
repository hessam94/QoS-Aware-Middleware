%%%******************   begin rnn_gen_net1.m      *********************%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  Info  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   File Name       :     rnn_gen_net1.m                             %%%
%%%   Type            :     m script file                           %%%
%%%   Parent          :     None                                    %%%
%%%   External Calls  :     None                                    %%% 
%%%   Internal Calls  :     None                                    %%%  
%%%   Date            :     September, 1, 1999                      %%%
%%%   Author          :     Hossam Eldin Mostafa Abdelbaki          %%%
%%%   Address         :     University of Central Florida,          %%%
%%%                   :     School of Computer Science              %%%
%%%  Email            :     ahossam@cs.ucf.edu                      %%% 
%%%  Home Page        :     http://www.cs.ucf.edu/~ahossam/         %%% 
%%%  Help             :     read the manual file (rnnsimve.pdf)     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%################ Network Parameter Initialization ###########
Mse_Threshold  = .00005;                     %Required stop mean square error value
Eta = 0.1;                                  %Learinig Rate
N_Iterations = 1000;                         %Maximum number of Iterations
R_Out = .1;                                 %Firing Rate of the Output Neurons
RAND_RANGE = 0.2;   
%RAND_RANGE = 1.0;   %Range of weights initialization 
FIX_RIN = 0;                                %DO NOT CHANGE (Related to RNN function approximation)  
R_IN = 1;                                   %DO NOT CHANGE (Related to RNN function approximation)
SAVE_Weights = 1;                           %Flag to indicate if the weight will be automatically saved
N_Saved_Iterations = 10;                    %Number of iterations after which weights will be saved automatically
Net_File_Name = 'rnn_gen_net1.m';           %Network file name (this file)
Connection_File_Name = 'rnn_gen_con1.dat';  %Connection file name 
%Connection_File_Name = 'rnn_gen_con2.dat';
Weights_File_Name = 'rnn_gen_wts1.mat';     %Weights file name
Trn_File_Name = 'rnn_gen_trn1.m';           %Training data file name  
Tst_File_Name = 'rnn_gen_tst1.m';           %Testing data file name  
Log_File_Name = 'rnn_gen_log1.txt';         %Results file name (ASCII format)
Temp_Log_File_Name = 'rnn_gen_log1.m';      %Results file name (MATLAB format)
SAVE_TEXT_LOG = 1;                         %Flag to indicate if the results will be saved in ASCII format
SAVE_MFILE_LOG = 1;                        %Flag to indicate if the results will be saved in MATLAB format
Res = .0001;                               %Resolution of solving the non linear equations of the model
AUTO_MAPPING = 0;                          %Flag = 1 only if the network is recurrent with shared inputs/outputs
AUTO_MAPPING = 0;                          %Flag = 0 for FF networks and 1 for fully recurrent networks
