function [ wcand] = P(  )
         global N_Total  st w grad  wplus_conn wplus_index wminus_conn wminus_index D2
         D2 = eye(2*(N_Total^2),2*(N_Total^2));
            z=zeros(2*(N_Total^2),1);
            wcand = zeros(2*(N_Total^2),1);
             grad = Gradient()/10;
             grad = D2*grad;
           for  i=1: 2*(N_Total^2)           
                z(1)=w(i)-st*grad(i);
               
                 if (z(1) > 0)
                     wcand(i) = z(1);
                 else
                wcand(i) = -z(1); 
             %    wcand(i) = 0;
               
                end
           end



        wtemp = zeros(2*(N_Total^2),1);
        
        for i=1:N_Total 
            for j=1: wplus_index(i)
                wtemp((i-1)*N_Total + wplus_conn(i,j)) = 1;             
            end
        end
        
           for i=1:N_Total 
            for j=1: wminus_index(i)
                wtemp((i-1)*N_Total + wminus_conn(i,j) + N_Total*N_Total ) = 1;             
            end
           end
        
           for i =1 :2*N_Total*N_Total
               if(wtemp(i)==0)
                   wcand(i)=0;
               end
           end
           
end
