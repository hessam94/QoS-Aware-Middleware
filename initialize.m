%%%******************   begin initialize.m     *********************%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  Info  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   File Name       :     initialize.m                            %%%
%%%   Type            :     script m file                           %%%
%%%   Parent          :     use_rnn_gen.m                           %%%
%%%   External Calls  :                                             %%%  
%%%                         function load_net_file                  %%%
%%%                         function etract_name                    %%%
%%%                         function read_connection_matrix         %%%
%%%                         function Initialize_Weights             %%% 
%%%   Internal Calls  :     None                                    %%%
%%%   Date            :     September, 1, 1999                      %%%
%%%   Author          :     Hossam Eldin Mostafa Abdelbaki          %%%
%%%   Address         :     University of Central Florida,          %%%
%%%                   :     School of Computer Science              %%%
%%%  Email            :     ahossam@cs.ucf.edu                      %%% 
%%%  Home Page        :     http://www.cs.ucf.edu/~ahossam/         %%% 
%%%  Help             :     read the manual file (rnnsimv2.pdf)     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(LOAD_WEIGHTS == 0)
   start = 0;
   last_iter = 0; 
   last_elapsed_time = 0;   
   load_net_file(Net_File_Name);   
   read_connection_matrix(Connection_File_Name);
   %initialize_weights;
  %Wini(x);
end

if(LOAD_WEIGHTS == 1)
   load_net_file(Net_File_Name);   
   mess = sprintf('load %s',Weights_File_Name);
   eval(mess);
   start = last_iter;   
   load_net_file(Net_File_Name);   
end

iter = start + 1;
elapsed_time = last_elapsed_time;

if(LOAD_WEIGHTS == 0 & TRAIN == 1)
   mess1 = sprintf('\n --------------------------------------------------- ');
   mess2 = sprintf('  Network        : loaded from file ( %s )',Net_File_Name);
   mess3 = sprintf('  Input/Output   : %d / %d ',N_Input,N_Output);
   mess4 = sprintf('  Weights        : Initialized');
   mess5 = sprintf('  Iteration      : %d',last_iter);
   mess6 = sprintf('  MSE            : None');
   mess7 = sprintf('  Save after     : %d  Iterations',N_Saved_Iterations);
   mess8 = sprintf('  Mode           : Start Training');
   mess9 = sprintf(' --------------------------------------------------- ');
   mess = str2mat(mess1,mess2,mess3,mess4,mess5,mess6,mess7,mess8,mess9);   
end

if(LOAD_WEIGHTS == 1 & TRAIN == 1)
   mess1 = sprintf('\n --------------------------------------------------- ');
   mess2 = sprintf('  Network        : loaded from file ( %s )',Net_File_Name);
   mess3 = sprintf('  Input/Output   : %d / %d ',N_Input,N_Output);
   mess4 = sprintf('  Weights        : loaded from file ( %s )',Weights_File_Name);
   mess5 = sprintf('  Iteration      : %d',last_iter);
   mess6 = sprintf('  MSE            : %12.9f',MSEaveg);
   mess7 = sprintf('  Save after     : %d  Iterations',N_Saved_Iterations);
   mess8 = sprintf('  Mode           : Continue Training');
   mess9 = sprintf(' --------------------------------------------------- ');
   mess = str2mat(mess1,mess2,mess3,mess4,mess5,mess6,mess7,mess8,mess9);   
end

if(LOAD_WEIGHTS == 1 & TRAIN == 0)
   mess1 = sprintf('\n --------------------------------------------------- ');
   mess2 = sprintf('  Network        : loaded from file ( %s )',Net_File_Name);
   mess3 = sprintf('  Input/Output   : %d / %d ',N_Input,N_Output);
   mess4 = sprintf('  Weights        : loaded from file ( %s )',Weights_File_Name);
   mess5 = sprintf('  Iteration      : %d',last_iter);
   mess6 = sprintf('  MSE            : %12.9f',MSEaveg);
   mess7 = sprintf('  Save after     : %d  Iterations',N_Saved_Iterations);
   mess8 = sprintf('  Mode           : Start Testing');
   mess9 = sprintf(' --------------------------------------------------- ');
   mess = str2mat(mess1,mess2,mess3,mess4,mess5,mess6,mess7,mess8,mess9);   
end

disp(mess);
disp('    press any key to continue');
pause   
%%%*************************   end initialize.m     *****************************%%%


