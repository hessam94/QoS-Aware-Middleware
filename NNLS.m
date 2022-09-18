function [ out ] =NNLS(  )
        NI=10;%iteration
     global sigma beta t    st StOldDest StInt StDest w N_Total
       sigma = 0.01 ;
      beta=0.1;
         t = 0;
      global   mid high low
         k=0,st=0,StOldDest=1,StInt=0,StDest=0;
     global    wcand % length = ??2N^2
        global A % length = ??nk*2n^2
        global AT% length = ??2n^2*nk;
        global grad%length 2n^2*1
        global q b temp 
     w=0;
            sigma = 0.01; beta = 0.1; t = 0; StDest = 1; 
             wcand =zeros(2*(N_Total^2),1) ;
            for  m = 0:  NI
           % {
                t = t + 1;
                w = wcand;
                st = StOldDest; StInt = StOldDest; k = -1;
               wcand =   P();%wcand<----p[...]
                if (Eq25()==true)
              %  {
                    flag = true;
                    while (flag)
                  %  {
                        k=k + 1;
                        st = StInt/(beta ^2^ k);
                     wcand =    P();
                        if (Eq25())
                          
                            flag = false;
                        end
                   
                  %  }//until 25 is not satisfied
                    end
                    low = floor(2^(k - 1) + 1);
                    high =2^k;
                    StDest = st;
                    while (low < high)
                   % {
                        mid =floor( (low + high) / 2);
                        st = StInt /(beta^mid);
                      wcand =    P();
                        if (Eq25()==false)
                      %  {
                            high = mid;
                            StDest = st;
                       
                       % }
                        else
                            low = mid + 1;
                        end
                    end
                  %  }
                   
             %   }
                    

                else 
               % {
                    flag = true;
                    while (flag)  
              %    {
                        k =k+ 1;
                        st = StInt / (beta ^2^ k);
                       wcand =  P();
                       if (Eq25()==false)
                          
                            flag = false;
                        end
                    end
                    %}//until 25 is not satisfied

                    low = floor((2^ (k - 1)) + 1);
                    high = (2^ k);
                    StDest = st;

                    while (low < high)
                 %   {
                        mid =  floor((low + high) / 2);
                        st = StInt * (beta^ mid);
                        wcand =  P();
                        if (Eq25())
                      %  {
                            high = mid;
                            StDest = st;
                           
                        %}
                        else
                            low = mid + 1;
                        end
                    end
                        %}
                       
              %  }
 
                end  
         %   }//end for

         out =   P();
         wcand = out;
            end
           
 


end

