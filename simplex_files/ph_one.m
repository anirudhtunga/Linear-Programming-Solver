function [T,B]= ph_one(T,B)
o =0;
while o==0
    o=chkopt(T);
    if (o==0)
        index = findpivot(T,B);
        [T,B] = pivot(T,index,B);
        
    else 
        if(T(1,end)<1e-6)  %similar to T(1,end)==0, but only till 10^-6, to avoid floating point errors
            disp("LP is Feasible");
            f=1;
        else
            disp("LP is not Feasible")
        end
        
        disp(T);
        disp(B);
    end
end
end
    
            
       