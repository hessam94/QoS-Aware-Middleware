%%%******************   begin vardef.m         *********************%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  Info  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   File Name       :     vardef.m                                %%%
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
%%%  Help             :     read the manual file (rnnsimv2.pdf)     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

varnames = ['wplus' ' ' 'wminus' ' ' 'last_iter' ' ' 'last_elapsed_time' ' ' 'err' ' ' 'x' ' ' 'winput_index' ' '];
varnames = [varnames 'r' ' ' 'MSEaveg' ' '];
varnames = [varnames 'N_Input' ' ' 'N_Output' ' ' 'N_Total' ' ' 'Mse_Threshold' ' ' 'Eta' ' ']; 
varnames = [varnames 'N_Iterations' ' ' 'R_Out' ' ' 'RAND_RANGE' ' ' 'FIX_RIN' ' ' 'R_IN' ' ']; 
varnames = [varnames 'N_Saved_Iterations' ' ' 'AUTO_MAPPING' ' ']; 
varnames = [varnames 'wplus_index' ' ' 'wplus_conn' ' ' 'wminus_index' ' ' 'wminus_conn' ' ' 'w'];
varnames = [varnames 'input_index' ' ' 'output_index' ' ' 'LAMBDA' ' ' 'lambda' ' ' 'y' ' ' ];

global wplus wminus wplus_index wplus_conn wminus_index wminus_conn x
global last_iter last_elapsed_time err;
global r MSEaveg Mse_Threshold Eta N_Iterations R_Out RAND_RANGE FIX_RIN R_IN winput_index
global N_Input N_Output N_Total  
global N_Saved_Iterations LAMBDA lambda y D q Winv 
global input_index output_index q_cal Res
global Temp_Log_File_Name Log_File_Name Connection_File_Name  
global Net_File_Name Weights_File_Name Trn_File_Name Tst_File_Name 
global N_Test_Patterns N_Train_Patterns TRAIN_INPUT TARGET TEST_INPUT
global SAVE_Weights SAVE_TEXT_LOG SAVE_MFILE_LOG AUTO_MAPPING Z

%%%******************   end vardef.m         *********************%%%

