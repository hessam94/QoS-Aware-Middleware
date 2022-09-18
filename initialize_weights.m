%%%******************   begin Initialize_Weights.m  ****************%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  Info  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   File Name       :     Initialize_Weights.m                    %%%
%%%   Type            :     m function file                         %%%
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

function Initialize_Weights()

global wplus wminus N_Total wplus_index wminus_index wplus_conn wminus_conn RAND_RANGE

wplus = zeros(N_Total,N_Total);
wminus = zeros(N_Total,N_Total);

% Initializing the weights 

for i = 1:N_Total
   for j = 1:wplus_index(i)
      wplus(i,wplus_conn(i,j)) = RAND_RANGE*rand(1,1);
   end
end

for i = 1:N_Total
   for j = 1:wminus_index(i)
      wminus(i,wminus_conn(i,j)) = RAND_RANGE*rand(1,1);
   end
end
end
%%%******************   end Initialize_Weights.m     *******************%%%